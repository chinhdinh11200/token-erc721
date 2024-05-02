import hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();

  const tokenContract = await hre.ethers.getContractFactory("BekiToken");
  const contract = await tokenContract.deploy(owner.address);
  const address = await contract.getAddress();

  console.log(address);
}

main().then(() => {
  process.exit(0);
}).then((err) => {
  console.log(err);
  process.exit(1);
});
