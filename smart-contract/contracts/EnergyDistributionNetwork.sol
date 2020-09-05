pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/// *** Using @openzeppelin/contracts v3.1.0 *** 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";  /// Access control

/// *** Using @hq/contracts v0.0.2 *** 
//import "./@hq20/contracts/access/Whitelist.sol";
//import "@hq20/contracts/contracts/access/Whitelist.sol";

/// Library
import "./lib/OwnableOriginal.sol";
//import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeContract.sol";
import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McModifiers.sol";
import "./common/McConstants.sol";

/// ERC20 token for paying for energy production and consumption
import "./mockToken/MaticEnergyToken.sol";

/// Time based payment formula
import "./TimeBasedPaymentFormula.sol";


/***
 * @notice - This contract is that ...
 * @dev - Implements a simple energy market, using ERC20 and AccessControl. 
 * @dev - ERC20 is used to enable payments from the consumers to the distribution network, represented by this contract, and from the distribution network to the producers. 
 * @dev - Whitelist is used to keep a list of compliant smart meters that communicate the production and consumption of energy.
 **/
contract EnergyDistributionNetwork is TimeBasedPaymentFormula, AccessControl, OwnableOriginal, McStorage, McEvents, McModifiers, McConstants {
    using SafeMath for uint;

    MaticEnergyToken public maticEnergyToken;

    /**
     * @dev - The constructor initializes the underlying currency token and the smart meter whitelist. 
     *      - The constructor also mints the requested amount of the underlying currency token to fund the network load. 
     *      - Also sets the base energy price, used for calculating prices.
     */
    constructor (address _maticEnergyToken, address adminUser)
        public
        TimeBasedPaymentFormula()
        AccessControl()
        OwnableOriginal(msg.sender)
    {
        maticEnergyToken = MaticEnergyToken(_maticEnergyToken);

        //uint256 _initialSupply = 1e20;  /// 100 MET
        //uint128 _basePrice = 1e18;      ///   1 MET (Current energy price = MET/kw)
        //basePrice = _basePrice;

        /// Set up the Admin role
        /// [Note]: Another role is writted in ./common/McConstant.sol
        _setupRole(DEFAULT_ADMIN_ROLE, adminUser);
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

        /// Execute distribution
        uint targetQuantity;
        string memory payer;
        string memory payee;
        uint paymentAmount;
        uint producedQuantity;
        uint consumedQuantity;

        if (timestampOfFirstDayOfNextMonth < now) {
            (payer, payee, paymentAmount, targetQuantity, producedQuantity, consumedQuantity) = judgeProfitOrLoss(prosumer, year, month);
        }

        /// Record a result of this month into the invoice

    }

    /***
     * @notice - Judge whether user pay consumed amount or get profit or both of no.
     **/
    function judgeProfitOrLoss(address prosumer, uint year, uint month) 
        public 
        returns (string memory _payer, 
                 string memory _payee, 
                 uint _paymentAmount, 
                 uint _targetQuantity, 
                 uint _producedQuantity, 
                 uint _consumedQuantity) 
    {
        /// Check that the calling account has the admin role - from AccessControl.sol
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a admin user");        

        SmartMeterForProduction memory smartMeterForProduction = smartMeterForProductions[prosumer][year][month];
        uint producedQuantity = smartMeterForProduction.producedQuantity;

        SmartMeterForConsumption memory smartMeterForConsumption = smartMeterForConsumptions[prosumer][year][month];
        uint consumedQuantity = smartMeterForConsumption.consumedQuantity;

        uint targetQuantity;
        string memory payer;
        string memory payee;
        uint paymentAmount;
        if (producedQuantity > consumedQuantity) {
            /// Identify which is payer/payee.
            payer = "EnergyDistributionNetwork contract";
            payee = "Prosumer";

            /// Distribution from contract (distribution network) to user (producer)
            targetQuantity = producedQuantity.sub(consumedQuantity);   /// In case of this, user get profit
            paymentAmount = distributionAmount(targetQuantity);
            maticEnergyToken.transfer(msg.sender, paymentAmount);

        } else if (producedQuantity < consumedQuantity) {
            /// Identify which is payer/payee.
            payer = "Prosumer";
            payee = "EnergyDistributionNetwork contract";

            /// Distribution from user (consumer) to contract (distribution network)
            targetQuantity = consumedQuantity.sub(producedQuantity);   /// In case of this, user pay for substracted amount
            paymentAmount = distributionAmount(targetQuantity);
            maticEnergyToken.transferFrom(msg.sender, address(this), paymentAmount);

        } else if (producedQuantity == consumedQuantity) {
            /// Identify which is payer/payee.
            payer = "No payer";
            payee = "No payee";            

            /// In case of this, there is no distribution
            targetQuantity = 0;      /// In case of this, user is no pay for any amount and no get profit
            paymentAmount = 0;  /// Result: 0
        }

        return (payer, payee, paymentAmount, targetQuantity, producedQuantity, consumedQuantity);
    }





    /***
     * @notice - The monthly invoice
     **/
    function getMontlyInvoice() public view returns (bool res) {
        UserWithWalletAddress memory userWithWalletAddress = getUserWithWalletAddress(msg.sender);

        /// The way① for checking that the calling account has the prosumer role <-- This is better than the way② below
        require(hasRole(PROSUMER_ROLE, msg.sender), "Caller should be the prosumer role");

        /// The way② for checking that the calling account has the prosumer role
        require (userWithWalletAddress.role == Role.Prosumer, "Caller's role must be prosumer");
        
        /// In progress
    }


    function getUserWithWalletAddress(address walletAddress) public view returns (UserWithWalletAddress memory userWithWalletAddress) {
        UserWithWalletAddress memory userWithWalletAddress = userWithWalletAddresses[walletAddress];
        return userWithWalletAddress;
    }
    
    
    
}
