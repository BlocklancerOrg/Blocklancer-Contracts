![alt text](https://i.imgur.com/purXzD3.png "Lancer Token")

# Blocklancer - Smart Contracts
[blocklancer.net](http://blocklancer.net)

Blocklancer is a so called Distributed Autonomous Job Market (DAJ) on the Ethereum platform, our vision of a completely self-regulatory platform for finding jobs and getting projects done. It will change the way freelancing works, both for customers and freelancers, and it will lift the reliability of freelancing to new heights.
  
# Abstract
The contracts in this repository are meant to be a proof-of-concept. It demonstrates the feasibility of the whole Blocklancer platform. It already solves many issues involved in the freelancing process, including but not limited to: 

  - refusals of paying the agreed-on amount of money for a project,
  - unfair decisions
  - the uncontrollable influence of a central authority figure

# Token Holder Tribunal (THT)
  
The current implementation of the Token Holder Tribunal already includes major improvements compared to the voting system in current tokens (e.g. Augur). Another undesirable problem of the democratic implementations presented so far is definitely not technical, but social. During the voting period, running tallies are public. This leads to undesirable consequences such as bandwagoning and groupthink. Thus a successful voting system has to hide the outcome of the vote until everyone made their vote. In the Blocklancer platform everyone submits his vote sealed and has to unseal it after everyone submitted his vote and thus hides the result from the crowd. With this implementation, Blocklancer is really able to harness the wisdom of the unbiased crowd. In addition, Blocklancer doesn’t locks transfers of funds whilst a vote is active as other tokens do. Transfers of Tokens are always possible and at the same time we are able to tackle double votes.

# Employment Contracts

All Employment contracts are stored in a contract holder. With this implementation we are able to ensure the highest amount of expandability by adding the ability to support many different sorts of contracts. Another advantage is expandability and modularity by providing the option to seamlessly replace contracts of the system.

#Migration to a new Contract

The Blocklancer contract is designed to be able to migrate to a new contract in the case another standard (ERC20) should be established and thus makes Blocklancer future proof. With this concept Blocklancer is able to change every aspect of the platform at any given time just by asking the token holder to approve the change.

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



