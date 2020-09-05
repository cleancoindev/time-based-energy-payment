pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/// *** Using @openzeppelin/contracts v3.1.0 *** 
import "@openzeppelin/contracts/math/SafeMath.sol";

/// Access control
import "@openzeppelin/contracts/access/AccessControl.sol";

/// Storage
import "./common/McStorage.sol";
import "./common/McEvents.sol";
import "./common/McModifiers.sol";
import "./common/McConstants.sol";


/***
 * Setup 4 actors in this scenario:
   - Producers
   - Distributors
   - Retailers
   - Consumers
 **/
contract RegisterRole is AccessControl, McStorage, McEvents, McModifiers, McConstants {
    using SafeMath for uint;
    
    uint currentUserId;

    constructor () public AccessControl() McModifiers() {
        /// [Note]: "DEFAULT_ADMIN_ROLE" is deployer address of EnergyDistributionNetwork.sol
        /// [Note]: Another role is writted in ./common/McConstant.sol
    }

    function registerAsProsumer(address walletAddress) public returns (bool) {
        uint newUserId = getNextUserId();
        currentUserId++;

        User storage user = users[newUserId];
        user.userId = newUserId;
        user.role = Role.Prosumer;  /// enum
        user.walletAddress = walletAddress;  

        UserWithWalletAddress storage userWithWalletAddress = userWithWalletAddresses[walletAddress];          
        userWithWalletAddress.userId = newUserId;
        userWithWalletAddress.role = Role.Prosumer;  /// enum
        userWithWalletAddress.walletAddress = walletAddress;  

        /// Set up the Producer role
        /// [Note]: Producer role is writted in ./common/McConstant.sol
        _setupRole(PROSUMER_ROLE, user.walletAddress);        
    }

    function registerAsDistributor(address walletAddress) public returns (bool) {
        uint newUserId = getNextUserId();
        currentUserId++;

        User storage user = users[newUserId];
        user.userId = newUserId;
        user.role = Role.Distributor;  /// enum
        user.walletAddress = walletAddress;

        /// Set up the Distributor role
        /// [Note]: Distributor role is writted in ./common/McConstant.sol
        _setupRole(DISTRIBUTOR_ROLE, user.walletAddress);
    }

    function registerAsRetailer(address walletAddress) public returns (bool) {
        uint newUserId = getNextUserId();
        currentUserId++;

        User storage user = users[newUserId];
        user.userId = newUserId;
        user.role = Role.Retailer;  /// enum
        user.walletAddress = walletAddress;        

        /// Set up the Retailer role
        /// [Note]: Retailer role is writted in ./common/McConstant.sol
        _setupRole(RETAILER_ROLE, user.walletAddress);
    }

    // function registerAsProducer(address walletAddress) public returns (bool) {
    //     uint newUserId = getNextUserId();
    //     currentUserId++;

    //     User storage user = users[newUserId];
    //     user.userId = newUserId;
    //     user.role = Role.Producer;  /// enum
    //     user.walletAddress = walletAddress;  

    //     UserWithWalletAddress storage userWithWalletAddress = userWithWalletAddresses[walletAddress];          
    //     userWithWalletAddress.userId = newUserId;
    //     userWithWalletAddress.role = Role.Producer;  /// enum
    //     userWithWalletAddress.walletAddress = walletAddress;  

    //     /// Set up the Producer role
    //     /// [Note]: Producer role is writted in ./common/McConstant.sol
    //     _setupRole(PRODUCER_ROLE, user.walletAddress);        
    // }

    // function registerAsConsumer(address walletAddress) public returns (bool) {
    //     uint newUserId = getNextUserId();
    //     currentUserId++;

    //     User storage user = users[newUserId];
    //     user.userId = newUserId;
    //     user.role = Role.Retailer;  /// enum
    //     user.walletAddress = walletAddress;

    //     /// Set up the Consumer role
    //     /// [Note]: Consumer role is writted in ./common/McConstant.sol
    //     _setupRole(CONSUMER_ROLE, user.walletAddress);
    // }

    
    function getNextUserId() internal view returns (uint nextUserId) {
        return currentUserId.add(1);
    }
    
}
