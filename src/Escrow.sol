// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint public amount;
    bool public isReleased;

    constructor(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;
        isReleased = false;
    }

    function release() external {
        require(msg.sender == buyer || msg.sender == arbiter, "Not authorized");
        require(!isReleased, "Already released");

        isReleased = true;
        payable(seller).transfer(amount);
    }

    function refund() external {
        require(msg.sender == arbiter, "Only arbiter can refund");
        require(!isReleased, "Already released");

        isReleased = true;
        payable(buyer).transfer(amount);
    }
}
