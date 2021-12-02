// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../SaferERC20.sol";

contract MockERC20 is SaferERC20 {
  constructor() SaferERC20("Mock Token", "MOCK") {}

  function mint(address to, uint256 amount) public {
    _mint(to, amount);
  }

  function burn(address account, uint256 amount) public {
    _burn(account, amount);
  }

  function onERC20Received(
    address from, 
    address to, 
    uint256 amount, 
    bytes memory data
  ) public returns(bytes4) {
    return this.onERC20Received.selector;
  }
}