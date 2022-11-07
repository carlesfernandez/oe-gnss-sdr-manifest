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
REPO_META_QT4="https://git.yoctoproject.org/meta-qt4"
REPO_META_QT5="https://github.com/meta-qt5/meta-qt5"
REPO_META_QT5_EXTRA="https://github.com/schnitzeltony/meta-qt5-extra"
REPO_META_SDR="https://github.com/balister/meta-sdr"
REPO_META_VIRTUALIZATION="https://git.yoctoproject.org/meta-virtualization"
REPO_META_XILINX="https://github.com/Xilinx/meta-xilinx"
REPO_META_XILINX_TOOLS="https://github.com/Xilinx/meta-xilinx-tools"
REPO_META_ADI="https://github.com/analogdevicesinc/meta-adi"
REPO_HDL="https://github.com/analogdevicesinc/hdl"
REPO_META_RASPBERRYPI="https://git.yoctoproject.org/meta-raspberrypi"
REPO_META_INTEL="https://git.yoctoproject.org/meta-intel"
REPO_META_TI="https://git.yoctoproject.org/meta-ti"
REPO_META_ARM="https://git.yoctoproject.org/meta-arm"
REPO_META_SW_UPDATE="https://github.com/sbabic/meta-swupdate"

echo -e "Getting the latest commits in the ${BRANCH} branch..."
mkdir -p sources
cd sources || exit

# openembedded-core
if [ -d "openembedded-core" ]
    then
        cd openembedded-core || exit
        git checkout "${BRANCH}"
        git pull origin "${BRANCH}"
    else
        git clone ${REPO_OE_CORE}
        cd openembedded-core || exit
        git checkout "$BRANCH"
fi
COMMIT_OPENEMBEDDED_CORE=$(git rev-parse HEAD)
cd ..

# meta-openembedded
if [ -d "meta-openembedded" ]
    then
        cd meta-openembedded || exit
        git checkout "${BRANCH}"
        git pull origin "${BRANCH}"
    else
        git clone ${REPO_META_OE}
        cd meta-openembedded || exit
        git checkout "$BRANCH"
fi
COMMIT_META_OPENEMBEDDED=$(git rev-parse HEAD)
cd ..

# meta-qt4
if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "sumo" ] || [ "${BRANCH}" == "thud" ]
   then
       if [ -d "meta-qt4" ]
           then
               cd meta-qt4 || exit
               git checkout "${BRANCH}"
               git pull origin "${BRANCH}"
           else
               git clone ${REPO_META_QT4}
               cd meta-qt4 || exit
               git checkout "$BRANCH"
       fi
       COMMIT_META_QT4=$(git rev-parse HEAD)
       cd ..
fi

# meta-qt5
if [ -d "meta-qt5" ]
    then
        cd meta-qt5 || exit
        git checkout "${BRANCH}"
        git pull origin "${BRANCH}"
    else
        git clone ${REPO_META_QT5}
        cd meta-qt5 || exit
        git checkout "$BRANCH"
fi
COMMIT_META_QT5=$(git rev-parse HEAD)
cd ..

# meta-qt5-extra
if [ "${BRANCH}" == "sumo" ]
    then
        if [ -d "meta-qt5-extra" ]
            then
                cd meta-qt5-extra || exit
                git checkout "${BRANCH}"
                git pull origin "${BRANCH}"
            else
                git clone ${REPO_META_QT5_EXTRA}
                cd meta-qt5-extra || exit
                git checkout "$BRANCH"
        fi
        COMMIT_META_QT5_EXTRA=$(git rev-parse HEAD)
        cd ..
fi

# meta-sdr
SPECIAL_SDR_BRANCH=${BRANCH}
if [ "${BRANCH}" == "thud" ]
    then
        SPECIAL_SDR_BRANCH="sumo"
fi
if [ "${BRANCH}" == "warrior" ]
    then
        SPECIAL_SDR_BRANCH="zeus"
fi
if [ "${BRANCH}" == "gatesgarth" ]
    then
        SPECIAL_SDR_BRANCH="dunfell"
