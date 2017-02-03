pragma solidity ^0.4.9;
contract owned {
    function owned() { owner = msg.sender; }
    address owner;
}

contract mortal is owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

contract Identity is owned, mortal {
    address public owner;
    mapping (uint => string) public identities;

    function Identity() {
        owner = msg.sender;
    }

    function newIdentity(uint id, string identity) {
        identities[id] = identity;
    }
}
