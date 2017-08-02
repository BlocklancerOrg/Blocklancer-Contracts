//--------------------------------------------------------------//
//----------------- BLOCKLANCER Work Contract ------------------//
//--------------------------------------------------------------//

pragma solidity ^0.4.4;

import "ContractHolder.sol";

/** @title Blocklancer Token (LNC) - Employment Contract code for the Blocklancer Project */
contract BlocklancerEmploymentContract {
    
    struct Bid{
        uint price;
        address freelancer;
    }
    
	//link to the information depending the working
	/*todo: should be replaced with IPFS*/
    string public link;

	//address of the client(Creator of the contract)
	address public client;
	
	/**
	*address to the Blocklancer data holder -> contains the addresses to all important contractState
	*allows us to just replace a single contract with another one
	*after replacing everything works the same as before - except this contract communicate with a different contract
	*/
	address aBlocklancerDataHolder=0x5AA72B91805713fAed3672C759f305B751C0a8D3;
    
	//the state of this job e.g. if its finished
    enum ContractState { SearchingFreelancer, FreelancerStartsWorking, TokenholderTribunal, CancelByFreelancer, FinishedSuccessful, ClientLostInTHT, FreelancerLostInTHT }
    
	//to store the current state
    ContractState contractState;
    
	//rating of the freelancer and client
    int public freelancerRating;
    uint clientRating;
    
	//bids of the freelancer
    Bid[] bid;
    
	//the bid the client selected
    Bid ChosenBid;

	/** @notice should be called by the contract holder contract
	*@param _link link to information of the contract (URL or IPFS hash)
	*@param _client address of the client
	*/
    function BlocklancerEmploymentContract(string _link, address _client) {
        link=_link;
		client=_client;
		//set the current state of the contract to -> "In Search of a Freelancer"
		contractState=ContractState.SearchingFreelancer;
    }
	
	/**@notice returns the link to the Contract information
	*@return the link to the information of the contract
	*todo: should be replaced with IPFS
	*/
	function getLink() constant returns(string){
        return link;
    }
    
	/**
	*@notice returns the client address
	*@return the client address
	*/
    function getClient() constant returns(address){
        return client;
    }

	/**
	*@dev returns the current state of the contract in readable form
	*@return the state of the contract as readable string
	*/
    function getStateofContractString() external constant returns (string) {
        if(contractState==ContractState.SearchingFreelancer){
            return "In Search of a Freelancer";
        }
        else if(contractState==ContractState.FreelancerStartsWorking){
            return "Freelancer started working";
        }
        else if(contractState==ContractState.TokenholderTribunal){
            return "Token Holder Tribunal is active";
        }
        else if(contractState==ContractState.CancelByFreelancer){
            return "Freelancer cancelled the contract";
        }
        else if(contractState==ContractState.FinishedSuccessful){
            return "Contract Successful finished";
        }
        else if(contractState==ContractState.ClientLostInTHT){
            return "Client Lost in the Token Holder Tribunal";
        }
        else if(contractState==ContractState.FreelancerLostInTHT){
            return "Freelancer Lost in the Token Holder Tribunal";
        }
        else{
            return "Error";
        }
    }
    
	/**
	*@notice get state of contract
	*@param the state of the contract as enum
	*/
    function getStateofContract() external constant returns(ContractState){
        return contractState;
    }
    
    /**
	*@notice returns the address of the selected freelancer (The one that works on this job)
	*@return address of the freelancer, who is working on the contract
	*/
    function getChosenFreelancer() external constant returns (address) {
        return ChosenBid.freelancer;
    }
    
	/**
	*@notice get the price of the selected freelancer
	*@return price of the freelancer, who is working on the contract
	*/
    function getBalance() external constant returns (uint) {
        return ChosenBid.price;
    }
    
	/**
	*@notice get the amount of bids for this job
	*@return how many bids are there for the contract
	*/
    function getNumberOfBid() external constant returns (uint) {
        return bid.length;
    }
    
	/**
	*@notice add a bid yourself
	*@param _price how many money you'd like for doing the contract
	*/
    function addBid(uint256 _price) external{
        Bid memory b;
		//convert the entered amount to wei
        b.price=_price*10**18;
        b.freelancer = msg.sender;
        bid.push(b);
    }
    
	/**
	*@notice get the price of a certain bid
	*@return price of a certain bid
	*/
    function getBidPrice(uint index) external constant returns (uint){
        if(bid.length>index)
            return bid[index].price;
        else
            return 0;
    }
    
	/**
	*@notice returns the freelancers address of a certain bid
	*@return address of freelancer of a certain bid
	*/
    function getBidFreelancer(uint index) external constant returns (address){
        if(bid.length>index)
            return bid[index].freelancer;
        else
            return 0;
    }

	/**
	*@notice The client selects a freelancer
	*@param the index of the selected freelancer
	*/
    function create(uint index) payable external {
        if(bid.length<=index)throw;
        if(msg.value!=bid[index].price)throw;
        if(msg.sender!=client)throw;
        
        ChosenBid=bid[index];
        contractState=ContractState.FreelancerStartsWorking;
    }

	/**
	*@notice if the client accepts the work of the freelancer after that the contract is finished successfully
	*@param _freelancerRating the rating the client is giving to the freelancer
	*/
    function PayFreelancer(int _freelancerRating) external {
		//only the client can call this function
        if(msg.sender!=client)throw;
		
		//only if the state of the contract is FreelancerStartsWorking
        if(contractState!=ContractState.FreelancerStartsWorking) throw;
		
		//set the state of this job to finished
        contractState=ContractState.FinishedSuccessful;
		
        freelancerRating=_freelancerRating;
		
		//tell the Blocklancer contract holder that this job is successfully finished
		BlocklanceContractHolder(BlocklancerDataHolder(aBlocklancerDataHolder).getBlocklancerContractHolder()).ContractFullfilled(client,freelancerRating);
		
		//send the money to the freelancer
		if (!ChosenBid.freelancer.send(this.balance)) throw;
    }
    
	/**
	*@notice If the contract is successfully finished, the freelacer is allowed to rate the client
	*@param _clientRating the rating of the client
	*/
    function RateClient(uint _clientRating) external{
        if(contractState!=ContractState.FinishedSuccessful)throw;
        if(msg.sender!=ChosenBid.freelancer)throw;
        clientRating=_clientRating;
    }

	/**
	*@notice If there is a dispute every side is allowed to ask the token holder
	*@param reason A description, why the THT is called
	*/
    function callTokenHolderTribunal(string reason) external {
		//only the client and the freelancer are allowed to call this function
        if(msg.sender!=client && msg.sender!=ChosenBid.freelancer)throw;
		
		// only possible if the freelancer started working
        if(contractState!=ContractState.FreelancerStartsWorking) throw;
		
		//set the state of this job to "Token Holder Tribunal is active"
        contractState=ContractState.TokenholderTribunal;
        BlocklanceContractHolder(BlocklancerDataHolder(aBlocklancerDataHolder).getBlocklancerContractHolder()).dispute();
    }
    
	/**
	*@notice After the token holder made a decision, this function can be called to finish the dispute and send the money to the winning side
	*/
    function finalizeDispute(){
	
		//only the client and the freelancer are allowed to call this function
        if(msg.sender!=client && msg.sender!=ChosenBid.freelancer)throw;
        uint result=2;
		
		//retrieve the result from the token holder tribunal
        result=BlocklanceContractHolder(BlocklancerDataHolder(aBlocklancerDataHolder).getBlocklancerContractHolder()).finalizeDispute();
		
		//if the result is not 0 or 1 cancel
        if(result!=0 && result!=1) throw;
		
		//if the token holder decided that the client war right
        if(result==0){
            if (!client.send(this.balance)) throw;
            
            contractState=ContractState.FreelancerLostInTHT;
        }
		//if the token holder decided that the freelancer war right
        else if(result==1){
            if (!ChosenBid.freelancer.send(this.balance)) throw;
            contractState=ContractState.ClientLostInTHT;
        }
    }
    
	/**
	*@notice If the freelancer volutarily chooses to stop working. The client will get the money back.
	*/
    function stopWork(){
	//only the freelancer is allowed to call this function
        if(msg.sender != ChosenBid.freelancer) throw;
        contractState=ContractState.CancelByFreelancer;
		
		//send the money to the client
        if (!client.send(this.balance)) throw;
    }
    
}