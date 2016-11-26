/* This program is free software. It creates
for the bemyapp AirFrance hackaton */

pragma solidity ^0.4.2;
/*'pragma' the version of the compiler */

contract universalVoucher {
    address public owner;

    mapping(uint256 => uint256) public passagerWallets;

    /* constructor */
    function universalVoucher() {
        owner = msg.sender ;
    }

    /// modifier for the owner of the contract
    modifier onlyOwner {
        if (msg.sender != owner)
            throw;
        _;
    }

    /// add and change the wallet of a passager
    function changePassager(uint256 id, uint256 amount) onlyOwner {
        passagerWallets[id]=amount;
    }

    /* destruct the smart contract */
    function kill() onlyOwner() {
      selfdestruct(owner);
    }
}
