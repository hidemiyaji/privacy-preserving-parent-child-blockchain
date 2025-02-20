// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ParentBridgeコントラクト
contract ParentBridge {
    // コントラクトのアドレスを保持
    address public parentAddress;

    // イベント: アドレスが開示されたときに発火
    event AddressDisclosed(address indexed parentAddress);

    constructor() {
        // コントラクトデプロイ時にアドレスを設定
        parentAddress = address(this);
    }

    // アドレスを開示する関数
    function discloseAddress() external {
        // イベントを発火してアドレスを公開
        emit AddressDisclosed(parentAddress);
    }
}

// ChildBridgeコントラクト
contract ChildBridge {
    // 受信したParentBridgeのアドレスを保持
    address public receivedParentAddress;

    // イベント: アドレスを受信したときに発火
    event AddressReceived(address indexed receivedAddress);

    // ParentBridgeからアドレスを受け取る関数
    function receiveAddress(address _parentAddress) external {
        receivedParentAddress = _parentAddress;
        emit AddressReceived(_parentAddress);
    }
}
