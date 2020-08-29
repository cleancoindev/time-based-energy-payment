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
contract TimeBasedPaymentFormula {
    using SafeMath for uint;
    
    uint currentEnergyPrice;

    constructor () public {
        currentEnergyPrice = 10;       /// [Default]: 10 EMT/kw
        currentEnergyPrice.mul(1e18);  /// multiply decimals
    }

    /***
     * @notice - In the future, the energy price is called via oracle.
     *         - Now, the energy price is defined as a constant
     *         - Unit: $/kw
     **/
    function getEnergyPrice() public view returns (uint currentEnergyPrice) {
        return currentEnergyPrice;   /// $/kw (It is already multiplied decimals)
    }

    /***
     * @notice - Calculation of the time based purchase amount which consumer will pay.
     * @param time - time is second       
     **/    
    function purchaseAmount(uint time) public view returns (uint _purchaseAmount) {
        uint energyPrice = getEnergyPrice();  /// $/kw
        return energyPrice.mul(time);         /// The purchaseAmount is equal to MET/kw per second * total consumed time (second)
    }
    
    /***
     * @notice - Calculation of the energy quantity (kw) based distribution amount.
     * @param quantity - the energy quantity (kw)    
     **/       
    function distributionAmount(uint quantity) public view returns (uint _distributionAmount) {
        uint energyPrice = getEnergyPrice();  /// $/kw
        return energyPrice.mul(quantity);     /// $/kw * kw
    }
    
}