fi
if [ "${BRANCH}" == "langdale" ]
    then
        SPECIAL_SDR_BRANCH="master"
fi
if [ -d "meta-sdr" ]
    then
        cd meta-sdr || exit
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
        cd meta-sdr || exit
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

# meta-virtualization
if [ "${BRANCH}" == "gatesgarth" ] || [ "${BRANCH}" == "honister" ]
    then
        if [ -d "meta-virtualization" ]
            then
                cd meta-virtualization || exit
                exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_VIRTUALIZATION="Unknown"
                   else
                       git checkout "${BRANCH}"
                       git pull origin "${BRANCH}"
                       COMMIT_META_VIRTUALIZATION=$(git rev-parse HEAD)
                fi
             else
                git clone ${REPO_META_VIRTUALIZATION}
                cd meta-virtualization || exit
                exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
                if [[ -z ${exists_in_remote} ]]
                    then
                        COMMIT_META_VIRTUALIZATION="Unknown"
                    else
                        git checkout "${BRANCH}"
                        COMMIT_META_VIRTUALIZATION=$(git rev-parse HEAD)
                fi
        fi
        cd ..
fi


# meta-xilinx
SPECIAL_XILINX_BRANCH=${BRANCH}
if [ "${BRANCH}" == "thud" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2019.2"
fi
if [ "${BRANCH}" == "zeus" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2020.3"
fi
if [ "${BRANCH}" == "gatesgarth" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2021.2"
fi
if [ "${BRANCH}" == "honister" ]
    then
        SPECIAL_XILINX_BRANCH="rel-v2022.1"
fi
if [ "${BRANCH}" != "kirkstone" ] && [ "${BRANCH}" != "langdale" ]
    then
        if [ -d "meta-xilinx" ]
            then
                cd meta-xilinx || exit
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
                cd meta-xilinx || exit
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
fi

# meta-xilinx-tools
SPECIAL_XILINX_TOOLS_BRANCH=${BRANCH}
if [ "${BRANCH}" == "thud" ]
   then
       SPECIAL_XILINX_TOOLS_BRANCH="rel-v2019.2"
fi
if [ "${BRANCH}" == "zeus" ]
   then
       SPECIAL_XILINX_TOOLS_BRANCH="rel-v2020.3"
fi
if [ "${BRANCH}" == "gatesgarth" ]
    then
        SPECIAL_XILINX_TOOLS_BRANCH="rel-v2021.2"
fi
if [ "${BRANCH}" == "honister" ]
   then
       SPECIAL_XILINX_TOOLS_BRANCH="rel-v2022.1"
fi

if [ "${BRANCH}" == "thud" ] || [ "${BRANCH}" == "zeus" ] || [ "${BRANCH}" == "gatesgarth" ] || [ "${BRANCH}" == "honister" ]
   then
       if [ -d "meta-xilinx-tools" ]
           then
               cd meta-xilinx-tools || exit
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
               cd meta-xilinx-tools || exit
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
if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "sumo" ] || [ "${BRANCH}" == "thud" ] || [ "${BRANCH}" == "gatesgarth" ]
    then
        if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "sumo" ]
            then
                SPECIAL_ADI_BRANCH="2019_R1"
        fi
        if [ "${BRANCH}" == "thud" ]
            then
                SPECIAL_ADI_BRANCH="2019_R2"
        fi
        if [ "${BRANCH}" == "gatesgarth" ]
            then
                SPECIAL_ADI_BRANCH="master"
        fi
        if [ -d "meta-adi" ]
            then
                cd meta-adi || exit
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
                cd meta-adi || exit
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
if [ "${BRANCH}" == "rocko" ]
    then
        SPECIAL_HDL_BRANCH="hdl_2019_r1"
fi
if [ "${BRANCH}" == "thud" ]
    then
        SPECIAL_HDL_BRANCH="hdl_2019_r2"
fi
if [ "${BRANCH}" == "gatesgarth" ]
    then
        SPECIAL_HDL_BRANCH="hdl_2021_r2"
fi
if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "thud" ] || [ "${BRANCH}" == "gatesgarth" ]
    then
        if [ -d "hdl" ]
            then
                cd hdl || exit
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
                cd hdl || exit
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
        cd meta-raspberrypi || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_RASPI="Unknown"
           else
               git checkout "${BRANCH}"
               git pull origin "${BRANCH}"
               COMMIT_META_RASPI=$(git rev-parse HEAD)
        fi
    else
        git clone ${REPO_META_RASPBERRYPI}
        cd meta-raspberrypi || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_RASPI="Unknown"
           else
               git checkout "${BRANCH}"
               COMMIT_META_RASPI=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-intel
