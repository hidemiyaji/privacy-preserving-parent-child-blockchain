// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ParentBridge{
    mapping(address => uint256) public balancesA;
    mapping(address=> uint256) public balancesB;

    //イベントの定義
    event TokenExchanged(
        address indexed userA,
        address indexed userB,
        uint256 amountA,
        uint256 amountB
    );

    // ChildBridgeAからトークンを受信
    function depositToChildA(address user, uint256 amount) external{
        balancesA[user] += amount;
    }

    //ChildBridgeBからトークンを受信
    function depositTOChildB(address user, uint amount) external{
        balancesB[user] += amount;
    }

    //トークン交換処理
    function exchangeTOkens(
        address userA,
        address userB,
        uint256 amountA,
        uint256 amountB
    ) external {
        require(balancesA[userA]>= amountA, "Insufficient balance in Child A");
        require(balancesB[userA]>= amountB, "Insufficient balance in Child B");

        //残鷹の計算
        balancesA[userB] += amountA;
        balancesB[userA] += amountB;

        //イベントの記録
        emit TokenExchanged(userA,userB,amountA,amountB);
    }
}