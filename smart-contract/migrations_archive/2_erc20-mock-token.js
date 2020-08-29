var Erc20MockToken = artifacts.require("Erc20MockToken");

//const initialSupply = 100000000000000000000000000;  /// Initial Supply amount is 100M

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(Erc20MockToken);
    //await deployer.deploy(Erc20MockToken, initialSupply);
};
