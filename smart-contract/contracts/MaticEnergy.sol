pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/// *** Using @hq/contracts v0.0.2 *** 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./@hq20/contracts/access/Whitelist.sol";
//import "@hq20/contracts/contracts/access/Whitelist.sol";

/// Use original Ownable.sol
import "./lib/OwnableOriginal.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McConstants.sol";

/// ERC20 token for paying for energy production and consumption
import "./mockToken/MaticEnergyToken.sol";


/***
 * @notice - This contract is that ...
 * @dev - Implements a simple energy market, using ERC20 and Whitelist. 
 * @dev - ERC20 is used to enable payments from the consumers to the distribution network, represented by this contract, and from the distribution network to the producers. 
 * @dev - Whitelist is used to keep a list of compliant smart meters that communicate the production and consumption of energy.
 **/
contract MaticEnergy is Whitelist, McStorage, McEvents, McConstants {
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
    constructor (address _maticEnergyToken)
        public
        Whitelist(msg.sender)  /// Add initial member
    {
        maticEnergyToken = MaticEnergyToken(_maticEnergyToken);

        //uint256 _initialSupply = 1e20;  /// 100 MET
        uint128 _basePrice = 1e18;        ///   1 MET (Current energy price = MET/kw)

        basePrice = _basePrice;
    }
    
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
