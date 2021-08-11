#!/bin/bash

# A script to make manifest manual updating easier
# SPDX-FileCopyrightText: 2021, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT

display_usage() {
    echo -e "This script helps to keep the manifest updated by checking the latest commits."
    echo -e "The script does not change the manifest, it's only for developers' purposes."
    echo -e "\nUsage:\n./update-helper.sh\n"
}

if [[ ( $1 == "--help") ||  $1 == "-h" ]]
    then
        display_usage
        exit 0
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BASEDIR=$PWD
echo -e "Getting the latest commits in the ${BRANCH} branch..."
mkdir -p sources
cd sources

# openembedded-core
if [ -d "openembedded-core" ]
    then
        cd openembedded-core
        git checkout ${BRANCH}
        git pull origin ${BRANCH}
    else
        git clone https://github.com/openembedded/openembedded-core
        cd openembedded-core
        git checkout $BRANCH
fi
COMMIT_OPENEMBEDDED_CORE=$(git rev-parse HEAD)
cd ..

# meta-openembedded
if [ -d "meta-openembedded" ]
    then
        cd meta-openembedded
        git checkout ${BRANCH}
        git pull origin ${BRANCH}
    else
        git clone https://github.com/openembedded/meta-openembedded
        cd meta-openembedded
        git checkout $BRANCH
fi
COMMIT_META_OPENEMBEDDED=$(git rev-parse HEAD)
cd ..

# meta-qt4
if [ ${BRANCH} == "rocko" ]
   then
       if [ -d "meta-qt4" ]
           then
               cd meta-qt4
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
           else
               git clone git://git.yoctoproject.org/meta-qt4
               cd meta-qt4
               git checkout $BRANCH
       fi
       COMMIT_META_QT4=$(git rev-parse HEAD)
       cd ..
fi

# meta-qt5
if [ -d "meta-qt5" ]
    then
        cd meta-qt5
        git checkout ${BRANCH}
        git pull origin ${BRANCH}
    else
        git clone https://github.com/meta-qt5/meta-qt5
        cd meta-qt5
        git checkout $BRANCH
fi
COMMIT_META_QT5=$(git rev-parse HEAD)
cd ..

# meta-qt5-extra
if [ ${BRANCH} == "sumo" ]
    then
        if [ -d "meta-qt5-extra" ]
            then
                cd meta-qt5-extra
                git checkout ${BRANCH}
                git pull origin ${BRANCH}
            else
                git clone https://github.com/schnitzeltony/meta-qt5-extra
                cd meta-qt5-extra
                git checkout $BRANCH
        fi
        COMMIT_META_QT5_EXTRA=$(git rev-parse HEAD)
        cd ..
fi

# meta-sdr
if [ -d "meta-sdr" ]
    then
        cd meta-sdr
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SDR="Unknown"
           else
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
               COMMIT_META_SDR=$(git rev-parse HEAD)
        fi
    else
        git clone https://github.com/balister/meta-sdr
        cd meta-sdr
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SDR="Unknown"
           else
               git checkout ${BRANCH}
               COMMIT_META_SDR=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-xilinx
SPECIAL_XILINX_BRANCH=${BRANCH}
if [ ${BRANCH} == "rocko" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2018.3"
fi
if [ ${BRANCH} == "thud" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2019.2"
fi
if [ ${BRANCH} == "zeus" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2020.3"
fi
if [ ${BRANCH} == "gatesgarth" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2021.1"
fi
if [ -d "meta-xilinx" ]
    then
        cd meta-xilinx
        exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_XILINX_BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_XILINX="Unknown"
           else
               git checkout ${SPECIAL_XILINX_BRANCH}
               git pull origin ${SPECIAL_XILINX_BRANCH}
               COMMIT_META_XILINX=$(git rev-parse HEAD)
        fi
    else
        git clone https://github.com/Xilinx/meta-xilinx
        cd meta-xilinx
        exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_XILINX_BRANCH})
        if [[ -z ${exists_in_remote} ]]
            then
                COMMIT_META_XILINX="Unknown"
            else
                git checkout ${SPECIAL_XILINX_BRANCH}
                COMMIT_META_XILINX=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-xilinx-tools
SPECIAL_XILINX_TOOLS_BRANCH=${BRANCH}
if [ ${BRANCH} == "thud" ]
   then
       SPECIAL_XILINX_TOOLS_BRANCH="rel-v2019.2"
fi
if [ ${BRANCH} == "zeus" ]
   then
       SPECIAL_XILINX_TOOLS_BRANCH="rel-v2020.3"
fi

if [ ${BRANCH} == "thud" ] || [ ${BRANCH} == "zeus" ]
   then
       if [ -d "meta-xilinx-tools" ]
           then
               cd meta-xilinx-tools
               exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_XILINX_TOOLS_BRANCH})
               if [[ -z ${exists_in_remote} ]]
                  then
                      COMMIT_META_XILINX_TOOLS="Unknown"
                  else
                      git checkout ${SPECIAL_XILINX_TOOLS_BRANCH}
                      git pull origin ${SPECIAL_XILINX_TOOLS_BRANCH}
                      COMMIT_META_XILINX_TOOLS=$(git rev-parse HEAD)
               fi
           else
               git clone https://github.com/Xilinx/meta-xilinx-tools
               cd meta-xilinx-tools
               exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_XILINX_TOOLS_BRANCH})
               if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_XILINX_TOOLS="Unknown"
                   else
                       git checkout ${SPECIAL_XILINX_TOOLS_BRANCH}
                       COMMIT_META_XILINX_TOOLS=$(git rev-parse HEAD)
               fi
       fi
       cd ..
