pragma solidity ^0.4.10;

contract UV {
  address public owner;
  
  struct Voucher {
      uint id;
      bytes32 keyHash;
      uint expiredAt;
      uint consumedAt;
      uint createdAt;
  }
  
  address[] public listPartners;

  Voucher[] public vouchers;
  
  event AddVoucher(uint);
  event RequestOnExpiredVoucher(uint);
  event RequestBadKeyVoucher(uint);
  event ConsumeVoucher(uint);

  event Transfer (address indexed _from, address indexed _to, uint256 _value);

  function UV() {
    owner = msg.sender ;
  }
  
  function addPartner() {}
  
  function removePartner() {}

  /// modifier for the owner of the contract
  modifier onlyOwner {
    if (msg.sender != owner)
        throw;
    _;
  }

  // only owner
  function deposit () payable returns (uint) {
  }

  /// add and change the wallet of a passager
  function addVoucher
  (
    uint _id,
    uint _key
  )
  {
    vouchers.push(Voucher(_id, keccak256(_key), 0, 0, block.timestamp));
    AddVoucher(vouchers.length - 1);
  }
  
  // modifier only partners
  function consumeVoucher (uint _index, uint _key) {
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
  }
  

  // fallback
  function () payable {}
  
  /* destruct the smart contract */
  function kill() onlyOwner() {
    selfdestruct(owner);
  }
}
