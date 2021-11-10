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

REPO_OE_CORE="https://github.com/openembedded/openembedded-core"
REPO_META_OE="https://github.com/openembedded/meta-openembedded"
REPO_META_QT4="git://git.yoctoproject.org/meta-qt4"
REPO_META_QT4_BROWSER="https://git.yoctoproject.org/cgit/cgit.cgi/meta-qt4"
REPO_META_QT5="https://github.com/meta-qt5/meta-qt5"
REPO_META_QT5_EXTRA="https://github.com/schnitzeltony/meta-qt5-extra"
REPO_META_SDR="https://github.com/balister/meta-sdr"
REPO_META_XILINX="https://github.com/Xilinx/meta-xilinx"
REPO_META_XILINX_TOOLS="https://github.com/Xilinx/meta-xilinx-tools"
REPO_META_ADI="https://github.com/analogdevicesinc/meta-adi"
REPO_HDL="https://github.com/analogdevicesinc/hdl"
REPO_META_RASPBERRYPI="git://git.yoctoproject.org/meta-raspberrypi"
REPO_META_RASPBERRYPI_BROWSER="https://git.yoctoproject.org/cgit/cgit.cgi/meta-raspberrypi"
REPO_META_INTEL="git://git.yoctoproject.org/meta-intel"
REPO_META_INTEL_BROWSER="https://git.yoctoproject.org/cgit/cgit.cgi/meta-intel"
REPO_META_SW_UPDATE="https://github.com/sbabic/meta-swupdate"

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
        git clone ${REPO_OE_CORE}
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
        git clone ${REPO_META_OE}
        cd meta-openembedded
        git checkout $BRANCH
fi
COMMIT_META_OPENEMBEDDED=$(git rev-parse HEAD)
cd ..

# meta-qt4
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ] || [ ${BRANCH} == "thud" ]
   then
       if [ -d "meta-qt4" ]
           then
               cd meta-qt4
               git checkout ${BRANCH}
               git pull origin ${BRANCH}
           else
               git clone ${REPO_META_QT4}
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
        git clone ${REPO_META_QT5}
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
                git clone ${REPO_META_QT5_EXTRA}
                cd meta-qt5-extra
                git checkout $BRANCH
        fi
        COMMIT_META_QT5_EXTRA=$(git rev-parse HEAD)
        cd ..
fi

# meta-sdr
SPECIAL_SDR_BRANCH=${BRANCH}
if [ ${BRANCH} == "thud" ]
    then
        SPECIAL_SDR_BRANCH="sumo"
fi
if [ ${BRANCH} == "warrior" ]
    then
        SPECIAL_SDR_BRANCH="zeus"
fi
if [ ${BRANCH} == "gatesgarth" ]
    then
        SPECIAL_SDR_BRANCH="dunfell"
fi
if [ -d "meta-sdr" ]
    then
        cd meta-sdr
        exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_SDR_BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SDR="Unknown"
           else
               git checkout ${SPECIAL_SDR_BRANCH}
               git pull origin ${SPECIAL_SDR_BRANCH}
               COMMIT_META_SDR=$(git rev-parse HEAD)
        fi
    else
        git clone ${REPO_META_SDR}
        cd meta-sdr
        exists_in_remote=$(git ls-remote --heads origin ${SPECIAL_SDR_BRANCH})
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SDR="Unknown"
           else
               git checkout ${SPECIAL_SDR_BRANCH}
               COMMIT_META_SDR=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-xilinx
SPECIAL_XILINX_BRANCH=${BRANCH}
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
        SPECIAL_XILINX_BRANCH="rel-v2021.2"
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
        git clone ${REPO_META_XILINX}
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
               git clone ${REPO_META_XILINX_TOOLS}
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
                git clone ${REPO_META_ADI}
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
                git clone ${REPO_HDL}
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
        git clone ${REPO_META_RASPBERRYPI}
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
        git clone ${REPO_META_INTEL}
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
        git clone ${REPO_META_SW_UPDATE}
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

# Warning color bold magenta: maybe it's time to update
COLOR_WARNING="\033[1m\033[35m"

# Info color bold green: take it a look, it's probably fine as it is.
COLOR_INFO="\033[1m\033[32m"

COLOR_RESET="\033[0m"

echo -e "\nSummary of updated commits for branch ${BRANCH}:\n"
echo -e "Color legend:"
echo -e "  * The manifest points to the latest commit."
echo -e "  * ${COLOR_INFO}The commit does not match, but it's probably made on purpose.${COLOR_RESET}"
echo -e "  * ${COLOR_WARNING}The commit does not match, time to update?${COLOR_RESET}\n"

# Display latest commit for openembedded-core
if grep -q ${COMMIT_OPENEMBEDDED_CORE} "${BASEDIR}/../default.xml"
    then
        echo -e "openembedded-core last commit: ${COMMIT_OPENEMBEDDED_CORE}"
    else
        echo -e "openembedded-core last commit: ${COLOR_WARNING}${COMMIT_OPENEMBEDDED_CORE}${COLOR_RESET} Check ${REPO_OE_CORE}/tree/${BRANCH}"
fi

# Display latest commit for meta-openembedded
if grep -q ${COMMIT_META_OPENEMBEDDED} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-openembedded last commit: ${COMMIT_META_OPENEMBEDDED}"
    else
        echo -e "meta-openembedded last commit: ${COLOR_WARNING}${COMMIT_META_OPENEMBEDDED}${COLOR_RESET} Check ${REPO_META_OE}/tree/${BRANCH}"
fi

