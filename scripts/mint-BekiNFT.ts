import hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const BekiNFTContract = await hre.ethers.getContractFactory("BekiNFT");
  const bekiNFT = await BekiNFTContract.attach('0xC4F0FA518259aB003B1D4D20fbC62D58bA9E9A67');
  const address = await bekiNFT.getAddress();

  await bekiNFT.safeMint(owner.address);

  console.log(address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
