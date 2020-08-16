var MaticEnergy = artifacts.require("MaticEnergy");
var IERC20 = artifacts.require("IERC20");

//@dev - Import from exported file
var contractAddressList = require('./contractAddress/contractAddress.js');
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var walletAddressList = require('./walletAddress/walletAddress.js');

const _initialSupply = 50000000000000000 
const _basePrice = 30000000000000


module.exports = async function(deployer, network, accounts) {
    // Initialize owner address if you want to transfer ownership of contract to some other address
    let ownerAddress = walletAddressList["WalletAddress1"];

    await deployer.deploy(MaticEnergy, _initialSupply, _basePrice)
    //               .then(async function(maticEnergy) {
    //                   if(ownerAddress && ownerAddress!="") {
    //                       console.log(`=== Transfering ownership to address ${ownerAddress} ===`)
    //                       await maticEnergy.transferOwnership(ownerAddress);
    //                   }
    //               }
    // );

    //@dev - Transfer 2.1 DAI from deployer's address to contract address in advance
    // const noLossFundraising = await NoLossFundraising.deployed();
    // const iERC20 = await IERC20.at(daiAddress);
    // await iERC20.transfer(noLossFundraising.address, depositedAmount);
};
