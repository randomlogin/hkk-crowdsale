pragma solidity ^0.4.24;
import "./ERC20Token.sol";

contract Crowdsale {

    //ad
    
    address updater;
    Token public token;
    uint public USDETH;


    uint softCap;
    uint hardCap;
    bool active;

    //hardcoded beneficiaries, they recieve half of all contributed amount
    address[] beneficiaries = ["0x8A0Dee4fB57041Da7104372004a9Fd80A5aC9716", "0x049d1EC8Af5e1C5E2b79983dAdb68Ca3C7eb37F4"] 

    //timestamps
    uint 1544140800;// 7 december
    uint 1545523200;// 23 december
    dollar_prices =
        k

    timestamps = [];
    prices = [];

    constructor(address _tokenAddress) {
        token = Token(_tokenAddress);
        require(prices.length == timestamps.length);
    }


    function updatePrice(uint _newPrice) {
        require(msg.sender == updater);
        require(_newPrice != 0);
        USDETH = _newPrice;
    }

    function() payable {
        uint amount = calculateTokens(msg.value);
        if (balance(address(this)) > hardCap) {
            active = false;
        }
        token.mint(msg.sender, amount);

    }

    function calculateTokens(uint _wei) {
        uint amount = priceInUsd
        priceInETH = currentPrice()*USDETH
        amount = 
    }

    function currentPrice() constant returns(uint) {
        for (uint i = 0; i < prices.length(); i++ ) {
            if (now < timestamps[i]) {
                return prices[i];
            }
        return prices[prices.length-1];
    }

}
