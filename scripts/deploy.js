const { ethers, upgrades } = require("hardhat");

async function main() {
  // Deploying GiftCardFactory
  const GiftCardFactory = await ethers.getContractFactory("GiftCardFactory");
  const giftCardFactory = await upgrades.deployProxy(GiftCardFactory, [/* implementation address */]);
  await giftCardFactory.deployed();

  console.log("GiftCardFactory deployed to:", giftCardFactory.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
