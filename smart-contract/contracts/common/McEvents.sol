pragma solidity ^0.6.12;

import "./McObjects.sol";


contract McEvents is McObjects {
    event EnergyProduced(address producer, uint256 time);
    event EnergyConsumed(address consumer, uint256 time);
}
