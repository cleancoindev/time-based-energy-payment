var EnergyDistributionNetwork = artifacts.require("EnergyDistributionNetwork");
var MaticEnergyToken = artifacts.require("MaticEnergyToken");

//@dev - Import from exported file
var contractAddressList = require('./contractAddress/contractAddress.js');
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var walletAddressList = require('./walletAddress/walletAddress.js');

//const _initialSupply = 50000000000000000000
//const _basePrice = 3000000000000000

const _maticEnergyToken = MaticEnergyToken.address;
const _initialMember = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1";  /// Ganache-CLI -d accounts[1]


module.exports = async function(deployer, network, accounts) {
    // Initialize owner address if you want to transfer ownership of contract to some other address
    let ownerAddress = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1";  /// Ganache-CLI -d accounts[1]

    //await deployer.deploy(EnergyDistributionNetwork)
    await deployer.deploy(EnergyDistributionNetwork, _maticEnergyToken, _initialMember)
                  .then(async function(maticEnergy) {
                      if(ownerAddress && ownerAddress!="") {
                          console.log(`=== Transfering ownership to address ${ownerAddress} ===`)
                          await maticEnergy.transferOwnership(ownerAddress);
                      }
                  }
    );

    //@dev - Transfer 2.1 DAI from deployer's address to contract address in advance
    // const noLossFundraising = await NoLossFundraising.deployed();
    // const iERC20 = await IERC20.at(daiAddress);
    // await iERC20.transfer(noLossFundraising.address, depositedAmount);
};