if [ -d "meta-intel" ]
    then
        cd meta-intel || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_INTEL="Unknown"
           else
               git checkout "${BRANCH}"
               git pull origin "${BRANCH}"
               COMMIT_META_INTEL=$(git rev-parse HEAD)
        fi
    else
        git clone ${REPO_META_INTEL}
        cd meta-intel || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_INTEL="Unknown"
           else
               git checkout "${BRANCH}"
               COMMIT_META_INTEL=$(git rev-parse HEAD)
        fi
fi
cd ..

# meta-ti
if [ "${BRANCH}" == "dunfell" ]
    then
        if [ -d "meta-ti" ]
            then
                cd meta-ti || exit
                exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_TI="Unknown"
                   else
                       git checkout "${BRANCH}"
                       git pull origin "${BRANCH}"
                       COMMIT_META_TI=$(git rev-parse HEAD)
                fi
        else
            git clone ${REPO_META_TI}
            cd meta-ti || exit
            exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
            if [[ -z ${exists_in_remote} ]]
                then
                    COMMIT_META_TI="Unknown"
                else
                    git checkout "${BRANCH}"
                    COMMIT_META_TI=$(git rev-parse HEAD)
            fi
        fi
    cd ..
fi

# meta-arm
if [ "${BRANCH}" == "dunfell" ]
    then
        if [ -d "meta-arm" ]
            then
                cd meta-arm || exit
                exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
                if [[ -z ${exists_in_remote} ]]
                   then
                       COMMIT_META_ARM="Unknown"
                   else
                       git checkout "${BRANCH}"
                       git pull origin "${BRANCH}"
                       COMMIT_META_ARM=$(git rev-parse HEAD)
                fi
        else
            git clone ${REPO_META_ARM}
            cd meta-arm || exit
            exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
            if [[ -z ${exists_in_remote} ]]
                then
                    COMMIT_META_ARM="Unknown"
                else
                    git checkout "${BRANCH}"
                    COMMIT_META_ARM=$(git rev-parse HEAD)
            fi
        fi
    cd ..
fi

# meta-swupdate
if [ -d "meta-swupdate" ]
    then
        cd meta-swupdate || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SWUPDATE="Unknown"
           else
               git checkout "${BRANCH}"
               git pull origin "${BRANCH}"
               COMMIT_META_SWUPDATE=$(git rev-parse HEAD)
        fi
    else
        git clone ${REPO_META_SW_UPDATE}
        cd meta-swupdate || exit
        exists_in_remote=$(git ls-remote --heads origin "${BRANCH}")
        if [[ -z ${exists_in_remote} ]]
           then
               COMMIT_META_SWUPDATE="Unknown"
           else
               git checkout "${BRANCH}"
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
if grep -q "${COMMIT_OPENEMBEDDED_CORE}" "${BASEDIR}/../default.xml"
    then
        echo -e "openembedded-core last commit:   ${COMMIT_OPENEMBEDDED_CORE}"
    else
        echo -e "openembedded-core last commit:   ${COLOR_WARNING}${COMMIT_OPENEMBEDDED_CORE}${COLOR_RESET} Check ${REPO_OE_CORE}/tree/${BRANCH}"
fi

# Display latest commit for meta-openembedded
if grep -q "${COMMIT_META_OPENEMBEDDED}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-openembedded last commit:   ${COMMIT_META_OPENEMBEDDED}"
    else
        echo -e "meta-openembedded last commit:   ${COLOR_WARNING}${COMMIT_META_OPENEMBEDDED}${COLOR_RESET} Check ${REPO_META_OE}/tree/${BRANCH}"
