pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/// *** Using @hq/contracts v0.0.2 *** 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./@hq20/contracts/access/Whitelist.sol";
//import "@hq20/contracts/contracts/access/Whitelist.sol";

/// Library
import "./lib/OwnableOriginal.sol";
//import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeContract.sol";
import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McConstants.sol";

/// ERC20 token for paying for energy production and consumption
import "./mockToken/MaticEnergyToken.sol";

/// Time based payment formula
import "./TimeBasedPaymentFormula.sol";


/***
 * @notice - This contract is that ...
 * @dev - Implements a simple energy market, using ERC20 and Whitelist. 
 * @dev - ERC20 is used to enable payments from the consumers to the distribution network, represented by this contract, and from the distribution network to the producers. 
 * @dev - Whitelist is used to keep a list of compliant smart meters that communicate the production and consumption of energy.
 **/
contract EnergyDistributionNetwork is TimeBasedPaymentFormula, Whitelist, McStorage, McEvents, McConstants {
    using SafeMath for uint;

    MaticEnergyToken public maticEnergyToken;

    event EnergyProduced(address producer, uint256 time);
    event EnergyConsumed(address consumer, uint256 time);
    
    // uint128 is used here to facilitate the price formula
    // Casting between uint128 and int256 never overflows
    // int256(uint128) - int256(uint128) never overflows  
    mapping(uint256 => uint128) public consumption;
    mapping(uint256 => uint128) public production;
    uint128 public basePrice;

    /**
     * @dev - The constructor initializes the underlying currency token and the smart meter whitelist. 
     *      - The constructor also mints the requested amount of the underlying currency token to fund the network load. 
     *      - Also sets the base energy price, used for calculating prices.
     */
    constructor (address _maticEnergyToken, address initialMember)
        public
        TimeBasedPaymentFormula()
        Whitelist(initialMember)  /// Add initial member
    {
        maticEnergyToken = MaticEnergyToken(_maticEnergyToken);

        //uint256 _initialSupply = 1e20;  /// 100 MET
        uint128 _basePrice = 1e18;        ///   1 MET (Current energy price = MET/kw)

        basePrice = _basePrice;
    }


    /***
     * @notice - Calculate time (unit is "second") of the specified month
     **/    
    // function calculateTimeForSpecifiedMonth(uint year, uint month) public view returns (uint calculatedTime) {
    //     uint startDayOfMonth = 1;
    //     uint endDayOfMonth = 30;   /// Tentative
    //     uint timestampForStartingDayOfMonth = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, startDayOfMonth);
    //     uint timestampForEndingDayOfMonth = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, endDayOfMonth);
    // }


    /***
     * @notice - Sample smart meter (This is just sample and will be replaced in the future)
     *         - Smart meter records value of every month
     **/
    function sampleSmartMeter(address prosumer, uint year, uint month) public view returns (uint producedTime, uint producedQuantity, uint consumedTime, uint consumedQuantity) {
        /// Contant value are assigned so far. (Assigned value will be replaced with oraclized value in the future)
        uint producedTime;
        uint producedQuantity;
        uint consumedTime;
        uint consumedQuantity;
        return (producedTime, producedQuantity, consumedTime, consumedQuantity); 
    }    

    /***
     * @notice - Record quantity during time (every month. 1st-30th) from each smart-meter
     *         - Save each time (produced time / consumed time) of prosumer
     **/
    function recordSmartMeter(address prosumer, uint year, uint month) public returns (bool) {
        /// Get producedTime/consumedTime and producedQuantity/consumedQuantity via smart-meter
        uint producedTime;
        uint producedQuantity;
        uint consumedTime;
        uint consumedQuantity;
        (producedTime, producedQuantity, consumedTime, consumedQuantity) = sampleSmartMeter(prosumer, year, month);

        /// Record quantity of production during time from smart-meter
        SmartMeterForProduction storage smartMeterForProduction = smartMeterForProductions[prosumer][year][month];
        smartMeterForProduction.year = year;
        smartMeterForProduction.month = month;
        smartMeterForProduction.producedTime = producedTime;
        smartMeterForProduction.producedQuantity = producedQuantity;

        /// Record quantity of consumption during time from smart-meter
        SmartMeterForConsumption storage smartMeterForConsumption = smartMeterForConsumptions[prosumer][year][month];
        smartMeterForConsumption.year = year;
        smartMeterForConsumption.month = month;
        smartMeterForConsumption.consumedTime = consumedTime;
        smartMeterForConsumption.consumedQuantity = consumedQuantity;
    }

    /***
     * @notice - Get each time from recorded smart-meter
     **/
    function getSmartMeter(address prosumer, uint year, uint month) public returns (uint producedQuantity, uint consumedQuantity) {
        SmartMeterForProduction memory smartMeterForProduction = smartMeterForProductions[prosumer][year][month];
        uint producedQuantity = smartMeterForProduction.producedQuantity;

        SmartMeterForConsumption memory smartMeterForConsumption = smartMeterForConsumptions[prosumer][year][month];
        uint consumedQuantity = smartMeterForConsumption.consumedQuantity;
        return (producedQuantity, consumedQuantity);
    }

    /***
     * @notice - Distrubution is executed every month.
     **/
    function monthlyDistribution(address prosumer, uint year, uint month) public returns (bool) {
        /// Calculate timestamp of the first day of next month by using BokkyPooBahsDateTimeLibrary.sol
        uint nextMonth = month.add(1);
        uint timestampOfFirstDayOfNextMonth = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, nextMonth, 1);

        if (timestampOfFirstDayOfNextMonth < now) {
            judgeProfitOrLoss(prosumer, year, month);
        }
    }

    /***
     * @notice - Judge whether user pay consumed amount or get profit or both of no.
     **/
    function judgeProfitOrLoss(address prosumer, uint year, uint month) public returns (bool) {
        SmartMeterForProduction memory smartMeterForProduction = smartMeterForProductions[prosumer][year][month];
        uint producedQuantity = smartMeterForProduction.producedQuantity;

        SmartMeterForConsumption memory smartMeterForConsumption = smartMeterForConsumptions[prosumer][year][month];
        uint consumedQuantity = smartMeterForConsumption.consumedQuantity;

        uint targetQuantity;
        if (producedQuantity > consumedQuantity) {
            targetQuantity = producedQuantity.sub(consumedQuantity);   /// In case of this, user get profit
            uint paymentAmount = distributionAmount(targetQuantity);
            /// Distribution from contract (distribution network) to user (producer)
            maticEnergyToken.transfer(msg.sender, paymentAmount);
        } else if (producedQuantity < consumedQuantity) {
            targetQuantity = consumedQuantity.sub(producedQuantity);   /// In case of this, user pay for substracted amount
            uint paymentAmount = distributionAmount(targetQuantity);
            /// Distribution from user (consumer) to contract (distribution network)
            maticEnergyToken.transferFrom(msg.sender, address(this), paymentAmount);
        } else if (producedQuantity == consumedQuantity) {
            targetQuantity = 0;                                       /// In case of this, user is no pay for any amount and no get profit
            uint paymentAmount = 0;      /// Result: 0
        }
    }

    
}
