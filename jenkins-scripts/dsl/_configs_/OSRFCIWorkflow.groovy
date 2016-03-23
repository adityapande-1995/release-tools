package _configs_

import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.jobs.WorkflowJob

def create_status_name = Globals.bitbucket_build_status_job_name

class OSRFCIWorflow
{
  void create(WorkflowJob job, String build_any_job)
  {
    job.with
    {
      label "master || docker"

      definition
      {
        cps
        {
          // run script in sandbox groovy
          sandbox()
          script("""\
                 currentBuild.description =  "\$JOB_DESCRIPTION"
                 def archive_number = ""

                 stage 'checkout for the mercurial hash'
                  node("master") {
                   checkout([\$class: 'MercurialSCM', credentialsId: '', installation: '(Default)', 
                             revision: "\$SRC_BRANCH", source: "\$SRC_REPO",
                             propagate: false, wait: true])
                    sh 'echo `hg id -i` > SCM_hash'
                    env.MERCURIAL_REVISION_SHORT = readFile('SCM_hash').trim()
                  }

                 stage 'create bitbucket status file'
                  node {
                    def bitbucket_metadata = build job: '${create_status_name}',
                          propagate: false, wait: true,
                          parameters:
                            [[\$class: 'StringParameterValue', name: 'RTOOLS_BRANCH',          value: "\$RTOOLS_BRANCH"],
                             [\$class: 'StringParameterValue', name: 'JENKINS_BUILD_REPO',     value: "\$SRC_REPO"],
                             [\$class: 'StringParameterValue', name: 'JENKINS_BUILD_HG_HASH',  value: env.MERCURIAL_REVISION_SHORT],
                             [\$class: 'StringParameterValue', name: 'JENKINS_BUILD_JOB_NAME', value: env.JOB_NAME],
                             [\$class: 'StringParameterValue', name: 'JENKINS_BUILD_URL',      value: env.BUILD_URL]]
                    archive_number = bitbucket_metadata.getNumber().toString()
                  }

                  stage 'set bitbucket status: in progress'
                  node {
                     build job: '_bitbucket-set_status',
                       parameters:
                          [[\$class: 'StringParameterValue', name: 'RTOOLS_BRANCH',           value: "\$RTOOLS_BRANCH"],
                           [\$class: 'StringParameterValue', name: 'BITBUCKET_STATUS',        value: "inprogress"],
                           [\$class: 'StringParameterValue', name: 'CREATE_CONFIG_BUILD_NUM', value: archive_number]]
                  }

                 stage 'compiling + QA'
                 node {
                  def compilation = build job: ${build_any_job},
                        propagate: true, wait: true,
                        parameters:
                         [[\$class: 'StringParameterValue',  name: 'RTOOLS_BRANCH',   value: "\$RTOOLS_BRANCH"],
                          [\$class: 'BooleanParameterValue', name: 'NO_MAILS',        value: false],
                          [\$class: 'StringParameterValue',  name: 'SRC_REPO',        value: "\$SRC_REPO"],
                          [\$class: 'StringParameterValue',  name: 'SRC_BRANCH',      value: "\$SRC_BRANCH"],
                          [\$class: 'StringParameterValue',  name: 'JOB_DESCRIPTION', value: "\$JOB_DESCRIPTION"],
                          [\$class: 'StringParameterValue',  name: 'DEST_BRANCH',     value: "\$DEST_BRANCH"]]
                }

                publish_result = 'failed'
                if (compilation.getResult() == 'SUCCESS')
                {
                  publish_result = 'ok'
                }

                stage 'publish bitbucket status'
                node {
                 build job: '_bitbucket-set_status',
                   parameters:
                      [[\$class: 'StringParameterValue', name: 'RTOOLS_BRANCH',           value: "\$RTOOLS_BRANCH"],
                       [\$class: 'StringParameterValue', name: 'STATUS',                  value: publish_result ],
                       [\$class: 'StringParameterValue', name: 'CREATE_CONFIG_BUILD_NUM', value: archive_number]]
                }
              """.stripIndent())
        }
      }
 
      parameters {
        stringParam('RTOOLS_BRANCH','default','release-tools branch to send to jobs')
        stringParam('SRC_REPO','','URL pointing to repository')
        stringParam('SRC_BRANCH','default','Branch of SRC_REPO to test')
        stringParam('JOB_DESCRIPTION','','Description of the job in course. For information proposes.')
        stringParam('DEST_BRANCH','default','Branch to merge in')
      }
    } // end of parameters
  } // end of create
} // end of class
