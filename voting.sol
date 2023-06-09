// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


contract voting{
  
    address public admin;
    struct Candidates{
        string name;
        uint votes;
    }
    Candidates[] public candidates;
    mapping (address => bool) public voted;
    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin{
        require (msg.sender == admin); 
        _;
    }
    function addCandidate(string memory candidate) public onlyAdmin{
        candidates.push(Candidates(candidate,0));
    }

    function showCandidates() public view returns(Candidates[] memory){
        return candidates;
    }
    function vote(string memory candidate) public{
        require(voted[msg.sender] ==  false, "YOU HAVE ALREADY VOTED");
        uint candidateIndex = getCandidateIndex(candidate);
        require(candidateIndex < candidates.length, "NOT A VALIDATE CANDIDATE INDEX");
        candidates[candidateIndex].votes++;
        voted[msg.sender] = true;
    }

function getWinners() public view returns (string[] memory) {
    require(candidates.length > 0, "No candidates available");

    uint256 winningVoteCount = candidates[0].votes;
    uint256 numWinners = 1;

    for (uint256 i = 1; i < candidates.length; i++) {
        if (candidates[i].votes > winningVoteCount) {
            winningVoteCount = candidates[i].votes;
            numWinners = 1;
        } else if (candidates[i].votes == winningVoteCount) {
            numWinners++;
        }
    }

    string[] memory winners = new string[](numWinners);
    uint256 index = 0;

    for (uint256 i = 0; i < candidates.length; i++) {
        if (candidates[i].votes == winningVoteCount) {
            winners[index] = candidates[i].name;
            index++;
        }
    }

    return winners;
}
function getCandidateIndex(string memory _name) private view returns (uint256) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(candidates[i].name)) == keccak256(bytes(_name))) {
                return i;
            }
        }
        revert("Candidate not found");
    }
    
}