// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract ERC20 {
  string public tokenName; // Token name
  string public tokenSymbol; // Token symbol
  uint256 public tokenSupply; // Supply of tokens
  uint8 public tokenDecimals; // Decimals the token uses for display purposes
  address public immutable masterAddress; // Token master address, gets all the supply

  mapping(address => uint256) private balances;
  mapping(address => mapping(address => uint256)) private allowances;

  constructor() {
    tokenName = "Avocado Coin";
    tokenSymbol = "AVO";
    tokenDecimals = 6;
    tokenSupply = 420069000000;
    masterAddress = msg.sender;
    balances[masterAddress] = tokenSupply;
  }

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  event Burn(uint256 _value);

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

  function allowance(address _owner, address _spender)
    public
    view
    returns (uint256 remaining)
  {
    return allowances[_owner][_spender];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balanceOf(msg.sender) >= _value, "Insufficient token balance");

    balances[msg.sender] -= _value;
    balances[_to] += _value;

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public returns (bool success) {
    require(balanceOf(msg.sender) >= _value, "Insufficient token balance");
    require(
      allowance(_from, msg.sender) >= _value,
      "Insufficient token allowance"
    );

    balances[_from] -= _value;
    balances[_to] += _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

  function approve(address _spender, uint256 _value)
    public
    returns (bool success)
  {
    require(_spender != address(0), "Cannot approve to the zero address");

    allowances[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function burn(uint256 _value) public returns (bool success) {
    require(balanceOf(msg.sender) >= _value, "Insufficient token balance");

    balances[msg.sender] -= _value;
    tokenSupply -= _value;

    emit Burn(_value);

    return true;
  }
}
