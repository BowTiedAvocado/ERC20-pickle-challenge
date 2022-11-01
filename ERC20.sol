// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract ERC20 {
  string public name; // Token name
  string public symbol; // Token symbol
  uint256 public immutable supply; // Supply of tokens
  uint8 public decimals; // Decimals the token uses for display purposes
  address public immutable masterAddress; // Token master address, has special powers

  mapping(address => uint256) balances;

  constructor() {
    name = "Avocado Coin";
    symbol = "AVO";
    decimals = 6;
    supply = 420069000000;
    masterAddress = msg.sender;
  }

  function name() public view returns (string) {
    return name;
  }

  function symbol() public view returns (string) {
    return symbol;
  }

  function decimals() public view returns (uint8) {
    return decimals;
  }

  function totalSupply() public view returns (uint256) {
    return supply;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer() returns () {}

  function transferFrom() returns () {}

  function approve() returns () {}

  function allowance() returns () {}
}
