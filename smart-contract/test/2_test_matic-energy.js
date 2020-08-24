const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

//const matic = require('@maticnetwork/maticjs');

/// Artifact
const EnergyDistributionNetwork = artifacts.require('EnergyDistributionNetwork');
const MaticEnergyToken = artifacts.require("MaticEnergyToken");

/// Global variable
// let maticEnergy;     
// let maticEnergyToken; 

/// Deployer Address (Owner Address) of MaticEnergy.sol => Ganache-CLI accounts[1]
let ownerAddress;   


contract('EnergyDistributionNetwork', accounts => {
    /// Global variable
    let maticEnergy;     
    let maticEnergyToken; 
        
    describe("Testing the basic user flow", () => {
        beforeEach('Setup contract instances', async () => {            
            // Get the contract instance.
            maticEnergy = await EnergyDistributionNetwork.new();
        });

        // it('addMember() in Whitelist.sol', async () => {
        //     ownerAddress = accounts[0];  /// Ganache-CLI accounts[1]
        //     const _member = accounts[1];
        //     let res = await maticEnergy.methods.addMember(_member).send({ from: ownerAddress });
        //     console.log('=== res ===', res);
        // });

        it('getProductionPrice', async () => {
            const _time = 1597967062;  /// Thu, 20 Aug 2020 23:44:22 GMT
            let res = await maticEnergy.getProductionPrice(_time, { from: accounts[0] });
            console.log('=== res ===', res);
        });

    });

});


