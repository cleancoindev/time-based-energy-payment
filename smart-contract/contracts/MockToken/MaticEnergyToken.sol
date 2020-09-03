pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  /// From @openzeppelin/contract v0.3.x
import "@openzeppelin/contracts/math/SafeMath.sol";


/***
 * @notice - This contract is the Test DAI Tokens (DAI) which is created by ERC20.
 * @dev - Reference from @openzeppelin/contract v0.3.x https://docs.openzeppelin.com/contracts/3.x/erc20
 **/
contract MaticEnergyToken is ERC20 {
    using SafeMath for uint;

    constructor() ERC20("MaticEnergyToken", "MET") public {
        uint256 _initialSupply = 1e20;    /// 100 MET
        //uint256 _initialSupply = 1e20;  /// 100 MET
        uint _decimals = 1e18;            ///   1 MET 
        uint initialSupply = _initialSupply.mul(_decimals);  /// Initial Supply amount is 100M
        
        address initialTokenHolder = msg.sender;
        _mint(initialTokenHolder, initialSupply);
    }

}
