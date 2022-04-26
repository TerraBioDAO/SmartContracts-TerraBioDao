// SPDX-License-Identifier: MIT

/// @title Dao contract
/// @author Benmissi-A
/// @notice You can use this contract to create a terrabioDAO
/// @dev ......

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./TerrabioToken.sol";

contract TerrabioDAO {
    using Counters for Counters.Counter;
    using Address for address payable;
    TerrabioToken private _tbio;

    event ProposalCreated(uint256 id, string proposition);
    event ProposalResolved(Status proposalStatus);

    constructor(address terrabioTokenAdress_ ) {
        _tbio = TerrabioToken(terrabioTokenAdress_);
    }

    event Withdrew(address indexed owner, uint256 balance);

    enum Vote {
        Yes,
        No
    }

    enum Status {
        Running,
        Approved,
        Rejected
    }

    struct Proposal {
        Status status;
        address author;
        uint256 createdAt;
        uint256 amountYes;
        uint256 amountNo;
        string proposition;
    }

    uint256 public constant TIME_LIMIT = 5 minutes;

    Counters.Counter private _id;
    mapping(uint256 => Proposal) private _proposals;

    function getCounter() public view returns(uint256){
        uint256 x = _id.current();
        return x;
    }
    function createProposal(string memory proposition) public returns (uint256) {
        uint256 id = _id.current();
        _id.increment();
        _proposals[id] = Proposal({
            status: Status.Running,
            author: msg.sender,
            createdAt: block.timestamp,
            amountYes: 0,
            amountNo: 0,
            proposition: proposition
        });
        emit ProposalCreated(id, _proposals[id].proposition);
        return id;
    }

    function vote(
        uint256 id,
        Vote vote_,
        uint256 amount_
    ) public {
        require(_proposals[id].status == Status.Running, "TerrabioDAO: Not a running proposal");

        if (block.timestamp > _proposals[id].createdAt + TIME_LIMIT) {
            if (_proposals[id].amountYes > _proposals[id].amountNo) {
                _proposals[id].status = Status.Approved;
            } else {
                _proposals[id].status = Status.Rejected;
            }
            emit ProposalResolved(_proposals[id].status);
        } else {
            require(amount_ > 0, "TerrabioDAO: Not a running proposal");
            if (vote_ == Vote.Yes) {
                _proposals[id].amountYes += amount_**18;
            } else {
                _proposals[id].amountNo += amount_**18;
            }
           // _tbio.transferFrom(msg.sender, _tbio.owner(), amount_**18);
        }
    }

    // lockToken 

    function proposalById(uint256 id) public view returns (Proposal memory) {
        return _proposals[id];
    }

    function withdraw() external payable {
        require(msg.sender == _tbio.owner(), "TerrabioDAO: only owner can withdraw");

        uint256 balance = address(this).balance;
        payable(_tbio.owner()).sendValue(balance);
        emit Withdrew(_tbio.owner(), balance);
    }
}
