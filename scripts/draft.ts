import hre from 'hardhat';
async function main() {
  const [owner] = await hre.ethers.getSigners();

  const contractFactory = await hre.ethers.getContractFactory('Draft');
  const contract =  await contractFactory.deploy();

  console.log(await contract.getAddress());
}

main().then(() => {
  process.exit(0);
}).catch((err) => {
  console.log(err);
  process.exit(1);
});
