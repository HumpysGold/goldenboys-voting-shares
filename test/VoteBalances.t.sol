pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/interfaces/IERC20.sol";

import {GoldenBoysVotes} from "../src/GoldenBoysVotes.sol";
import {IWeightedPool} from "../src/interfaces/IWeightedPool.sol";
import {IVault} from "../src/interfaces/IVault.sol";


contract VoteBalances is Test {
    uint256 mainnetFork;
    uint256 baseFork;
    uint256 arbitrumFork;

    GoldenBoysVotes votes;

    uint256 constant BLOCK = 9230000;

    address constant GOLD = 0xbeFD5C25A59ef2C1316c5A4944931171F30Cd3E4;
    IVault constant vault = IVault(payable(0xBA12222222228d8Ba445958a75a0704d566BF2C8));

    IWeightedPool constant bptGold99Weth1 = IWeightedPool(0x17e7d59bB209a3215Ccc25FFfEf7161498B7C10d);
    IWeightedPool constant bptGoldWethUsdc = IWeightedPool(0x433f09ca08623E48BAc7128B7105De678E37D988);
    IWeightedPool constant bptGoldBalUsdc = IWeightedPool(0xb328B50F1f7d97EE8ea391Ab5096DD7657555F49);

    function setUp() public {
        baseFork = vm.createSelectFork("base", BLOCK);
        // arbitrumFork = vm.createFork("arbitrum");

        vm.selectFork(baseFork);
        votes = new GoldenBoysVotes();
    }

    function test_goldBalanceOf() public {
        address holder = address(1);
        deal(GOLD, holder, 100);
        uint256 bal = votes.goldBalanceOf(holder);
        assertEq(bal, 100);
    }

    function test_balancerGold99Weth1BalanceOf() public {
        // https://basescan.org/tokencheck-tool?t=0x157a6dFD77F527efef0b36b5B2156B1aB710E32F&a=0x8042A1E006BeB0435345216e43E5a0443D185050 (input block 9230000)
        // holds ~10e18
        address holder = 0x8042A1E006BeB0435345216e43E5a0443D185050;
        uint256 numVotes = votes.balancerGold99Weth1BalanceOf(holder);

        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGold99Weth1.getPoolId());
        uint256 bptTotalSupply = bptGold99Weth1.totalSupply();
        uint256 voterBalance = (numVotes * bptTotalSupply) / poolGoldBalance;

        assertApproxEqAbs(voterBalance / 1e18, 10, 1);
    }

    function test_balancerGoldWethUsdcBalanceOf() public {
        // https://basescan.org/tokencheck-tool?t=0x433f09ca08623E48BAc7128B7105De678E37D988&a=0xF1fF29394490FD373dA1875afc7bb6688057baDf (input block 9230000)
        // holds 10e18
        address holder = 0xF1fF29394490FD373dA1875afc7bb6688057baDf;
        uint256 numVotes = votes.balancerGoldWethUsdcBalanceOf(holder);

        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWethUsdc.getPoolId());
        uint256 bptTotalSupply = bptGoldWethUsdc.totalSupply();
        uint256 voterBalance = (numVotes * bptTotalSupply) / poolGoldBalance;

        assertApproxEqAbs(voterBalance, 10e18, 1e3);
    }

    function test_balancerGoldBalUsdcBalanceOf() public {
        // https://basescan.org/tokencheck-tool?t=0x7B3EF4cAD077d871499285A2A8a1Cee0Ee122137&a=0x1E7267fA2628d66538822Fc44f0EDb62b07272A4 (input block 9230000)
        // holds 6000e18
        address holder = 0x1E7267fA2628d66538822Fc44f0EDb62b07272A4;
        uint256 numVotes = votes.balancerGoldBalUsdcBalanceOf(holder);

        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldBalUsdc.getPoolId());
        uint256 bptTotalSupply = bptGoldBalUsdc.totalSupply();
        uint256 voterBalance = (numVotes * bptTotalSupply) / poolGoldBalance;

        assertApproxEqAbs(voterBalance, 6000e18, 1e3);
    }

    function _findGoldBalanceInPool(bytes32 _poolId) internal view returns (uint256) {
        (address[] memory tokens, uint256[] memory balances,) = vault.getPoolTokens(_poolId);

        uint256 poolGoldBalance;
        for (uint256 i = 0; i < tokens.length;) {
            if (tokens[i] == GOLD) {
                poolGoldBalance = balances[i];
                break;
            }
            unchecked {
                ++i;
            }
        }

        return poolGoldBalance;
    }
}
