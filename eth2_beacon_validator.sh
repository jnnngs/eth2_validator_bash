#!/bin/bash
# Script to install prysm Beacon on Ubuntu 20.04 LTS
# -prysm beacon and validator
#  
# credit to https://github.com/metanull-operator/eth2-ubuntu for the hardwork!

# ###### SECTIONS ######
# 1. Install prysm beacon and validator

# Add to log command and display output on screen
# echo " $(date +%m.%d.%Y_%H:%M:%S) : $MESSAGE" | tee -a "$LOGFILE"
# Add to log command and do not display output on screen
# echo " $(date +%m.%d.%Y_%H:%M:%S) : $MESSAGE" >> $LOGFILE 2>&1

# write to log only, no output on screen # echo  -e "---------------------------------------------------- " >> $LOGFILE 2>&1
# write to log only, no output on screen # echo  -e "    ** This entry gets written to the log file directly. **" >> $LOGFILE 2>&1
# write to log only, no output on screen # echo  -e "---------------------------------------------------- \n" >> $LOGFILE 2>&1

function check_distro() {
    # currently only for Ubuntu 16.04
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        if [[ "${VERSION_ID}" != "16.04" ]] ; then
            echo -e "\nThis script works the very best with Ubuntu 16.04 LTS."
            echo -e "Some elements of this script won't work correctly on other releases.\n"
        fi
    else
        # no, thats not ok!
        echo -e "This script only supports Ubuntu 16.04, exiting.\n"
        exit 1
    fi
}

function setup_environment() {
    ### define colors ###
    lightred=$'\033[1;31m'  # light red
    red=$'\033[0;31m'  # red
    lightgreen=$'\033[1;32m'  # light green
    green=$'\033[0;32m'  # green
    lightblue=$'\033[1;34m'  # light blue
    blue=$'\033[0;34m'  # blue
    lightpurple=$'\033[1;35m'  # light purple
    purple=$'\033[0;35m'  # purple
    lightcyan=$'\033[1;36m'  # light cyan
    cyan=$'\033[0;36m'  # cyan
    lightgray=$'\033[0;37m'  # light gray
    white=$'\033[1;37m'  # white
    brown=$'\033[0;33m'  # brown
    yellow=$'\033[1;33m'  # yellow
    darkgray=$'\033[1;30m'  # dark gray
    black=$'\033[0;30m'  # black
    nocolor=$'\e[0m' # no color

    echo -e -n "${lightred}"
    echo -e -n "${red}"
    echo -e -n "${lightgreen}"
    echo -e -n "${green}"
    echo -e -n "${lightblue}"
    echo -e -n "${blue}"
    echo -e -n "${lightpurple}"
    echo -e -n "${purple}"
    echo -e -n "${lightcyan}"
    echo -e -n "${cyan}"
    echo -e -n "${lightgray}"
    echo -e -n "${white}"
    echo -e -n "${brown}"
    echo -e -n "${yellow}"
    echo -e -n "${darkgray}"
    echo -e -n "${black}"
    echo -e -n "${nocolor}"
    clear

    # Set Vars
    LOGFILE='/var/log/server_beacon.log'
    SSHDFILE='/etc/ssh/sshd_config'
}

function begin_log() {
    # Create Log File and Begin
    echo -e -n "${lightcyan}"
    echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : SCRIPT STARTED SUCCESSFULLY " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
    echo -e "------- jnnn.gs prysm beacon and validator installation Script --------- " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------------- \n" | tee -a "$LOGFILE"
    echo -e -n "${nocolor}"
    sleep 2
}

##################
## BEACON INSTALL ##
##################

