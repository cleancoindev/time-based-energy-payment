pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract McObjects {
    
    enum Role { Producer, Distributor, Retailer, Consumer }  /// Producer:0 ~ Consumer:3

    struct User {  /// Key: userId
        uint userId;
        Role role;
        address walletAddress;
    }
    
    struct UserWithWalletAddress {  /// Key: user's wallet address
        uint userId;
        Role role;
        address walletAddress;
    }

    struct SmartMeterForProduction {   /// Key: address of producer --> year --> month
        uint year;
        uint month;
        uint producedTime;       /// second
        uint producedQuantity;   /// kw/h
    }

    struct SmartMeterForConsumption {   /// Key: address of consumer --> year --> month
        uint year;
        uint month;
        uint consumedTime;      /// second
        uint consumedQuantity;  /// kw/h
    }    
    

}
