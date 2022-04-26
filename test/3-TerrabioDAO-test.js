/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */

const { expect } = require('chai');
describe('TerrabioDAO', function () {
  let TerrabioToken, terrabioToken, TerrabioDAO, terrabioDAO, dev, owner, alice, bob, eve;
  // const NAME = 'TerrabioToken';
  // const SYMBOL = 'TBIO';
  const INITIAL_SUPPLY = ethers.utils.parseEther('100000000');
  this.beforeEach(async function () {
    [dev, owner, alice, bob, eve] = await ethers.getSigners();
    TerrabioToken = await ethers.getContractFactory('TerrabioToken');
    terrabioToken = await TerrabioToken.connect(dev).deploy(INITIAL_SUPPLY);
    await terrabioToken.deployed();
    TerrabioDAO = await ethers.getContractFactory('TerrabioDAO');
    terrabioDAO = await TerrabioDAO.connect(dev).deploy(terrabioToken.address);
    await terrabioDAO.deployed();
  });
  describe('Deployement', function () {

  });
  describe('Functions', function () {
    describe('createProposal', function () {
      it('Should emit  ProposalCreated', async function () {
        expect(await terrabioDAO.connect(dev).createProposal('A or B'))
          .to.emit(terrabioDAO, 'ProposalCreated')
          .withArgs(0, 'A or B');
      });
    });

    describe('vote', function () {
      //   //todo create event on vote
      //   it('Should return ???', async function () {
      //     await terrabioDAO.connect(dev).createProposal('A or B')
      //     expect(await terrabioDAO.connect(dev).vote(1,Yes,10)).to.equal(10);
      //   });
    });
    describe('proposalById', function () {})
    describe('withdraw', function () {})
  });
});
