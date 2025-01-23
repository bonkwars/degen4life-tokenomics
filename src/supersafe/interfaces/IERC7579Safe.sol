// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC7579Safe {
    event SafeOperationExecuted(
        uint256 indexed safeId,
        bytes4 indexed functionSig,
        address target,
        bool success
    );
    
    event SafeguardUpdated(
        uint256 indexed safeId,
        bytes4 indexed functionSig,
        bool restricted
    );
    
    event ProofRegistered(
        uint256 indexed safeId,
        bytes32 indexed messageHash,
        bytes32 proofHash
    );

    function executeOperation(
        uint256 safeId,
        address target,
        bytes calldata data,
        bytes32 messageHash,
        bytes calldata verificationData
    ) external returns (bool);

    function setSafeguard(
        uint256 safeId,
        bytes4 functionSig,
        bool restricted
    ) external;

    function registerProof(
        uint256 safeId,
        bytes32 messageHash,
        bytes32 commitmentHash,
        bytes32 challengeHash,
        bytes32 responseHash
    ) external;
}