pragma solidity ^0.6.12;

// Library
import "../lib/EthAddressLib.sol";


/// @title Shared constants
contract McConstants {

    /***
     * @notice - Define each roles for access control
     *         - by using "@openzeppelin/contracts/access/AccessControl.sol";
     **/
    bytes32 public constant PRODUCER_ROLE = keccak256("PRODUCER");
    bytes32 public constant DISTRIBUTOR_ROLE = keccak256("DISTRIBUTOR_ROLE");
    bytes32 public constant RETAILER_ROLE = keccak256("RETAILER_ROLE");
    bytes32 public constant CONSUMER_ROLE = keccak256("CONSUMER_ROLE");    



    /**
     * @notice Eth address
     */
    address ethAddress = EthAddressLib.ethAddress();



    /**
     * @notice In Exp terms, 1e18 is 1, or 100%
     */
    uint256 constant hundredPercent = 1e18;

    /**
     * @notice In Exp terms, 1e16 is 0.01, or 1%
     */
    uint256 constant onePercent = 1e16;

    bool constant CONFIRMED = true;

    uint8 constant EXAMPLE_VALUE = 1;

}
