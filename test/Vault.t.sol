// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { Test , console} from "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { Token } from "./mocks/Token.sol";

contract VaultTest is Test {
    Vault public vaultContract;
    Token public tokenVaultcontract;
   
    address public userOne = makeAddr("userOne");
    
    /// @notice emitted when the user withdraws from the vault
    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    function setUp() public {
        tokenVaultcontract = new Token("catellaTech","CTH");
        vaultContract = new Vault(tokenVaultcontract);

        tokenVaultcontract.mint(userOne, 100e18);
        console.log("Balance of userOne:", tokenVaultcontract.balanceOf(userOne));
    }

    function testDeposit() public {
        uint256 amount = 100e18;
        // We perform the call.
        vm.startPrank(userOne);
        tokenVaultcontract.approve(address(vaultContract), amount);
        // Expect emit the Deposited event if the deposited was successful
        vm.expectEmit(false, false, true, true);
        emit Deposited(userOne, amount);
        
        vaultContract.deposit(amount);
        vm.stopPrank();
        // we make sure the vault contract balance is correct  
        uint256 VaultBalance = tokenVaultcontract.balanceOf(address(vaultContract));
        assertEq(VaultBalance, amount);
    }

    function testWithdraw() public {
        testDeposit();
        uint256 amountOut = 90e18;
        vm.expectEmit(false, false, true, true);
        // We emit the event we expect to see.
        emit Withdrawn(userOne,amountOut);
        // We perform the call.
        vm.prank(userOne);
        vaultContract.withdraw(amountOut);

        // lets check the balance of the vault contract
        uint256 VaultBalance = tokenVaultcontract.balanceOf(address(vaultContract));
        // the userOne deposited 100e18 and now he withdraw 90e18. so the vault contract balance should be 10e18
        assertEq(VaultBalance, 10e18);

        // Expect revert with the follow msg "Insufficient amount" when the user try to withdraw an amount that execced.
        vm.expectRevert(bytes("Execced amount"));
        vaultContract.withdraw(1000);
    }

}
