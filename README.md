# Randomness Solidity

This project is a demonstration of two solutions for the generation of pseudo-random numbers in Solidity.

## Solutions

- [OnChain](/contracts/OnChain.sol): Solution with 2 on chain steps to remove any possibility of taking advantage of the participants.
- [OffChain](/contracts/OffChain) Solution using oracle.

## Mumbai address

- OnChain: [0xf08285fc747c17140ff24b98ab46e58d4dc11fec](https://mumbai.polygonscan.com/address/0xf08285fc747c17140ff24b98ab46e58d4dc11fec)
- OffChain: [0xa48b924a93b1495b90f170ee90234c9b04868846](https://mumbai.polygonscan.com/address/0xa48b924a93b1495b90f170ee90234c9b04868846)

## Tasks

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/sample-script.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
