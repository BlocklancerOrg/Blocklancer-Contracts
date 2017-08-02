//--------------------------------------------------------------//
//------------------ BLOCKLANCER Data Holder -------------------//
//--------------------------------------------------------------//

pragma solidity ^0.4.4;

/**
*@title Holds the addresses of the other contracts
*
*/
contract BlocklancerDataHolder{
    address TokenHolderTribunal;
    address BlocklancerContractHolder;
    address BlocklancerTokenContract=0xF5266aEF432905370364C5B5BE50Db53F8C3B3d8;
    address master;
    
    function BlocklancerDataHolder(){
        master=msg.sender;
    }
    
	/**
	*@notice returns address of THT
	*@return the THT
	*/
    function getTokenHolderTribunal() external constant returns(address){
        return TokenHolderTribunal;
    }
    
	/*
	*@notice returns address of contract holder
	*@return the contract holder
	*/
    function getBlocklancerContractHolder() external constant returns(address){
        return BlocklancerContractHolder;
    }
    
	/*
	*@notice setter for THT
	*@param _TokenHolderTribunal address of THT to set
	*/
    function setTokenHolderTribunal(address _TokenHolderTribunal) external{
        if(msg.sender!=master)throw;
        TokenHolderTribunal=_TokenHolderTribunal;
    }
    
	/*
	*@notice setter for contract holder
	*@param _BlocklancerContractHolder the address of the contract holder
	*/
    function setBlocklancerContractHolder(address _BlocklancerContractHolder) external{
        if(msg.sender!=master)throw;
        BlocklancerContractHolder=_BlocklancerContractHolder;
    }
    
	/*
	*@notice returns the address of the Lancer TokenHolderTribunal
	*@return the address of the Lancer Token
	*/
    function getBlocklancerToken() external constant returns(address){
        return BlocklancerTokenContract;
    }
    
	/**
	*@notice setter for the Lancer Token contract
	*@param _BlocklancerTokenContract the address of the Lancer token
	*/
    function setBlocklancerToken(address _BlocklancerTokenContract) external{
        if(msg.sender!=master)throw;
        BlocklancerTokenContract=_BlocklancerTokenContract;
    }
}