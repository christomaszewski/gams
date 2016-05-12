#!/bin/bash
#
# Copyright (c) 2015 Carnegie Mellon University. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following acknowledgments
# and disclaimers.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. The names "Carnegie Mellon University," "SEI" and/or "Software
# Engineering Institute" shall not be used to endorse or promote
# products derived from this software without prior written
# permission. For written permission, please contact
# permission@sei.cmu.edu.
#
# 4. Products derived from this software may not be called "SEI" nor
# may "SEI" appear in their names without prior written permission of
# permission@sei.cmu.edu.
#
# 5. Redistributions of any form whatsoever must retain the following
# acknowledgment:
#
# Copyright 2015 Carnegie Mellon University
#
# This material is based upon work funded and supported by the
# Department of Defense under Contract No. FA8721-05-C-0003 with
# Carnegie Mellon University for the operation of the Software
# Engineering Institute, a federally funded research and development
# center.
#
# Any opinions, findings and conclusions or recommendations expressed
# in this material are those of the author(s) and do not necessarily
# reflect the views of the United States Department of Defense.
#
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE
# ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS"
# BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT
# LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY,
# EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE
# MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH
# RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT
# INFRINGEMENT.
#
# This material has been approved for public release and unlimited
# distribution.
#
# DM-0002489
#
# Build the required libraries for GAMS
#
# There are several expected environment variables
#   $CORES        - number of build jobs to launch with make
#   $ACE_ROOT     - location of local copy of ACE subversion repository from
#                   svn://svn.dre.vanderbilt.edu/DOC/Middleware/sets-anon/ACE
#   $MADARA_ROOT  - location of local copy of MADARA git repository from
#                   git://git.code.sf.net/p/madara/code
#   $GAMS_ROOT    - location of this GAMS git repository
#   $VREP_ROOT    - location of VREP installation, if applicable
#
# For android
#   $LOCAL_CROSS_PREFIX
#                 - Set this to the toolchain prefix
#
# For java
#   $JAVA_HOME

TESTS=0
VREP=0
JAVA=0
ROS=0
ANDROID=0
STRIP=0
ODROID=0
ACE=0
MADARA=0
STRIP_EXE=strip
VREP_INSTALLER="V-REP_PRO_EDU_V3_3_0_64_Linux.tar.gz"
INSTALL_DIR=`dirname $0`

for var in "$@"
do
  if [ "$var" = "tests" ]; then
    TESTS=1
  elif [ "$var" = "vrep" ]; then
    VREP=1
  elif [ "$var" = "java" ]; then
    JAVA=1
  elif [ "$var" = "ros" ]; then
    ROS=1
  elif [ "$var" = "ace" ]; then
    ACE=1
  elif [ "$var" = "madara" ]; then
    MADARA=1
  elif [ "$var" = "gams" ]; then
    GAMS=1
  elif [ "$var" = "odroid" ]; then
    ODROID=1
    STRIP_EXE=${LOCAL_CROSS_PREFIX}strip
  elif [ "$var" = "android" ]; then
    ANDROID=1
    JAVA=1
    STRIP_EXE=${LOCAL_CROSS_PREFIX}strip
  elif [ "$var" = "strip" ]; then
    STRIP=1
  else
    echo "Invalid argument: $var"
    echo "  args can be zero or more of the following, space delimited"
    echo "  ace             build ACE"
    echo "  android         build android libs, turns on java"
    echo "  java            build java jar"
    echo "  ace             build MADARA"
    echo "  odroid          target ODROID computing platform"
    echo "  ros             build ROS platform classes"
    echo "  strip           strip symbols from the libraries"
    echo "  tests           build test executables"
    echo "  vrep            build with vrep support"
    echo "  help            get script usage"
    echo ""
    echo "The following environment variables are used"
    echo "  CORES               - number of build jobs to launch with make, optional"
    echo "  ACE_ROOT            - location of local copy of ACE subversion repository from"
    echo "                        svn://svn.dre.vanderbilt.edu/DOC/Middleware/sets-anon/ACE"
    echo "  MADARA_ROOT         - location of local copy of MADARA git repository from"
    echo "                        git://git.code.sf.net/p/madara/code"
    echo "  GAMS_ROOT           - location of this GAMS git repository"
    echo "  VREP_ROOT           - location of VREP installation"
    echo "  JAVA_HOME           - location of JDK"
    exit
  fi
done

# echo build information
echo "Using $CORES build jobs"
echo "MADARA will be built from $MADARA_ROOT"
echo "ACE will be built from $ACE_ROOT"
echo "GAMS will be built from $GAMS_ROOT"
echo "TESTS has been set to $TESTS"
echo "ROS has been set to $ROS"
echo "STRIP has been set to $STRIP"
if [ $STRIP -eq 1 ]; then
  echo "strip will use $STRIP_EXE"
fi

echo "JAVA has been set to $JAVA"
if [ $JAVA -eq 1 ]; then
  echo "JAVA_HOME is referencing $JAVA_HOME"
fi

echo "VREP has been set to $VREP"
if [ $VREP -eq 1 ]; then
  echo "VREP_ROOT is referencing $VREP_ROOT"
fi

echo "ANDROID has been set to $ANDROID"
if [ $ANDROID -eq 1 ]; then
  echo "CROSS_COMPILE is set to $LOCAL_CROSS_PREFIX"
fi

echo ""

