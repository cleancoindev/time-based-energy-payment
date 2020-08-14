require('dotenv').config();

const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/" + process.env.INFURA_KEY);
const web3 = new Web3(provider);


/// Artifact
const MaticEnergy = artifacts.require('MaticEnergy');

contract('MaticEnergy', accounts => {

    /***
     * @notice - Test Backend wallet
     **/
    describe("Test Backend wallet", () => {
        it('Test Backend wallet', async () => {
            web3.eth.net.isListening()
               .then(() => console.log('web3 is connected'))
               .catch(e => console.log('Wow. Something went wrong'));
            
            const abi=[{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"greet","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getGreeting","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}];
            
            const contract_Address = "0xcbe74e21b070a979b9d6426b11e876d4cb618daf";  /// Rinkeby
            
            const contract = new web3.eth.Contract(abi, contract_Address);
            
            contract.methods.getGreeting().call().then(console.log);
        });

    });

});


