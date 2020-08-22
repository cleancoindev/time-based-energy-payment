pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./McObjects.sol";

// shared storage
contract McStorage is McObjects {

    mapping (uint => User) users;  /// Key: userId
    

}
