#!/bin/bash

#COLORS
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NOCOLOR='\033[0m' 

AIRLIB=0
ANDROID=0
ANDROID_TESTS=0
BUILD_ERRORS=0
CAPNP=0
# Hard setting this because of SCRIMMAGE debian bug
SCRIMMAGE_ROOT="/opt/scrimmage/x86_64-linux-gnu/" 
CAPNP_JAVA=0
CLANG=0
CLANG_DEFINED=0
CLANG_IN_LAST=0
CLEAN=1
CMAKE=0
CUDA=0
DEBUG=0
TESTS=0
TUTORIALS=0
VREP=0
SCRIMMAGE=0
DMPL=0
DOCS=0
FORCE_AIRSIM=0
FORCE_UNREAL=0
GAMS=0
GAMSPULL=0
JAVA=0
LZ4=0
MAC=0
MADARA=0
MADARAPULL=0
MPC=0
NOKARL=0
NOTHREADLOCAL=0
ODROID=0
OPENCV=0
OSC=0
PREREQS=0
PYTHON=0
ROS=0
SIMTIME=0
SSL=0
DMPL=0
LZ4=0
NOKARL=0
PYTHON=0
WARNINGS=0
CLEAN=1
CLEAN_ENV=0
MADARAPULL=0
GAMSPULL=0
BUILD_ERRORS=0
STRIP=0
TESTS=0
TUTORIALS=0
TYPES=0
UNREAL=0
UNREAL_DEV=0
UNREAL_GAMS=0
VREP=0
VREP_CONFIG=0
WARNINGS=0
ZMQ=0

if [ -z $PYTHON_VERSION ] ; then
  echo "PYTHON_VERSION unset, so setting it to default of 2.7"
  export PYTHON_VERSION="2.7"
fi

echo "MAC=$MAC"

CAPNP_AS_A_PREREQ=0
EIGEN_AS_A_PREREQ=0
GAMS_AS_A_PREREQ=0
MADARA_AS_A_PREREQ=0
MPC_DEPENDENCY_ENABLED=0
MADARA_DEPENDENCY_ENABLED=0
MPC_AS_A_PREREQ=0
MADARA_AS_A_PREREQ=0
VREP_AS_A_PREREQ=0
SCRIMMAGE_AS_A_PREREQ=0
GAMS_AS_A_PREREQ=0
EIGEN_AS_A_PREREQ=0
CAPNP_AS_A_PREREQ=0
UNREAL_AS_A_PREREQ=0
VREP_AS_A_PREREQ=0

AIRSIM_BUILD_RESULT=0
CAPNP_REPO_RESULT=0
CAPNP_BUILD_RESULT=0
CAPNPJAVA_REPO_RESULT=0
CAPNPJAVA_BUILD_RESULT=0
DART_REPO_RESULT=0
DART_BUILD_RESULT=0
GAMS_REPO_RESULT=0
GAMS_BUILD_RESULT=0
LZ4_REPO_RESULT=0
MADARA_REPO_RESULT=0
MADARA_BUILD_RESULT=0
MPC_REPO_RESULT=0
VREP_REPO_RESULT=0
SCRIMMAGE_REPO_RESULT=0
ZMQ_REPO_RESULT=0
ZMQ_BUILD_RESULT=0
LZ4_REPO_RESULT=0
CAPNP_REPO_RESULT=0
CAPNP_BUILD_RESULT=0
CAPNPJAVA_REPO_RESULT=0
CAPNPJAVA_BUILD_RESULT=0
OSC_REPO_RESULT=0
OSC_BUILD_RESULT=0
UNREAL_BUILD_RESULT=0
UNREAL_GAMS_REPO_RESULT=0
UNREAL_GAMS_BUILD_RESULT=0
VREP_REPO_RESULT=0
ZMQ_REPO_RESULT=0
ZMQ_BUILD_RESULT=0

STRIP_EXE=strip
VREP_INSTALLER="V-REP_PRO_EDU_V3_4_0_Linux.tar.gz"
export INSTALL_DIR=`pwd`
SCRIPTS_DIR=`dirname $0`



# if $@ is empty, the user wants to repeat last build with noclean

