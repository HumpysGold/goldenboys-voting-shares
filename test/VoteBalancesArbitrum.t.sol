pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/interfaces/IERC20.sol";

import {GoldenBoysVotes} from "../src/arbitrum/GoldenBoysVotes.sol";
import {IWeightedPool} from "../src/interfaces/IWeightedPool.sol";
import {IVault} from "../src/interfaces/IVault.sol";

contract VoteBalancesBase is Test {
    GoldenBoysVotes votes;

    uint256 constant BLOCK = 170000000;

    address constant GOLD = 0x8b5e4C9a188b1A187f2D1E80b1c2fB17fA2922e1;
    IVault constant vault = IVault(payable(0xBA12222222228d8Ba445958a75a0704d566BF2C8));

    IWeightedPool constant bptGoldWstethUsdc = IWeightedPool(0x2e8Ea681FD59c9dc5f32B29de31F782724EF4DcB);
    IWeightedPool constant bptGoldWstethBalAura = IWeightedPool(0x49b2De7d214070893c038299a57BaC5ACb8B8A34);

    function setUp() public {
        vm.createSelectFork("arbitrum", 170000000);
        votes = new GoldenBoysVotes();
    }

    function test_goldBalanceOf() public {
        address holder = address(1);
        deal(GOLD, holder, 100);
        uint256 bal = votes.goldBalanceOf(holder);
        assertEq(bal, 100);
    }

    function test_balancerGoldWstethUsdcBalanceOf() public {
        // https://arbiscan.io/tokencheck-tool?t=0xcF853F14EF6111435Cb39c0C43C66366cc6300F1&a=0x1E7267fA2628d66538822Fc44f0EDb62b07272A4 (input block 170000000)
        // holds 10e18
        address holder = 0x1E7267fA2628d66538822Fc44f0EDb62b07272A4;
        uint256 numVotes = votes.balancerGoldWstethUsdcBalanceOf(holder);

        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWstethUsdc.getPoolId());
        uint256 bptTotalSupply = bptGoldWstethUsdc.totalSupply();
        uint256 voterBalance = (numVotes * bptTotalSupply) / poolGoldBalance;

        assertApproxEqAbs(voterBalance, 3000e18, 1e3);
    }

    function test_balancerGoldWstethBalAuraBalanceOf() public {
        // https://arbiscan.io/tokencheck-tool?t=0x159be31493C26F8F924b3A2a7F428C2f41247e83&a=0x1E7267fA2628d66538822Fc44f0EDb62b07272A4 (input block 170000000)
        // holds 10e18
        address holder = 0x1E7267fA2628d66538822Fc44f0EDb62b07272A4;
        uint256 numVotes = votes.balancerGoldWstethBalAuraBalanceOf(holder);

        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWstethBalAura.getPoolId());
        uint256 bptTotalSupply = bptGoldWstethBalAura.totalSupply();
        uint256 voterBalance = (numVotes * bptTotalSupply) / poolGoldBalance;

        assertApproxEqAbs(voterBalance, 400e18, 1e3);
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
