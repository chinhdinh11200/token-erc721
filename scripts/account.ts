const hre = require("hardhat");

async function main() {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address, account);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
