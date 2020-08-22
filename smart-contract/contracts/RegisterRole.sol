pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./@hq20/contracts/access/Whitelist.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McConstants.sol";


/***
 * Setup 4 actors in this scenario:
   - Producers
   - Distributors
   - Retailers
   - Consumers
 **/
contract RegisterRole is Whitelist, McStorage, McEvents, McConstants {
    
    constructor ()
        public
        Whitelist(msg.sender)  /// Add initial member
    {

    }

    function registerAsProducer() public returns (bool) {}

    function registerAsDistributor() public returns (bool) {}

    function registerAsRetailer() public returns (bool) {}

    function registerAsConsumer() public returns (bool) {}

    
}
