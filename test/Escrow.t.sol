// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    address buyer;
    address seller;
    address arbiter;

    Escrow escrow;

    function setUp() public {
        buyer = address(0xBEEF);
        seller = address(0xCAFE);
        arbiter = address(0xDEAD);

        // label addresses for test output
        vm.label(buyer, "Buyer");
        vm.label(seller, "Seller");
        vm.label(arbiter, "Arbiter");

        // prank makes next call from buyer
        vm.prank(buyer);
        escrow = new Escrow{value: 1 ether}(seller, arbiter);
    }

    function testInitialState() public {
        assertEq(escrow.buyer(), buyer);
        assertEq(escrow.seller(), seller);
        assertEq(escrow.arbiter(), arbiter);
        assertEq(address(escrow).balance, 1 ether);
        assertEq(escrow.amount(), 1 ether);
        assertFalse(escrow.isReleased());
    }

    function testReleaseByBuyer() public {
        vm.prank(buyer);
        escrow.release();

        assertTrue(escrow.isReleased());
        assertEq(seller.balance, 1 ether);
    }

    function testReleaseByArbiter() public {
        vm.prank(arbiter);
        escrow.release();

        assertTrue(escrow.isReleased());
        assertEq(seller.balance, 1 ether);
    }

    function testRefundByArbiter() public {
        vm.prank(arbiter);
        escrow.refund();

        assertTrue(escrow.isReleased());
        assertEq(buyer.balance, 1 ether);
    }

    function testCannotReleaseTwice() public {
        vm.prank(buyer);
        escrow.release();

        vm.expectRevert("Already released");
        vm.prank(arbiter);
        escrow.release();
    }

    function testUnauthorizedReleaseFails() public {
        address intruder = address(0xBAD1);
        vm.expectRevert("Not authorized");
        vm.prank(intruder);
        escrow.release();
    }

    function testUnauthorizedRefundFails() public {
        address intruder = address(0xBAD2);
        vm.expectRevert("Only arbiter can refund");
        vm.prank(intruder);
        escrow.refund();
    }

    function testCannotRefundAfterRelease() public {
        vm.prank(arbiter);
        escrow.release();

        vm.expectRevert("Already released");
        vm.prank(arbiter);
        escrow.refund();
    }
}
