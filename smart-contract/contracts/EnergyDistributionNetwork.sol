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
    function calculateTimeForSpecifiedMonth(uint year, uint month) public view returns (uint calculatedTime) {
        uint startDayOfMonth = 1;
        uint endDayOfMonth = 30;   /// Tentative
        uint timestampForStartingDayOfMonth = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, startDayOfMonth);
        uint timestampForEndingDayOfMonth = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, endDayOfMonth);
    }

    /***
     * @notice - Record quantity during time (every month. 1st-30th) from each smart-meter
     *         - Produced time and consumed time are same.
     **/
    function recordSmartMeter(address prosumer, uint timePerMonth, uint producedQuantity, uint consumedQuantity) returns (bool) {
        /// Record quantity of production during time from smart-meter
        SmartMeterForProduction storage smartMeterForProduction = smartMeterForProductions[prosumer]; 
        smartMeterForProduction.producedTime = timePerMonth;
        smartMeterForProduction.producedQuantity = producedQuantity;

        /// Record quantity of consumption during time from smart-meter
        SmartMeterForConsumption storage smartMeterForConsumption = smartMeterForConsumptions[prosumer]; 
        smartMeterForConsumption.consumedTime = timePerMonth;
        smartMeterForConsumption.consumedQuantity = consumedQuantity;
    }

    /***
     * Check and record smart-meter for getting each time
     **/
    function getSmartMeter(address prosumer, uint timePerMonth) returns (uint producedQuantity, uint consumedQuantity) {
        SmartMeterForProduction memory smartMeterForProduction = smartMeterForProductions[prosumer];
        uint producedQuantity = smartMeterForProduction.producedQuantity;

        SmartMeterForConsumption memory smartMeterForConsumption = smartMeterForConsumptions[prosumer]; 
        uint consumedQuantity = smartMeterForConsumption.consumedQuantity;
        return (producedQuantity, consumedQuantity);
    }

    /***
     * @notice - This method is executed for checking prosumer's smart-meter every month.
     **/
    function monthlyCheck(address prosumer, uint timePerMonth) public returns (bool) {
        /// Call the most recent datetime when it was checked before
        uint lastCheckedDatetime = _lastCheckedDatetime[prosumer];

        /// If now is passed more than 1 month compare to last checked datetime, it will be checked payment amount as a amount of the most recent month
        uint timeOfThisMonth = timePerMonth;
        uint checkingTimeForMostRecentMonth = lastCheckedDatetime.add(timeOfThisMonth);
        if (checkingTimeForMostRecentMonth < now) {
            judgeProfitAndLoss(timeOfThisMonth);
        }
    }

    /***
     * @notice - Judge whether user pay consumed amount or get profit or both of no.
     **/
    function judgeProfitOrLoss(address prosumer, uint timeOfThisMonth) public returns (bool) {
        SmartMeterForProduction memory smartMeterForProduction = smartMeterForProductions[prosumer];
        uint producedQuantity = smartMeterForProduction.producedQuantity;

        SmartMeterForConsumption memory smartMeterForConsumption = smartMeterForConsumptions[prosumer]; 
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
    

    






    /////////---------------------- Reference methods below ----------------------/////////
    
    /**
     * @dev The production price for each time slot.
     */
    function getProductionPrice(uint256 _time)
        public
        view
        returns(uint256)
    {
        return uint256(
            max(
                0,
                int256(basePrice) *
                  (3 + safeSub(production[_time], consumption[_time]))
            )
        );
    }
    
    /**
     * @dev The consumption price for each time slot
     */
     function getConsumptionPrice(uint256 _time)
        public
        view
        returns(uint256)
    {
        return uint256(
            max(
                0,
                int256(basePrice) *
                  (3 + safeSub(consumption[_time], production[_time]))
            )
        );
    }
    
    /**
     * @dev - Add one energy unit to the distribution network at the specified time and be paid the production price. 
     *      - Only whitelisted smart meters can call this function.
     */
    function produce(uint256 _time)
        public
    {
        require(isMember(msg.sender), "Unknown meter.");

        /// "this" below is ERC20 Token (Matic Enegy Token / MET)
        /// "time" based pricing
        /// Transfer MET from this contract to user 
        maticEnergyToken.transfer(
            msg.sender,
            getProductionPrice(_time)
        );
        production[_time] = production[_time] + 1;
        emit EnergyProduced(msg.sender, _time);
    }
    
    /**
     * @dev - Take one energy unit from the distribution network at the specified time by paying the consumption price. 
     *      - Only whitelisted smart meters can call this function.
     */
    function consume(uint256 _time)
        public
    {
        require(isMember(msg.sender), "Unknown meter.");

        /// "this" below is ERC20 Token (Matic Enegy Token / MET)
        /// "time" based pricing
        /// Transfer MET from user to this contract 
        maticEnergyToken.transferFrom(
            msg.sender,
            address(this),
            getConsumptionPrice(_time)
        );

        consumption[_time] = consumption[_time] + 1;
        emit EnergyConsumed(msg.sender, _time);
    }
    
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(int256 a, int256 b)
        internal
        pure
        returns(int256)
    {
        return a >= b ? a : b;
    }
    
    /**
     * @dev Substracts b from a using types safely casting from uint128 to int256.
     */
    function safeSub(uint128 a, uint128 b)
        internal
        pure
        returns(int256)
    {
        return int256(a) - int256(b);
    }
    
}
