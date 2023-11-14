// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { Token } from "./mocks/Token.sol";

contract VaultTest is Test {
    Vault public vaultContract;
    Token public tokenVaultcontract;
   
    address public  userOne = vm.addr(0x01);
    
    /// @notice  emitted when the user deposits to the vault
    event Deposited(address indexed from, uint256 amount);
    /// @notice emitted when the user withdraws from the vault
    event Withdrawn(address indexed to, uint256 amount);

    function setUp() public {
        tokenVaultcontract = new Token("catellaTech","CTH");
        vaultContract = new Vault(tokenVaultcontract);

        tokenVaultcontract.mint(userOne, 100e18);
    }

    function testDeposit() public {
        vm.expectEmit(false, false, true, true);
        // We emit the event we expect to see.
        emit Deposited(userOne, 100);
        // We perform the call.
        vm.startPrank(userOne);
        tokenVaultcontract.approve(address(vaultContract), 100e18);
        vaultContract.deposit(100);
    }

    function testWithdraw() public {
        testDeposit();
        vm.expectEmit(false, false, true, true);
        // We emit the event we expect to see.
        emit Withdrawn(userOne,90);
        // We perform the call.
        vaultContract.withdraw(90);

        // Expect revert with the follow msg "Insufficient amount" when the user try to withdraw an amount that execced.
        vm.expectRevert(bytes("Execced amount"));
        vaultContract.withdraw(1000);
    }

}
