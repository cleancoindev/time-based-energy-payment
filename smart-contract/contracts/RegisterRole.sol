pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./@hq20/contracts/access/Whitelist.sol";


contract RegisterRole is {
    constructor ()
        public
        Whitelist(msg.sender)  /// Add initial member
    {

    }
}