fi

# meta-adi
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ] || [ ${BRANCH} == "thud" ]
    then
        if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ]
            then
                SPECIAL_ADI_BRANCH="2019_R1"
        fi
        if [ ${BRANCH} == "thud" ]
            then
                SPECIAL_ADI_BRANCH="2019_R2"
        fi
        if [ -d "meta-adi" ]
            then
                cd meta-adi
                exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_ADI_BRANCH})
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_ADI="Unknown"
                   else
                       git checkout ${SPECIAL_ADI_BRANCH}
                       git pull origin ${SPECIAL_ADI_BRANCH}
                       COMMIT_META_ADI=$(git rev-parse HEAD)
                fi
            else
                git clone https://github.com/analogdevicesinc/meta-adi
                cd meta-adi
                exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_ADI_BRANCH})
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_ADI="Unknown"
                   else
                       git checkout ${SPECIAL_ADI_BRANCH}
                       COMMIT_META_ADI=$(git rev-parse HEAD)
                fi
        fi
        cd ..
fi

# hdl
SPECIAL_HDL_BRANCH=${BRANCH}
if [ ${BRANCH} == "rocko" ]
    then
        SPECIAL_HDL_BRANCH="hdl_2019_r1"
fi
if [ ${BRANCH} == "thud" ]
    then
        SPECIAL_HDL_BRANCH="hdl_2019_r2"
fi
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "thud" ]
    then
        if [ -d "hdl" ]
            then
                cd hdl
                exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_HDL_BRANCH})
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_HDL="Unknown"
                   else
                       git checkout remotes/origin/${SPECIAL_HDL_BRANCH}
                       git pull origin ${SPECIAL_HDL_BRANCH}
                       COMMIT_HDL=$(git rev-parse HEAD)
                fi
            else
                git clone https://github.com/analogdevicesinc/hdl
                cd hdl
                exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_HDL_BRANCH})
                if [[ -z ${exists_in_remote} ]]
                    then
                        COMMIT_HDL="Unknown"
                    else
                        git checkout remotes/origin/${SPECIAL_HDL_BRANCH}
                        COMMIT_HDL=$(git rev-parse HEAD)
                fi
        fi
        cd ..
fi

# meta-raspberrypi
if [ -d "meta-raspberrypi" ]
    then
        cd meta-raspberrypi
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_RASPI="Unknown"
           else
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
               COMMIT_META_RASPI=$(git rev-parse HEAD)
        fi
    else
        git clone git://git.yoctoproject.org/meta-raspberrypi
        cd meta-raspberrypi
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_RASPI="Unknown"
           else
               git checkout ${BRANCH}
               COMMIT_META_RASPI=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-intel
if [ -d "meta-intel" ]
    then
        cd meta-intel
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_INTEL="Unknown"
           else
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
               COMMIT_META_INTEL=$(git rev-parse HEAD)
        fi
    else
        git clone git://git.yoctoproject.org/meta-intel
        cd meta-intel
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_INTEL="Unknown"
           else
               git checkout ${BRANCH}
               COMMIT_META_INTEL=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-swupdate
if [ -d "meta-swupdate" ]
    then
        cd meta-swupdate
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SWUPDATE="Unknown"
           else
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
               COMMIT_META_SWUPDATE=$(git rev-parse HEAD)
        fi
    else
        git clone https://github.com/sbabic/meta-swupdate
        cd meta-swupdate
        exists_in_remote=$(git ls-remote --heads origin ${BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SWUPDATE="Unknown"
           else
               git checkout ${BRANCH}
               COMMIT_META_SWUPDATE=$(git rev-parse HEAD)
        fi
fi
cd ..

echo -e "\nSummary of updated commits for branch ${BRANCH}:\n"
echo -e "openembedded-core last commit: ${COMMIT_OPENEMBEDDED_CORE}"
echo -e "meta-openembedded last commit: ${COMMIT_META_OPENEMBEDDED}"
if [ ${BRANCH} == "rocko" ]
   then
       echo -e "meta-qt4 last commit:          ${COMMIT_META_QT4}"
fi
echo -e "meta-qt5 last commit:          ${COMMIT_META_QT5}"
if [ ${BRANCH} == "sumo" ]
   then
       echo -e "meta-qt5-extra last commit:    ${COMMIT_META_QT5_EXTRA}"
fi
echo -e "meta-sdr last commit:          ${COMMIT_META_SDR}"
echo -e "meta-xilinx last commit:       ${COMMIT_META_XILINX}"
if [ ${BRANCH} == "thud" ] || [ ${BRANCH} == "zeus" ]
    then
        echo -e "meta-xilinx-tools last commit: ${COMMIT_META_XILINX_TOOLS}"
fi
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ] || [ ${BRANCH} == "thud" ]
    then
        echo -e "meta-adi last commit:          ${COMMIT_META_ADI}"
fi
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "thud" ]
    then
        echo -e "hdl last commit:               ${COMMIT_HDL}"
fi
echo -e "meta-raspberrypi last commit:  ${COMMIT_META_RASPI}"
echo -e "meta-intel last commit:        ${COMMIT_META_INTEL}"
echo -e "meta-swupdate last commit:     ${COMMIT_META_SWUPDATE}"
cd $BASEDIR
