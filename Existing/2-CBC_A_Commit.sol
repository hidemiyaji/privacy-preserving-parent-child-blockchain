// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CBC_A_Commit {
    address public parentBridge; // ParentBridgeのアドレス

    event TokensSentToParent(address indexed user, uint256 amount);

    constructor(address _parentBridge) {
        require(_parentBridge != address(0), "Invalid ParentBridge address");
        parentBridge = _parentBridge; // ParentBridgeのアドレスを設定
    }

    /**
     * @dev ParentBridgeにトークンを送信する関数
     * @param amount 送信するトークンの量
     */
    function sendToParent(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        // ParentBridgeにトークンを送信
        (bool success, ) = parentBridge.call(
            abi.encodeWithSignature("receiveTokens(address,uint256)", msg.sender, amount)
        );
        require(success, "Failed to send tokens to ParentBridge");

        // イベント発火
        emit TokensSentToParent(msg.sender, amount);
    }
}
