// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Simple ERC20 Token to test our simple vault
 * @author catellaTech
 * @notice This token missing access control, and this token is unsafe in real life
 */
contract Token is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol){}

     function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

/* For testing this (and later for playing around with it on Etherscan) create a ERC20 mock contract. Don't worry about understanding every detail of this contract, it is more important at this stage to understand the Vault and the interaction with the vault. Be sure your ERC20 mock has a public, unrestricted mint() function that will allow you to mint tokens to any user (of course we would not do this with a real token, but it is useful when testing). */