// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CBC_A_Commit {
    address public parentBridge; //ParentBridgeのアドレス
    mapping(address => bytes32) public commitments; //ユーザアドレスとコミットメントのマッピング
    event CommitmentSent(
        address indexed user,
        bytes32 commitment,
        bytes zkProof
    );

    constructor(address _parentBridge) payable{
        parentBridge = _parentBridge;
    }

    /**
     * @dev ユーザーアドレスを取得し、コミットメント値を計算して保存
     * @param userAddress トークン交換を希望するユーザーのアドレス
     * @param tokenValue 交換したいトークンの値（ゼロ知識証明に使用）
     */

    function createCommitment(address userAddress, uint256 tokenValue) public {
        require(userAddress != address(0), "Invalid user address");
        require(tokenValue > 0, "Token value must be greater than zero");
        //コミットメント値を計算（Keccak256ハッシュを使用）
        bytes32 commitment = keccak256(
            abi.encodePacked(userAddress, tokenValue)
        );
        commitments[userAddress] = commitment;
        //ゼロ知識証明の生成（ダミー値を使用）
        bytes memory zkProof = generateZeroKnowledgeProof(tokenValue);
        //ParentBridgeにデータを送信
        sendToParentBridge(commitment, zkProof);
        emit CommitmentSent(userAddress, commitment, zkProof);
    }

    /**
     * @dev ゼロ知識証明を生成（簡易的なモックアップ）
     * @param tokenValue トークン値
     * @return zkProof ゼロ知識証明データ
     */
    function generateZeroKnowledgeProof(
        uint256 tokenValue
    ) internal pure returns (bytes memory) {
        // 実際にはゼロ知識証明ライブラリやアルゴリズムを使用する必要あり
        return abi.encodePacked("zkProof", tokenValue);
    }

    /**
     * @dev ParentBridgeにコミットメントとゼロ知識証明を送信
     * @param commitment コミットメント値
     * @param zkProof ゼロ知識証明データ
     */

    function sendToParentBridge(
        bytes32 commitment,
        bytes memory zkProof
    ) internal {
        //ParentBridgeコントラクトが受け取る関数に送信（例：receiveCommitment関数を想定）
        (bool success, ) = parentBridge.call(
            abi.encodeWithSignature(
                "receiveCommitment(bytes32,bytes)",
                commitment,
                zkProof
            )
        );
        require(success, "Failed to send data to ParentBridge");
    }
}
