const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RociERC20 contract", function() {
  const initialAmount = 100;
  let account1, account2, rociERC20, rociNov20, rociOct20;

  beforeEach("create and deploy contracts", async () => {
    account1 = '0xbcd4042de499d14e55001ccbb24a551f3b954096';
    account2 = '0xfabb0ac9d68b0b445fb7357272ff202c5651694a';

    const RociERC20 = await ethers.getContractFactory("RociERC20");
    rociERC20 = await RociERC20.deploy();
  
    await rociERC20.deployed();  

    await rociERC20.approve(account1, initialAmount);
    await rociERC20.approve(account2, initialAmount);

    const RociNov20 = await ethers.getContractFactory("RociNov20");
    rociNov20 = await RociNov20.deploy(rociERC20.address);
    await rociNov20.deployed();

    const RociOct20 = await ethers.getContractFactory("RociOct20");
    rociOct20 = await RociOct20.deploy(rociERC20.address);  
    await rociOct20.deployed();

    await rociERC20.mint(account1, 50, rociNov20.address);
    await rociERC20.mint(account2, 50, rociOct20.address);
  });

  it("Mint is working correctly", async function() { 
    expect(await rociERC20.balanceOf(account1)).to.equal(50);
    expect(await rociERC20.balanceOf(account2)).to.equal(50);
  })

});
