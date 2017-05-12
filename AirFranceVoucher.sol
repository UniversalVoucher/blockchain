pragma solidity ^0.4.10;

// Contract to set the owner of the contract
contract Owned {
  function Owned() { owner = msg.sender; }
  address public owner;
}

// Mortal contract
contract Mortal is Owned {
  function kill() {
    if (msg.sender == owner) selfdestruct(owner);
  }
}

// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/issues/20
contract Token {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Partner {
    address[] public partners; // partner adress array

    function addPartner(address _partner) returns (uint index) {
        partners.push(_partner);

        return partners.length - 1;
    }

    function removePartner(uint index) {
        partners[index] = 0x000;
    }

    function isPartner(address _partner) returns (bool isPartner) {
        bool partnerExists = false;
        for(uint i; i < partners.length; i++) {
            if (_partner == partners[i])
                partnerExists = true;
        }

        return partnerExists;
    }
}

contract StandardToken is Mortal, Token, Partner {
    /// map with the creation date of the voucher
    mapping (address => uint) public voucherCreatedAt;

    function transfer(address _to, uint256 _value) returns (bool success) {
        require(
            balances[msg.sender] >= _value &&
            balances[_to] <= balances[_to] + _value // to prevent an overflow
        );

        if (msg.sender == owner) { // transfer to a voucher
            voucherCreatedAt[_to] = now; // add the creation date of the voucher
        } else if (isPartner(msg.sender)) { // transfer to the owner (msg.sender is a partner)
            require(_to == owner);
        } else { // transfer to a partner (msg.sender is a voucher)
            require(voucherCreatedAt[msg.sender] != 0); // if the address of the voucher is not valid, it throws
            require(voucherCreatedAt[msg.sender] <= voucherCreatedAt[msg.sender] + 24 hours); // if the voucher is expired, it throws
        }

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        Transfer(msg.sender, _to, _value);

        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        throw; // disable this function
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        throw; // disable this function
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      throw; // disable this function
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}


contract AirFranceVoucher is StandardToken {

    function () {
        //if ether is sent to this address, send it back.
        throw;
    }

    /* Public variables of the token */
    string public name;                   // name
    uint8 public decimals;                // decimals
    string public symbol;                 // identifier of the subcurrency
    string public version = 'AFV-0.1';    // Air France Voucher 0.1 standard

    function AirFranceVoucher() {
        balances[owner] = 1000;
        totalSupply = 1000;
        name = "AFV";
        decimals = 18;
        symbol = "AFV";
    }
}
