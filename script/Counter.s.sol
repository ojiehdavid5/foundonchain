// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Escrow.sol";

contract DeployEscrowScript is Script {
    function run() external {
        // Load deployer's private key from .env or CLI
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Replace with test addresses
        address seller = vm.addr(1);   // generates a test address
        address arbiter = vm.addr(2);  // another test address

        // Deploy with 1 ETH value
        Escrow escrow = (new Escrow){value: 1 ether}(seller, arbiter);

        vm.stopBroadcast();

        console2.log("Escrow deployed to:", address(escrow));
        console2.log("Buyer:", msg.sender);
        console2.log("Seller:", seller);
        console2.log("Arbiter:", arbiter);
    }
}
