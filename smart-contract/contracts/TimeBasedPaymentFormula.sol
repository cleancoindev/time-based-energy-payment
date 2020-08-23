pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/math/SafeMath.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McConstants.sol";


/***
 * This contract is that the formula of time based payment
 **/
contract TimeBasedPaymentFormula is Whitelist, McStorage, McEvents, McConstants {
    using SafeMath for uint;
    
    uint currentEnergyPrice;

    constructor () public {
        currentEnergyPrice = 10;       /// [Default]: 10 EMT/kw
        currentEnergyPrice.mul(1e18);  /// multiply decimals
    }

    /***
     * @notice - In the future, the energy price is called via oracle.
     *         - Now, the energy price is defined as a constant
     **/
    function getEnergyPrice() public view returns (uint currentEnergyPrice) {
        return currentEnergyPrice;   /// It is already multiplied decimals
    }


    /***
     * @notice - Calculation of the time based purchase amount which consumer will pay.
     * @param time - time is second       
     **/    
    function purchaseAmount(uint time) public view returns (uint _purchaseAmount) {
        uint energyPrice = getEnergyPrice();
        return energyPrice.mul(time);  /// The purchaseAmount is equal to MET/kw per second * total consumed time (second)
    }
    
    
}
