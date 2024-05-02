import hre from "hardhat";

async function main() {
  const nftAddress = "0xa5c18EaBd9DCb96A20b004360793F4415e41d63d"; // "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const tokenAddress = "0x0273AbB81E0dc3BbD4e69Ed89C4Fc6ce488986E3"; // "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const marketAddress = "0x6f14F89AB6745F7088Bc6F34864CeDC12A743603"; // "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
  const [owner, buyer] = await hre.ethers.getSigners();

  const nftContract = await hre.ethers.getContractAt("BekiNFT", nftAddress);
  const tokenContract = await hre.ethers.getContractAt(
    "BekiToken",
    tokenAddress
  );
  const marketContract = await hre.ethers.getContractAt(
    "Marketplace",
    marketAddress
  );
  await nftContract.safeMint("http://127.0.0.1:8545", 1, marketAddress);
  await nftContract.safeMint("http://127.0.0.1:8545", 2, marketAddress);
  await nftContract.safeMint("http://127.0.0.1:8545", 3, marketAddress);
  await nftContract.setTokenTier(0, 2); // đổi giá token từ tier 1 sang tier 2
  await nftContract.setTokenDiscount(0, 1500); // discount 15%

  await tokenContract.mint(buyer, 10000);

  const priceToken0 = await nftContract.getTokenPrice(0);
  const priceToken1 = await nftContract.getTokenPrice(1);
  console.log("token balance market before sell : ", await nftContract.balanceOf(marketAddress));
  console.log("token balance buyer before buy : ", await tokenContract.balanceOf(buyer.address));

  await tokenContract.apporveForMaketplace(buyer.address, marketAddress, priceToken0);
  await marketContract.connect(buyer).buyBekiNFT(0);
  
  await tokenContract.apporveForMaketplace(buyer.address, marketAddress, priceToken1);
  await marketContract.connect(buyer).buyBekiNFT(1);

  console.log('----------------------------------------------');
  console.log("nft balance market : ", await nftContract.balanceOf(marketAddress));
  console.log("token balance market : ", await tokenContract.balanceOf(marketAddress));
  console.log("nft balance buyer : ", await nftContract.balanceOf(buyer.address));
  console.log("token balance buyer : ", await tokenContract.balanceOf(buyer.address));
  console.log("buyer paid : ", await marketContract.connect(buyer).getPriceBoughtOfAddress());
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
