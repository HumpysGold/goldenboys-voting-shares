# GoldenBoys Voting Shares

The `GoldenBoysVotes.sol` contract, hereby implemented for the Base and Arbitrum One chains, take multiple $GOLD and $GOLD positions into account to derive the total amount of $GOLD a particular user has. `GoldenBoysVotes.balanceOf(address _voter)` can be queried to get this total amount.

## Coverage

Positions currently considered are:

### Base

- `0xbeFD5C25A59ef2C1316c5A4944931171F30Cd3E4`: $GOLD
- `0x17e7d59bB209a3215Ccc25FFfEf7161498B7C10d`: $bptGold99Weth1
- `0x157a6dFD77F527efef0b36b5B2156B1aB710E32F`: $bptGold99Weth1 staked on Balancer
- `0x433f09ca08623E48BAc7128B7105De678E37D988`: $bptGoldWethUsdc
- `0xdAe8AC766eB1c4Bb76Bc814FdE22AC46F467C51b`: $bptGoldWethUsdc staked on Balancer
- `0xEe374580BFf150be6b955954aC3b9899D890cB57`: $bptGoldWethUsdc staked on Aura
- `0xb328B50F1f7d97EE8ea391Ab5096DD7657555F49`: $bptGoldBalUsdc
- `0x7B3EF4cAD077d871499285A2A8a1Cee0Ee122137`: $bptGoldBalUsdc staked on Balancer
- `0x6C03c044c307ecDe1d4CBBffb6327bDEF07EDFcF`: $bptGoldBalUsdc staked on Aura

### Arbitrum One

- `0x8b5e4C9a188b1A187f2D1E80b1c2fB17fA2922e1`: $GOLD
- `0x2e8Ea681FD59c9dc5f32B29de31F782724EF4DcB`: $bptGoldWstethUsdc
- `0xcF853F14EF6111435Cb39c0C43C66366cc6300F1`: $bptGoldWstethUsdc staked on Balancer
- `0xaDC09b9853fc276413ec9430B407f6f4C5c9E1F9`: $bptGoldWstethUsdc staked on Aura
- `0x49b2De7d214070893c038299a57BaC5ACb8B8A34`: $bptGoldWstethBalAura
- `0x159be31493C26F8F924b3A2a7F428C2f41247e83`: $bptGoldWstethBalAura staked on Balancer
- `0xaDC09b9853fc276413ec9430B407f6f4C5c9E1F9`: $bptGoldWstethBalAura staked on Aura

## Foundry

[Foundry](https://book.getfoundry.sh/) tests for both chains are included:

```shell
$ forge test
```
