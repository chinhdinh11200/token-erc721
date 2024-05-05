import { ethers } from "hardhat";
async function main() {
  const [owner, buyer] = await ethers.getSigners();

  const nftAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const tokenAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const marketAddress = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
  const stakeAddress = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";

  const nftContract = await ethers.getContractAt("BekiNFT", nftAddress);
  const tokenContract = await ethers.getContractAt(
    "BekiToken",
    tokenAddress
  );
  const marketContract = await ethers.getContractAt(
    "Marketplace",
    marketAddress
  );
  const stakeContract = await ethers.getContractAt("Stake", stakeAddress);
  const nftSend = [0];
  // await Promise.all(nftSend.map((nftId) => {
  //   return nftContract.connect(buyer).approve(stakeAddress, nftId);
  // }));
  // await stakeContract.connect(buyer).sendTokenStake([0]);
  console.log("stake balance ", await nftContract.balanceOf(stakeAddress));

  await stakeContract.connect(buyer).getStakeValueAndNFT(nftSend);
  console.log("stake balance ", await nftContract.balanceOf(stakeAddress));
  console.log("buyer balance ", await tokenContract.balanceOf(buyer.address));
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
