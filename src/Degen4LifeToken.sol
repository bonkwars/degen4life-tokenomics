// SPDX-License-Identifier: MIT
// Copyright (c) 2025 Degen4Life
pragma solidity ^0.8.20;

import "./TokenomicsRules.sol";
import "./tokens/MultiChainToken.sol";

contract Degen4LifeToken is MultiChainToken {

    address public tokenomicsRules;
    address public communityWallet;
    address public treasuryWallet;
    address public teamWallet;
    address public marketingWallet;
    address public dexLiquidity;
   
    address public cexLiquidity;


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

    function setTokenomicsRules(address _tokenomicsRules) external onlyOwner {
        tokenomicsRules = _tokenomicsRules;
    }

    function setCommunityWallet(address _communityWallet) external onlyOwner {
        communityWallet = _communityWallet;
    }

    function setTreasuryWallet(address _treasuryWallet) external onlyOwner {
        treasuryWallet = _treasuryWallet;
    }

    function setTeamWallet(address _teamWallet) external onlyOwner {
        teamWallet = _teamWallet;
    }

    function setMarketingWallet(address _marketingWallet) external onlyOwner {
        marketingWallet = _marketingWallet;
    }

    function setDEXLiquidity(address _dexLiquidity) external onlyOwner {
        dexLiquidity = _dexLiquidity;
    }


    function setCEXLiquidity(address _cexLiquidity) external onlyOwner {
        cexLiquidity = _cexLiquidity;
    }



    function _update(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
       
        if (tokenomicsRules != address(0)) {
            uint256 tax = TokenomicsRules(tokenomicsRules).calculateTax(amount);
            uint256 burn = TokenomicsRules(tokenomicsRules).calculateBurn(amount);
            uint256 communityWalletAmt = TokenomicsRules(tokenomicsRules).calculateCommunityWallet(amount);
            uint256 teamWalletAmt = TokenomicsRules(tokenomicsRules).calculateTeamWallet(amount);
            uint256 dexLiquidityAmt = TokenomicsRules(tokenomicsRules).calculateDEXLiquidity(amount);
            uint256 treasuryInitiativeAmt = TokenomicsRules(tokenomicsRules).calculateTreasuryInitiative(amount);
            uint256 marketingWalletAmt = TokenomicsRules(tokenomicsRules).calculateMarketingWallet(amount);
            uint256 cexLiquidityAmt = TokenomicsRules(tokenomicsRules).calculateCEXLiquidity(amount);

            _burn(sender, burn);
            _mint(address(0), tax);
            _mint(communityWallet, communityWalletAmt);
            _mint(teamWallet, teamWalletAmt);
            _mint(dexLiquidity, dexLiquidityAmt);
            _mint(treasuryWallet, treasuryInitiativeAmt);
            _mint(marketingWallet, marketingWalletAmt);
            _mint(cexLiquidity, cexLiquidityAmt);
        }
        super._update(sender, recipient, amount);
    }
}