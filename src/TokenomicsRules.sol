// SPDX-License-Identifier: MIT
// Copyright (c) 2025 Degen4Life
pragma solidity ^0.8.20;

contract TokenomicsRules {
    // The following functions are used to define the tokenomics rules for the Degen4Life token.
    // The Degen4Life token is a deflationary token with a 1% burn rate on every transaction.
    // The Degen4Life token has a maximum supply of 1,000,000,000 tokens.
    // The Degen4Life token has a 3% tax on every transaction, which is distributed as follows:
    // The Degen4Life token has a 25% that is added to the community wallet.
    // The Degen4Life token has a 20% that is added to the team wallet.
    // The Degen4Life token has a 30% that is added to the DEX Liquidity pool
    // The Degen4Life token has a 10% that is added to the Degen4Life treasury initiative.
    // The Degen4Life token has a 10% that is added to the marketing wallet.
    // The Degen4Life token has a 5% that is added to the CEX Liquidity.

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10 ** 18;
    uint256 public constant BURN_RATE = 1;
    uint256 public constant TAX_RATE = 3;
    uint256 public constant COMMUNITY_WALLET_RATE = 25;
    uint256 public constant TEAM_WALLET_RATE = 20;
    uint256 public constant DEX_LIQUIDITY_RATE = 30;
    uint256 public constant TREASURY_INITIATIVE_RATE = 10;
    uint256 public constant MARKETING_WALLET_RATE = 10;
    uint256 public constant CEX_LIQUIDITY_RATE = 5;

    // The following functions are used to calculate the tax amount for a given transaction amount.
    function calculateTax(uint256 _amount) public pure returns (uint256) {
        return (_amount * TAX_RATE) / 100;
    }

    // The following functions are used to calculate the burn amount for a given transaction amount.
    function calculateBurn(uint256 _amount) public pure returns (uint256) {
        return (_amount * BURN_RATE) / 100;
    }

    // The following functions are used to calculate the community wallet amount for a given transaction amount.
    function calculateCommunityWallet(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * COMMUNITY_WALLET_RATE) / 100;
    }

    // The following functions are used to calculate the team wallet amount for a given transaction amount.
    function calculateTeamWallet(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * TEAM_WALLET_RATE) / 100;
    }

    // The following functions are used to calculate the DEX liquidity pool amount for a given transaction amount
    function calculateDEXLiquidity(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * DEX_LIQUIDITY_RATE) / 100;
    }

    // The following functions are used to calculate the treasury initiative amount for a given transaction amount
    function calculateTreasuryInitiative(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * TREASURY_INITIATIVE_RATE) / 100;
    }

    // The following functions are used to calculate the marketing wallet amount for a given transaction amount
    function calculateMarketingWallet(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * MARKETING_WALLET_RATE) / 100;
    }

    // The following functions are used to calculate the CEX liquidity amount for a given transaction amount
    function calculateCEXLiquidity(
        uint256 _amount
    ) public pure returns (uint256) {
        return (_amount * CEX_LIQUIDITY_RATE) / 100;
    }

    // The following functions are used to calculate the total amount for a given transaction amount
    function calculateTotal(uint256 _amount) public pure returns (uint256) {
        return (_amount +
            calculateTax(_amount) +
            calculateBurn(_amount) +
            calculateCommunityWallet(_amount) +
            calculateTeamWallet(_amount) +
            calculateDEXLiquidity(_amount) +
            calculateTreasuryInitiative(_amount) +
            calculateMarketingWallet(_amount) +
            calculateCEXLiquidity(_amount));
    }

    // The following functions are used to calculate the tax amount for a given transaction amount
    function calculateTaxAmount(uint256 _amount) public pure returns (uint256) {
        return calculateTax(_amount);
    }
}