if [ $# == 0 ]; then
  echo "Loading last build with noclean..."
  IFS=$'\r\n ' GLOBIGNORE='*' command eval  'ARGS=($(cat $GAMS_ROOT/last_build.lst))'
  ARGS+=("noclean")
else
  echo "Processing user arguments..."
  ARGS=("$@")
fi

echo "build features: ${ARGS[@]}"

for var in "${ARGS[@]}"
do
  if [ "$var" = "airlib" ] ||  [ "$var" = "airsim" ]; then
    AIRLIB=1
    CLANG=1
  elif [ "$var" = "android" ]; then
    ANDROID=1
    JAVA=1
    STRIP_EXE=${LOCAL_CROSS_PREFIX}strip
  elif [ "$var" = "android-tests" ]; then 
    ANDROID_TESTS=1
    ANDROID=1
    JAVA=1
  elif [ "$var" = "capnp" ]; then
    CAPNP=1
  elif [ "$var" = "cmake" ]; then
    CMAKE=1
  elif [ "$var" = "nocapnp" ]; then
    CAPNP=0
  elif [ "$var" = "capnp-java" ]; then
    CAPNP_JAVA=1
  elif [ "$var" = "clang" ]; then
    CLANG=1
    CLANG_DEFINED=1
  elif [ "$var" = "clang5" ] ||  [ "$var" = "clang-5" ]; then
    CLANG=1
    CLANG_DEFINED=1
    export CLANG_SUFFIX=-5.0
    export FORCE_CC=clang-5.0
    export FORCE_CXX=clang++-5.0
  elif [ "$var" = "clang6" ] ||  [ "$var" = "clang-6" ]; then
    CLANG=1
    CLANG_DEFINED=1
    export CLANG_SUFFIX=-6.0
    export FORCE_CC=clang-6.0
    export FORCE_CXX=clang++-6.0
  elif [ "$var" = "clang8" ] ||  [ "$var" = "clang-8" ]; then
    CLANG=1
    CLANG_DEFINED=1
    export CLANG_SUFFIX=-8
    export FORCE_CC=clang-8
    export FORCE_CXX=clang++-8
  elif [ "$var" = "clang9" ] ||  [ "$var" = "clang-9" ]; then
    CLANG=1
    CLANG_DEFINED=1
    export CLANG_SUFFIX=-9
    export FORCE_CC=clang-9
    export FORCE_CXX=clang++-9
  elif [ "$var" = "clean" ]; then
    CLEAN=1
  elif [ "$var" = "cleanenv" ]; then
    CLEAN_ENV=1
  elif [ "$var" = "cuda" ]; then
    CUDA=1
  elif [ "$var" = "dart" ]; then
    DMPL=1
  elif [ "$var" = "debug" ]; then
    DEBUG=1
  elif [ "$var" = "dmpl" ]; then
    DMPL=1
  elif [ "$var" = "docs" ]; then
    DOCS=1
  elif [ "$var" = "force-airsim" ]; then
    AIRLIB=1
    FORCE_AIRSIM=1
  elif [ "$var" = "force-unreal" ]; then
    UNREAL=1
    FORCE_UNREAL=1
  elif [ "$var" = "gams" ]; then
    GAMS=1
  elif [ "$var" = "java" ]; then
    JAVA=1
  elif [ "$var" = "lz4" ]; then
    LZ4=1
  elif [ "$var" = "mpc" ]; then
    MPC=1
  elif [ "$var" = "madara" ]; then
    MADARA=1
  elif [ "$var" = "noclean" ]; then
    CLEAN=0
  elif [ "$var" = "nogamspull" ]; then
    GAMSPULL=0
  elif [ "$var" = "nokarl" ]; then
    NOKARL=1
  elif [ "$var" = "nomadarapull" ]; then
    MADARAPULL=0
  elif [ "$var" = "nopull" ]; then
    GAMSPULL=0
    MADARAPULL=0
  elif [ "$var" = "nothreadlocal" ]; then
    NOTHREADLOCAL=1
  elif [ "$var" = "odroid" ]; then
    ODROID=1
    STRIP_EXE=${LOCAL_CROSS_PREFIX}strip
  elif [ "$var" = "opencv" ]; then
    OPENCV=1
  elif [ "$var" = "osc" ]; then
    OSC=1
  elif [ "$var" = "prereqs" ]; then
    PREREQS=1
  elif [ "$var" = "python" ]; then
    PYTHON=1
  elif [ "$var" = "ros" ]; then
    ROS=1
  elif [ "$var" = "simtime" ]; then
    SIMTIME=1
  elif [ "$var" = "ssl" ]; then
    SSL=1
  elif [ "$var" = "strip" ]; then
    STRIP=1
  elif [ "$var" = "tests" ]; then
    TESTS=1
  elif [ "$var" = "tutorials" ]; then
    TUTORIALS=1
  elif [ "$var" = "types" ]; then
    TYPES=1
  elif [ "$var" = "unreal" ]; then
    UNREAL=1
  elif [ "$var" = "unreal-dev" ]; then
    UNREAL_DEV=1
    UNREAL_GAMS=1
    CLANG=1
  elif [ "$var" = "unreal-gams" ]; then
    UNREAL_GAMS=1
  elif [ "$var" = "scrimmage" ]; then
    SCRIMMAGE=1
  elif [ "$var" = "vrep" ]; then
    VREP=1
  elif [ "$var" = "vrep-config" ]; then
    VREP_CONFIG=1
  elif [ "$var" = "warnings" ]; then
    WARNINGS=1
  elif [ "$var" = "zmq" ]; then
    ZMQ=1
  else
#    echo "Invalid argument: $var"
    echo ""
    echo "Args can be zero or more of the following, space delimited"
    echo ""
    echo "  airlib|airsim   build with Microsoft AirSim support"
    echo "  android         build android libs, turns on java"
    echo "  capnp           enable capnproto support"
    echo "  clang           build using clang++\$CLANG_SUFFIX and libc++"
    echo "  clang-5         build using clang++-5.0 and libc++"
    echo "  clang-6         build using clang++-6.0 and libc++"
    echo "  clang-8         build using clang++-8.0 and libc++"
    echo "  clang-9         build using clang++-9.0 and libc++"
    echo "  clean           run 'make clean' before builds (default)"
    echo "  cleanenv       Unsets all related environment variables before building."
    echo "  cuda            build relevant libs with CUDA support"
    echo "  debug           create a debug build, with minimal optimizations"
    echo "  dmpl            build DART DMPL verifying compiler"
    echo "  docs            generate API documentation"
    echo "  force-airsim    if airsim dir exists, rebuild"
    echo "  force-unreal    if unreal dir exists, rebuild"
    echo "  gams            build GAMS"
    echo "  help            get script usage"
    echo "  java            build java jar"
    echo "  lz4             build with LZ4 compression"
    echo "  madara          build MADARA"
    echo "  mpc             download MPC if prereqs is enabled"
    echo "  nocapnp         disable capnproto support"
    echo "  noclean         do not run 'make clean' before builds."
    echo "                  This is an option that supercharges the build"
    echo "                  process and can reduce build times to seconds."
    echo "                  99.9% of update builds can use this, unless you"
    echo "                  are changing features (e.g., enabling ssl when"
    echo "                  you had previously not enabled ssl)"
    echo "  nogamspull      when building GAMS, don't do a git pull"
    echo "  nokarl          when building MADARA, remove all karl evaluation"
    echo "                  This is useful to remove RTTI dependencies"
    echo "  nomadarapull    when building MADARA, don't do a git pull"
    echo "  nothreadlocal   do not compile with thread local support for printing"
    echo "  nopull          when building MADARA or GAMS, don't do a git pull"
    echo "  odroid          target ODROID computing platform"
    echo "  opencv          build opencv"
    echo "  osc             build with open stage control support"
    echo "  python          build with Python $PYTHON_VERSION support"
    echo "  prereqs         use apt-get to install prereqs. This usually only"
    echo "                  has to be used on the first usage of a feature"
    echo "  ros             build ROS platform classes"
    echo "  ssl             build with OpenSSL support"
    echo "  simtime         build with simtime support in Madara"
    echo "  scrimmage       build with SCRIMMAGE support"
    echo "  strip           strip symbols from the libraries"
    echo "  tests           build test executables"
    echo "  tutorials       build MADARA tutorials"
    echo "  types           builds libTYPES.so"
    echo "  unreal          builds Unreal and AirSim if preqreqs is enabled"
    echo "  unreal-dev      builds Unreal Dev and UnrealGAMS"
    echo "  unreal-gams     builds UnrealGAMS"
    echo "  vrep            build with vrep support"
    echo "  scrimmage-gams  build with scrimmage support"
    echo "  vrep-config     configure vrep to support up to 20 agents"
    echo "  warnings        build with compile warnings enabled in GAMS/MADARA"
    echo "  zmq             build with ZeroMQ support"
    echo ""
    echo "The following environment variables are used"
    echo ""
    echo "  AIRSIM_ROOT         - location of AirSim repository"
    echo "  CAPNP_ROOT          - location of Cap'n Proto"
    echo "  CORES               - number of build jobs to launch with make, optional"
    echo "  DMPL_ROOT           - location of DART DMPL directory"
    echo "  MPC_ROOT            - location of MakefileProjectCreator"
    echo "  MADARA_ROOT         - location of local copy of MADARA git repository from"
    echo "                        git://git.code.sf.net/p/madara/code"
    echo "  GAMS_ROOT           - location of this GAMS git repository"
    echo "  VREP_ROOT           - location of VREP installation"
    echo "  SCRIMMAGE_GIT_ROOT  - the location of the SCRIMMAGE Github installation"
    echo "  SCRIMMAGE_ROOT      - the location of the SCRIMMAGE installation"
    echo "  JAVA_HOME           - location of JDK"
    echo "  LZ4_ROOT            - location of LZ4"
    echo "  MPC_ROOT            - location of MakefileProjectCreator"
    echo "  MADARA_ROOT         - location of local copy of MADARA repository"
    echo "  OPENCV_ROOT         - location of opencv to install to"
    echo "  OPENCV_CONTRIB_ROOT - location of opencv_contrib to install to"
    echo "  OSC_ROOT            - location of open stage control (oscpack)"
    echo "  ROS_ROOT            - location of ROS (usually set by ROS installer)"
    echo "  SSL_ROOT            - location of OpenSSL"
    echo "  UNREAL_ROOT         - location of UnrealEngine repository"
    echo "  VREP_ROOT           - location of VREP installation"
    echo "  ZMQ_ROOT            - location of ZeroMQ"
    echo ""
    echo "Previous build (can repeat by calling this script with no args):"
    echo ""
    echo "  $(cat $GAMS_ROOT/last_build.lst)"
    echo ""
    exit
  fi
done

# make the .gams directory if it doesn't exist
if [ ! -d $HOME/.gams ]; then
  mkdir $HOME/.gams
  touch $HOME/.gams/env.sh
elif [ $CLEAN_ENV -eq 1 ]; then
  rm $HOME/.gams/env.sh
  touch $HOME/.gams/env.sh
fi

if [ $CLANG -eq 1 ] && [ $CLANG_DEFINED -eq 0 ] ; then
  ARGS+=('clang')
fi

# did we compile with clang last time?
if grep -q clang $GAMS_ROOT/last_build.lst ; then
  CLANG_IN_LAST=1
fi

# if we have changed compilers, stop everything
if [ $CLANG_IN_LAST -ne $CLANG ] ; then
  echo "Compiler change detected. Forcing clean build"

  for i in "${!ARGS[@]}"; do
    if [ "${ARGS[i]}" != "noclean" ]; then
      NEW_ARGS+=( "${ARGS[i]}" )
    fi
  done
  ARGS=("${NEW_ARGS[@]}")
  unset NEW_ARGS
  CLEAN=1

  if [ $MADARA -eq 0 ] && [ $GAMS -eq 1 ] ; then
    echo "  MADARA needs to be rebuilt"
    MADARA_AS_A_PREREQ=1
  fi
fi

if [ $DMPL -eq 1 ] || [ $GAMS -eq 1 ] ; then
  MADARA_DEPENDENCY_ENABLED=1
fi

# check if MADARA is a prereq for later packages
if [ $MADARA_DEPENDENCY_ENABLED -eq 1 ] && [ ! -d $MADARA_ROOT ]; then
  MADARA_AS_A_PREREQ=1
fi

# save the last builds that have been performed
echo "${ARGS[*]}" >> $HOME/.gams/build.lst

CLANG_IN_LAST=0


if [ $CLEAN_ENV -eq 1 ]; then
    echo -e "${ORANGE} Resetting all environment variables to blank. ${NOCOLOR}"
    export UNREAL_ROOT=""
    export UNREAL_GAMS_ROOT=""
    export UE4_ROOT=""
    export UE4_GAMS=""
    export AIRSIM_ROOT=""
    export OSC_ROOT=""
    export VREP_ROOT=""
    export MPC_ROOT=""
    export EIGEN_ROOT=""
    export CAPNP_ROOT=""
    export MADARA_ROOT=""
    export GAMS_ROOT=""
    export DMPL_ROOT=""
    export PYTHONPATH=$PYTHONPATH:$MADARA_ROOT/lib:$GAMS_ROOT/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MADARA_ROOT/lib:$GAMS_ROOT/lib:$VREP_ROOT:$CAPNP_ROOT/c++/.libs/$SCRIMMAGE_GIT_ROOT/build/lib/:$SCRIMMAGE_GIT_ROOT/build/plugin_libs
    export PATH=$PATH:$MPC_ROOT:$VREP_ROOT:$CAPNP_ROOT/c++:$MADARA_ROOT/bin:$GAMS_ROOT/bin:$DMPL_ROOT/src/DMPL:$DMPL_ROOT/src/vrep
    export SCRIMMAGE_GIT_ROOT=""
    export SCRIMMAGE_PLUGIN_PATH=""
    export SCRIMMAGE_MISSION_PATH=""
fi

if [ -z $DMPL_ROOT ] ; then
  export DMPL_ROOT=$INSTALL_DIR/dmplc
fi

if [ -z $GAMS_ROOT ] ; then
  export GAMS_ROOT=$INSTALL_DIR/gams
fi

if [ -z $MPC_ROOT ] ; then
  export MPC_ROOT=$INSTALL_DIR/MPC
fi

if [ -z $EIGEN_ROOT ] ; then
  export EIGEN_ROOT=$INSTALL_DIR/eigen
fi


if [ -z $LZ4_ROOT ] ; then
  export LZ4_ROOT=$INSTALL_DIR/lz4
fi

if [ -z $OSC_ROOT ] ; then
  export OSC_ROOT=$INSTALL_DIR/oscpack
fi

if [ -z $AIRSIM_ROOT ] ; then
  export AIRSIM_ROOT=$INSTALL_DIR/AirSim
fi


if [ ! -z $CC ] ; then
  export FORCE_CC=$CC
  echo "Forcing CC=$CC"
fi

if [ ! -z $CXX ] ; then
  export FORCE_CXX=$CXX
  echo "Forcing CXX=$CXX"
fi

# echo build information
echo "INSTALL_DIR will be $INSTALL_DIR"
echo "Using $CORES build jobs"

if [ $PREREQS -eq 0 ]; then
  echo "No pre-requisites will be installed"
else
  echo "Pre-requisites will be installed"
fi

echo "MPC_ROOT is set to $MPC_ROOT"

echo "EIGEN_ROOT is set to $EIGEN_ROOT"
echo "CAPNP_ROOT is set to $CAPNP_ROOT"
echo "CAPNPJAVA_ROOT is set to $CAPNPJAVA_ROOT"
echo "CUDA is set to $CUDA"
echo "OSC_ROOT is set to $OSC_ROOT"
echo "UNREAL_ROOT is set to $UNREAL_ROOT"
echo "AIRSIM_ROOT is set to $AIRSIM_ROOT"
echo "LZ4_ROOT is set to $LZ4_ROOT"
echo "MADARA will be built from $MADARA_ROOT"
if [ $MADARA -eq 0 ]; then
  echo "MADARA will not be built"
else
  echo "MADARA will be built"
fi

echo "GAMS_ROOT is set to $GAMS_ROOT"

echo "ODROID has been set to $ODROID"
echo "OPENCV has been set to $OPENCV"
echo "TESTS has been set to $TESTS"
echo "ROS has been set to $ROS"
echo "STRIP has been set to $STRIP"
if [ $STRIP -eq 1 ]; then
  echo "strip will use $STRIP_EXE"
fi
echo "AIRLIB has been set to $AIRLIB"

if [ $DOCS -eq 1 ]; then
  echo "DOCS is set to $DOCS"
fi

echo ""

unzip_strip() (
  local zip=$1
  local dest=${2:-.}
  local temp=$(mktemp -d) && unzip -qq -d "$temp" "$zip" && mkdir -p "$dest" &&
  shopt -s dotglob && local f=("$temp"/*) &&
  if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
    mv "$temp"/*/* "$dest"
  else
    mv "$temp"/* "$dest"
  fi && rmdir "$temp"/* "$temp"
)

append_if_needed() (
  if grep -q "$1" "$2"; then
    true
  else
    echo "$1" >> "$2"
  fi
)

if [ $PREREQS -eq 1 ] && [ $MAC -eq 0 ]; then

  if [ $CLANG -eq 1 ]; then
	# Not using Mac
    sudo apt-get install -y -f clang-6.0 libc++-dev libc++abi-dev clang-5.0

    if [ $CLANG_SUFFIX = "-8" ]; then
      sudo apt-get install -y -f clang-8
    elif [ $CLANG_SUFFIX = "-9" ]; then
      sudo apt-get install -y -f clang-9
    fi
  fi


  if [ $SSL -eq 1 ]; then
    sudo apt-get install -y libssl-dev
  fi
  
  if [ $ZMQ -eq 1 ]; then 
    sudo apt-get install -y libtool pkg-config autoconf automake
  fi

fi

# Update CORES in the GAMS environment file
if grep -q CORES $HOME/.gams/env.sh ; then
  sed -i 's@CORES=.*@CORES='"$CORES"'@' $HOME/.gams/env.sh
else
  echo "export CORES=$CORES" >> $HOME/.gams/env.sh
fi


# Update AIRSIM_ROOT in the GAMS environment file
if grep -q AIRSIM_ROOT $HOME/.gams/env.sh ; then
  sed -i 's@AIRSIM_ROOT=.*@AIRSIM_ROOT='"$AIRSIM_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export AIRSIM_ROOT=$AIRSIM_ROOT" >> $HOME/.gams/env.sh
fi

# Update OSC_ROOT in the GAMS environment file
if grep -q OSC_ROOT $HOME/.gams/env.sh ; then
  sed -i 's@OSC_ROOT=.*@OSC_ROOT='"$OSC_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export OSC_ROOT=$OSC_ROOT" >> $HOME/.gams/env.sh
fi

# Update GAMS environment script with VREP_ROOT
if grep -q VREP_ROOT $HOME/.gams/env.sh ; then
  sed -i 's@VREP_ROOT=.*@VREP_ROOT='"$VREP_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export VREP_ROOT=$VREP_ROOT" >> $HOME/.gams/env.sh
fi



if [ $LZ4 -eq 1 ] ; then
  export LZ4=1
  if [ ! -d $LZ4_ROOT  ]; then
    echo "git clone https://github.com/lz4/lz4.git $LZ4_ROOT"
    git clone https://github.com/lz4/lz4.git $LZ4_ROOT
  else
    echo "UPDATING LZ4"
    cd $LZ4_ROOT
    git pull
  fi

  LZ4_REPO_RESULT=$?

  # Update GAMS environment script with LZ4_ROOT
  if grep -q LZ4_ROOT $HOME/.gams/env.sh ; then
    sed -i 's@LZ4_ROOT=.*@LZ4_ROOT='"$LZ4_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export LZ4_ROOT=$LZ4_ROOT" >> $HOME/.gams/env.sh
  fi

  if [ -f $LZ4_ROOT/lib/lz4.c ] ; then
    echo "cp $LZ4_ROOT/lib/lz4.c $LZ4_ROOT/lib/lz4.cpp"
    cp $LZ4_ROOT/lib/lz4.c $LZ4_ROOT/lib/lz4.cpp
  fi

  if [ ! -f $LZ4_ROOT/lib/liblz4.so ]; then
    echo "LZ4 library did not build properly";
  fi
fi

if [ ! -z $FORCE_CC ] ; then
  export CC=$FORCE_CC
  echo "Forcing CC=$CC"
fi

if [ ! -z $FORCE_CXX ] ; then
  export CXX=$FORCE_CXX
  echo "Forcing CXX=$CXX"
fi

# check if MPC is a prereq for later packages

if [ $DMPL -eq 1 ] || [ $GAMS -eq 1 ] || [ $MADARA -eq 1 ]; then
  MPC_DEPENDENCY_ENABLED=1
fi

if [ $MPC_DEPENDENCY_ENABLED -eq 1 ] && [ ! -d $MPC_ROOT ]; then
  MPC_AS_A_PREREQ=1
fi


if [ $MPC -eq 1 ] || [ $MPC_AS_A_PREREQ -eq 1 ]; then

  cd $INSTALL_DIR

  echo "ENTERING $MPC_ROOT"
  if [ ! -d $MPC_ROOT ] ; then
    echo "git clone --depth 1 https://github.com/DOCGroup/MPC.git $MPC_ROOT"
    git clone --depth 1 https://github.com/DOCGroup/MPC.git $MPC_ROOT
    MPC_REPO_RESULT=$?
  fi
else
  echo "NOT CHECKING MPC"
fi


if [ $GAMS -eq 1 ] || [ $EIGEN_AS_A_PREREQ -eq 1 ]; then

  cd $INSTALL_DIR

  echo "ENTERING $EIGEN_ROOT"
  if [ -d $EIGEN_ROOT ]; then
    (
      cd $EIGEN_ROOT
      if git branch | grep "* master"; then
        echo "EIGEN IN $EIGEN_ROOT IS MASTER BRANCH"
        echo "Deleting and redownloading stable release..."
        cd $HOME
        rm -rf $EIGEN_ROOT
      fi
    )
  fi
  if [ ! -d $EIGEN_ROOT ] ; then
    echo "git clone https://gitlab.com/libeigen/eigen.git $EIGEN_ROOT"
    git clone https://gitlab.com/libeigen/eigen.git $EIGEN_ROOT
    EIGEN_REPO_RESULT=$?
  else
    echo "UPDATING Eigen"
    cd $EIGEN_ROOT
    git pull
    EIGEN_REPO_RESULT=$?
  fi
else
  echo "NOT CHECKING EIGEN"
fi

# this is common to Mac and Linux, so it needs to be outside of the above
if [ $PREREQS -eq 1 ]; then 

  if [ $OSC -eq 1 ]; then
    if [ ! -d $OSC_ROOT ]; then 
      echo "Downloading oscpack"
      git clone https://github.com/jredmondson/oscpack.git $OSC_ROOT
    else
      echo "Updating oscpack"
      cd $OSC_ROOT
      git pull
    fi

    cd $OSC_ROOT
    echo "Cleaning oscpack"
    make clean
    echo "Building oscpack"0
    if [ $MAC -eq 0 ] && [ $CLANG -eq 1 ]; then
    
      if [ ! -z $FORCE_CC ] ; then
        export CC=$FORCE_CC
        echo "Forcing CC=$CC"
      else
        export CC=clang
      fi

      if [ ! -z $FORCE_CXX ] ; then
        export CXX=$FORCE_CXX
        echo "Forcing CXX=$CXX"
      else
        export CXX=clang++
      fi

    fi 

    if [ ! -z "$CXX" ]; then
      sudo make CXX=$CXX COPTS='-Wall -Wextra -fPIC' install
    else
      sudo make COPTS='-Wall -Wextra -fPIC' install
    fi
  fi # end OSC -eq 1
fi # end PREREQS -eq 1

if [ $ZMQ -eq 1 ]; then
  export ZMQ=1
  cd $INSTALL_DIR

  if [ -z $ZMQ_ROOT ]; then
      if [ $ANDROID -eq 1 ]; then
        export ZMQ_ROOT=$INSTALL_DIR/libzmq/output
      else 
        export ZMQ_ROOT=/usr/local
      fi
  fi

  echo "ZMQ_ROOT has been set to $ZMQ_ROOT"

  if [ ! -f $ZMQ_ROOT/lib/libzmq.so ]; then
    
     if [ ! -d libzmq ] ; then
       echo "git clone --depth 1 https://github.com/zeromq/libzmq"
       git clone --depth 1 https://github.com/zeromq/libzmq
       ZMQ_REPO_RESULT=$?
     fi
    
     #Go to zmq directory
     cd libzmq
    
     # For Android
     if [ $ANDROID -eq 1 ]; then 
        echo "UPDATING ZMQ FOR ANDROID"
        export ZMQ_OUTPUT_DIR=`pwd`/output
        ./autogen.sh && ./configure --enable-shared --disable-static --host=$ANDROID_TOOLCHAIN --prefix=$ZMQ_OUTPUT_DIR LDFLAGS="-L$ZMQ_OUTPUT_DIR/lib" CPPFLAGS="-fPIC -I$ZMQ_OUTPUT_DIR/include" LIBS="-lgcc"  CXX=$NDK_TOOLS/bin/$ANDROID_TOOLCHAIN-clang++ CC=$NDK_TOOLS/bin/$ANDROID_TOOLCHAIN-clang
        make clean install -j $CORES
        export ZMQ_ROOT=$ZMQ_OUTPUT_DIR
   
    #For regular builds.
     else 
       echo "UPDATING ZMQ"
       ./autogen.sh && ./configure && make clean -j $CORES
       make check
       sudo make install && sudo ldconfig
       ZMQ_BUILD_RESULT=$? 
       export ZMQ_ROOT=/usr/local
     fi
    
  fi
    
    #check again after installation
    if [ ! -f $ZMQ_ROOT/lib/libzmq.so ]; then
     echo "No libzmq found at $ZMQ_ROOT"
     exit 1;
    fi

#fi  #libzmq.so condition check ends.
else
  echo "NOT BUILDING ZEROMQ. If this is an error, delete the libzmq directory"
fi

if [ $SSL -eq 1 ]; then
  export SSL=1;
  if [ -z $SSL_ROOT ]; then
    if [ $MAC -eq 0 ]; then
      export SSL_ROOT=/usr
    elif [ $ANDROID -eq 1 ]; then
      export SSL_ROOT=$INSTALL_DIR/openssl
    else
      export SSL_ROOT=/usr/local/opt/openssl
    fi
  fi
fi

# set MADARA_ROOT since it is required by most other packages
if [ -z $MADARA_ROOT ] ; then
  export MADARA_ROOT=$INSTALL_DIR/madara
  echo "SETTING MADARA_ROOT to $MADARA_ROOT"
fi

# check if MADARA_ROOT/lib is in LD_LIBRARY_PATH and modify if needed
if [[ ! ":$LD_LIBRARY_PATH:" == *":$MADARA_ROOT/lib:"* ]]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MADARA_ROOT/lib
fi

if [ $MADARA -eq 1 ] || [ $MADARA_AS_A_PREREQ -eq 1 ]; then

  echo "LD_LIBRARY_PATH for MADARA compile is $LD_LIBRARY_PATH"

  cd $INSTALL_DIR

  if [ $NOKARL -eq 1 ] ; then
    echo "REMOVING KARL EXPRESSION EVALUATION FROM MADARA BUILD"
  fi

  if [ ! -z $FORCE_CC ] ; then
    export CC=$FORCE_CC
    echo "Forcing CC=$CC"
  fi

  if [ ! -z $FORCE_CXX ] ; then
    export CXX=$FORCE_CXX
    echo "Forcing CXX=$CXX"
  fi


  cd $MADARA_ROOT

  if [ $CMAKE -eq 1 ] ; then
    
    echo "GENERATING MADARA PROJECT"
    
    mkdir build
    mkdir install
    
    cd build
    
    echo "cmake -Dmadara_TESTS=$TESTS -Dmadara_TUTORIALS=$TUTORIALS -DCMAKE_INSTALL_PREFIX=../install .."
    cmake -Dmadara_TESTS=$TESTS -Dmadara_TUTORIALS=$TUTORIALS -DCMAKE_INSTALL_PREFIX=../install ..
    echo "... build debug libs"
    cmake --build .  --config debug
    
    echo "... build release libs"
    cmake --build .  --config release
    echo "... installing to $MADARA_ROOT/install"
    cmake --build .  --target install --config release
    cmake --build .  --target install --config debug
    MADARA_BUILD_RESULT=$?

  else
    echo "GENERATING MADARA PROJECT"

    echo "perl $MPC_ROOT/mwc.pl -type make -features no_karl=$NOKARL,android=$ANDROID,python=$PYTHON,java=$JAVA,tests=$TESTS,tutorials=$TUTORIALS,docs=$DOCS,ssl=$SSL,zmq=$ZMQ,simtime=$SIMTIME,nothreadlocal=$NOTHREADLOCAL,clang=$CLANG,debug=$DEBUG,warnings=$WARNINGS,capnp=$CAPNP MADARA.mwc"
    perl $MPC_ROOT/mwc.pl -type make -features no_karl=$NOKARL,lz4=$LZ4,android=$ANDROID,python=$PYTHON,java=$JAVA,tests=$TESTS,tutorials=$TUTORIALS,docs=$DOCS,ssl=$SSL,zmq=$ZMQ,simtime=$SIMTIME,nothreadlocal=$NOTHREADLOCAL,clang=$CLANG,debug=$DEBUG,warnings=$WARNINGS,capnp=$CAPNP MADARA.mwc

    echo "BUILDING MADARA"
    echo "make depend no_karl=$NOKARL android=$ANDROID capnp=$CAPNP java=$JAVA tests=$TESTS tutorials=$TUTORIALS docs=$DOCS ssl=$SSL zmq=$ZMQ simtime=$SIMTIME python=$PYTHON warnings=$WARNINGS nothreadlocal=$NOTHREADLOCAL -j $CORES"
    make depend no_karl=$NOKARL lz4=$LZ4 android=$ANDROID capnp=$CAPNP java=$JAVA tests=$TESTS tutorials=$TUTORIALS docs=$DOCS ssl=$SSL zmq=$ZMQ simtime=$SIMTIME python=$PYTHON warnings=$WARNINGS nothreadlocal=$NOTHREADLOCAL -j $CORES
    echo "make no_karl=$NOKARL android=$ANDROID capnp=$CAPNP java=$JAVA tests=$TESTS tutorials=$TUTORIALS docs=$DOCS ssl=$SSL zmq=$ZMQ simtime=$SIMTIME python=$PYTHON warnings=$WARNINGS nothreadlocal=$NOTHREADLOCAL -j $CORES"
    make no_karl=$NOKARL lz4=$LZ4 android=$ANDROID capnp=$CAPNP java=$JAVA tests=$TESTS tutorials=$TUTORIALS docs=$DOCS ssl=$SSL zmq=$ZMQ simtime=$SIMTIME python=$PYTHON warnings=$WARNINGS nothreadlocal=$NOTHREADLOCAL -j $CORES
    MADARA_BUILD_RESULT=$?
    if [ ! -f $MADARA_ROOT/lib/libMADARA.so ]; then
      MADARA_BUILD_RESULT=1
      echo -e "\e[91m MADARA library did not build properly. \e[39m"
      exit 1;
    fi

    if [ $STRIP -eq 1 ]; then
      echo "STRIPPING MADARA"
      $STRIP_EXE libMADARA.so*
    fi
  fi
else
  echo "NOT BUILDING MADARA"
fi

echo "LD_LIBRARY_PATH for GAMS compile is $LD_LIBRARY_PATH"
 
# check if GAMS_ROOT/lib is in LD_LIBRARY_PATH and modify if needed
if [[ ! ":$LD_LIBRARY_PATH:" == *":$GAMS_ROOT/lib:"* ]]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GAMS_ROOT/lib
fi
 

# save the last feature changing build (need to fix this by flattening $@)
if [ $CLEAN -eq 1 ]; then
  echo "$@" > $GAMS_ROOT/last_build.lst
  
fi

echo ""
echo "BUILD STATUS"


if [ $MPC -eq 1 ] || [ $MPC_AS_A_PREREQ -eq 1 ]; then
  echo "  MPC"
  if [ $MPC_REPO_RESULT -eq 0 ]; then
    echo -e "    REPO=\e[92mPASS\e[39m"
  else
    echo -e "    REPO=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
fi

if [ $LZ4 -eq 1 ]; then
  echo "  LZ4"
  if [ $LZ4_REPO_RESULT -eq 0 ]; then
    echo -e "    REPO=\e[92mPASS\e[39m"
  else
    echo -e "    REPO=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
fi

if [ $ZMQ -eq 1 ]; then
  echo "  ZMQ"
  if [ $ZMQ_REPO_RESULT -eq 0 ]; then
    echo -e "    REPO=\e[92mPASS\e[39m"
  else
    echo -e "    REPO=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
  if [ $ZMQ_BUILD_RESULT -eq 0 ]; then
    echo -e "    BUILD=\e[92mPASS\e[39m"
  else
    echo -e "    BUILD=\e[91mFAIL\e[39m"
    # MAC has multiple failed tests for ZeroMQ
    if [ $MAC -eq 0 ]; then
      (( BUILD_ERRORS++ ))
    fi
  fi
fi


if [ $MADARA -eq 1 ] || [ $MADARA_AS_A_PREREQ -eq 1 ]; then
  echo "  MADARA"

  if [ $MADARAPULL -eq 1 ]; then
    if [ $MADARA_REPO_RESULT -eq 0 ]; then
      echo -e "    REPO=\e[92mPASS\e[39m"
    else
      echo -e "    REPO=\e[91mFAIL\e[39m"
      (( BUILD_ERRORS++ ))
    fi
  fi

  if [ $MADARA_BUILD_RESULT -eq 0 ]; then
    echo -e "    BUILD=\e[92mPASS\e[39m"
  else
    echo -e "    BUILD=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
fi


if [ $AIRLIB -eq 1 ] && [ $FORCE_AIRSIM -eq 1 ]; then
  echo "  AIRSIM"
  if [ $AIRSIM_BUILD_RESULT -eq 0 ]; then
    echo -e "    BUILD=\e[92mPASS\e[39m"
  else
    echo -e "    BUILD=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
fi

if [ $GAMS -eq 1 ] || [ $GAMS_AS_A_PREREQ -eq 1 ]; then
  echo "  EIGEN"
  if [ $EIGEN_REPO_RESULT -eq 0 ]; then
    echo -e "    REPO=\e[92mPASS\e[39m"
  else
    echo -e "    REPO=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi

  echo "  GAMS"
  if [ $GAMSPULL -eq 1 ]; then
    if [ $GAMS_REPO_RESULT -eq 0 ]; then
      echo -e "    REPO=\e[92mPASS\e[39m"
    else
      echo -e "    REPO=\e[91mFAIL\e[39m"
      (( BUILD_ERRORS++ ))
    fi
  fi

  if [ $GAMS_BUILD_RESULT -eq 0 ]; then
    echo -e "    BUILD=\e[92mPASS\e[39m"
  else
    echo -e "    BUILD=\e[91mFAIL\e[39m"
    (( BUILD_ERRORS++ ))
  fi
fi


echo -e ""
echo -e "Saving environment variables into \$HOME/.gams/env.sh"

if grep -q "export MPC_ROOT" $HOME/.gams/env.sh ; then
  sed -i 's@MPC_ROOT=.*@MPC_ROOT='"$MPC_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export MPC_ROOT=$MPC_ROOT" >> $HOME/.gams/env.sh
fi

if grep -q "export EIGEN_ROOT" $HOME/.gams/env.sh ; then
  sed -i 's@EIGEN_ROOT=.*@EIGEN_ROOT='"$EIGEN_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export EIGEN_ROOT=$EIGEN_ROOT" >> $HOME/.gams/env.sh
fi

if grep -q "export CAPNP_ROOT" $HOME/.gams/env.sh ; then
  sed -i 's@CAPNP_ROOT=.*@CAPNP_ROOT='"$CAPNP_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export CAPNP_ROOT=$CAPNP_ROOT" >> $HOME/.gams/env.sh
fi

if grep -q "export MADARA_ROOT" $HOME/.gams/env.sh ; then
  sed -i 's@MADARA_ROOT=.*@MADARA_ROOT='"$MADARA_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export MADARA_ROOT=$MADARA_ROOT" >> $HOME/.gams/env.sh
fi

if grep -q "export GAMS_ROOT" $HOME/.gams/env.sh ; then
  sed -i 's@export GAMS_ROOT=.*@export GAMS_ROOT='"$GAMS_ROOT"'@' $HOME/.gams/env.sh
else
  echo "export GAMS_ROOT=$GAMS_ROOT" >> $HOME/.gams/env.sh
fi

if [ $SSL -eq 1 ]; then
  if [ -z $SSL_ROOT ]; then
    export SSL_ROOT=/usr
  fi

  if grep -q SSL_ROOT $HOME/.gams/env.sh ; then
    sed -i 's@SSL_ROOT=.*@SSL_ROOT='"$SSL_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export SSL_ROOT=$SSL_ROOT" >> $HOME/.gams/env.sh
  fi

fi

if [ $LZ4 -eq 1 ]; then

  if grep -q LZ4_ROOT $HOME/.gams/env.sh ; then
    sed -i 's@LZ4_ROOT=.*@LZ4_ROOT='"$LZ4_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export LZ4_ROOT=$LZ4_ROOT" >> $HOME/.gams/env.sh
  fi

fi

if [ $ZMQ -eq 1 ]; then

  if grep -q ZMQ_ROOT $HOME/.gams/env.sh ; then
    sed -i 's@ZMQ_ROOT=.*@ZMQ_ROOT='"$ZMQ_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export ZMQ_ROOT=$ZMQ_ROOT" >> $HOME/.gams/env.sh
  fi
fi

if [ $CMAKE -eq 1 ]; then
  
  if [ $MAC -eq 0 ]; then
    echo "Configuring non-mac cmake..."

    if grep -q LD_LIBRARY_PATH $HOME/.gams/env.sh ; then
      sed -i 's@LD_LIBRARY_PATH=.*@LD_LIBRARY_PATH='"\$LD_LIBRARY_PATH"':'"\$MADARA_ROOT/install/lib"':'"\$GAMS_ROOT/install/lib"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++/.libs"'@' $HOME/.gams/env.sh
    else
      echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$MADARA_ROOT/install/lib:\$GAMS_ROOT/install/lib:\$VREP_ROOT:\$CAPNP_ROOT/c++/.libs" >> $HOME/.gams/env.sh
    fi

  else

    echo "Configuring mac cmake..."
    if grep -q DYLD_LIBRARY_PATH $HOME/.gams/env.sh ; then
      sed -i 's@DYLD_LIBRARY_PATH=.*@DYLD_LIBRARY_PATH='"\$DYLD_LIBRARY_PATH"':'"\$MADARA_ROOT/install/lib"':'"\$GAMS_ROOT/install/lib"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++/.libs"'@' $HOME/.gams/env.sh
    else
      echo "export DYLD_LIBRARY_PATH=\$DYLD_LIBRARY_PATH:\$MADARA_ROOT/install/lib:\$GAMS_ROOT/install/lib:\$VREP_ROOT:\$CAPNP_ROOT/c++/.libs" >> $HOME/.gams/env.sh
    fi
  fi

  if grep -q "export PATH" $HOME/.gams/env.sh ; then
    sed -i 's@export PATH=.*@export PATH='"\$PATH"':'"\$MPC_ROOT"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++"':'"\$MADARA_ROOT/install/bin"':'"\$GAMS_ROOT/install/bin"':'"\$DMPL_ROOT/src/DMPL"':'"\$DMPL_ROOT/src/vrep"':'"\$CAPNPJAVA_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export PATH=\$PATH:\$MPC_ROOT:\$VREP_ROOT:\$CAPNP_ROOT/c++:\$MADARA_ROOT/install/bin:\$GAMS_ROOT/install/bin:\$DMPL_ROOT/src/DMPL:\$DMPL_ROOT/src/vrep:\$CAPNPJAVA_ROOT" >> $HOME/.gams/env.sh
  fi
else # not CMAKE
  if [ $MAC -eq 0 ]; then

    if grep -q LD_LIBRARY_PATH $HOME/.gams/env.sh ; then
      sed -i 's@LD_LIBRARY_PATH=.*@LD_LIBRARY_PATH='"\$LD_LIBRARY_PATH"':'"\$MADARA_ROOT/lib"':'"\$GAMS_ROOT/lib"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++/.libs:\$SCRIMMAGE_GIT_ROOT/build/plugin_libs:\$SCRIMMAGE_GIT_ROOT/build/lib"'@' $HOME/.gams/env.sh
    else
      echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$MADARA_ROOT/lib:\$GAMS_ROOT/lib:\$VREP_ROOT:\$CAPNP_ROOT/c++/.libs:\$SCRIMMAGE_GIT_ROOT/build/plugin_libs:\$SCRIMMAGE_GIT_ROOT/build/lib" >> $HOME/.gams/env.sh
    fi
  else
    if grep -q DYLD_LIBRARY_PATH $HOME/.gams/env.sh ; then
      sed -i 's@DYLD_LIBRARY_PATH=.*@DYLD_LIBRARY_PATH='"\$DYLD_LIBRARY_PATH"':'"\$MADARA_ROOT/lib"':'"\$GAMS_ROOT/lib"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++/.libs"'@' $HOME/.gams/env.sh
    else
      echo "export DYLD_LIBRARY_PATH=\$DYLD_LIBRARY_PATH:\$MADARA_ROOT/lib:\$GAMS_ROOT/lib:\$VREP_ROOT:\$CAPNP_ROOT/c++/.libs" >> $HOME/.gams/env.sh
    fi
  fi

  if grep -q "export PATH" $HOME/.gams/env.sh ; then
    sed -i 's@export PATH=.*@export PATH='"\$PATH"':'"\$MPC_ROOT"':'"\$VREP_ROOT"':'"\$CAPNP_ROOT/c++"':'"\$MADARA_ROOT/bin"':'"\$GAMS_ROOT/bin"':'"\$DMPL_ROOT/src/DMPL"':'"\$DMPL_ROOT/src/vrep"':'"\$CAPNPJAVA_ROOT"'@' $HOME/.gams/env.sh
  else
    echo "export PATH=\$PATH:\$MPC_ROOT:\$VREP_ROOT:\$CAPNP_ROOT/c++:\$MADARA_ROOT/bin:\$GAMS_ROOT/bin:\$DMPL_ROOT/src/DMPL:\$DMPL_ROOT/src/vrep:\$CAPNPJAVA_ROOT" >> $HOME/.gams/env.sh
  fi
  
fi

if ! grep -q ".gams/env.sh" $HOME/.bashrc ; then
  echo "Updating bashrc to load environment. Close terminals to reload."
  echo ""
  echo "" >> $HOME/.bashrc
  echo "source \$HOME/.gams/env.sh" >> $HOME/.bashrc
else
  echo "If environment has changed, close terminals or reload .bashrc"
  echo ""
fi

echo "BUILD_ERRORS=$BUILD_ERRORS"
exit $BUILD_ERRORS
