// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract ERC20 {
  string public tokenName; // Token name
  string public tokenSymbol; // Token symbol
  uint256 public immutable tokenSupply; // Supply of tokens
  uint8 public tokenDecimals; // Decimals the token uses for display purposes
  address public immutable masterAddress; // Token master address, has special powers

  mapping(address => uint256) balances;

  constructor() {
    tokenName = "Avocado Coin";
    tokenSymbol = "AVO";
    tokenDecimals = 6;
    tokenSupply = 420069000000;
    masterAddress = msg.sender;
    balances[masterAddress] = tokenSupply;
  }

  function name() public view returns (string memory) {
    return tokenName;
  }

  function symbol() public view returns (string memory) {
    return tokenSymbol;
  }

  function decimals() public view returns (uint8) {
    return tokenDecimals;
  }

  function totalSupply() public view returns (uint256) {
    return tokenSupply;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public {
    require(balances[msg.sender] > _value);

    balances[msg.sender] -= _value;
    balances[_to] += _value;
  }

  function transferFrom() public {}

  function approve() public {}

  function allowance() public {}
}
