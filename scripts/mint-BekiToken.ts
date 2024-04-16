import hre from "hardhat";

async function main() {
  const buyer = await hre.ethers.getSigner('0x24074804ef8700B7A291846F91d14E55aA200899');
  const BekiTokenContract = await hre.ethers.getContractFactory("BekiToken");
  const bekiToken = await BekiTokenContract.attach('0x7eE55F6D448dDc564153cdd59f90911A71E75b40');
  const address = await bekiToken.getAddress();

  await bekiToken.mint(buyer.address, 1000000);

  console.log(address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
