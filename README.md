## Build Setup

#### Make sure you have Ethereum client running in local or remote, and have enough eth in the account

### Install Truffle:
```bash
npm install -g truffle
```

#### Install dependencies
```bash
npm install
```

### Run Token Distribution
#### Compile contracts
```bash
truffle compile
```
#### Migrate(deploy) contracts
```bash
truffle migrate --network {network_alias}
```
#### Run scripts
```bash
npm run start (transfer ownerships etc..)
npm run normal
npm run vesting
npm run transferBackOwnerships
npm run finalize
...
```

Make sure you have at least 4 accounts in your Ethereum node and set password in .env (for test only)

#### Compile contracts
```bash
truffle compile
```
#### Run migration
```bash
rm -rf build
truffle migrate --reset --network {network_alias}
```
#### Run test scripts one by one. Make sure removing ./build holder for each test suite
```bash
rm -rf build
truffle test --network {network_alias} test/distribution.js
```