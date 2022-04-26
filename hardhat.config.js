require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-solhint');
require('hardhat-docgen');
require('hardhat-contract-sizer');

require('dotenv').config();
const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID;
const DEPLOYER_PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY;

module.exports = {
  solidity: {
    version: '0.8.7',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      // workaround from https://github.com/sc-forks/solidity-coverage/issues/652#issuecomment-896330136 .
      // Remove when that issue is closed.
      initialBaseFeePerGas: 0,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
  },
  docgen: {
    path: './docs',
    clear: true,
    runOnCompile: false,
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: true,
  },
};
