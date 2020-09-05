pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract McObjects {
    
    enum Role {  /// Prosumer:0 ~ Retailer:2
        Prosumer, 
        Distributor, 
        Retailer
        //Producer, 
        //Consumer 
    }

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

    struct SmartMeterForProduction {   /// Key: address of prosumer --> year --> month
        uint year;
        uint month;
        uint producedTime;       /// second
        uint producedQuantity;   /// kw/h
    }

    struct SmartMeterForConsumption {   /// Key: address of prosumer --> year --> month
        uint year;
        uint month;
        uint consumedTime;      /// second
        uint consumedQuantity;  /// kw/h
    }

    struct MonthlyInvoice {   /// Key: address of prosumer --> year --> month
        address prosumer;
        uint year;
        uint month;
        string payer;
        string payee;
        uint paymentAmount;
        uint targetQuantity;
        uint producedQuantity;
        uint consumedQuantity;
    }    

}
