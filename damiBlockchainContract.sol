// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MovieTicket {
    address payable public owner;
    mapping(address => uint) public userBalances; // Tracks balances topped up by users

    event Purchase(address indexed buyer, uint amount);
    event FundToppedUp(address indexed user, uint amount);
    event Withdrawal(address indexed recipient, uint amount);

    constructor() {
        owner = payable(msg.sender);
    }

    // Modifier to check if the sender is the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    // Function to purchase a movie ticket
    function purchaseTicket() external payable {
        require(msg.value == 0.1 ether, "Incorrect amount sent for ticket purchase");

        // Emit event to log the purchase
        emit Purchase(msg.sender, msg.value);
    }

    // Function for users to top up funds
    function topUpFunds() external payable {
        userBalances[msg.sender] += msg.value;

        // Emit event to log the fund top-up
        emit FundToppedUp(msg.sender, msg.value);
    }

    // Function to withdraw funds received from ticket purchases (only owner)
    function withdrawTicketFunds(address payable _to, uint _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Insufficient contract balance");
        _to.transfer(_amount);
        emit Withdrawal(_to, _amount);
    }

    // Function to withdraw funds topped up by the user
    function withdrawUserFunds(address payable _to, uint _amount) external {
        require(_amount <= userBalances[msg.sender], "Insufficient user balance");
        userBalances[msg.sender] -= _amount;
        _to.transfer(_amount);
        emit Withdrawal(_to, _amount);
    }   

    // Function to get the contract balance
    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }

    // Function to get the contract owner
    function getOwner() external view returns(address) {
        return owner;
    }

    // Function to get the top-up balance of a user
    function getUserTopUpBalance(address _user) external view returns(uint) {
        return userBalances[_user];
    }
}
