// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker is ExampleExternalContract {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) public {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    mapping(address => uint256) public balances;

    uint256 public constant threshold = 1 ether;

    function stake(uint256 amount) public payable {
        require(msg.value >= amount);
        require(balances[msg.sender] == 0);
        balances[msg.sender] = amount;
    }

    uint256 public deadline = now + 30 seconds;

    // write a function that returns the number of seconds until the deadline
    function timeLeft() public view returns (uint256) {
        return deadline - now;
    }

    function execute() public {
        if (address(this).balance > threshold && timeLeft() < 0) {
            exampleExternalContract.complete{value: address(this).balance}();
        } else if (now >= deadline) {
            return 0;
        }
    }

    // After some `deadline` allow anyone to call an `execute()` function
    //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

    // if the `threshold` was not met, allow everyone to call a `withdraw()` function

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
}
