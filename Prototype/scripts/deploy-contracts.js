// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { BigNumber } = require("@ethersproject/bignumber");
const hh = require("hardhat");

const SPONSOR_ADDRESS = '0xFe2de4c96C992136eadcF2EdaDF74a091fA4267C';

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  await hh.run('compile');
  
  const RociERC20 = await hh.ethers.getContractFactory("RociERC20");
  const rociERC20 = await RociERC20.deploy();

  await rociERC20.deployed();   

  const account1 = '0xdd2fd4581271e230360230f9337d5c0430bf44c0';
  const account2 = '0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199';

  await rociERC20.approve(account1, 100);
  await rociERC20.approve(account2, 100);

  const RociNov20 = await hh.ethers.getContractFactory("RociNov20");
  const rociNov20 = await RociNov20.deploy(rociERC20.address);
  await rociNov20.deployed();

  const RociOct20 = await hh.ethers.getContractFactory("RociOct20");
  const rociOct20 = await RociOct20.deploy(rociERC20.address);
  await rociOct20.deployed();

  await rociERC20.addContract(rociNov20.address);
  await rociERC20.addContract(rociOct20.address);

  await rociNov20.mint(account1, 50);
  await rociOct20.mint(account2, 50);

  console.log("RociERC20:", rociERC20.address,
    "\nRociNov20:", rociNov20.address,
    "\nRociOct20:", rociOct20.address);

  console.log(await rociERC20.balanceOf(account1));
  console.log(await rociERC20.balanceOf(account2));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
