import dotenv from "dotenv";
dotenv.config();
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";

const { PRIVATE_KEY, PRIVATE_KEY_BUYER, API_BSCSCAN } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  defaultNetwork: 'marketplace',
  networks: {
    marketplace: {
      url: 'http://127.0.0.1:8545/',
    },
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s2.bnbchain.org:8545",
      // url: "https://endpoints.omniatech.io/v1/bsc/testnet/public",
      chainId: 97,
      gasPrice: 10000000000,
      // accounts: [`0xdade6b2d296d18649268b3434aab6d686d2c6140bf0b167b3bbc8c2a7798dc45`],
      accounts: [`0x${PRIVATE_KEY}`, `0x${PRIVATE_KEY_BUYER}`],
    },
  },
  etherscan: {
    apiKey: {
      bscTestnet: API_BSCSCAN || "M6U7W1BD438WZSKM66BNGSWF9MPQVJ7I8E",
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 2000000,
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    gasPrice: 21,
  },
};

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account);
  }
});

export default config;
