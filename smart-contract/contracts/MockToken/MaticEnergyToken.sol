pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  /// From @openzeppelin/contract v0.3.x
import "@openzeppelin/contracts/math/SafeMath.sol";

/// Access control
import "@openzeppelin/contracts/access/AccessControl.sol";


/***
 * @notice - This contract is the Test DAI Tokens (DAI) which is created by ERC20.
 * @dev - Reference from @openzeppelin/contract v0.3.x https://docs.openzeppelin.com/contracts/3.x/erc20
 **/
contract MaticEnergyToken is ERC20, AccessControl {
    using SafeMath for uint;

    constructor() ERC20("MaticEnergyToken", "MET") AccessControl() public {
        uint256 _initialSupply = 1e20;    /// 100 MET
        //uint256 _initialSupply = 1e20;  /// 100 MET
        uint _decimals = 1e18;            ///   1 MET 
        uint initialSupply = _initialSupply.mul(_decimals);  /// Initial Supply amount is 100M
        
        address initialTokenHolder = msg.sender;
        _mint(initialTokenHolder, initialSupply);

        /// Set Role
        address MINTER_ROLE = msg.sender;
    }

    function mint(address to, uint256 mintAmount) public {
        // Check that the calling account has the minter role
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }

}
