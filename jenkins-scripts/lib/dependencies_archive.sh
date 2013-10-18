#!/bin/bash

# **** WARNING ***** : when modifying this file
# **** WARNING ***** : any trailing whitespaces will break dependencies scapes


if [[ -z $ROS_DISTRO ]]; then
    echo "ROS_DISTRO was not set before using dependencies_archive.sh!"
    exit 1
fi

# mesa-utils for dri checks and xsltproc for qtest->junit conversion
BASE_DEPENDENCIES="build-essential \\
                   cmake           \\
                   debhelper       \\
                   mesa-utils      \\
                   cppcheck        \\
                   xsltproc        \\
                   python"

# 1. SDFORMAT
SDFORMAT_BASE_DEPENDENCIES="python                       \\
                            libboost-system-dev          \\
                            libboost-filesystem-dev      \\
                            libboost-program-options-dev \\
                            libboost-regex-dev           \\
                            libboost-iostreams-dev       \\
                            libtinyxml-dev"

# GAZEBO related dependencies
GAZEBO_BASE_DEPENDENCIES="libfreeimage-dev                 \\
                          libprotoc-dev                    \\
                          libprotobuf-dev                  \\
                          protobuf-compiler                \\
                          freeglut3-dev                    \\
                          libcurl4-openssl-dev             \\
                          libtinyxml-dev                   \\
                          libtar-dev                       \\
                          libtbb-dev                       \\
                          libogre-dev                      \\
                          libxml2-dev                      \\
                          pkg-config                       \\
                          libqt4-dev                       \\
                          libltdl-dev                      \\
                          libboost-thread-dev              \\
                          libboost-signals-dev             \\
                          libboost-system-dev              \\
                          libboost-filesystem-dev          \\
                          libboost-program-options-dev     \\
                          libboost-regex-dev               \\
                          libboost-iostreams-dev           \\
                          libbullet-dev                    \\
                          libsimbody-dev                   \\
                          sdformat"

GAZEBO_EXTRA_DEPENDENCIES="robot-player-dev \\
                           libcegui-mk2-dev \\
                           libavformat-dev  \\
                           libavcodec-dev   \\
                           libswscale-dev"

GAZEBO_DEB_PACKAGE=$GAZEBO_DEB_PACKAGE
if [ -z $GAZEBO_DEB_PACKAGE ]; then
    GAZEBO_DEB_PACKAGE=gazebo-current
fi

# image-transport-plugins is needed to properly advertise compressed image topics
DRCSIM_BASE_DEPENDENCIES="ros-${ROS_DISTRO}-pr2-mechanism                     \\
                          ros-${ROS_DISTRO}-std-msgs                          \\
                          ros-${ROS_DISTRO}-common-msgs                       \\
                          ros-${ROS_DISTRO}-image-common                      \\
                          ros-${ROS_DISTRO}-geometry                          \\
                          ros-${ROS_DISTRO}-pr2-controllers                   \\
                          ros-${ROS_DISTRO}-geometry-experimental             \\
                          ros-${ROS_DISTRO}-robot-model-visualization         \\
                          ros-${ROS_DISTRO}-image-pipeline                    \\
                          ros-${ROS_DISTRO}-image-transport-plugins           \\
                          ros-${ROS_DISTRO}-gazebo-plugins                    \\
                          ros-${ROS_DISTRO}-compressed-depth-image-transport  \\
                          ros-${ROS_DISTRO}-compressed-image-transport        \\
                          ros-${ROS_DISTRO}-theora-image-transport            \\
                          ${GAZEBO_DEB_PACKAGE}"

DRCSIM_FULL_DEPENDENCIES="${DRCSIM_BASE_DEPENDENCIES} \\
                          sandia-hand                 \\
			  osrf-common"
