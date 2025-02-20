// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ParentBridge {
    address public childBridgeA; // 2-CBC_A_Commit.solのアドレス
    address public childBridgeB; // 1-CBC_B_Commit.solのアドレス

    event TokensTransferredToChild(address indexed from, address indexed to, uint256 amount);

    constructor(address _childBridgeA, address _childBridgeB) {
        require(_childBridgeA != address(0), "Invalid ChildBridgeA address");
        require(_childBridgeB != address(0), "Invalid ChildBridgeB address");
        childBridgeA = _childBridgeA;
        childBridgeB = _childBridgeB;
    }

    /**
     * @dev 1-CBC_B_Commitからトークンを受け取り、2-CBC_A_Commitに送信
     * @param amount トークンの量
     */
    function transferToChildA(uint256 amount) external {
        require(msg.sender == childBridgeB, "Only ChildBridgeB can call this function");
        require(amount > 0, "Amount must be greater than zero");

        // 2-CBC_A_Commitにトークンを送信
        (bool success, ) = childBridgeA.call(
            abi.encodeWithSignature("receiveFromParent(address,uint256)", msg.sender, amount)
        );
        require(success, "Failed to transfer tokens to ChildBridgeA");

        emit TokensTransferredToChild(msg.sender, childBridgeA, amount);
    }

    /**
     * @dev 2-CBC_A_Commitからトークンを受け取り、1-CBC_B_Commitに送信
     * @param amount トークンの量
     */
    function transferToChildB(uint256 amount) external {
        require(msg.sender == childBridgeA, "Only ChildBridgeA can call this function");
        require(amount > 0, "Amount must be greater than zero");

        // 1-CBC_B_Commitにトークンを送信
        (bool success, ) = childBridgeB.call(
            abi.encodeWithSignature("receiveFromParent(address,uint256)", msg.sender, amount)
        );
        require(success, "Failed to transfer tokens to ChildBridgeB");

        emit TokensTransferredToChild(msg.sender, childBridgeB, amount);
    }
}
