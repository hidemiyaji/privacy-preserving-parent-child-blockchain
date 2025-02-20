// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ParentBridgeを定義
interface ParentBridge {
    function receiveTokens(address user, uint256 amount) external;
}

contract ChildBridge {
    event TokensSentToParent(address indexed user, uint256 amount);
    event TokensReceivedFromParent(address indexed user, uint256 amount);

    address public parentBridge; // ParentBridgeコントラクトのアドレス

    constructor(address _parentBridge) payable {
        parentBridge = _parentBridge; // ParentBridgeのアドレスを設定
    }

    // ParentBridgeにトークンを送信する関数
    function sendToParent(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        // ParentBridgeにトークンを送信
        ParentBridge(parentBridge).receiveTokens(msg.sender, amount);

        // イベント発火
        emit TokensSentToParent(msg.sender, amount);
    }

    // ParentBridgeからトークンを受け取る関数
    function receiveFromParent(address user, uint256 amount) external {
        require(msg.sender == parentBridge, "Only ParentBridge can call this function");
        require(amount > 0, "Amount must be greater than zero");

        // イベント発火
        emit TokensReceivedFromParent(user, amount);
    }
}
