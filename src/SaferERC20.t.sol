// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";

import "./SaferERC20.sol";
import "./ERC20Receiver.sol";
import "./mocks/MockSaferERC20.sol";
import "./mocks/MockNonReceiver.sol";
import "./mocks/GenericUser.sol";

contract SaferERC20Test is DSTest {
    MockERC20 token;

    function setUp() public {
        token = new MockERC20();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }

    function test_safeTransfer(address to, uint256 amount) public {
        // exceptional cases
        if(
            to == address(0) || // transfer to zero address should fail
            amount <= 2 // won't divide in two well, which messed things up
        ) return;

        uint256 halfAmount = amount / 2;

        // fund this contract so it can transfer
        token.mint(address(this), amount);

        // EOA
        uint256 preBal = token.balanceOf(to);
        token.safeTransfer(to, halfAmount);
        uint256 postBal = token.balanceOf(to);

        assertEq(postBal - preBal, halfAmount );

        // ERC20Receiver
        ERC20Receiver recipient = new ERC20Receiver();

        preBal = token.balanceOf(address(recipient));
        token.safeTransfer(address(recipient), halfAmount);
        postBal = token.balanceOf(address(recipient));

        assertEq(postBal - preBal, halfAmount );
    }

    function test_safeTransferFrom(address to, uint256 amount) public {
        // exceptional cases
        if(
            to == address(0) || // transfer to zero address should fail
            amount <= 2 // won't divide in two well, which messed things up
        ) return;

        // create "user"
        GenericUser from = new GenericUser();

        uint256 halfAmount = amount / 2;

        // fund address
        token.mint(address(from), amount);
        // approve test contract
        from.call(
            address(token), 
            abi.encodeWithSignature(
                "approve(address,uint256)", 
                address(this),
                type(uint256).max
            )
        );

        // to EOA
        uint256 preBal = token.balanceOf(to);
        token.safeTransferFrom(address(from), to, halfAmount);
        uint256 postBal = token.balanceOf(to);

        assertEq(postBal - preBal, halfAmount);

        // to ERC20Receiver
        // token.mint(address(from), amount);
        ERC20Receiver recipient = new ERC20Receiver();

        preBal = token.balanceOf(address(recipient));
        token.safeTransferFrom(address(from), address(recipient), halfAmount);
        postBal = token.balanceOf(address(recipient));

        assertEq(postBal - preBal, halfAmount );
    }

    // for non ERC20Receiver
    function testFail_safeTransfer(uint256 amount) public {
        ERC20 nonReceiver = new ERC20("non", "NON");
        token.mint(address(this), amount);

        // transfer to nonReceiver
        token.safeTransfer(address(nonReceiver), amount);
    }
    // for non ERC20Receiver
    function testFail_safeTransferFrom(uint256 amount) public {
        ERC20 nonReceiver = new ERC20("non", "NON");
        GenericUser from = new GenericUser();

        // fund address
        token.mint(address(from), amount);
        // approve test contract
        from.call(
            address(token), 
            abi.encodeWithSignature(
                "approve(address,uint256)", 
                address(this),
                type(uint256).max
            )
        );

        // transferFrom to nonReceiver
        token.safeTransferFrom(address(from), address(nonReceiver), amount);
    }
}
