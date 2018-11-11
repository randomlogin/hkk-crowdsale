pragma solidity ^0.4.24;
import "./ERC20Token.sol";

contract Crowdsale is Owned {

    Token public token;
    uint public ETHUSD;

    uint public hardCap = 1000000000000000000000000; //in usd  
    uint public softCap = 200000000000000000000000; //in usd
    bool public active = false;

    bool public softCapReached;
    bool public hardCapReached;

    uint public totalUSD;
    uint public totalETH;

    //hardcoded beneficiaries, they recieve half of all contributed amount
    //address[] beneficiaries; 
    address[] public beneficiaries; 

    address public updater;
    //timestamps
    //uint 1544140800;// 7 december

    //uint 1544313600; // 9 december
    //uint 1545523200;// 23 december
    //uint 1546819200; // 7 january 2019
    //uint 1547942400; //20 january
    //uint 1549238400; // 4 february
    //uint 1550361600; // 17 february
    //uint 1551398400; // 1 March

    uint[] public timestamps = [1544313600, 1545523200, 1546819200, 1547942400, 1549238400, 1550361600, 1551398400];
    uint[] public prices = [1000, 1428, 1666, 1739, 1818, 1904, 2000];

    modifier only(address _address) {
        require(msg.sender == _address);
        _;
    }

    constructor(address _tokenAddress, address _owner, address _updater) public {
        token = Token(_tokenAddress);
        require(prices.length == timestamps.length);
        owner = _owner;
        updater = _updater;
        beneficiaries.push(0x8A0Dee4fB57041Da7104372004a9Fd80A5aC9716);
        beneficiaries.push(0x049d1EC8Af5e1C5E2b79983dAdb68Ca3C7eb37F4);
    }

    function() payable public {
        require(active);
        uint amount = calculateTokens(msg.value);

        totalETH += msg.value;
        totalUSD += msg.value*ETHUSD / 10**(uint(18));

        if (!softCapReached) {
            if (totalUSD > softCap ) {
                softCapReached = true;
                require(beneficiaries[0].send(address(this).balance/2));
                require(beneficiaries[1].send(address(this).balance));
            }
        } else {
            if (totalUSD > hardCap ) {
                active = false;
                require(beneficiaries[0].send(address(this).balance/2));
                require(beneficiaries[1].send(address(this).balance));
            }
        }
        token.mint(msg.sender, amount);
    }

    //Takes amount of wei sent by investor and calculates how many tokens he must receive (according to the current
    //ETH price and token price.
    //function calculateTokens(uint val) view internal returns(uint) {
    function calculateTokens(uint val) view public returns(uint) {
        uint amount = val * ETHUSD / currentPrice();
        return amount;
    }

    //Calculates current price of token in USD.
    function currentPrice() constant public returns(uint) {
        for (uint i = 0; i < prices.length; i++ ) {
            if (now < timestamps[i]) {
                return prices[i]*10**uint(17);
            }
        }
        return prices[prices.length-1]*10**uint(17);
    }

    //Update current ETHUSD price.
    function updatePrice(uint _newPrice) only(updater) public {
        require(msg.sender == updater);
        require(_newPrice != 0);
        ETHUSD = _newPrice;
    }

    //Activates the ICO. It means tokens can be purchased only when ICO is active.
    function activate() only(owner) public {
        require(now < timestamps[timestamps.length-1]);
        require(!active);
        active = true;
    }

    //Deactivates the ICO;
    function deactivate() only(owner) public {
        require(active);
        active = false;
    }

}
