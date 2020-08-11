pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// Use original Ownable.sol
import "./lib/OwnableOriginal.sol";

// Storage
import "./storage/McStorage.sol";
import "./storage/McEvents.sol";
import "./storage/McConstants.sol";



/***
 * @notice - This contract is that ...
 **/
contract MaticEnergy is OwnableOriginal(msg.sender), McStorage, McEvents, McConstants {
    using SafeMath for uint;

    constructor() public {}

}
