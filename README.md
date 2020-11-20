# 5 STEPS to install ETH2 Set-up
1) Harden OS, 2) Install Geth, 3) Prysm Beacon & Validator, 4) Validator Deposits and Install Keys, 5) Start prysm Beacon & Validator services
- Currently hardcoded for goerli & pyrmont testnet
- Tested in Ubuntu 20.04 LTS

## STEP 1: Harden OS
if needed, install curl using ```sudo apt-get install curl```
```
bash <(curl -s https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/eth2_harden.sh)
```
## STEP 2: Install ETH1 node geth
```
bash <(curl -s https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/eth2_geth.sh)
```
## STEP 3: Install prysm Beacon and Validator
```
bash <(curl -s https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/eth2_beacon_validator.sh)
```

## STEP 4: Manual Steps to Make Validator Deposits and Install Keys

Follow the latest instructions at [pyrmont.launchpad.ethereum.org](https://pyrmont.launchpad.ethereum.org) or the correct launch pad for the network to which you will be connecting.

Look for the latest eth2.0-deposit-cli [here](https://github.com/ethereum/eth2.0-deposit-cli/releases/).

```console
cd
wget https://github.com/ethereum/eth2.0-deposit-cli/releases/download/v1.0.0/eth2deposit-cli-9310de0-linux-amd64.tar.gz
tar xzvf eth2deposit-cli-9310de0-linux-amd64.tar.gz
mv eth2deposit-cli-9310de0-linux-amd64 eth2deposit-cli
cd eth2deposit-cli
./deposit new-mnemonic --num_validators NUMBER_OF_VALIDATORS --chain pyrmont
```

Change the `NUMBER_OF_VALIDATORS` to the number of validators you want to create. Follow the prompts and instructions.

**BACKUP YOUR MNEMONIC AND PASSWORD!**

The next step is to upload your deposit data file to the launchpad site. If you are using Ubuntu Server, you can either open up the deposit data file and copy it to a file on your desktop computer with the same name, or you can use scp or an equivalent tool to copy the deposit data to your desktop computer.

Follow the instructions by dragging and dropping the deposit file into the launchpad site. Then continue to follow the instructions until your deposit transaction is successful.

```console
sudo -u validator /home/validator/bin/prysm.sh validator accounts import --keys-dir=$HOME/eth2deposit-cli/validator_keys
```

Follow the prompts. The default wallet directory should be `/home/validator/.eth2validators/prysm-wallet-v2`. Use the same password used when you were prompted for a password while running `./deposit new-mnemonic --num_validators NUMBER_OF_VALIDATORS --chain pyrmont`.

Edit the file and put the password you entered into the `deposit` tool into the `wallet-password.txt` file.

```console
sudo nano /home/validator/.eth2validators/wallet-password.txt
```

Enter the password into the first line and save the file.

## STEP 5: Start Beacon Chain and Validator

Start and enable the validator service.

```console
sudo systemctl daemon-reload
sudo systemctl start beacon-chain validator
sudo systemctl enable beacon-chain validator
```

## Common Commands
The following are some common commands you may want to use while running this setup.

### Service Statuses
To see the status of system services:

```console
sudo systemctl status beacon-chain
sudo systemctl status validator
sudo systemctl status geth
```

Or, to see the status of all at once:
```console
sudo systemctl status beacon-chain validator geth prometheus grafana-server eth2stats node_exporter blackbox_exporter
```
### Service Logs
To watch the logs in real time:

```console
sudo journalctl -u beacon-chain -f
sudo journalctl -u validator -f
sudo journalctl -u geth -f
```
### Restarting Services
To restart a service:

```console
sudo systemctl restart beacon-chain
sudo systemctl restart validator
sudo systemctl restart geth
```

### Stopping Services
Stopping a service is separate from disabling a service. Stopping a service stops the current execution of the server, but does not prohibit the service from starting again after a system reboot. If you intend for the service to stop running and to not restart after a reboot, you will want to stop and disable a service.

To stop a service:

```console
sudo systemctl stop beacon-chain
sudo systemctl stop validator
sudo systemctl stop geth
```

**Important:** If you intend to stop the beacon chain and validator in order to run these services on a different system, stop the services using the instructions in this section, and disable these services following the instructions in the next section. You will be at risk of losing funds through slashing if you accidentally validate the same keys on two different systems, and failing to disable the services may result in your beacon chain and validator running again after a system reboot.

### Disabling Services
To disable a service so that it no longer starts automatically after a reboot:

```console
sudo systemctl disable beacon-chain
sudo systemctl disable validator
sudo systemctl disable geth
```

### Enabling Services
To re-enable a service that has been disabled:

```console
sudo systemctl enable beacon-chain
sudo systemctl enable validator
sudo systemctl enable geth
```
### Starting Services
Re-enabling a service will not necessarily start the service as well. To start a service that is stopped:

```console
sudo systemctl start beacon-chain
sudo systemctl start validator
sudo systemctl start geth
```

### Upgrading Prysm
Upgrading the Prysm beacon chain and validator clients is as easy as restarting the service when running the prysm.sh script as we are in these instructions. To upgrade to the latest release, simple restart the services.

```console
sudo systemctl restart beacon-chain
sudo systemctl restart validator
```

### Changing systemd Service Files
If you edit any of the systemd service files in `/etc/systemd/system` or another location, run the following command prior to restarting the affected service:

```console
sudo systemctl daemon-reload
```
Then restart the affected service:
```console
sudo systemctl restart SERVICE_NAME
```

- Replace SERVICE_NAME with the name of the service for which the service file was updated. For example, `sudo systemctl restart beacon-chain`.

### Updating Prysm Options
To update the configuration options of the beacon chain or validator, edit the Prysm configuration file located in the home directories for the services.

```console
sudo nano /home/validator/prysm-validator.yaml
sudo nano /home/beacon/prysm-beacon.yaml
```

Then restart the services:

```console
sudo systemctl restart validator
sudo systemctl restart beacon-chain
```

