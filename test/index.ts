/* eslint-disable node/no-missing-import */
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Pig } from "../typechain";

describe("Pseudo RNG", function () {
  let contract: Pig;
  let user: SignerWithAddress;
  this.beforeAll(async () => {
    const ContractFactory = await ethers.getContractFactory("Pig");
    contract = await ContractFactory.deploy();

    await contract.deployed();

    [user] = await ethers.getSigners();
  });
  it("Should request a new mint", async () => {
    const mint = await contract.connect(user).mint({
      value: ethers.utils.parseUnits("0.0001"),
    });
    await mint.wait();
    expect(mint)
      .to.emit(contract, "MintRequested")
      .withArgs(user.address, mint.blockNumber! + 1);
  });

  it("Should proccess a request mint", async () => {
    await ethers.provider.send("evm_mine", []);

    const process = await contract.connect(user).processMintRequests();
    await process.wait();

    expect(process).to.emit(contract, "PigMinted");
    expect(await contract.balanceOf(user.address)).to.be.eq(1);

    const rarity = await contract.getRarity(0);
    console.log(rarity);
  });
});
