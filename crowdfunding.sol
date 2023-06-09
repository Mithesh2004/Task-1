// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract crowdfunding{
        mapping (address => uint256) public amountSent;
        mapping (address => bool) hasPaid;
        address payable public admin;
        uint256 public goal;
        bool goalReached;
        int256 timeLimit;
        address[] payers;
        uint256 balance;


        constructor() {
            admin = payable(msg.sender);
            timeLimit = int256(block.timestamp) + 3 days;
        } 

        modifier onlyAdmin(){
            require(msg.sender==admin);
            _;
        }

        function Pay() payable public{
            require((msg.value + balance) <= goal, "YOU ARE EXCEEDING THE GOAL");
            require(remainingTime() > 0, "TIME IS OVER");
            amountSent[msg.sender] += msg.value;
            balance+=msg.value;
            if (balance == goal){
                goalReached = true;  
            }
            if (hasPaid[msg.sender] == false){
                payers.push(msg.sender);
                hasPaid[msg.sender] = true;
            }
        }

        function setGoal(uint256 _goal) public onlyAdmin{
            goal = _goal;
        }

        function Extract() payable public onlyAdmin {
            require(goalReached, "GOAL NOT REACHED BEFORE TIME");
            admin.transfer(address(this).balance);
            for(uint i=0; i< payers.length; i++){
                amountSent[payers[i]]=0;
            }
            payers = new address[](0);
        }

        function Return() payable public onlyAdmin{
            require(remainingTime() < 0 && goalReached == false, "MORE TIME IS THERE OR GOAL NOT REACHED");
            for(uint i=0; i< payers.length; i++){
                payable(payers[i]).transfer(amountSent[payers[i]]);
                amountSent[payers[i]]=0;
            }
            payers = new address[](0);
        }

        function remainingTime() public view returns(int256 Seconds){
            Seconds = timeLimit - int256(block.timestamp);
        }

      
        
        
}