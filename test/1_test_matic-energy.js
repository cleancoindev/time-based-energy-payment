const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

/// Artifact
const MaticEnergy = artifacts.require('MaticEnergy');

/// Module
const Matic = require('@maticnetwork/maticjs').default
//const config = require('../utils/matic-config.json')

contract('MaticEnergy', accounts => {

    /***
     * @notice - Setup
     **/
    describe("Setup", () => {
        it('Setup contract for each test', async () => {
            const from = config.FROM_ADDRESS // from address

            // Create object of Matic
            const matic = new Matic({
                maticProvider: config.MATIC_PROVIDER,
                parentProvider: config.PARENT_PROVIDER,
                rootChain: config.ROOTCHAIN_ADDRESS,
                withdrawManager: config.WITHDRAWMANAGER_ADDRESS,
                depositManager: config.DEPOSITMANAGER_ADDRESS,
                registry: config.REGISTRY,
            })

            async function execute() {
                await matic.initialize()
                matic.setWallet(config.PRIVATE_KEY)
            }
        });

    });

});


