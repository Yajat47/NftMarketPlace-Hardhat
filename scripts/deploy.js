// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const MarketContractFactory = await hre.ethers.getContractFactory("MarketContract");
  const Market = await MarketContractFactory.deploy();
  await Market.deployed();

  console.log("NFT MarketPlace Contract Deployed to: " ,Market.address);
  console.log("NFT MarketPlace Owner Address :" , owner.address);
}

//NFT MarketPlace Contract Deployed to:  0xFDD8eBd6C370bD398ad4477C585Cf68401A43b52
//NFT MarketPlace Owner Address : 0x34d6e9559820c6Bb6523E969420a737bBdfFCAD5

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
