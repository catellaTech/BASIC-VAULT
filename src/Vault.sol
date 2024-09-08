// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

/**
 * @title Basic Vault 
 * @author catellaTech
 * @notice This contract allows for deposits and withdrawals 
   of an ERC20 token to a vault
 */
contract Vault {
    /// @notice the ERC20 token the vault holds
    IERC20 public token;

    /// @notice mapping from user addresses to their respective vault balance
    mapping(address => uint256) public vaultBalances;

    /// @notice  emitted when the user deposits to the vault
    event Deposited(address indexed from, uint256 amount);
    /// @notice emitted when the user withdraws from the vault
    event Withdrawn(address indexed to, uint256 amount);

    /// @param _token the address of the ERC20 token to instantiate
    constructor(IERC20 _token){
        token = _token;
    }

    /**
    @notice Deposits to the vault
    @param amount the amount to deposit
     */
    function deposit(uint256 amount) external {
        console.log("Updating the mapping balances..");
        vaultBalances[msg.sender] = vaultBalances[msg.sender] + amount;
        console.log("Transfering the tokens into the Vault smart contract");
        (bool success) = token.transferFrom(msg.sender, address(this), amount);
        require(success,"Deposit failed");
        emit Deposited(msg.sender, amount);
    }

    /**
    @notice Withdraws from the vault
    @param amount the amount to withdraw
     */
    function withdraw(uint256 amount) external {
        require(vaultBalances[msg.sender] >= amount,"Execced amount");
        vaultBalances[msg.sender] = vaultBalances[msg.sender] - amount;
        (bool success) = token.transfer(msg.sender, amount);
        require(success,"Withdraw failed");
        emit Withdrawn(msg.sender, amount);
    }
}
