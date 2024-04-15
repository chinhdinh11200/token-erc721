import hre from "hardhat";
import { config } from 'dotenv';

config();

async function main() {
  const defaultAddressOwner = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
  const [owner, buyer, seller] = await hre.ethers.getSigners();
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

  const addressSeller = seller.address;
  const addressBuyer = buyer.address;
  await bekiNFT.safeMint(addressSeller);
  await bekiNFT.sellNFT(0, 1, 0);
  await bekiNFT.safeMint(addressSeller);
  await bekiNFT.sellNFT(0, 2, 0);
  await bekiToken.mint(addressBuyer, 10000);

  console.log('------------------BEFORE SELL------------------');
  console.log('SELLER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressSeller));
  console.log('SELLER NFT BALANCE : ' + await bekiNFT.balanceOf(addressSeller));
  console.log('BUYER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressBuyer));
  console.log('BUYER NFT BALANCE : ' + await bekiNFT.balanceOf(addressBuyer));

  await marketplace.connect(buyer).buyBekiNFT(0);
  console.log(await marketplace.findToken(0));

  console.log('------------------AFTER SELL------------------');
  console.log('SELLER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressSeller));
  console.log('SELLER NFT BALANCE : ' + await bekiNFT.balanceOf(addressSeller));
  console.log('BUYER TOKEN BALANCE : ' + await bekiToken.balanceOf(addressBuyer));
  console.log('BUYER NFT BALANCE : ' + await bekiNFT.balanceOf(addressBuyer));


  console.log("ALL TOKEN : ", await marketplace.getAllToken());
  console.log(`TOKEN BUYER BY ADDRESS : ${addressBuyer} : `, await marketplace.connect(buyer).getTokenBoughtByAddress());
  console.log(addressNFT)
  console.log(addressToken)
  console.log(addressMarketplace)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
