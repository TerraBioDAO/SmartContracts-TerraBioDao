/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */

const { expect } = require('chai');

describe('TerrabioToken', function () {
  let TerrabioToken, terrabioToken, dev, owner, alice, bob, eve;
  // const NAME = 'TerrabioToken';
  // const SYMBOL = 'TBIO';
  const INITIAL_SUPPLY = ethers.utils.parseEther('1000000');
  this.beforeEach(async function () {
    [dev, owner, alice, bob, eve] = await ethers.getSigners();
    TerrabioToken = await ethers.getContractFactory('TerrabioToken');
    terrabioToken = await TerrabioToken.connect(dev).deploy(INITIAL_SUPPLY);
    await terrabioToken.deployed();
  });
  describe('Deployement', function () {
    it('Test deploy ownable event', async function () {
      await expect(terrabioToken.deployTransaction)
        .to.emit(terrabioToken, 'OwnershipTransferred')
        .withArgs(ethers.constants.AddressZero, dev.address);
    });
  });
  describe('Functions', function () {
    describe('owner', function () {
      it('Should return owner', async function () {
        expect(await terrabioToken.owner()).to.equal(dev.address);
      });
    });
    describe('totalSupply', function () {
      it('Should return totalSupply', async function () {
        expect(await terrabioToken.totalSupply()).to.equal(ethers.utils.parseEther('1000000'));
      });
    });
    describe('balanceOf', function () {
      it('Should return balance of owner', async function () {
        expect(await terrabioToken.connect(dev).balanceOf(dev.address)).to.equal(ethers.utils.parseEther('1000000'));
      });
    });
  });
});
