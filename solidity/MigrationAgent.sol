//--------------------------------------------------------------//
//----------------- BLOCKLANCER MIGRATION AGENT ----------------//
//--------------------------------------------------------------//

pragma solidity ^0.4.8;

/**@title The old contract. This contract is going to be replaced. Just an Interface
*/
contract BlocklancerToken{
	function totalSupply() constant returns (uint256);
}

/**
*@title The new contract. This contract replaces the old contract. Just an Interface
*/
contract NewBlocklancerToken{
	function totalSupply() constant returns (uint256);
	
	function finalizeMigration();
	
	//creates token on the new contract
	function createToken(address from, uint256 amount);
}

/**
*@title Allows to migrate to a new contract
*/
contract MigrationAgent {

	//only the owner is allowed to do some things
    address master;
	
	//old and new BlocklancerToken address
    address oldBlocklancerToken;
    address NewBlocklancerToken;

	//total amount of migrated token
    uint256 tokenSupply;

	/**@notice set the old BlocklancerToken address at the creation master = sender
	*@param _oldBlocklancerToken The contract that should be replaced
	*/
    function MigrationAgent(address _oldBlocklancerToken) {
        master = msg.sender;
        oldBlocklancerToken = _oldBlocklancerToken;
    }
	
	/**
	*@notice return the total amount of migrated token  -> allows everyone to easiely see the progress of the migration
	*@return how many tokens are already migrated
	*/
	function totalSupply() constant returns(uint256){
		return tokenSupply;
	}

	/**
	*@notice The address of the new token contract
	*@param _NewBlocklancerToken The address of the new token contract
	*/
	function setNewTokenAddress(address _NewBlocklancerToken) {
        if (msg.sender != master) throw;
        if (NewBlocklancerToken != 0) throw;

        NewBlocklancerToken = _NewBlocklancerToken;
    }

	/**
	*@notice check conditions, if migration is possible
	*@param _value how many tokens should be migrated
	*/
    function safetyCheck(uint256 _value) private {
        if (NewBlocklancerToken == 0) throw;
        if (BlocklancerToken(oldBlocklancerToken).totalSupply() + NewBlocklancerToken(NewBlocklancerToken).totalSupply() != tokenSupply - _value) throw;
    }

    /**
	*@notice migrate from function is called in the old contract. Starts migartion
	*@param _from from whom should the tokens migrate
	*@param _value how many tokens should migrate
	*/
    function migrateFrom(address _from, uint256 _value) {
        if (msg.sender != oldBlocklancerToken) throw;
        if (NewBlocklancerToken == 0) throw;

        //Right here oldBlocklancerToken has already been updated, but corresponding GNT have not been created in the NewBlocklancerToken contract yet
        safetyCheck(_value);

        NewBlocklancerToken(NewBlocklancerToken).createToken(_from, _value);

        //Right here totalSupply invariant must hold
        safetyCheck(0);
    }

	/**
	*@notice Finish the migration process. Stops further migration. Allows working with the new contract.
	*/
    function finalizeMigration() {
        if (msg.sender != master) throw;

        safetyCheck(0);

		//finish the migration and stop further migration
        NewBlocklancerToken(NewBlocklancerToken).finalizeMigration();

        oldBlocklancerToken = 0;
        NewBlocklancerToken = 0;

        tokenSupply = 0;
    }
}