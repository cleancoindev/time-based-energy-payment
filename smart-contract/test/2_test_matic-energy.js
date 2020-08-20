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
        it('Setup contract for each test', async () => {
            maticEnergy = new web3.eth.Contract(MaticEnergy.abi, MaticEnergy.address);
        });

        it('Some function', async () => {
            //const token = Erc20MockToken.address // ERC20 token address of Erc20MockToken.sol
            // const token = config.GOERLI_ERC20      // ERC20 token address
            // const amount = '1000000000000000000'   // amount in wei

            // await matic.approveERC20TokensForDeposit(token, amount, { from: fromAddress, gasPrice: '10000000000' })

        });

    });

});


