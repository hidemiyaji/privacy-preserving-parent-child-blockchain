// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    address public minter;
    mapping(address => uint) public balances;

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "Only the minter can mint tokens");
        balances[receiver] += amount;
    }

    // msg to get the information
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
}
