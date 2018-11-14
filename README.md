# Overview

This repository holds contracts for an ICO. The ICO rules are the following:

1. Price is increasing within the predefined intervals.
2. The price of token is measured in USD, therefore the cross rate is calculated.
3. The price of ETH is get from some exchange some times per predefined time interval.
4. Once the softcap is reached the contributed amount can be withdrawn by beneficiaries.

This contract holds both the contract and the crowdsale contracts.

# Description

There are two contracts here, the token and the crowdsale.

## Token
It's a ERC20 token, which has some additional functionality:

1. First of all it's owned, some additional functions can be done only by owner. Owner can trasfer ownership to another
   address (this address has to accept the transfer of ownership).

2. The token is mintable by owner and by crowdsale contract. Mint can be done when `mintable` modifier is set to true, upon deploy it's true and can
   be deactivated once the ICO over. This action cannot be reverted, so once it's set unmintable it can no longer be
   minted. Moreover, the token can be transferred only when it's not mintable. It means it's not transferrable until the
   end of ICO. (Mint is not default function of ERC20 interface.) `mintable` stage can be thought as when the ICO is
   active. End of `mintable` stage is enforced by owner invoking `deactivateMint()`, it makes token transferrable and
   not mintable.

3. `multimint`. Same as mint, but takes array of destionations.
4. `multitransfer`. Same as transfer, but takes array of destinations.
5. `unMint`. This function removes the tokens of a given address. It can be done only in `mintable` stage. This function
   can be called only by crowdsale contract if the ICO has not reached the minimum cap (soft cap), or the contributor didn't
   pass the KYC procedures. 
6. Reference to the crowdsale contract. It's set once and forever.


## Crowdsale

It's the crowdsale contract which is reponsible for minting tokens in automatic way.

1. Crowdsale has the current ETH/USD exchange rate, it can be updated only by `updater`. Updater checks the price at
   some exchange and posts it to the contract.
2. Crowdsale has the timestamps for time intervals and prices (in USD) at such an interval.
3. Minimum and maximum caps (also known as `hardCap` and `softCap`) are set in USD, the contributed amount is also
   calculated in USD at the moment of contribution.
4. `active` modifier, which activates/deactivates the possibility of contributing Ether (it doesn't affect the token, so
   it can be minted by its owner in a manual way). Crowdsale cannot be activated after the end of ICO (1st March 2019).
5. Fallback function receives Ether, recalculates it in USD, calculates with current price the amount of tokens to be
   minted and invokes `mint` in the Token contract. The contribution is stored (both in USD and in ETH). 
6. When the `softCap` is reached, the Ether is sent to the beneficiaries (there are two of them, the amount is split in equal
   proportion between them).
7. When the `hardCap` is reached, the Ether is sent to the beneficiaries (there are two of them, the amount is split in equal
   proportion between them). Once it's reached, the crowdsale is no longer active.
8. Ether can be returned to contributor by owner via `returnEther`. It's done if the contributor purchased tokens, but failed to pass the
   KYC. In this case the address who sent the contribution receives the full amount of Ether he sent, his tokens are
   `unMinted`. 

# Disclaimer

I don't have any connection with the HKK, I'm not responsible for any kind of issue with this company.
