// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface SaferERC20 is IERC20, IERC165 {
  function safeTransfer(address to, uint256 amount) external returns(bool);
  function safeTransfer(address to, uint256 amount, bytes memory data) external returns(bool);
  function safeTransferFrom(address from, address to, uint256 amount) external returns(bool);
  function safeTransferFrom(address from, address to, uint256 amount, bytes memory data) external returns(bool);
}