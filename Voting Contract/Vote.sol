//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VotingContract
 * @dev A simple voting contract that allows users to vote for candidates and donate Ether.
 */
contract VotingContract {
    // Struct to represent a candidate
    struct Candidate {
        string name;       // The name of the candidate
        uint voteCount;    // The number of votes received by the candidate
    }

    // Mapping to store candidates
    mapping(string => Candidate) public candidates;

    // Event to log donations
    event DonationReceived(address indexed sender, uint amount);

    /**
     * @dev Constructor to initialize the contract with two initial candidates, "John" and "Paul".
     */
    constructor() {
        candidates["John"] = Candidate("John", 0);
        candidates["Paul"] = Candidate("Paul", 0);
    }

    /**
     * @dev Function to allow users to vote for a candidate.
     * @param candidateName The name of the candidate to vote for ("John" or "Paul").
     */
    function vote(string memory candidateName) public onlyValidCandidate(candidateName) {
        candidates[candidateName].voteCount++;
    }

    /**
     * @dev Modifier to ensure that the candidate name is valid ("John" or "Paul").
     * @param candidateName The name of the candidate to check.
     */
    modifier onlyValidCandidate(string memory candidateName) {
        require(
            keccak256(abi.encodePacked(candidateName)) == keccak256(abi.encodePacked("John")) ||
            keccak256(abi.encodePacked(candidateName)) == keccak256(abi.encodePacked("Paul")),
            "You are not allowed to vote"
        );
        _;
    }

    /**
     * @dev Function to get the current vote count and candidate's name.
     * @param candidateName The name of the candidate to get the vote count for ("John" or "Paul").
     * @return The current vote count and name of the candidate as a Candidate struct.
     */
    function getCandidateVoteCount(string memory candidateName) public view onlyValidCandidate(candidateName) returns (Candidate memory) {
        return candidates[candidateName];
    }

    /**
     * @dev Payable function to allow users to send Ether as a donation to the contract.
     */
    receive() external payable {
        emit DonationReceived(msg.sender, msg.value);
    }
}