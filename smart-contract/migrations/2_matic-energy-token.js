var MaticEnergyToken = artifacts.require("MaticEnergyToken");

//const initialSupply = 100000000000000000000000000;  /// Initial Supply amount is 100M

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(MaticEnergyToken);
    //await deployer.deploy(Erc20MockToken, initialSupply);
};
