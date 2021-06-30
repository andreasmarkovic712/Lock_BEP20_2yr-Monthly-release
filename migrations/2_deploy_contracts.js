const Local2Token = artifacts.require('Local2Token');
const Local2TokenDistribution = artifacts.require('Local2TokenDistribution');
const VestingVault = artifacts.require('VestingVault');
const Web3 = require('web3');

module.exports = function (deployer, network) {
    if (network === 'remote') {
        const provider = new Web3.providers.HttpProvider(
            "https://" + process.env.GETH_REMOTE_URL,
            5000,
            process.env.GETH_USER,
            process.env.GETH_PASSWORD
        );

        const web3 = new Web3(provider);
        web3.personal.unlockAccount(web3.eth.accounts[0], process.env.PASSWORD);
    } else if (network === 'local') {
        const provider = new Web3.providers.HttpProvider("http://localhost:8545");
        const web3 = new Web3(provider);
        web3.personal.unlockAccount(web3.eth.accounts[0], process.env.PASSWORD);
    }

    deployer.deploy(Local2Token).then(() => {
        console.log('--------------------------------------------------------');
        console.log('[Local2Token] contract deployed: ', Local2Token.address);
        return deployer.deploy(VestingVault, Local2Token.address).then(() => {
            console.log('--------------------------------------------------------');
            console.log('[VestingVault] contract deployed: ', Local2Token.address);
            return deployer.deploy(Local2TokenDistribution, Local2Token.address, VestingVault.address).then(() => {
                console.log('--------------------------------------------------------');
                console.log('[Local2TokenDistribution] contract deployed: ', Local2TokenDistribution.address);
            });
        });
    });
};
