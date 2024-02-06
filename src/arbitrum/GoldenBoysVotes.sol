// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "../interfaces/IVault.sol";
import "../interfaces/IWeightedPool.sol";
import "forge-std/interfaces/IERC20.sol";

contract GoldenBoysVotes {
    IERC20 constant gold = IERC20(0x8b5e4C9a188b1A187f2D1E80b1c2fB17fA2922e1);
    IVault constant vault = IVault(payable(0xBA12222222228d8Ba445958a75a0704d566BF2C8));

    IWeightedPool constant bptGoldWstethUsdc = IWeightedPool(0x2e8Ea681FD59c9dc5f32B29de31F782724EF4DcB);
    IERC20 constant stakedBptGoldWstethUsdc = IERC20(0xcF853F14EF6111435Cb39c0C43C66366cc6300F1);
    IERC20 constant auraBptGoldWstethUsdc = IERC20(0xaDC09b9853fc276413ec9430B407f6f4C5c9E1F9);

    IWeightedPool constant bptGoldWstethBalAura = IWeightedPool(0x49b2De7d214070893c038299a57BaC5ACb8B8A34);
    IERC20 constant stakedBptGoldWstethBalAura = IERC20(0x159be31493C26F8F924b3A2a7F428C2f41247e83);
    IERC20 constant auraBptGoldWstethBalAura = IERC20(0xaDC09b9853fc276413ec9430B407f6f4C5c9E1F9);

    function _findGoldBalanceInPool(bytes32 _poolId) internal view returns (uint256) {
        (address[] memory tokens, uint256[] memory balances,) = vault.getPoolTokens(_poolId);

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

        return poolGoldBalance;
    }

    function _goldBalanceOf(address _voter) internal view returns (uint256) {
        return gold.balanceOf(_voter);
    }

    function _balancerGoldWstethUsdcBalanceOf(address _voter) internal view returns (uint256) {
        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWstethUsdc.getPoolId());

        uint256 bptTotalSupply = bptGoldWstethUsdc.totalSupply();
        uint256 voterBalance = bptGoldWstethUsdc.balanceOf(_voter);
        uint256 stakedVoterBalance = stakedBptGoldWstethUsdc.balanceOf(_voter);
        uint256 voterAuraBalance = auraBptGoldWstethUsdc.balanceOf(_voter);

        uint256 bptVotes = (voterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 stakedBptVotes = (stakedVoterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 auraVotes = (voterAuraBalance * poolGoldBalance) / bptTotalSupply;

        return bptVotes + stakedBptVotes + auraVotes;
    }

    function _balancerGoldWstethBalAuraBalanceOf(address _voter) internal view returns (uint256) {
        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWstethBalAura.getPoolId());

        uint256 bptTotalSupply = bptGoldWstethBalAura.totalSupply();
        uint256 voterBalance = bptGoldWstethBalAura.balanceOf(_voter);
        uint256 stakedVoterBalance = stakedBptGoldWstethBalAura.balanceOf(_voter);
        uint256 voterAuraBalance = auraBptGoldWstethBalAura.balanceOf(_voter);

        uint256 bptVotes = (voterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 stakedBptVotes = (stakedVoterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 auraVotes = (voterAuraBalance * poolGoldBalance) / bptTotalSupply;

        return bptVotes + stakedBptVotes + auraVotes;
    }

    /// public functions ///

    function goldBalanceOf(address _voter) external view returns (uint256) {
        return _goldBalanceOf(_voter);
    }

    function balancerGoldWstethUsdcBalanceOf(address _voter) external view returns (uint256) {
        return _balancerGoldWstethUsdcBalanceOf(_voter);
    }

    function balancerGoldWstethBalAuraBalanceOf(address _voter) external view returns (uint256) {
        return _balancerGoldWstethBalAuraBalanceOf(_voter);
    }

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
        return _goldBalanceOf(_voter) + _balancerGoldWstethUsdcBalanceOf(_voter)
            + _balancerGoldWstethBalAuraBalanceOf(_voter);
    }
}
