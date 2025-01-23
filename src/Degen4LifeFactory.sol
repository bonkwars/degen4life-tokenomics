// SPDX-License-Identifier: MIT
// Copyright (c) 2025 Degen4Life
pragma solidity ^0.8.20;

import "./Degen4LifeToken.sol";

contract Degen4LifeFactory {
    event TokenDeployed(address tokenAddress);

    function deploy(
        address trustedForwarder,
        uint256 initialSupply,
        bytes32 salt
    ) external returns (address) {
        Degen4LifeToken token = new Degen4LifeToken{salt: salt}(
            trustedForwarder,
            initialSupply
        );
        
        emit TokenDeployed(address(token));
        return address(token);
    }

    function computeAddress(
        address trustedForwarder,
        uint256 initialSupply,
        bytes32 salt
    ) external view returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(Degen4LifeToken).creationCode,
            abi.encode(trustedForwarder, initialSupply)
        );
        
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(bytecode)
            )
        );
        
        return address(uint160(uint256(hash)));
    }
}