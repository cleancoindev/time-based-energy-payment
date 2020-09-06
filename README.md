# Time based energy payment ⚡️

***
## 【Introduction of the time based energy payment ⚡️】
- This is the smart-contract for realizing the time based energy payment.
- Payment: using the Matic Network of layer 2 solution for avoiding expensive gas fee when payment tokens (ERC20) are transferred.
  - Matic Energy Token (ERC20. Symbol: MET) is used as a payment token.

<br>

- Stack
  - Solidity-v0.6.12
  - @openzeppelin/contracts-v3.1.0 


&nbsp;

## 【User Flow】
① User register as a `"prosumer"` (Both of producer and consumer)
② Measured values of the smart-meter are measured at the end of every month by instruction of smart-contract.
  (measured smart-meter are both that from production and from consumption)
③ Measured values from production and measured value from consumption are compared.
④ Transfer  
・If the measured value from production is greater than measured value from consumption, the smart-contract transfer payment tokens into the prosumer's wallet.
・If the measured value from consumption is greater than measured value from production, the prosumer transfer payment tokens into the smart-contract.
⑤ Invoices of monthly result are sent to each prosumers. (at the end of every month)

&nbsp;

***

## 【Setup】
### Setup smart-contract
- Compile
```
cd smart-contract

ganache-cli -d

npm run compile: local
```


### Setup backend

&nbsp;

### Setup frontend


&nbsp;


***

## 【References】
- Matic (Document)
  - Getting started  
    https://docs.matic.network/docs/develop/maticjs/getting-started

<br>

- @openzeppelin/contract
  - Doc (From @openzeppelin/contract v0.3.x)  
https://docs.openzeppelin.com/contracts/3.x/erc20  
  
  - Access Control
    - Doc for Access Control.sol  
      https://docs.openzeppelin.com/contracts/3.x/access-control  
    - How to Use OpenZeppelin’s New AccessControl Contract  
https://medium.com/better-programming/how-to-use-openzeppelins-new-accesscontrol-contract-5b49a4bcd160

<br>

- Article of energy market
  - How to Build an Energy Market on a Blockchain  
https://medium.com/coinmonks/how-to-build-an-energy-market-on-a-blockchain-c43b0cfc2d12?source=linkShare-8b51f748f36a-1595734355&_branch_match_id=716987589328688022
