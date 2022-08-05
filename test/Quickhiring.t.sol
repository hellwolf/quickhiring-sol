// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Quickhiring.sol";

contract QuickhiringTest is Test {
    address private immutable owner;
    uint private ENTRANCE_FEE;
    SortProgramContest t;
    ISortProgram baseline;

    constructor() {
        owner = msg.sender;
    }

    function setUp() public {
        vm.startPrank(owner);
        t = new SortProgramContest();
        ENTRANCE_FEE = t.ENTRANCE_FEE();
        baseline = t.baseline();
    }

    function testSetup() public {
        t.selfTest1();
        t.selfTest2();
        assertEq(t.numContestants(), 1);
        SortProgramContest.Contestant memory top = t.topGun();
        assertEq(top.applicant, owner);
        assertEq(address(top.program), address(t.baseline()));
        assertEq(top.gasUsed, t.GAS_LIMIT());
        (bool success,,) = t.validateProgram(baseline);
        assertTrue(success);
        vm.expectRevert(bytes("Don't bust the baseline!"));
        t.autoBust();
        vm.expectRevert(bytes("Until challenge period finishes!"));
        t.collectNativeCoin();
        vm.expectRevert(bytes("Until challenge period finishes!"));
        t.collectERC20(IERC20(address(0)));
    }

    function testSuccinctQuicksort(uint256[] memory input) public {
        vm.assume(input.length < 100);
        uint256[] memory result = t.baseline().sort(input);
        assertEq(result.length, input.length);
        // use xor to validate result efficiently
        uint256 a;
        uint256 b;
        uint256 min;
        for (uint i = 0; i < input.length; ++i) {
            a ^= input[i];
            b ^= result[i];
            assertTrue(result[i] >= min);
            min = result[i];
        }
        assertEq(a, b);
    }

    function testBaselineProgram() public {
        t.qualify{ value: ENTRANCE_FEE } (baseline);
        assertEq(address(t).balance, t.ENTRANCE_FEE());
        assertEq(t.numContestants(), 2);
        SortProgramContest.Contestant memory top = t.topGun();
        assertEq(address(top.program), address(t.baseline()));
        assertTrue(top.gasUsed < t.GAS_LIMIT());

        vm.expectRevert(bytes("Your program used more gas than the top gun!"));
        t.qualify{ value: ENTRANCE_FEE } (baseline);

        vm.expectRevert(bytes("Not busted!"));
        t.autoBust();

        vm.warp(block.timestamp + t.CONTEST_PERIOD());
        vm.expectRevert(bytes("Contest ended!"));
        t.qualify{ value: ENTRANCE_FEE } (baseline);

        vm.expectRevert(bytes("Until challenge period finishes!"));
        t.collectNativeCoin();
        vm.expectRevert(bytes("Until challenge period finishes!"));
        t.collectERC20(IERC20(address(0)));

        vm.warp(block.timestamp + t.CHALLENGE_PERIOD());
        t.collectNativeCoin();
    }

    function testBustingCheater() public {
        CheatSort bader = new CheatSort(t);
        t.qualify{ value: ENTRANCE_FEE }(bader);
        SortProgramContest.Contestant memory top = t.topGun();
        assertEq(address(top.program), address(bader));
        t.autoBust();

        top = t.topGun();
        assertEq(t.numContestants(), 1);
        assertEq(address(top.program), address(t.baseline()));
        assertEq(top.gasUsed, t.GAS_LIMIT());
    }

    function testBustingCheaterChallengePeriod() public {
        CheatSort bader = new CheatSort(t);
        t.qualify{ value: ENTRANCE_FEE }(bader);
        SortProgramContest.Contestant memory top = t.topGun();
        assertEq(address(top.program), address(bader));

        vm.warp(block.timestamp + t.CONTEST_PERIOD());
        vm.expectRevert(bytes("Contest ended!"));
        t.qualify{ value: ENTRANCE_FEE } (baseline);

        t.autoBust();

        top = t.topGun();
        assertEq(t.numContestants(), 1);
        assertEq(address(top.program), address(t.baseline()));
        assertEq(top.gasUsed, t.GAS_LIMIT());
    }

    function testBustingCheaterTooLate() public {
        CheatSort bader = new CheatSort(t);
        t.qualify{ value: ENTRANCE_FEE }(bader);
        SortProgramContest.Contestant memory top = t.topGun();
        assertEq(address(top.program), address(bader));

        vm.warp(block.timestamp + t.CONTEST_PERIOD() + t.CHALLENGE_PERIOD());
        vm.expectRevert(bytes("Contest ended!"));
        t.qualify{ value: ENTRANCE_FEE } (baseline);

        vm.expectRevert(bytes("Challenge period ended!"));
        t.autoBust();
    }
}