function install_beacon() {
    # query user to disable password authentication or not
    echo -e -n "${lightcyan}"
    figlet BEACON Install | tee -a "$LOGFILE"
    figlet VALIDATOR Install | tee -a "$LOGFILE"
    echo -e -n "${yellow}"
    echo -e "---------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : GETH INSTALL " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------- \n"
    echo -e -n "${lightcyan}"
    echo -e " prysm BEACON "
    echo -e
    
        echo -e -n "${cyan}"
            while :; do
            echo -e "\n"
            read -n 1 -s -r -p " Would you like to install prysm beacon and validator? y/n  " BEACONINSTALL
            if [[ ${BEACONINSTALL,,} == "y" || ${BEACONINSTALL,,} == "Y" || ${BEACONINSTALL,,} == "N" || ${BEACONINSTALL,,} == "n" ]]
            then
                break
            fi
        done
        echo -e "${nocolor}\n"
    
    if [ "${BEACONINSTALL,,}" = "Y" ] || [ "${BEACONINSTALL,,}" = "y" ]
    then	echo -e -n "${nocolor}"
        # Add repro #
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # Create User Accounts"
        sudo adduser --home /home/beacon --disabled-password --gecos 'Ethereum 2 Beacon Chain' beacon
	sudo adduser --home /home/validator --disabled-password --gecos 'Ethereum 2 Validator' validator
	sudo -u beacon mkdir /home/beacon/bin
	sudo -u validator mkdir /home/validator/bin
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # Install prysm.sh"
	cd /home/validator/bin
	sudo -u validator curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && sudo -u validator chmod +x prysm.sh
	cd /home/beacon/bin
	sudo -u beacon curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && sudo -u beacon chmod +x prysm.sh
	# download systemd Service File
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " #download beacon systemd Service File"
	wget -O /etc/systemd/system/beacon-chain.service https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/beacon-chain.service
        echo " #download validator systemd Service File"
	wget -O /etc/systemd/system/validator.service https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/validator.service
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " #download Prysm beacon Configuration Files"
	wget -O /home/beacon/prysm-beacon.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-beacon.yaml
	sudo -u beacon chmod 600 /home/beacon/prysm-beacon.yaml
        echo " #download Prysm validator Configuration Files"
	wget -O /home/validator/prysm-validator.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-validator.yaml
	sudo -u validator chmod 600 /home/validator/prysm-validator.yaml
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
	echo " #Create a password file"
	sudo -u validator touch /home/validator/.eth2validators/wallet-password.txt && sudo chmod 600 /home/validator/.eth2validators/wallet-password.txt
	sudo -u beacon chmod 600 /home/beacon/prysm-beacon.yaml
        echo " #download Prysm validator Configuration Files"
	wget -O /home/validator/prysm-validator.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-validator.yaml
	sudo -u validator chmod 600 /home/validator/prysm-validator.yaml
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # reload daemon, start and enable geth"
        sudo systemctl daemon-reload
	sudo systemctl start beacon-chain validator
	sudo systemctl enable beacon-chain validator
        echo -e "------------------------- \n" | tee -a "$LOGFILE"
        echo -e -n "${nocolor}"
        sleep 1
        # 
    else	echo -e -n "${yellow}"
        echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
        echo -e " ** User chose not to setup prysm beacon and validator at this time **"  | tee -a "$LOGFILE"
        echo -e "---------------------------------------------------- \n" | tee -a "$LOGFILE"
        echo -e -n "${nocolor}"
        sleep 1
    fi

    clear
    echo -e -n "${lightgreen}"
    echo -e "------------------------------------------------ " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : BEACON and VALIDATORE COMPLETE " | tee -a "$LOGFILE"
    echo -e "------------------------------------------------ " | tee -a "$LOGFILE"
    echo -e -n "${nocolor}"
}

######################
## Install Complete ##
######################

function install_complete() {
    # Display important login variables before exiting script
    clear
    echo -e -n "${lightcyan}"
    figlet Install Complete -f small | tee -a "$LOGFILE"
    echo -e -n "${lightgreen}"
    echo -e "---------------------------------------------------- " >> $LOGFILE 2>&1
    echo -e -n "${lightpurple}"

    if [ "${BEACONINSTALL,,}" = "yes" ] || [ "${BEACONINSTALL,,}" = "y" ]
    then 
        echo -e "${white} *--------------------------------------------------* " | tee -a "$LOGFILE"
    	echo -e " | YES: You chose to install prysm beacon and validator   | " | tee -a "$LOGFILE"
    	echo -e " |                                                  | " | tee -a "$LOGFILE"
    	echo -e " *--------------------------------------------------* " | tee -a "$LOGFILE"
	echo -e " *--- PLEASE now continue with the MANUAL STEPS ---*" | tee -a "$LOGFILE"
	echo -e "${white} |--------------------------------------------------| " | tee -a "$LOGFILE"
    else
    	echo -e "${white}-------------------------------------------------------- " | tee -a "$LOGFILE"
    	echo -e " You chose NOT to install prysm beacon and validator" | tee -a "$LOGFILE"
	echo -e "${white}-------------------------------------------------------- " | tee -a "$LOGFILE"
    fi
    echo -e "${yellow}-------------------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " Installation log saved to" $LOGFILE | tee -a "$LOGFILE"
    echo -e -n "${nocolor}"
}

function display_banner() {

    echo -e -n "${lightcyan}"
    figlet eth 2 -f small
    figlet validator -f small
    echo "jnnn.gs v0.1"
    echo ""  
    echo -e -n "${lightgreen}"
    echo "Script to install prysm beacon "
    echo "-geth"

    echo ""  
    echo -e -n "${nocolor}"
    echo " 5 Second pause for respect: https://github.com/metanull-operator/eth2-ubuntu/blob/master/prysm-medalla.md"
    echo "                           : https://github.com/metanull-operator/eth2-ubuntu"
}

check_distro
setup_environment
clear
display_banner
sleep 5
clear
begin_log
install_beacon
install_complete

exit