fi

# Display latest commit for meta-qt4
if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "sumo" ] || [ "${BRANCH}" == "thud" ]
   then
       if grep -q "${COMMIT_META_QT4}" "${BASEDIR}/../default.xml"
           then
               echo -e "meta-qt4 last commit:            ${COMMIT_META_QT4}"
           else
               echo -e "meta-qt4 last commit:            ${COLOR_WARNING}${COMMIT_META_QT4}${COLOR_RESET} Check ${REPO_META_QT4}/log/?h=${BRANCH}"
       fi
fi

# Display latest commit for meta-qt5
if grep -q "${COMMIT_META_QT5}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-qt5 last commit:            ${COMMIT_META_QT5}"
    else
        echo -e "meta-qt5 last commit:            ${COLOR_WARNING}${COMMIT_META_QT5}${COLOR_RESET} Check ${REPO_META_QT5}/tree/${BRANCH}"
fi

# Display latest commit for meta-qt5-extra
if [ "${BRANCH}" == "sumo" ]
   then
       if grep -q "${COMMIT_META_QT5_EXTRA}" "${BASEDIR}/../default.xml"
           then
               echo -e "meta-qt5-extra last commit:      ${COMMIT_META_QT5_EXTRA}"
           else
               echo -e "meta-qt5-extra last commit:      ${COLOR_WARNING}${COMMIT_META_QT5_EXTRA}${COLOR_RESET} Check ${REPO_META_QT5_EXTRA}/tree/${BRANCH}"
       fi
fi

# Display latest commit for meta-sdr
if grep -q "${COMMIT_META_SDR}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-sdr last commit:            ${COMMIT_META_SDR}"
    else
        if [ "${COMMIT_META_SDR}" == "Unknown" ]
            then
                echo -e "meta-sdr last commit:            ${COLOR_INFO}${COMMIT_META_SDR}${COLOR_RESET}"
            else
                echo -e "meta-sdr last commit:            ${COLOR_INFO}${COMMIT_META_SDR}${COLOR_RESET} Check ${REPO_META_SDR}/tree/${SPECIAL_SDR_BRANCH}"
        fi
fi

# Display latest commit for meta-virtualization
if [ "${BRANCH}" == "gatesgarth" ] || [ "${BRANCH}" == "honister" ]
   then
       if grep -q "${COMMIT_META_VIRTUALIZATION}" "${BASEDIR}/../default.xml"
           then
               echo -e "meta-virtualization last commit: ${COMMIT_META_VIRTUALIZATION}"
           else
               echo -e "meta-virtualization last commit: ${COLOR_WARNING}${COMMIT_META_VIRTUALIZATION}${COLOR_RESET} Check ${REPO_META_VIRTUALIZATION}/log/?h=${BRANCH}"
       fi
fi

# Display latest commit for meta-xilinx
if [ "${BRANCH}" != "kirkstone" ] && [ "${BRANCH}" != "langdale" ]
    then
        if grep -q "${COMMIT_META_XILINX}" "${BASEDIR}/../default.xml"
            then
                echo -e "meta-xilinx last commit:         ${COMMIT_META_XILINX}"
            else
                if [ "${COMMIT_META_XILINX}" == "Unknown" ]
                    then
                        echo -e "meta-xilinx last commit:         ${COLOR_INFO}${COMMIT_META_XILINX}${COLOR_RESET}"
                    else
                        echo -e "meta-xilinx last commit:         ${COLOR_WARNING}${COMMIT_META_XILINX}${COLOR_RESET} Check ${REPO_META_XILINX}/tree/${SPECIAL_XILINX_BRANCH}"
                fi
        fi
fi

