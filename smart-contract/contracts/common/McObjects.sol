pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract McObjects {
    
    enum Role { Producer, Distributor, Retailer, Consumer }

    struct User {  /// Key: userId
        Role role;
        address walletAddress;
    }
    
}
