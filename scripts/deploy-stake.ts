import { ethers } from "hardhat";

async function main() {
  const [owner, buyer] = await ethers.getSigners();
  const nftAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const tokenAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const stakeContract = await ethers.getContractFactory("Stake");
  const contract = await stakeContract.deploy(nftAddress, tokenAddress, 1000);
  const address = await contract.getAddress();

  console.log(address);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
