#!/bin/bash
# Script to Harden Security on Ubuntu 20.04 LTS & install eth2 validator 
# -geth
#  
# credit to https://github.com/metanull-operator/eth2-ubuntu for the hardwork!

function akguy_banner() {
    cat << "EOF"                                                                      

       _   _     ___  
      | | | |   |__ \ 
   ___| |_| |__    ) |
  / _ \ __| '_ \  / / 
 |  __/ |_| | | |/ /_ 
  \___|\__|_| |_|____|
                                        
    jnnn.gs
EOF
}

# ###### SECTIONS ######
# 1. Install eth 1 full node (geth)

# Add to log command and display output on screen
# echo " $(date +%m.%d.%Y_%H:%M:%S) : $MESSAGE" | tee -a "$LOGFILE"
# Add to log command and do not display output on screen
# echo " $(date +%m.%d.%Y_%H:%M:%S) : $MESSAGE" >> $LOGFILE 2>&1

# write to log only, no output on screen # echo  -e "---------------------------------------------------- " >> $LOGFILE 2>&1
# write to log only, no output on screen # echo  -e "    ** This entry gets written to the log file directly. **" >> $LOGFILE 2>&1
# write to log only, no output on screen # echo  -e "---------------------------------------------------- \n" >> $LOGFILE 2>&1

##################
## GETH INSTALL ##
##################

function install_geth() {
    # query user to disable password authentication or not
    echo -e -n "${lightcyan}"
    figlet GETH Install | tee -a "$LOGFILE"
    echo -e -n "${yellow}"
    echo -e "---------------------------------------------- " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : GETH INSTALL " | tee -a "$LOGFILE"
    echo -e "---------------------------------------------- \n"
    echo -e -n "${lightcyan}"
    echo -e " GETH is an eth 1 full node to feed eth 1 ledger into"
    echo -e "  the beacon node."
    echo -e
    
        echo -e -n "${cyan}"
            while :; do
            echo -e "\n"
            read -n 1 -s -r -p " Would you like to install GETH eth1 full node? y/n  " GETHINSTALL
            if [[ ${GETHINSTALL,,} == "y" || ${GETHINSTALL,,} == "Y" || ${GETHINSTALL,,} == "N" || ${GETHINSTALL,,} == "n" ]]
            then
                break
            fi
        done
        echo -e "${nocolor}\n"
    
    if [ "${GETHINSTALL,,}" = "Y" ] || [ "${GETHINSTALL,,}" = "y" ]
    then	echo -e -n "${nocolor}"
        # Add repro #
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # Add geth repro"
        sudo add-apt-repository -y ppa:ethereum/ethereum
	sudo apt-get update >> $LOGFILE 2>&1
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # install ethereum"
	sudo apt-get install ethereum -qqy >> $LOGFILE 2>&1
        # add user account
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # add geth user account"
	sudo adduser --home /home/geth --disabled-password --gecos 'Go Ethereum Client' geth
	# download systemd Service File
	echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " #download geth systemd Service File"
	wget -O /etc/systemd/system/geth.service https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/geth.service
        echo -e -n "${white}"
        echo -e "------------------------------------------- " | tee -a "$LOGFILE"
        echo " # reload daemon, start and enable geth"
        sudo systemctl daemon-reload
	sudo systemctl start geth
	sudo systemctl enable geth
        echo -e "------------------------- \n" | tee -a "$LOGFILE"
        echo -e -n "${nocolor}"
        sleep 1
        # 
    else	echo -e -n "${yellow}"
        echo -e "---------------------------------------------------- " | tee -a "$LOGFILE"
        echo -e " ** User chose not to setup geth at this time **"  | tee -a "$LOGFILE"
        echo -e "---------------------------------------------------- \n" | tee -a "$LOGFILE"
        echo -e -n "${nocolor}"
        sleep 1
    fi

    clear
    echo -e -n "${lightgreen}"
    echo -e "------------------------------------------------ " | tee -a "$LOGFILE"
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : GETH FULL NODE COMPLETE " | tee -a "$LOGFILE"
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
    echo -e " $(date +%m.%d.%Y_%H:%M:%S) : YOUR SERVER IS NOW SECURE " >> $LOGFILE 2>&1
    echo -e -n "${lightpurple}"

    if [ "${GETHINSTALL,,}" = "yes" ] || [ "${GETHINSTALL,,}" = "y" ]
    then 
        echo -e "${white} *--------------------------------------------------* " | tee -a "$LOGFILE"
    	echo -e " | YES: You chose to install GETH eth 1 full node   | " | tee -a "$LOGFILE"
    	echo -e " |                                                  | " | tee -a "$LOGFILE"
    	echo -e " *--------------------------------------------------* " | tee -a "$LOGFILE"
	echo -e " *--- Common GETH commands ---*" | tee -a "$LOGFILE"
	echo -e "${green} sudo systemctl stop geth ${white} <--- stop GETH" | tee -a "$LOGFILE"
	echo -e "${green} sudo systemctl start geth ${white} <--- start GETH" | tee -a "$LOGFILE"
	echo -e "${green} sudo systemctl disable geth ${white} <--- disable GETH at startup" | tee -a "$LOGFILE"
	echo -e "${green} sudo systemctl enable geth ${white} <--- enable GETH at startup" | tee -a "$LOGFILE"
	echo -e "${green} sudo journalctl -u geth -f ${white} <--- read the end of the log file" | tee -a "$LOGFILE"
	echo -e "${white} |--------------------------------------------------| " | tee -a "$LOGFILE"
    else
    	echo -e "${white}-------------------------------------------------------- " | tee -a "$LOGFILE"
    	echo -e " You chose NOT to install GETH eth 1 full node" | tee -a "$LOGFILE"
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
    echo "Script to install ETH1 node geth "
    echo "-geth"

    echo ""  
    echo -e -n "${nocolor}"
    echo " 5 Second pause for respect: https://github.com/metanull-operator/eth2-ubuntu/blob/master/prysm-medalla.md"
    echo "                           : https://github.com/metanull-operator/eth2-ubuntu"
}

check_distro
clear
display_banner
sleep 5
clear
begin_log
install_geth
install_complete

exit
