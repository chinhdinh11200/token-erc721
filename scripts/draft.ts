import hre from 'hardhat';
async function main() {
  const [owner] = await hre.ethers.getSigners();

  const contractFactory = await hre.ethers.getContractFactory('Draft');
  const contract =  await contractFactory.deploy();

  console.log(await contract.getAddress());
  console.log(await contract.connect(owner).msgValue());
  console.log("===========================================");
  console.log(await contract.connect(owner).msgData());
  console.log("===========================================");
  console.log(await contract.connect(owner).processData());
}

main().then(() => {
  process.exit(0);
}).catch((err) => {
  console.log(err);
  process.exit(1);
});
