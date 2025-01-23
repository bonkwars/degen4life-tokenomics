// SPDX-License-Identifier: MIT
// Copyright (c) 2025 Degen4Life
pragma solidity ^0.8.20;

import "./tokens/MultiChainToken.sol";

contract Degen4LifeToken is MultiChainToken {
    constructor(
        address trustedForwarder,
        uint256 initialSupply
    ) MultiChainToken(
        "Degen4Life",
        "DE4L",
        block.chainid,
        trustedForwarder
    ) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}