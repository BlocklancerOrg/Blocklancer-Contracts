![alt text](http://i.imgur.com/5jgMxke.png "Lancer Token")

# Blocklancer - Smart Contracts
[blocklancer.net](http://blocklancer.net)
Blocklancer is a so called Distributed Autonomous Job Market (DAJ) on the Ethereum platform, our vision of a completely self-regulatory platform for finding jobs and getting projects done. It will change the way freelancing works, both for customers and freelancers, and it will lift the reliability of freelancing to new heights.

# Smart Contracts

This repository contains the underlying smart contracts of Blocklancer. The smart contracts are written in Ethereum's Solidity programming language. The smart contracts are the backbone of Blocklancer and manage main features like:

  - The Token holder tribunal (THT)
  - The reputation system
  - The escrow system
  - 
# Usage
**Requires:** Install [geth](https://github.com/ethereum/go-ethereum/wiki/geth) and run the smart contracts on a local geth-node.

In the directory *blocklancer_python* you find a python-script that shows how to communicate with the smart contracts over a python interface. For running the python script you need python3, web3-python and json. You find the requirements in requirements.txt. The requirements can be installed by typing: 

```sh
pip3 install 
```

The script outputs: 

- the state of the contract
- the client of the contract
- the freelancer of the contract
- the bids
- the price of the bids
- etc.



