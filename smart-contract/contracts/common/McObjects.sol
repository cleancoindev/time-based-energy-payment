pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract McObjects {
    
    enum Role { Producer, Distributor, Retailer, Consumer }  /// Producer:0 ~ Consumer:3

    struct User {  /// Key: userId
        Role role;
        address walletAddress;
    }
    
}
