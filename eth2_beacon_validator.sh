#!/bin/bash
# Script to install prysm Beacon and Validator on Ubuntu 20.04 LTS
# -prysm client
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
    # currently only for Ubuntu 20.04
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        if [[ "${VERSION_ID}" != "20.04" ]] ; then
            echo -e "\nThis script works the very best with Ubuntu 16.04 LTS."
            echo -e "Some elements of this script won't work correctly on other releases.\n"
        fi
    else
        # no, thats not ok!
        echo -e "This script only supports Ubuntu 20.04, exiting.\n"
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
    LOGFILE='/var/log/server_prysm.log'
    SSHDFILE='/etc/ssh/sshd_config'
}

function begin_log() {
    # Create Log File and Begin
    echo -e -n "${lightcyan}"
    echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : SCRIPT STARTED SUCCESSFULLY " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
    echo -e "------- jnnn.gs prysm beacon and validator installation Script " | tee -a "$LOGFILE"
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
    clear
    figlet BEACON | tee -a "$LOGFILE"
    figlet VALIDATOR | tee -a "$LOGFILE"
    echo -e -n "${yellow}"
    echo -e "---------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : Prysm INSTALL " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------- \n"
    echo -e -n "${lightcyan}"
    echo -e " install prysm beacon and validator clients"
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
        echo " # Create User Accounts" | tee -a "$LOGFILE"
        sudo adduser --home /home/beacon --disabled-password --gecos 'Ethereum 2 Beacon Chain' beacon | tee -a "$LOGFILE"
	sudo adduser --home /home/validator --disabled-password --gecos 'Ethereum 2 Validator' validator | tee -a "$LOGFILE"
	sudo -u beacon mkdir /home/beacon/bin | tee -a "$LOGFILE"
	sudo -u validator mkdir /home/validator/bin | tee -a "$LOGFILE"
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # Install prysm.sh" | tee -a "$LOGFILE"
	cd /home/validator/bin
	sudo -u validator curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && sudo -u validator chmod +x prysm.sh | tee -a "$LOGFILE"
	cd /home/beacon/bin | tee -a "$LOGFILE"
	sudo -u beacon curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && sudo -u beacon chmod +x prysm.sh | tee -a "$LOGFILE"
	# download systemd Service File
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " #download beacon systemd Service File" | tee -a "$LOGFILE"
	wget -O /etc/systemd/system/beacon-chain.service https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/beacon-chain.service | tee -a "$LOGFILE"
        echo " #download validator systemd Service File" | tee -a "$LOGFILE"
	wget -O /etc/systemd/system/validator.service https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/validator.service | tee -a "$LOGFILE"
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " #download Prysm beacon Configuration Files" | tee -a "$LOGFILE"
	wget -O /home/beacon/prysm-beacon.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-beacon.yaml | tee -a "$LOGFILE"
	sudo -u beacon chmod 600 /home/beacon/prysm-beacon.yaml | tee -a "$LOGFILE"
        echo " #download Prysm validator Configuration Files" | tee -a "$LOGFILE"
	wget -O /home/validator/prysm-validator.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-validator.yaml | tee -a "$LOGFILE"
	sudo -u validator chmod 600 /home/validator/prysm-validator.yaml | tee -a "$LOGFILE"
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
	echo " #Create a password file" | tee -a "$LOGFILE"
	sudo -u validator mkdir .eth2validators  | tee -a "$LOGFILE"
	sudo -u validator touch /home/validator/.eth2validators/wallet-password.txt | tee -a "$LOGFILE"
        echo " #download Prysm validator Configuration Files" | tee -a "$LOGFILE"
	wget -O /home/validator/prysm-validator.yaml https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/prysm-validator.yaml | tee -a "$LOGFILE"
	sudo -u validator chmod 600 /home/validator/prysm-validator.yaml | tee -a "$LOGFILE"
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # reload daemon"
        sudo systemctl daemon-reload | tee -a "$LOGFILE"
	sudo systemctl start beacon-chain 
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
    	echo -e " | prysm beacon and validator installed " | tee -a "$LOGFILE"
    	echo -e " |                                                   " | tee -a "$LOGFILE"
    	echo -e " *--------------------------------------------------* " | tee -a "$LOGFILE"
	echo -e " *--- In order to finish the installation, please continue at" | tee -a "$LOGFILE"
	echo -e " *--- STEP 4: Manual Steps for Validator Deposits and Keys" | tee -a "$LOGFILE"
	echo -e " *--- following the instructions on GitHub" | tee -a "$LOGFILE"
	echo -e " *--------------------------------------------------* " | tee -a "$LOGFILE"
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
    figlet prysm -f small
    echo "" 
    echo "v0.1"
    echo ""  
    echo -e -n "${lightgreen}"
    echo "Script to install prysm beacon and validator "

    echo ""  
    echo -e -n "${nocolor}"
    echo " 5 Second pause for respect: prysmaticlabs.com and https://github.com/metanull-operator/eth2-ubuntu"
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
