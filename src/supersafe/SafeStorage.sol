// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeStorage {
    struct Safe {
        bytes32[] pubKeys;
        uint256 threshold;
        mapping(bytes4 => bool) restrictions;
        mapping(bytes32 => uint256) confirmations;
        bool initialized;
    }

    struct Operation {
        address target;
        bytes data;
        bool executed;
        mapping(bytes32 => bool) proofs;
    }
    
    mapping(uint256 => Safe) internal safes;
    mapping(uint256 => mapping(bytes32 => Operation)) internal operations;
    
    address public immutable falconRegistry;
    
    constructor(address _falconRegistry) {
        falconRegistry = _falconRegistry;
    }
}