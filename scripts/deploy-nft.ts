import hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const nftContract = await hre.ethers.getContractFactory("BekiNFT");
  const contract = await nftContract.deploy(owner.address);
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
