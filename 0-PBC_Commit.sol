// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ParentBridge {
    //コントラクトのアドレスを公開する変数
    address public parentBridgeAddress;
    event BlockTimestampLogged(uint256 timestamp); // timestampの表示

   constructor(){
        emit BlockTimestampLogged(block.timestamp);
        //デプロイ時にコントラクトのアドレスを設定
        parentBridgeAddress = address(this);
        emit BlockTimestampLogged(block.timestamp);
    }

    // 任意のタイミングでブロックタイムスタンプを記録する関数
    function logTimestamp() public {
        emit BlockTimestampLogged(block.timestamp);
    }

    // // 既存のEndprocess関数
    // function Endprocess(uint256 timestamp) public {
    //     emit BlockTimestampLogged(block.timestamp);
    // }


}