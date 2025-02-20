// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//ParentBridgeを定義
interface ParentBridge {
    function receiveCommitment(bytes32 commitment) external;
    event BlockTimestampLogged(uint256 timestamp); // timestampの表示
}

contract ChildBridge {
    event TokensSentToParent(address indexed user, uint256 amount);
    event TokensReceivedFromParent(address indexed user, uint256 amount);
    event CommitmentSentToParent(address indexed user, bytes32 commitment);
    event ZeroKnowledgeProofGenerated(address indexed user, bytes32 zkProof);
    event BlockTimestampLogged(uint256 timestamp); // timestampの表示

    address public parentBridge; // ParentBridgeコントラクトのアドレス

    constructor(address _parentBridge) payable {
        parentBridge = _parentBridge; // ParentBridgeのアドレスを設定
        emit BlockTimestampLogged(block.timestamp);
    }
    //トークンデータを擬似ゼロ知識証明で暗号化
    function encryptTokenWithZKProof(
        uint256 tokenId,
        uint256 secret
    ) public returns (bytes32) {
        emit BlockTimestampLogged(block.timestamp);
        //擬似ゼロ知識証明の作成
        bytes32 zkProof = keccak256(abi.encodePacked(tokenId, secret));
        //擬似ゼロ知識証明イベントの発火
        emit ZeroKnowledgeProofGenerated(msg.sender, zkProof);
        emit BlockTimestampLogged(block.timestamp);
        return zkProof;
    }

    // ユーザのアドレス情報を取得し、Pedersenコミットメント値に変換して送信
    function sendCommitmentToParent(uint256 tokenId, uint256 secret) external {
    // function sendCommitmentToParent(uint256 secret) external {    
        // 
        require(tokenId > 0, "Invalid tokenId");
        require(secret > 0, "Invalid secret");
        // 
        emit BlockTimestampLogged(block.timestamp);
        // 1. ユーザのアドレス情報を取得 (msg.sender)
        address user = msg.sender;

        // 2. アドレス情報をSHA256でハッシュ化 (Pedersenコミットメント用フォーマット)
        bytes32 hashedAddress = sha256(abi.encodePacked(user));

        // 3. Pedersenコミットメント値 (模擬的な例としてハッシュ値そのものを使用)
        bytes32 pedersenCommitment = hashedAddress; // 実際には楕円曲線演算が必要

        // 3. ゼロ知識証明を作成
        bytes32 zkProof = encryptTokenWithZKProof(tokenId, secret);

        // 4. ParentBridgeへ送信 (イベントで送信シミュレーション)
        emit CommitmentSentToParent(user, pedersenCommitment);
        emit ZeroKnowledgeProofGenerated(msg.sender, zkProof);

        // 実際にはParentBridgeとのインタラクションが必要
        ParentBridge(parentBridge).receiveCommitment(pedersenCommitment);
        emit BlockTimestampLogged(block.timestamp);
    }
    //ParentBridgeにトークンを送信する関数
    function sendToParent(uint256 amount) external {
        emit BlockTimestampLogged(block.timestamp);
        emit TokensSentToParent(msg.sender, amount);
        emit BlockTimestampLogged(block.timestamp);
    }
    //ParentBridgeからトークンを受け取る関数
    function receiveFromParent(address user, uint256 amount) external {
        emit BlockTimestampLogged(block.timestamp);
        emit TokensReceivedFromParent(user, amount);
        emit BlockTimestampLogged(block.timestamp);
    }

    // 任意のタイミングでブロックタイムスタンプを記録する関数
    function logTimestamp() public {
        emit BlockTimestampLogged(block.timestamp);
    }
}
