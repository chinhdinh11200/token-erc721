import hre from "hardhat";
const bekiNFTParams = require('./argument/bekiNFT');

async function main() {
  const BekiNFTContract = await hre.ethers.getContractFactory("BekiNFT");
  console.log(bekiNFTParams);
  // const bekiNFT = await BekiNFTContract.deploy(...bekiNFTParams);
  // const address = await bekiNFT.getAddress();

  // console.log(address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
