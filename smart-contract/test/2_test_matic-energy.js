const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

//const matic = require('@maticnetwork/maticjs');

/// Artifact
const MaticEnergy = artifacts.require('MaticEnergy');
const Erc20MockToken = require("../build/contracts/Erc20MockToken.json");

/// Global variable
let maticEnergy;     
let erc20MockToken; 


contract('MaticEnergy', accounts => {
    describe("Testing the basic user flow", () => {
        before('Setup contract instances', async () => {
            // Get the contract instance.
            const deployedNetwork = null;
            const networkId = await web3.eth.net.getId();
            if (MaticEnergy.networks) {
                deployedNetwork = MaticEnergy.networks[networkId.toString()];
                if (deployedNetwork) {
                    maticEnergy = new web3.eth.Contract(
                        MaticEnergy.abi,
                        deployedNetwork && deployedNetwork.address,
                    );
                    console.log('=== maticEnergy ===', maticEnergy);
                }
            }        
        });

        it('getProductionPrice', async () => {
            const _time = 1597967062;  /// Thu, 20 Aug 2020 23:44:22 GMT
            let res = await maticEnergy.methods.getProductionPrice(_time).call();
            console.log('=== res ===', res);
        });

    });

});