# Display latest commit for meta-xilinx-tools
if [ "${BRANCH}" == "thud" ] || [ "${BRANCH}" == "zeus" ] || [ "${BRANCH}" == "gatesgarth" ] || [ "${BRANCH}" == "honister" ]
    then
        if grep -q "${COMMIT_META_XILINX_TOOLS}" "${BASEDIR}/../default.xml"
            then
                echo -e "meta-xilinx-tools last commit:   ${COMMIT_META_XILINX_TOOLS}"
            else
                echo -e "meta-xilinx-tools last commit:   ${COLOR_WARNING}${COMMIT_META_XILINX_TOOLS}${COLOR_RESET} Check ${REPO_META_XILINX_TOOLS}/tree/${SPECIAL_XILINX_TOOLS_BRANCH}"
        fi
fi

# Display latest commit for meta-adi
if [ "${BRANCH}" == "rocko" ] || [ "${BRANCH}" == "sumo" ] || [ "${BRANCH}" == "thud" ]  || [ "${BRANCH}" == "gatesgarth" ]
    then
        if grep -q "${COMMIT_META_ADI}" "${BASEDIR}/../default.xml"
            then
                echo -e "meta-adi last commit:            ${COMMIT_META_ADI}"
            else
                echo -e "meta-adi last commit:            ${COLOR_WARNING}${COMMIT_META_ADI}${COLOR_RESET} Check ${REPO_META_ADI}/tree/${SPECIAL_ADI_BRANCH}"
        fi
fi

# Display latest commit for hdl
if [ "${BRANCH}" == "rocko" ]  || [ "${BRANCH}" == "thud" ] || [ "${BRANCH}" == "gatesgarth" ]
    then
        if grep -q "${COMMIT_HDL}" "${BASEDIR}/../default.xml"
            then
                echo -e "hdl last commit:                 ${COMMIT_HDL}"
            else
                echo -e "hdl last commit:                 ${COLOR_WARNING}${COMMIT_HDL}${COLOR_RESET} Check ${REPO_HDL}/tree/${SPECIAL_HDL_BRANCH}"
        fi
fi

# Display latest commit for meta-raspberrypi
if grep -q "${COMMIT_META_RASPI}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-raspberrypi last commit:    ${COMMIT_META_RASPI}"
    else
        echo -e "meta-raspberrypi last commit:    ${COLOR_WARNING}${COMMIT_META_RASPI}${COLOR_RESET} Check ${REPO_META_RASPBERRYPI}/log/?h=${BRANCH}"
fi

# Display latest commit for meta-intel
if grep -q "${COMMIT_META_INTEL}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-intel last commit:          ${COMMIT_META_INTEL}"
    else
        echo -e "meta-intel last commit:          ${COLOR_WARNING}${COMMIT_META_INTEL}${COLOR_RESET} Check ${REPO_META_INTEL}/log/?h=${BRANCH}"
fi

# Display latest commit for meta-ti
if [ "${BRANCH}" == "dunfell" ]
    then
        if grep -q "${COMMIT_META_TI}" "${BASEDIR}/../default.xml"
            then
                echo -e "meta-ti last commit:             ${COMMIT_META_TI}"
            else
                echo -e "meta-ti last commit:             ${COLOR_WARNING}${COMMIT_META_TI}${COLOR_RESET} Check ${REPO_META_TI}/log/?h=${BRANCH}"
        fi
fi

# Display latest commit for meta-arm
if [ "${BRANCH}" == "dunfell" ]
    then
        if grep -q "${COMMIT_META_ARM}" "${BASEDIR}/../default.xml"
            then
                echo -e "meta-arm last commit:            ${COMMIT_META_ARM}"
            else
                echo -e "meta-arm last commit:            ${COLOR_WARNING}${COMMIT_META_ARM}${COLOR_RESET} Check ${REPO_META_ARM}/log/?h=${BRANCH}"
        fi
fi

# Display latest commit for meta-swupdate
if grep -q "${COMMIT_META_SWUPDATE}" "${BASEDIR}/../default.xml"
    then
        echo -e "meta-swupdate last commit:       ${COMMIT_META_SWUPDATE}"
    else
        echo -e "meta-swupdate last commit:       ${COLOR_INFO}${COMMIT_META_SWUPDATE}${COLOR_RESET} Check ${REPO_META_SW_UPDATE}/tree/${BRANCH}"
fi

cd "$BASEDIR" || exit
