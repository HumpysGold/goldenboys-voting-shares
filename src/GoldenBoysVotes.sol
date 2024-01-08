// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./interfaces/IVault.sol";
import "./interfaces/IWeightedPool.sol";
import "forge-std/interfaces/IERC20.sol";

contract GoldenBoysVotes {
    IERC20 constant gold = IERC20(0xbeFD5C25A59ef2C1316c5A4944931171F30Cd3E4);
    IVault constant vault = IVault(payable(0xBA12222222228d8Ba445958a75a0704d566BF2C8));
    IWeightedPool constant bptGold99Weth1 = IWeightedPool(0x17e7d59bB209a3215Ccc25FFfEf7161498B7C10d);

    function _goldBalanceOf(address _voter) internal view returns (uint256) {
        return gold.balanceOf(_voter);
    }

    function _bptGold99Weth1BalanceOf(address _voter) internal view returns (uint256) {
        // TODO: also build implementations around the balancer and aura gauge
        bytes32 poolId = bptGold99Weth1.getPoolId();
        (address[] memory tokens, uint256[] memory balances,) = vault.getPoolTokens(poolId);

        // loop over tokens in the bpt to find its gold balance
        uint256 poolGoldBalance;
        for (uint256 i = 0; i < tokens.length;) {
            if (tokens[i] == address(gold)) {
                poolGoldBalance = balances[i];
                break;
            }
            unchecked {
                ++i;
            }
        }
    }

    /// public functions ///

    function decimals() external pure returns (uint8) {
        return uint8(18);
    }

    function name() external pure returns (string memory) {
        return "GoldenBoysVotes";
    }

    function symbol() external pure returns (string memory) {
        return "GOLDEN_VOTES";
    }

    function totalSupply() external view returns (uint256) {
        return gold.totalSupply();
    }

    function balanceOf(address _voter) external view returns (uint256) {
        return _goldBalanceOf(_voter);
    }
}
