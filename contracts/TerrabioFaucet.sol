// SPDX-License-Identifier: MIT

/// @title Faucet contract
/// @author Benmissi-A
/// @notice Claim testNet TBIO
/// @dev ......

pragma solidity ^0.8.7;


import "@openzeppelin/contracts/utils/Address.sol";
import "./TerrabioToken.sol";

contract TerrabioFaucet {
    using Address for address payable;
    TerrabioToken private _tbio;


    event Recieved(address indexed sender, uint256 amount);

    constructor(address tbioAddress_) {
        _tbio = TerrabioToken(tbioAddress_);
    }
    
    function buyTokens() external payable {
        _buyTokens();
    }

    function _buyTokens() private {
        require(_tbio.allowance(_tbio.owner(), address(this)) > 0, "TerrabioFaucet: no more token to buy");
        uint256 tokenValue = 60;

        _tbio.transferFrom(_tbio.owner(), msg.sender, tokenValue);

        emit Recieved(msg.sender, tokenValue);
    }
}
