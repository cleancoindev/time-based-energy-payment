const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

//const matic = require('@maticnetwork/maticjs');

/// Artifact
const MaticEnergy = artifacts.require('MaticEnergy');
const Erc20MockToken = require("../build/contracts/Erc20MockToken.json");
let erc20MockToken;  /// Global

/// Module
const Matic = require('@maticnetwork/maticjs').default
let matic;  /// Global variable
let fromAddress;

/// Config
const config = require('../utils/matic-config.json')

contract('MaticEnergy', accounts => {

    /***
     * @notice - Testing the basic user flow
     *         - Ref: https://docs.matic.network/docs/develop/maticjs/getting-started 
     **/
    describe("Testing the basic user flow", () => {

        it('Create a instance of Erc20MockToken.sol', async () => {
            const abi = Erc20MockToken.abi;
            const _erc20MockToken = Erc20MockToken.address;  /// Local
            erc20MockToken = await web3.eth.Contract(abi, _erc20MockToken);
        }        

        it('Check balance of accounts[0] who has initialSupply of Erc20MockToken.sol', async () => {
            let balance = await erc20MockToken.methods.balanceOf(accounts[0]).call();
            console.log("== balance ===", balance);
        }

        it('Setup contract for each test', async () => {
            fromAddress = config.FROM_ADDRESS // from address

            // Create object of Matic (assigned as a global variable)
            matic = new Matic({
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
            execute()
        });

        it('Deposit (Ethereum → Matic)', async () => {
            const token = Erc20MockToken.address // ERC20 token address of Erc20MockToken.sol
            //const token = config.GOERLI_ERC20  // ERC20 token address
            const amount = '1000000000000000000' // amount in wei

            async function execute() {               
                // Approve Deposit Manager contract to transfer tokens
                await matic.approveERC20TokensForDeposit(token, amount, { from: fromAddress, gasPrice: '10000000000' })

                // Deposit tokens
                return matic.depositERC20ForUser(token, fromAddress, amount, { from: fromAddress, gasPrice: '10000000000' })
            }
            execute()
        });

        it('Transfer (Matic ↔ Matic)', async () => {
            const recipient = accounts[1]      /// 'recepient-address'
            const token = Erc20MockToken.address // ERC20 token address of Erc20MockToken.sol
            //const token = config.GOERLI_ERC20  /// <--Need to have Goerli ETH in this wallet address
            //const token = config.MUMBAI_WETH
            console.log("== recipient ===", recipient);
            console.log("== token ===", token);

            const amount = '1000000000000000000' // amount in wei

            /// Transfer ERC20 Tokens
            let res = await matic.transferERC20Tokens(token, recipient, amount, { from: fromAddress })
            console.log("== hash ===", res.transactionHash);
        });

    });

});


