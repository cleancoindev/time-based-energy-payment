/// Config
const config = require('../utils/matic-config.json')

const token = config.GOERLI_ERC20 // ERC20 token address
const amount = '1000000000000000000' // amount in wei

const from = config.FROM_ADDRESS // from address


/// Module
const Matic = require('@maticnetwork/maticjs').default

// Create object of Matic
const matic = new Matic({
    maticProvider: config.MATIC_PROVIDER,
    parentProvider: config.PARENT_PROVIDER,
    rootChain: config.ROOTCHAIN_ADDRESS,
    withdrawManager: config.WITHDRAWMANAGER_ADDRESS,
    depositManager: config.DEPOSITMANAGER_ADDRESS,
    registry: config.REGISTRY,
})

async function executeInit() {
    await matic.initialize()
    matic.setWallet(config.PRIVATE_KEY)
}
executeInit()

async function executeDeposit() {
    //await matic.initialize()
    //matic.setWallet(config.PRIVATE_KEY)

    // Approve Deposit Manager contract to transfer tokens
    await matic.approveERC20TokensForDeposit(token, amount, { from, gasPrice: '10000000000' })
    // Deposit tokens
    return matic.depositERC20ForUser(token, from, amount, { from, gasPrice: '10000000000' })
}
executeDeposit()
