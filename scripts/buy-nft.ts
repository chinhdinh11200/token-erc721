import hre from "hardhat";
import { config } from 'dotenv';

config();

async function main() {
  const defaultAddressOwner = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
  const seller = await hre.ethers.getSigner('0x737DcAc2c2b401145698DeBdA998867AB9BB6c29');
  const buyer = await hre.ethers.getSigner('0x24074804ef8700B7A291846F91d14E55aA200899');
  const bekiNFTContract = await hre.ethers.getContractFactory("BekiNFT");
  const bekiTokenContract = await hre.ethers.getContractFactory("BekiToken");
  const marketplaceContract = await hre.ethers.getContractFactory("Marketplace");

  const bekiNFT = bekiNFTContract.attach('0xC4F0FA518259aB003B1D4D20fbC62D58bA9E9A67');
  const addressNFT = await bekiNFT.getAddress();
  
  const bekiToken = bekiTokenContract.attach('0x7eE55F6D448dDc564153cdd59f90911A71E75b40');
  const addressToken = await bekiToken.getAddress();
  
  const marketplace = marketplaceContract.attach('0x9340350Af64022Db695ba1CFe28187773261091A');
  const addressMarketplace = await marketplace.getAddress();

  const addressSeller = seller.address;
  const addressBuyer = buyer.address;
  await bekiNFT.sellNFT(1, 1, 0);

  console.log('------------------BEFORE SELL------------------');
  console.log('SELLER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressSeller));
  console.log('SELLER NFT BALANCE : ' + await bekiNFT.balanceOf(addressSeller));
  console.log('BUYER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressBuyer));
  console.log('BUYER NFT BALANCE : ' + await bekiNFT.balanceOf(addressBuyer));

  await marketplace.connect(buyer).buyBekiNFT(1);

  console.log('------------------AFTER SELL------------------');
  console.log('SELLER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressSeller));
  console.log('SELLER NFT BALANCE : ' + await bekiNFT.balanceOf(addressSeller));
  console.log('BUYER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressBuyer));
  console.log('BUYER NFT BALANCE : ' + await bekiNFT.balanceOf(addressBuyer));
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
