
/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */

const { expect } = require('chai');
describe('TerrabioFaucet', function () {
  let TerrabioToken, terrabioToken,TerrabioFaucet, terrabioFaucet, dev, owner, alice, bob, eve;
  // const NAME = 'TerrabioToken';
  // const SYMBOL = 'TBIO';
  const INITIAL_SUPPLY = ethers.utils.parseEther('1000000');
  this.beforeEach(async function () {
    [dev, owner, alice, bob, eve] = await ethers.getSigners();
    TerrabioToken = await ethers.getContractFactory('TerrabioToken');
    terrabioToken = await TerrabioToken.connect(dev).deploy(INITIAL_SUPPLY);
    TerrabioFaucet = await ethers.getContractFactory('TerrabioFaucet');
    terrabioFaucet = await TerrabioFaucet.connect(dev).deploy(TerrabioToken.address);
    await terrabioToken.deployed();
    describe('Deployement', function () {
      it('Test deploy ownable event', async function () {
        await expect(terrabioToken.deployTransaction)
          .to.emit(terrabioToken, 'OwnershipTransferred')
          .withArgs(ethers.constants.AddressZero, dev.address);
      })
    });
  });
});