if [ $ACE -eq 1 ]; then

  # build ACE, all build information (compiler and options) will be set here
  echo "Building ACE"
  if [ ! $ACE_ROOT ] ; then
    export $ACE_ROOT = $INSTALL_DIR/ace/ACE_wrappers
  fi
  if [ ! -d $ACE_ROOT ] ; then
    svn checkout --quiet svn://svn.dre.vanderbilt.edu/DOC/Middleware/sets-anon/ACE $INSTALL_DIR/ace
    if [ $ANDROID -eq 1 ]; then
      # use the android specific files, we use custom config file for android due to build bug in ACE
      echo "#include \"$GAMS_ROOT/scripts/linux/config-android.h\"" > $ACE_ROOT/ace/config.h

      # Android does not support versioned libraries and requires cross-compiling
      echo -e "no_hidden_visibility=1\nversioned_so=0\nCROSS_COMPILE=$LOCAL_CROSS_PREFIX\ninclude \$(ACE_ROOT)/include/makeinclude/platform_android.GNU" > $ACE_ROOT/include/makeinclude/platform_macros.GNU
    else
      # use linux defaults
      echo "#include \"ace/config-linux.h\"" > $ACE_ROOT/ace/config.h
      echo -e "no_hidden_visibility=1\ninclude \$(ACE_ROOT)/include/makeinclude/platform_linux.GNU" > $ACE_ROOT/include/makeinclude/platform_macros.GNU
    fi
  fi
  
  cd $ACE_ROOT/ace
  perl $ACE_ROOT/bin/mwc.pl -type gnuace ace.mwc
  make realclean -j $CORES
  make -j $CORES
  if [ $STRIP -eq 1 ]; then
    $STRIP_EXE libACE.so*
  fi
fi

if [ $MADARA -eq 1 ]; then
  # build MADARA
  echo "Building MADARA"
  if [ ! $MADARA_ROOT ] ; then
    export $MADARA_ROOT = $INSTALL_DIR/madara
  fi
  if [ ! -d $MADARA_ROOT ] ; then
    git clone http://git.code.sf.net/p/madara/code $MADARA_ROOT
  else
    cd $MADARA_ROOT
    git pull
  fi
  cd $MADARA_ROOT
  perl $ACE_ROOT/bin/mwc.pl -type gnuace -features android=$ANDROID,java=$JAVA,tests=$TESTS MADARA.mwc
  make realclean -j $CORES
  make android=$ANDROID java=$JAVA tests=$TESTS -j $CORES
  if [ $JAVA -eq 1 ]; then
    # sometimes the jar'ing will occur before all classes are actually built when performing
    # multi-job builds, fix by deleting class files and recompiling with single build job
    find . -name "*.class" -delete
    make android=$ANDROID java=$JAVA tests=$TESTS -j $CORES
  fi
  if [ $STRIP -eq 1 ]; then
    $STRIP_EXE libMADARA.so*
  fi
fi

# build GAMS
echo "Updating GAMS"
if [ ! $GAMS_ROOT ] ; then
  export $GAMS_ROOT = $INSTALL_DIR/gams
fi
if [ ! -d $GAMS_ROOT ] ; then
  git clone -b master --single-branch https://github.com/jredmondson/gams.git $GAMS_ROOT
  
else
  cd $GAMS_ROOT
  git pull
fi

if [ $VREP -eq 1 ]; then
  echo "Building VREP"
  if [ ! $VREP_ROOT ] ; then
    export $VREP_ROOT = $INSTALL_DIR/vrep
  fi
  if [ ! -d $VREP_ROOT ]; then 
    cd $INSTALL_DIR
    wget http://coppeliarobotics.com/$VREP_PKG
    mkdir vrep
    tar xfz $VREP_INSTALLER -C vrep  --strip-components 1
    if [ -f vrep/system/usrset.txt ]; then
      for i in doNotShowOpenglSettingsMessage doNotShowCrashRecoveryMessage doNotShowUpdateCheckMessage; do
        cat vrep/system/usrset.txt | sed "s/$i = false/$i = true/g" > vrep/system/usrset.txt1
          mv vrep/system/usrset.txt1 vrep/system/usrset.txt
      done
    else
      for i in doNotShowOpenglSettingsMessage doNotShowCrashRecoveryMessage doNotShowUpdateCheckMessage; do
        echo "$i = true" >> vrep/system/usrset.txt
      done
    fi
    patch -b -d $VREP_ROOT -p1 -i $GAMS_ROOT/scripts/linux/patches/00_VREP_extApi_readPureDataFloat_alignment.patch
  fi
fi

  
echo "Building GAMS"
cd $GAMS_ROOT

perl $ACE_ROOT/bin/mwc.pl -type gnuace -features java=$JAVA,ros=$ROS,vrep=$VREP,tests=$TESTS,android=$ANDROID gams.mwc
make realclean -j $CORES
make java=$JAVA ros=$ROS vrep=$VREP tests=$TESTS android=$ANDROID -j $CORES
if [ $JAVA -eq 1 ]; then
  # sometimes the jar'ing will occur before all classes are actually built when performing
  # multi-job builds, fix by deleting class files and recompiling with single build job
  find . -name "*.class" -delete
  make java=$JAVA ros=$ROS vrep=$VREP tests=$TESTS android=$ANDROID
fi
if [ $STRIP -eq 1 ]; then
  $STRIP_EXE libGAMS.so*
fi
