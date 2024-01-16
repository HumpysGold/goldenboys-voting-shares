// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./interfaces/IVault.sol";
import "./interfaces/IWeightedPool.sol";
import "forge-std/interfaces/IERC20.sol";

contract GoldenBoysVotes {
    IERC20 constant gold = IERC20(0xbeFD5C25A59ef2C1316c5A4944931171F30Cd3E4);
    IVault constant vault = IVault(payable(0xBA12222222228d8Ba445958a75a0704d566BF2C8));

    IWeightedPool constant bptGold99Weth1 = IWeightedPool(0x17e7d59bB209a3215Ccc25FFfEf7161498B7C10d);
    IERC20 constant stakedBptGold99Weth1 = IERC20(0x157a6dFD77F527efef0b36b5B2156B1aB710E32F);

    IWeightedPool constant bptGoldWethUsdc = IWeightedPool(0x433f09ca08623E48BAc7128B7105De678E37D988);
    IERC20 constant stakedBptGoldWethUsdc = IERC20(0xdAe8AC766eB1c4Bb76Bc814FdE22AC46F467C51b);
    IERC20 constant bptAuraGoldWethUsdc = IERC20(0xEe374580BFf150be6b955954aC3b9899D890cB57);

    IWeightedPool constant bptGoldBalUsdc = IWeightedPool(0xb328B50F1f7d97EE8ea391Ab5096DD7657555F49);
    IERC20 constant stakedBptGoldBalUsdc = IERC20(0x7B3EF4cAD077d871499285A2A8a1Cee0Ee122137);
    IERC20 constant bptAuraGoldBalUsdc = IERC20(0x6C03c044c307ecDe1d4CBBffb6327bDEF07EDFcF);

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

    function _balancerGold99Weth1BalanceOf(address _voter) internal view returns (uint256) {
        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGold99Weth1.getPoolId());

        uint256 bptTotalSupply = bptGold99Weth1.totalSupply();
        uint256 voterBalance = bptGold99Weth1.balanceOf(_voter);
        uint256 stakedVoterBalance = stakedBptGold99Weth1.balanceOf(_voter);

        uint256 bptVotes = (voterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 stakedBptVotes = (stakedVoterBalance * poolGoldBalance) / bptTotalSupply;

        return bptVotes + stakedBptVotes;
    }

    function _balancerGoldWethUsdcBalanceOf(address _voter) internal view returns (uint256) {
        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldWethUsdc.getPoolId());

        uint256 bptTotalSupply = bptGoldWethUsdc.totalSupply();
        uint256 voterBalance = bptGoldWethUsdc.balanceOf(_voter);
        uint256 stakedVoterBalance = stakedBptGoldWethUsdc.balanceOf(_voter);
        uint256 voterAuraBalance = bptAuraGoldWethUsdc.balanceOf(_voter);

        uint256 bptVotes = (voterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 stakedBptVotes = (stakedVoterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 auraVotes = (voterAuraBalance * poolGoldBalance) / bptTotalSupply;

        return bptVotes + stakedBptVotes + auraVotes;
    }

    function _balancerGoldBalUsdcBalanceOf(address _voter) internal view returns (uint256) {
        uint256 poolGoldBalance = _findGoldBalanceInPool(bptGoldBalUsdc.getPoolId());

        uint256 bptTotalSupply = bptGoldBalUsdc.totalSupply();
        uint256 voterBalance = bptGoldBalUsdc.balanceOf(_voter);
        uint256 stakedVoterBalance = stakedBptGoldBalUsdc.balanceOf(_voter);
        uint256 voterAuraBalance = bptAuraGoldBalUsdc.balanceOf(_voter);

        uint256 bptVotes = (voterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 stakedBptVotes = (stakedVoterBalance * poolGoldBalance) / bptTotalSupply;
        uint256 auraVotes = (voterAuraBalance * poolGoldBalance) / bptTotalSupply;

        return bptVotes + stakedBptVotes + auraVotes;
    }

    /// public functions ///

    function goldBalanceOf(address _voter) external view returns (uint256) {
        return _goldBalanceOf(_voter);
    }

    function balancerGold99Weth1BalanceOf(address _voter) external view returns (uint256) {
        return _balancerGold99Weth1BalanceOf(_voter);
    }

    function balancerGoldWethUsdcBalanceOf(address _voter) external view returns (uint256) {
        return _balancerGoldWethUsdcBalanceOf(_voter);
    }

    function balancerGoldBalUsdcBalanceOf(address _voter) external view returns (uint256) {
        return _balancerGoldBalUsdcBalanceOf(_voter);
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
        return _goldBalanceOf(_voter) + _balancerGold99Weth1BalanceOf(_voter) + _balancerGoldWethUsdcBalanceOf(_voter)
            + _balancerGoldBalUsdcBalanceOf(_voter);
    }
}
