// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Safererc20.sol";

contract Safererc20Test is DSTest {
    Safererc20 safererc;

    function setUp() public {
        safererc = new Safererc20();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
