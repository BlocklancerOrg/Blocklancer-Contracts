//--------------------------------------------------------------//
//----------BLOCKLANCER TOKEN HOLDER TRIBUNAL (THT) ------------//
//--------------------------------------------------------------//

pragma solidity ^0.4.4;

/**
*@title Interface for the Lancer Token
*/
contract BlocklancerToken{
    function balanceOf(address _owner) constant returns (uint256);
    function getLastTransferred(address owner) constant returns (uint);
}

/**
*@title Interface for the DataHolder
*/
contract BlocklancerDataHolder{
    function getTokenHolderTribunal() external constant returns(address);
    
    function getBlocklancerContractHolder() external constant returns(address);
    
    function getBlocklancerToken() external constant returns(address);
}

/**
*@title Token Holder Tribunal (THT) Allows Token Holder to vote on disputes betweet freelancer and client
*/
contract TokenHolderTribunal{
    
    //holds information about a dispute
    struct dispute{
        mapping(uint => uint256) option;
        uint timeEnd;
        uint timeEndReveal;
        uint startTime;
        mapping(address => bytes32) secretVote;
        mapping(address => uint256) amount;
        uint arrayEntry;
    }
    
    /**
	*save the disputes
    *the mapping allows cheap access
	*/
    mapping(address => dispute) disputes;
    
    //the array allows to return all disputes
	address[] adisputes;
    
    //address of the Lancer Token (LNC)
    address BlocklancerTokenContract=0xF5266aEF432905370364C5B5BE50Db53F8C3B3d8;
    
    address aBlocklancerDataHolder=0x5AA72B91805713fAed3672C759f305B751C0a8D3;
    
    /**
	*@notice create a dispute
	*@param disputeContract Which employment contract starts the dispute
	*/
    function createDispute(address disputeContract) external{
        //create new dispute
        dispute memory disp;
        
        //set dispute start to current time + 1 day
        //can be changed by the token holder
        disp.timeEnd=block.timestamp + 1* 1 days;
        
        //set the reveal period start time to current time + 2 days
        //can be changed by the token holder
        disp.timeEndReveal=block.timestamp + 2* 1 days;
        
        //start time of the dispute
        disp.startTime=block.timestamp;
        
        //to later delete the dispute from the array
        disp.arrayEntry=adisputes.length;
        
        //save the dispute
        disputes[disputeContract]=disp;
        adisputes.push(disputeContract);
    }
    
    /**
	*@notice check how long you have before you can't vote for a certain dispute anymore
	*@param IDDispute the Id of the dispute
	*/
    function HowLongIsDisputeStillRunning(uint IDDispute) constant returns(uint){
        //if the voting period is over return 0
        if(disputes[adisputes[IDDispute]].timeEndReveal<block.timestamp) return 0;
        
        // otherwise return the time which remains before you can't vote anymore
        else return disputes[adisputes[IDDispute]].timeEnd-block.timestamp;
    }
    
    /**
	*@notice check how long you have before you can't reveal your vote for a certain dispute anymore
	*@param IDDispute The Id of the dispute
	*/
    function HowLongIsDisputeRevealStillRunning(uint IDDispute) constant returns(uint){
        //if the revealing period is over return 0
        if(disputes[adisputes[IDDispute]].timeEnd<block.timestamp) return 0;
        
        // otherwise return the time which remain before you can't reveal your vote anymore
        else return disputes[adisputes[IDDispute]].timeEndReveal-block.timestamp;
    }
    
    /**
	*@notice return all disputes at the moment
	*@return array of all employment contracts with disputes
	*/
    function GetDisputesAtTheMoment() constant returns(address[]){
        return adisputes;
    }
    
    /**
	*@notice Nobody is able to see the result before everyone voted. Has to be called before submitting to StoreSecretVote.
	*@param salt The salt
	*@param optionID Id of the dispute
	*/
    function generateVoteSecret(string salt, uint optionId) constant external returns (bytes32)
    {
        //return SHA3 hash, has to be sent to StoreSecretVote
        return keccak256(salt, optionId);
    }
    
    /**
	*@notice send the generated hash in generateVoteSecret to this function
	*@param secret The hashed decision
	*@param IDDispute The Id of the dispute
	*/
    function storeSecretVote(bytes32 secret,uint IDDispute){
        // if the voting period already ended -> throw
        if(block.timestamp>disputes[adisputes[IDDispute]].timeEnd) throw;
        
        //save the hash
        disputes[adisputes[IDDispute]].secretVote[msg.sender]=secret;
        
        //save the amount of token the sender own at the moment
        //the sender isn't able to reveal the vote if he has less token than here
        disputes[adisputes[IDDispute]].amount[msg.sender]=BlocklancerToken(BlocklancerTokenContract).balanceOf(msg.sender);
    }
    
    /**
	*@dev for testing. Returns the hash the sender submitted in storeSecretVote
	*@param IDDispute id of the dispute
	*@return The hash of the secret vote
	*/
    function returnSecretVoteHash(uint IDDispute) constant returns(bytes32){
        return disputes[adisputes[IDDispute]].secretVote[msg.sender];
    }
    
    /**
	* @notice Reveal the option you chose to vote for
	*@param salt The salt
	*@param optionID The decision. For whom you decided.
	*@param IDDispute Id of the dispute
	*/
    function revealVote(string salt, uint optionID,uint IDDispute){
        //only possible after the voting time is over
        if(block.timestamp<disputes[adisputes[IDDispute]].timeEnd) throw;
        
        //only possible if the reveal time limit hasn't ended
        //You aren't able to reveal your vote afterwards
        if(block.timestamp>disputes[adisputes[IDDispute]].timeEndReveal) throw;
        
        //generate the hash to check if it is the same as submitted before
        bytes32 a=keccak256(salt, optionID);
        if(a != disputes[adisputes[IDDispute]].secretVote[msg.sender]) throw;
        
        //don't allow to vote anything else than yes or no at the moment
        if(optionID>1) throw;
        
        //check if the sender still has the same amount of token or more
        //if he has less token he isn't allowed to reveal his vote
        //this prevents double voting by just sending the token to another address and resubmit a vote
        //with this we don't have to disable transactions of token like the DAO
        if(disputes[adisputes[IDDispute]].amount[msg.sender]<BlocklancerToken(BlocklancerTokenContract).balanceOf(msg.sender)) throw;
        
        //if he transferred token he isn't allowed to reveal his vote
        //this prevents someone from storing a vote then sending it to another wallet and storing another vote and so on
        //when the revealing period comes he could do the same thing and just sends the fund around and reveal
        //--------if(BlocklancerToken(BlocklancerTokenContract).getLastTransferred(msg.sender)>disputes[adisputes[IDDispute]].startTime) throw;
        
        //add the voting power(token in possesion) to the result
        //if the sender has more token than before the old amount is still used here
        disputes[adisputes[IDDispute]].option[optionID]+=disputes[adisputes[IDDispute]].amount[msg.sender];
        
        //delete all entrys
        //the sender isn't able to reveal his vote again
        delete disputes[adisputes[IDDispute]].secretVote[msg.sender];
        delete disputes[adisputes[IDDispute]].amount[msg.sender];
    }
    
    /**
	*@dev for testing. Returns the amount of token the sender holds
	*@return The amount of tokens the sender holds
	*/
    function fundsOf() constant external returns(uint256){
        return BlocklancerToken(BlocklancerTokenContract).balanceOf(msg.sender);
    }
    
    /**
	*@notice finish the dispute and send the result to the other contracts
	*@param disputeContract The address of the contract, that is currently under dispute
	*@return the winner of the THT
	*/
    function FinalizeDispute(address disputeContract) external returns(uint){
        // only BlocklancerContractHolder is able to call this function
        if(msg.sender != BlocklancerDataHolder(aBlocklancerDataHolder).getBlocklancerContractHolder()) throw;
        
        //store the winner before deleting the dispute from the blockchain
        uint winner;
        
        //the voting option with the more supporter wins
        if(disputes[disputeContract].option[0] > disputes[disputeContract].option[1] )
            winner=0;
        else
            winner=1;
            
        //delete the dispute
        delete adisputes[disputes[disputeContract].arrayEntry];
        delete disputes[disputeContract];
        
        
        //return the winner to the BlocklancerContractHolder contract
        return winner;
    }
    
    /**
	*@notice returns the result of the vote
	*@param IDDispute The Id of the dispute
	*@param optionID The option you'd like to see
	*@param result of the vote
	*/
    function getResult(uint IDDispute, uint optionID) constant returns(uint){
        return disputes[adisputes[IDDispute]].option[optionID];
    }
}