pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./@hq20/contracts/access/Whitelist.sol";

/// Storage
import "./storage/McStorage.sol";
import "./storage/McEvents.sol";
import "./storage/McConstants.sol";


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

    
}
