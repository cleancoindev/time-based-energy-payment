pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./McObjects.sol";

// shared storage
contract McStorage is McObjects {

    mapping (uint => User) users;  /// Key: userId
    mapping (address => UserWithWalletAddress) userWithWalletAddresses;  /// Key: user's wallet address

    mapping (address => uint) _lastCheckedDatetime;  /// Key: prosumer's address

    /// Smart Meter
    mapping (address => mapping (uint => mapping (uint => SmartMeterForProduction))) smartMeterForProductions;    /// Key: address of prosumer -> year -> month
    mapping (address => mapping (uint => mapping (uint => SmartMeterForConsumption))) smartMeterForConsumptions;  /// Key: address of prosumer -> year -> month
    
    /// Monthly Invoice
    mapping (address => mapping (uint => mapping (uint => MonthlyInvoice))) monthlyInvoices;    /// Key: address of prosumer -> year -> month

}
