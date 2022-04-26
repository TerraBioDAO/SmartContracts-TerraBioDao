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

    mapping(address => uint256) private _balances;
    
    function buyTokens(uint256 value_) external payable {
        _buyTokens(value_);
    }

    function _buyTokens(uint256 value_) private {
        require(_tbio.allowance(_tbio.owner(), address(this)) > 0, "TerrabioFaucet: no more token to buy");
        require(_tbio.balanceOf(address(msg.sender))< 50000, "TerrabioFaucet: you can not have more than 50000 TBIO");
        
        uint256 tokenValue = 50000 - value_;

        if(tokenValue > 0){
            if(_tbio.allowance(_tbio.owner(),address(this))< value_){
                _tbio.transferFrom(_tbio.owner(), msg.sender, _tbio.allowance(_tbio.owner(),address(this)));
            }else{
                _tbio.transferFrom(_tbio.owner(), msg.sender, value_);
                }       
        }
        emit Recieved(msg.sender, tokenValue);
    }

    function getBalance(address userAddress_) public view returns (uint256){
        uint256 balanceOf = _tbio.balanceOf(userAddress_);
        return  balanceOf;
    }

    function getAllowance() public view returns(uint256){
        uint256 allowance = _tbio.allowance(_tbio.owner(),address(this));
        return allowance;
    }
}
