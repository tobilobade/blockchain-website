// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ComplaintToken is ERC20 {
    address public owner;
    mapping(address => bool) public hasReceivedToken;

    constructor() ERC20("DSAmoviesToken", "DSAM") {
        owner = msg.sender;
    }

    function complain() external {
        require(!hasReceivedToken[msg.sender], "Token already received");

        // Send 1 token to the complainant
        _mint(msg.sender, 1 * 10**18); // Assuming 1 token has 18 decimals

        hasReceivedToken[msg.sender] = true;
    }
}