# Display latest commit for meta-qt4
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ] || [ ${BRANCH} == "thud" ]
   then
       if grep -q ${COMMIT_META_QT4} "${BASEDIR}/../default.xml"
           then
               echo -e "meta-qt4 last commit:          ${COMMIT_META_QT4}"
           else
               echo -e "meta-qt4 last commit:          ${COLOR_WARNING}${COMMIT_META_QT4}${COLOR_RESET} Check ${REPO_META_QT4_BROWSER}/log/?h=${BRANCH}"
       fi
fi

# Display latest commit for meta-qt5
if grep -q ${COMMIT_META_QT5} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-qt5 last commit:          ${COMMIT_META_QT5}"
    else
        echo -e "meta-qt5 last commit:          ${COLOR_WARNING}${COMMIT_META_QT5}${COLOR_RESET} Check ${REPO_META_QT5}/tree/${BRANCH}"
fi

# Display latest commit for meta-qt5-extra
if [ ${BRANCH} == "sumo" ]
   then
       if grep -q ${COMMIT_META_QT5_EXTRA} "${BASEDIR}/../default.xml"
           then
               echo -e "meta-qt5-extra last commit:    ${COMMIT_META_QT5_EXTRA}"
           else
               echo -e "meta-qt5-extra last commit:    ${COLOR_WARNING}${COMMIT_META_QT5_EXTRA}${COLOR_RESET} Check ${REPO_META_QT5_EXTRA}/tree/${BRANCH}"
       fi
fi

# Display latest commit for meta-sdr
if grep -q ${COMMIT_META_SDR} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-sdr last commit:          ${COMMIT_META_SDR}"
    else
        if [ ${COMMIT_META_SDR} == "Unknown" ]
            then
                echo -e "meta-sdr last commit:          ${COLOR_INFO}${COMMIT_META_SDR}${COLOR_RESET}"
            else
                echo -e "meta-sdr last commit:          ${COLOR_INFO}${COMMIT_META_SDR}${COLOR_RESET} Check ${REPO_META_SDR}/tree/${SPECIAL_SDR_BRANCH}"
        fi
fi

# Display latest commit for meta-xilinx
if grep -q ${COMMIT_META_XILINX} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-xilinx last commit:       ${COMMIT_META_XILINX}"
    else
        if [ ${COMMIT_META_XILINX} == "Unknown" ]
            then
                echo -e "meta-xilinx last commit:       ${COLOR_INFO}${COMMIT_META_XILINX}${COLOR_RESET}"
            else
                echo -e "meta-xilinx last commit:       ${COLOR_WARNING}${COMMIT_META_XILINX}${COLOR_RESET} Check ${REPO_META_XILINX}/tree/${SPECIAL_XILINX_BRANCH}"
        fi
fi

# Display latest commit for meta-xilinx-tools
if [ ${BRANCH} == "thud" ] || [ ${BRANCH} == "zeus" ]
    then
        if grep -q ${COMMIT_META_XILINX_TOOLS} "${BASEDIR}/../default.xml"
            then
                echo -e "meta-xilinx-tools last commit: ${COMMIT_META_XILINX_TOOLS}"
            else
                echo -e "meta-xilinx-tools last commit: ${COLOR_WARNING}${COMMIT_META_XILINX_TOOLS}${COLOR_RESET} Check ${REPO_META_XILINX_TOOLS}/tree/${SPECIAL_XILINX_TOOLS_BRANCH}"
        fi
fi

# Display latest commit for meta-adi
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "sumo" ] || [ ${BRANCH} == "thud" ]
    then
        if grep -q ${COMMIT_META_ADI} "${BASEDIR}/../default.xml"
            then
                echo -e "meta-adi last commit:          ${COMMIT_META_ADI}"
            else
                echo -e "meta-adi last commit:          ${COLOR_WARNING}${COMMIT_META_ADI}${COLOR_RESET} Check ${REPO_META_ADI}/tree/${SPECIAL_ADI_BRANCH}"
        fi
fi

# Display latest commit for hdl
if [ ${BRANCH} == "rocko" ] || [ ${BRANCH} == "thud" ]
    then
        if grep -q ${COMMIT_HDL} "${BASEDIR}/../default.xml"
            then
                echo -e "hdl last commit:               ${COMMIT_HDL}"
            else
                echo -e "hdl last commit:               ${COLOR_WARNING}${COMMIT_HDL}${COLOR_RESET} Check ${REPO_HDL}/tree/${SPECIAL_HDL_BRANCH}"
        fi
fi

# Display latest commit for meta-raspberrypi
if grep -q ${COMMIT_META_RASPI} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-raspberrypi last commit:  ${COMMIT_META_RASPI}"
    else
        echo -e "meta-raspberrypi last commit:  ${COLOR_WARNING}${COMMIT_META_RASPI}${COLOR_RESET} Check ${REPO_META_RASPBERRYPI_BROWSER}/log/?h=${BRANCH}"
fi

# Display latest commit for meta-intel
if grep -q ${COMMIT_META_INTEL} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-intel last commit:        ${COMMIT_META_INTEL}"
    else
        echo -e "meta-intel last commit:        ${COLOR_WARNING}${COMMIT_META_INTEL}${COLOR_RESET} Check ${REPO_META_INTEL_BROWSER}/log/?h=${BRANCH}"
fi

# Display latest commit for meta-swupdate
if grep -q ${COMMIT_META_SWUPDATE} "${BASEDIR}/../default.xml"
    then
        echo -e "meta-swupdate last commit:     ${COMMIT_META_SWUPDATE}"
    else
        echo -e "meta-swupdate last commit:     ${COLOR_INFO}${COMMIT_META_SWUPDATE}${COLOR_RESET} Check ${REPO_META_SW_UPDATE}/tree/${BRANCH}"
fi

cd $BASEDIR
