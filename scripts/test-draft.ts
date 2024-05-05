import { ethers } from "hardhat";

async function main() {
  const address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const contract = await ethers.getContractAt("Draft", address);
  // await contract.setStartTime();
  console.log(await contract.startTime(), await contract.elapsedSeconds());
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
