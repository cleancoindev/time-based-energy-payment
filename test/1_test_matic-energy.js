const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

const MaticEnergy = artifacts.require('MaticEnergy');


contract('MaticEnergy', accounts => {});
