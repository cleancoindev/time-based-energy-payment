pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  /// From @openzeppelin/contract v0.3.x


/***
 * @notice - This contract is the Test DAI Tokens (DAI) which is created by ERC20.
 * @dev - Reference from @openzeppelin/contract v0.3.x https://docs.openzeppelin.com/contracts/3.x/erc20
 **/
contract Erc20MockToken is ERC20 {

    constructor() ERC20("Erc20MockToken", "EMT", 18) public {
        uint initialSupply = 1e8.mul(1e18);  /// Initial Supply amount is 100M
        address initialTokenHolder = msg.sender;
        _mint(initialTokenHolder, initialSupply);
    }
    
    function mintTo(address to, uint mintAmount) public returns (bool) {
        _mint(to, mintAmount);
    }

    function _balanceOf(address _account) public view returns (uint HodlngToken_balance) {
        return balanceOf(_account);
    }

}
