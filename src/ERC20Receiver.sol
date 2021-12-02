// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./IERC20Receiver.sol";

contract ERC20Receiver is IERC20Receiver {
  function onERC20Received(
    address from, 
    address to, 
    uint256 amount, 
    bytes memory data
  ) public returns(bytes4) {
    return this.onERC20Received.selector;
  }
}