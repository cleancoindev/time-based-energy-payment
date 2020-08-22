pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./@hq20/contracts/access/Whitelist.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";

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
    using SafeMath for uint;
    
    uint currentUserId;

    constructor ()
        public
        Whitelist(msg.sender)  /// Add initial member
    {

    }

    function registerAsProducer(address walletAddress) public returns (bool) {
        uint newUserId = getNextUserId();
        currentUserId++;

        User storage user = users[newUserId];
        user.role = Role.Producer;  /// enum
        user.walletAddress = walletAddress;
    }

    function registerAsDistributor() public returns (bool) {}

    function registerAsRetailer() public returns (bool) {}

    function registerAsConsumer() public returns (bool) {}

    
    function getNextUserId() view internal returns (uint nextUserId) {
        return currentUserId.add(1);
    }
    
}
