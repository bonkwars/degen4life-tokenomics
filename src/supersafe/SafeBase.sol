// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./SafeStorage.sol";
import "./interfaces/IERC7579Safe.sol";
import "./FalconProofRegistry.sol";

abstract contract SafeBase is SafeStorage, Ownable, ReentrancyGuard, IERC7579Safe {
    error SafeNotInitialized();
    error InvalidOperation();
    error InvalidProof();
    error NotEnoughConfirmations();
    error OperationFailed();

    constructor(
        address _falconRegistry
    ) SafeStorage(_falconRegistry) Ownable(msg.sender) {}

    function initializeSafe(
        uint256 safeId,
        bytes32[] calldata pubKeys,
        uint256 threshold
    ) external {
        require(!safes[safeId].initialized, "Safe exists");
        require(threshold > 0 && threshold <= pubKeys.length, "Invalid threshold");
        
        Safe storage safe = safes[safeId];
        safe.pubKeys = pubKeys;
        safe.threshold = threshold;
        safe.initialized = true;
    }

    function executeOperation(
        uint256 safeId,
        address target,
        bytes calldata data,
        bytes32 messageHash,
        bytes calldata verificationData
    ) external virtual override nonReentrant returns (bool) {
        Safe storage safe = safes[safeId];
        if (!safe.initialized) revert SafeNotInitialized();

        bytes32 operationHash = keccak256(abi.encode(target, data));
        Operation storage op = operations[safeId][operationHash];

        // Verify proof
        FalconProofRegistry registry = FalconProofRegistry(falconRegistry);
        if (!registry.verifyProof(messageHash, verificationData)) {
            revert InvalidProof();
        }

        op.proofs[messageHash] = true;
        uint256 confirmations = countConfirmations(safeId, operationHash);
        
        if (confirmations >= safe.threshold && !op.executed) {
            op.executed = true;
            (bool success,) = target.call(data);
            if (!success) revert OperationFailed();
            
            emit SafeOperationExecuted(
                safeId,
                bytes4(data),
                target,
                success
            );
            
            return success;
        } else if (confirmations < safe.threshold) {
            revert NotEnoughConfirmations();
        }

        return false;
    }

    function setSafeguard(
        uint256 safeId,
        bytes4 functionSig,
        bool restricted
    ) external virtual override {
        Safe storage safe = safes[safeId];
        if (!safe.initialized) revert SafeNotInitialized();
        
        safe.restrictions[functionSig] = restricted;
        emit SafeguardUpdated(safeId, functionSig, restricted);
    }

    function registerProof(
        uint256 safeId,
        bytes32 messageHash,
        bytes32 commitmentHash,
        bytes32 challengeHash,
        bytes32 responseHash
    ) external virtual override {
        Safe storage safe = safes[safeId];
        if (!safe.initialized) revert SafeNotInitialized();

        FalconProofRegistry registry = FalconProofRegistry(falconRegistry);
        registry.registerProof(
            messageHash,
            commitmentHash,
            challengeHash,
            responseHash
        );

        emit ProofRegistered(safeId, messageHash, keccak256(
            abi.encode(commitmentHash, challengeHash, responseHash)
        ));
    }

    function countConfirmations(
        uint256 safeId,
        bytes32 operationHash
    ) internal view returns (uint256 count) {
        bytes32[] storage pubKeys = safes[safeId].pubKeys;
        for (uint256 i = 0; i < pubKeys.length; i++) {
            if (operations[safeId][operationHash].proofs[pubKeys[i]]) {
                count++;
            }
        }
    }
}