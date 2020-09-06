pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract McObjects {
    
    enum EnergyType { SolarPower, WindPower, HydraulicPower, GeothermalPower }  /// SolarPower:0 ~ GeothermalPower:3

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
        EnergyType energyType;
        uint producedTime;       /// second
        uint producedQuantity;   /// kw/h
    }

    struct SmartMeterForConsumption {   /// Key: address of prosumer --> year --> month
        uint year;
        uint month;
        EnergyType energyType;
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
        EnergyType energyTypeFromSmartMeterOfProduction;   /// Smart-meter from the production
        EnergyType energyTypeFromSmartMeterOfConsumption;  /// Smart-meter from the consumption
        uint targetQuantity;
        uint producedQuantity;
        uint consumedQuantity;
    }    

}
