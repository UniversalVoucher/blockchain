pragma solidity ^0.4.10;

// Contract to set the owner of the contract
contract Owned {
    function Owned() { owner = msg.sender; }
    address owner;
}

// Mortal contract
contract Mortal is Owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

// Abstract contract for the ERC 20 Token standard
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

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}

// UV contract
contract UV is Mortal,Token {
  struct Voucher {
      uint id;
      bytes32 keyHash;
      uint expiredAt;
      uint consumedAt;
      uint createdAt;
  }
  
  address[] public partners;

  Voucher[] public vouchers;
  
  mapping(address => uint) balances;
  
  event AddVoucher(uint);
  event RequestOnExpiredVoucher(uint);
  event RequestBadKeyVoucher(uint);
  event ConsumeVoucher(uint);

  /// @notice constructor
  function UV() {
    owner = msg.sender ;
  }
  
  function addPartner(address _partner) returns (bool success) {
    partners.push(_partner);
    
    return true;
  }
  
  function removePartner(address _partner) returns (bool success) {}

  /// modifier for the owner of the contract
  modifier onlyOwner {
    if (msg.sender != owner)
        throw;
    _;
  }

  /// add and change the wallet of a passager
  function addVoucher
  (
    uint _id,
    uint _key
  )
    onlyOwner
  returns (uint indexVoucher)
  {
    vouchers.push(Voucher(_id, keccak256(_key), 0, 0, block.timestamp));
    AddVoucher(--vouchers.length);
    
    return --vouchers.length;
  }
  
  // modifier only partners
  function consumeVoucher (uint _index, uint _key) returns (bool success) {
    // if 24hours => not expire
    // modifier voucherNotExpire
    if (block.timestamp >  vouchers[_index].createdAt + 1 days) {
        vouchers[_index].expiredAt = block.timestamp;
        RequestOnExpiredVoucher(_index);
        throw;
    }
    
    // check key
    // modifier checkKey
    if (keccak256(_key) != vouchers[_index].keyHash) {
        RequestBadKeyVoucher(_index);
        throw;
    }
    
    vouchers[_index].consumedAt = block.timestamp;
    
    ConsumeVoucher(_index);
    
    return true;
  }
  
  /// @notice see `Token` contract
  function balanceOf(address _owner) constant returns (uint256 balance) {
      return balances[_owner];
  }
  

  /// @notice fallback
  function () payable {}
}
