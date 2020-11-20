/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

pragma solidity ^0.6.12;

contract SimpleBank {

    //
    // State variables
    //
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    address public owner;
    
    //
    // Events - publicize actions to external listeners
    //
    
    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Functions
    //

    constructor() public {
        owner = msg.sender;
    }

    fallback() external payable {
        revert();
    }

    /// @notice Get balance
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    function enroll() public returns (bool isEnrolled){
        enrolled[msg.sender] = true; 
        bool isEnrolled = enrolled[msg.sender];

        emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    function deposit() public payable returns (uint newBalance) {
        bool isEnrolled = enrolled[msg.sender];
        require(isEnrolled, "Error: user not enrolled");

        uint currentBalance = balances[msg.sender];
        balances[msg.sender] = currentBalance + msg.value;
        uint newBalance = balances[msg.sender];

        emit LogDepositMade(msg.sender, msg.value);
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    function withdraw(uint withdrawAmount) public returns (uint newBalance) {
        require(balances[msg.sender] >= withdrawAmount, "Error: not enough funds");

        address payable to = msg.sender;
        uint currentBalance = balances[msg.sender];
        balances[msg.sender] = currentBalance - withdrawAmount;
        uint newBalance = balances[msg.sender];
        to.transfer(withdrawAmount);

        emit LogWithdrawal(msg.sender, withdrawAmount, newBalance);
    }

}
