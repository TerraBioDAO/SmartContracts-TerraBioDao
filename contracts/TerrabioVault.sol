// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/// @title ERC20-based Token
/// @author Benmissi-A
/// @notice You can use this contract to create an ERC20-based Token
/// @dev You can customize this Token contract (name, symbol, amount of tokens) at deployment only

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 *@dev Token is {Ownable}, {ERC20}
 */

contract TerrabioToken is Ownable, ERC20 {
    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */

    constructor(uint256 totalSupply) ERC20("TBIO", "TBIO") {
        _mint(owner(), totalSupply);
    }

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }
}
