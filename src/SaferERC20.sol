// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IERC20Receiver.sol";

contract SaferERC20 is ERC20, ReentrancyGuard {
  using Address for address;

  constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

  function safeTransfer(address to, uint256 amount) external returns(bool){
    safeTransfer(to, amount, "");
  }

  function safeTransfer(address to, uint256 amount, bytes memory data) public returns(bool) {
    require(_checkOnERC20Received(msg.sender, to, amount, data), "ERC20: non ERC20Receiver");
    _transfer(msg.sender, to, amount);
  }

  function safeTransferFrom(address from, address to, uint256 amount) external returns(bool){
    safeTransferFrom(from, to, amount, "");
  }

  function safeTransferFrom(address from, address to, uint256 amount, bytes memory data) public returns(bool){
    require(_checkOnERC20Received(from, to, amount, data), "ERC20: non ERC20Receiver");
    ERC20.transferFrom(from, to, amount);
  }

  function _checkOnERC20Received(
    address from,
    address to,
    uint256 amount,
    bytes memory data
  ) private nonReentrant returns(bool) {
    if(to.isContract()) {
      try IERC20Receiver(to).onERC20Received(msg.sender, from, amount, data) returns(bytes4 retval) {
        return retval == IERC20Receiver.onERC20Received.selector;
      } catch (bytes memory reason) {
        if(reason.length == 0) {
          revert("ERC20: non ERC20Receiver");
        } else {
          assembly {
            revert(add(32, reason), mload(reason))
          }
        }
      } 
    } else {
      return true;
    }
  }
}
