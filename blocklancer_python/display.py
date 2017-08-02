# Python Script to display all information depending the contracts made on the Blocklancer Platform

from web3 import Web3, RPCProvider, KeepAliveRPCProvider, IPCProvider
import json

# Connect to the geth node
# web3=Web3(web3.RPCProvider(""))
# web3=Web3(RPCProvider("127.0.0.1"))
web3 = Web3(IPCProvider())

# set all abis
abi_dataHolder = json.loads(
    '[{"constant":true,"inputs":[],"name":"getBlocklancerToken","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_TokenHolderTribunal","type":"address"}],"name":"setTokenHolderTribunal","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_BlocklancerTokenContract","type":"address"}],"name":"setBlocklancerToken","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_BlocklancerContractHolder","type":"address"}],"name":"setBlocklancerContractHolder","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getBlocklancerContractHolder","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenHolderTribunal","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]')
abi_contractHolder = json.loads(
    '[{"constant":true,"inputs":[],"name":"getActiveContracts","outputs":[{"name":"","type":"address[]"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"link","type":"string"}],"name":"createNewFreelanceContract","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"pos","type":"uint256"}],"name":"getActiveContracts","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_client","type":"address"},{"name":"_rating","type":"int256"}],"name":"ContractFullfilled","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finalizeDispute","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"dispute","outputs":[],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]')
abi_workContract = json.loads(
    '[{"constant":false,"inputs":[],"name":"stopWork","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_price","type":"uint256"}],"name":"addBid","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getNumberOfBid","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_clientRating","type":"uint256"}],"name":"RateClient","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getClient","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"index","type":"uint256"}],"name":"create","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getBidPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getChosenFreelancer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getBidFreelancer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getStateofContract","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"reason","type":"string"}],"name":"callTokenHolderTribunal","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"freelancerRating","outputs":[{"name":"","type":"int256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getStateofContractString","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finalizeDispute","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_freelancerRating","type":"int256"}],"name":"PayFreelancer","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_link","type":"string"},{"name":"_client","type":"address"}],"payable":false,"type":"constructor"}]')
abi_tokenHolderTribunal = json.loads(
    '[{"constant":false,"inputs":[{"name":"disputeContract","type":"address"}],"name":"FinalizeDispute","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"disputeContract","type":"address"}],"name":"createDispute","outputs":[],"payable":false,"type":"function"}]')

ContractDataHolder = web3.eth.contract(abi=abi_dataHolder)
ContractWorkContractHolder = web3.eth.contract(abi=abi_contractHolder)
ContractWorkContract = web3.eth.contract(abi=abi_workContract)
ContractTokenHolderTribunal = web3.eth.contract(abi=abi_tokenHolderTribunal)

# set the address of the Contract Data Holder which contains all other addresses
ContractDataHolder.address = "0x5AA72B91805713fAed3672C759f305B751C0a8D3"


# ---------------
# Blocklancer Data Holder
# ---------------

# returns the address of the Work Contract Holder
# return address
def getBlocklancerContractHolder():
    try:
        return ContractDataHolder.call().getBlocklancerContractHolder();
    except:
        return 0;


# returns the address of the Token Holder Tribunal
# return address
def getTokenHolderTribunal():
    try:
        return ContractDataHolder.call().getTokenHolderTribunal();
    except:
        return 0;


# ---------------
# Work Contract Holder
# ---------------

# returns all work Contracts
# return address[]
def getActiveContracts():
    try:
        return ContractWorkContractHolder.call().getActiveContracts();
    except:
        return 0;


# ---------------
# Work Contract
# ---------------

# returns the address of the client
# return address
def getClient():
    try:
        return ContractWorkContract.call().getClient();
    except:
        return 0;


# returns the address of the selected freelancer
# return address
def getChosenFreelancer():
    try:
        return ContractWorkContract.call().getChosenFreelancer();
    except:
        return 0;


# returns the price of the selected freelancer
# return uint
def getPriceOfFreelancer():
    try:
        return ContractWorkContract.call().getBalance();
    except:
        return 0;


# returns the amount of bids made
# return uint
def getNumberOfBid():
    try:
        return ContractWorkContract.call().getNumberOfBid();
    except:
        return 0;


# get the price of the freelancer that made a bid
# return uint
def getBidPrice(pos):
    try:
        return ContractWorkContract.call().getBidPrice(pos);
    except:
        return 0;


# get the address of the freelancer that made a bid
# return uint
def getBidFreelancer(pos):
    try:
        return ContractWorkContract.call().getBidFreelancer(pos);
    except:
        return 0;


# return the link to more information depending the work contract
# return string
def getLink():
    try:
        return ContractWorkContract.call().getLink();
    except:
        return 0;


# for testing
# returns the current state of the work contract in readable form
# return string
def getStateofContractString():
    try:
        return ContractWorkContract.call().getStateofContractString();
    except:
        return 0;


# returns the current state of the work contract e.g. if the freelancer started working
# return uint
def getStateofContract():
    try:
        return ContractWorkContract.call().getStateofContract();
    except:
        return 0;


# Test everything

print("Work Contract Holder: ", getBlocklancerContractHolder())
print("Token Holder Tribunal: ", getTokenHolderTribunal())

ContractWorkContractHolder.address = getBlocklancerContractHolder()
ContractTokenHolderTribunal.address = getTokenHolderTribunal()

listOfContracts = getActiveContracts();
print(listOfContracts)

for t in range(len(listOfContracts)):
    ContractWorkContract.address = listOfContracts[t]

    print("\nContract ", t)

    print("State: ", getStateofContractString(), " : ", getStateofContract())
    print("Client: ", getClient())
    print("Freelancer: ", getChosenFreelancer())
    print("Price: ", getPriceOfFreelancer() / 10 ** 18, " ETH")
    print("Link: ", getLink())
    print("Number of Bids made: ", getNumberOfBid())
    for i in range(getNumberOfBid()):
        print("Bid ", i, " Price: ", getBidPrice(i) / 10 ** 18, " ETH")
        print("Bid ", i, " Freelancer: ", getBidFreelancer(i))

