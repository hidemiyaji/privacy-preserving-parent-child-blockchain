// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./3-Verifier.sol"; // zk-SNARK Verifier Contract

contract ParentBridge {
    address public childBridge;
    Verifier public verifier; // Instance of Verifier contract

    event ProofVerified(address indexed sender, bool success);

    constructor(address _childBridge, address _verifierAddress) {
        childBridge = _childBridge;
        verifier = Verifier(_verifierAddress); // Initialize Verifier instance
    }

    /**
     * @dev ChildBridgeから送信されたゼロ知識証明を検証
     * @param proofA zk-SNARKの証明パラメータ (a)
     * @param proofB zk-SNARKの証明パラメータ (b)
     * @param proofC zk-SNARKの証明パラメータ (c)
     * @param publicInputs 公開される入力値
     */
    function verifyProof(
        uint256[2] memory proofA,
        uint256[2][2] memory proofB,
        uint256[2] memory proofC,
        uint256[] memory publicInputs
    ) public returns (bool) {
        require(msg.sender == childBridge, "Only ChildBridge can call this function");

        // Call verifyProof on the deployed Verifier contract
        bool isValid = verifier.verifyProof(proofA, proofB, proofC, publicInputs);

        emit ProofVerified(msg.sender, isValid);
        return isValid;
    }
}
