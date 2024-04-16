import hre from "hardhat";
import { config } from 'dotenv';

config();

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const bekiNFTContract = await hre.ethers.getContractFactory("BekiNFT");
  const bekiTokenContract = await hre.ethers.getContractFactory("BekiToken");
  const marketplaceContract = await hre.ethers.getContractFactory("Marketplace");
  const bekiNFT = await bekiNFTContract.deploy(owner.address);
  const addressNFT = await bekiNFT.getAddress();
  const bekiToken = await bekiTokenContract.deploy(owner.address);
  const addressToken = await bekiToken.getAddress();
  const marketplace = await marketplaceContract.deploy(addressNFT, addressToken);
  const addressMarketplace = await marketplace.getAddress();
  await bekiNFT.connectToMarket(addressMarketplace);
  
  console.log('NFT ADDR: ' ,addressNFT)
  console.log('TOKEN ADDR: ', addressToken)
  console.log('MARKET ADDR: ', addressMarketplace)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
