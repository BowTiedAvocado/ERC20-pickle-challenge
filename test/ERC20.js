const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers")
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs")
const { expect } = require("chai")
const { BigNumber } = require("ethers")
const { ethers } = require("hardhat")

describe("ERC20", function () {
  async function deployTokenFixture() {
    const [master, otherAccount] = await ethers.getSigners()
    const Erc20 = await ethers.getContractFactory("ERC20")
    const erc20 = await Erc20.deploy()

    return { master, otherAccount, erc20 }
  }

  describe("Deployment", function () {
    it("Should set the token name as Avocado Coin", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.tokenName()).to.equal("Avocado Coin")
    })
    it("Should set the token symbol as AVO", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.tokenSymbol()).to.equal("AVO")
    })
    it("Should set the token decimals as 6", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.tokenDecimals()).to.equal(6)
    })
    it("Should set the token supply as 420069000000", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.tokenSupply()).to.equal(420069000000)
    })
    it("Should set the token master address as the address of the contract deployer", async function () {
      const { erc20, master } = await loadFixture(deployTokenFixture)

      expect(await erc20.masterAddress()).to.equal(master.address)
    })
    it("Should assign all the token supply to the balance of the master address", async function () {
      const { erc20, master } = await loadFixture(deployTokenFixture)

      expect(await erc20.balances(master.address)).to.equal(
        await erc20.tokenSupply()
      )
    })
  })
  describe("View functions", function () {
    it("Should return the token name", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.name()).to.equal(await erc20.tokenName())
    })
    it("Should return the token symbol", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.symbol()).to.equal(await erc20.tokenSymbol())
    })
    it("Should return the token decimals", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.decimals()).to.equal(await erc20.tokenDecimals())
    })
    it("Should return the token supply", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)

      expect(await erc20.totalSupply()).to.equal(await erc20.tokenSupply())
    })
    it("Should return the token balance of the input address", async function () {
      const { erc20, master, otherAccount } = await loadFixture(
        deployTokenFixture
      )

      expect(await erc20.balanceOf(master.address)).to.equal(
        await erc20.balances(master.address)
      )
      expect(await erc20.balanceOf(otherAccount.address)).to.equal(
        await erc20.balances(otherAccount.address)
      )
    })
    it("Should return the token allowance the spender address has over the owner address balance", async function () {
      const { erc20, master, otherAccount } = await loadFixture(
        deployTokenFixture
      )

      expect(
        await erc20.allowance(master.address, otherAccount.address)
      ).to.equal(await erc20.allowances(master.address, otherAccount.address))
    })
  })
  describe("transfer", function () {
    it("Should revert if the sender address' token balance is insufficient", async function () {
      const { erc20, master, otherAccount } = await loadFixture(
        deployTokenFixture
      )
      await expect(
        erc20.connect(otherAccount).transfer(master.address, 100)
      ).to.be.revertedWith("Insufficient token balance")
    })
    it("Should revert if the sender tries to send tokens to the zero address", async function () {
      const { erc20 } = await loadFixture(deployTokenFixture)
      await expect(
        erc20.transfer(ethers.constants.AddressZero, 100)
      ).to.be.revertedWith("Can't transfer tokens to the zero address")
    })
    it("Should change the token balances of the sender address and reciever address accordingly", async function () {
      const { erc20, master, otherAccount } = await loadFixture(
        deployTokenFixture
      )
      expect(
        await erc20.transfer(otherAccount.address, 200)
      ).to.changeTokenBalances(erc20, [master, otherAccount], [-200, 200])
    })
  })
})
