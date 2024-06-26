import hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const nftAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const tokenAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

  const marketContract = await hre.ethers.getContractFactory("Marketplace");
  const contract = await marketContract.deploy(owner.address, nftAddress, tokenAddress);
  const address = await contract.getAddress();
  contract.setNFTAddress(nftAddress);
  contract.setTokenAddress(tokenAddress);

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
