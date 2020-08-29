pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./McObjects.sol";

// shared storage
contract McStorage is McObjects {

    mapping (uint => User) users;  /// Key: userId
    
    mapping (address => uint) _lastCheckedDatetime;  /// Key: prosumer's address

    /// Smart Meter
    mapping (address => SmartMeterForProduction) smartMeterForProductions;    /// Key: address of producer
    mapping (address => SmartMeterForConsumption) smartMeterForConsumptions;  /// Key: address of consumer
    

}
