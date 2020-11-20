# Several BASH scripts to install ETH2 Set-up
- Harden OS, install Geth, Beacon & Validator

** Scripts are currently hardcoded for pyrmont testnet **
## Script 1: Harden OS
if needed, install curl using ```sudo apt-get install curl```
```
bash <(curl -s https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/eth2_harden.sh)
```
## Script 2: Install ETH1 node geth
```
bash <(curl -s https://raw.githubusercontent.com/jnnngs/eth2_validator_bash/main/eth2_geth.sh)
```


