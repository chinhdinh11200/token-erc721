import hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const BekiNFTContract = await hre.ethers.getContractFactory("BekiNFT");
  const bekiNFT = await BekiNFTContract.attach('0xC4F0FA518259aB003B1D4D20fbC62D58bA9E9A67');
  const address = await bekiNFT.getAddress();

  const MarketplaceContract = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await MarketplaceContract.attach('0x9340350Af64022Db695ba1CFe28187773261091A');
  const addressMarket = await marketplace.getAddress();

  await bekiNFT.connectToMarket(addressMarket);

  console.log(addressMarket)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
