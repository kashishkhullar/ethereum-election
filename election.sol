pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

contract Election{
    
    struct Candidate{
        string name;
        uint voteCount;
    }
    
    struct Voter{
        uint weight;
        bool voted;
        uint voterId;
    }
    string public name;
    address private owner;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint electionEnd;
    
    event ElectionResult(string name, uint voteCount);
    
    constructor(string memory _name,uint  _duration,  string[] memory  _candidates) public{
        owner = msg.sender;
        electionEnd = now +(_duration * 1 minutes);
        name = _name;
        for(uint i=0;i<_candidates.length;i++ ){
        candidates.push(Candidate(_candidates[i],0));
        }
    }
    
    function authorise(address _voter) public{
        require(msg.sender == owner);
        require(!voters[_voter].voted);
        voters[_voter].weight = 1;
    }
    
    function vote(uint voterId) public {
        require(now <electionEnd);
        require(!voters[msg.sender].voted);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].voterId = voterId;
        candidates[voterId].voteCount += voters[msg.sender].weight;
        
    }
    
    function end() public {
        require(msg.sender == owner);
        require(now >= electionEnd);
        
        for(uint i=0;i<candidates.length;i++){
            emit ElectionResult(candidates[i].name,candidates[i].voteCount);
        }
    }
    
}