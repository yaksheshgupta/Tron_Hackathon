// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../openzeppelin-solidity/contracts/crowdsale/crowdsale.sol";
// erc20
// governce
// cloudsale
contract EquistartProject is ERC20{

    uint32 constant minimumVotingPeriod = 1 weeks;
    uint256 numOfGeneralProposals;
    
    struct GeneralProposal {
        uint256 id;
        string header;
        string description;
        address proposer;
        uint256 livePeriod;
        uint256 votesFor;
        uint256 votesAgainst;
        bool votingPassed;
    }
    
    mapping(uint256 => GeneralProposal) private generalProposals;
    mapping(address => uint256[]) private generalProposalVotes;
    // mapping(address => uint256) private boardMembers;

    event NewGeneralProposal(address indexed proposer);


    constructor(string memory name, string memory symbol, uint tokenSupply, address manager) ERC20(name, symbol){
        _mint(manager, tokenSupply);
    }
    
    
    // modifier onlyInvestor (string memory errorMessage){
    //     require(hasRole(INVESTOR_ROLE, msg.sender), errorMessage);
    //     _;
    // }
    // modifier onlyBoardMember (string memory errorMessage){
    //     require(hasRole(BOARD_MEMBER_ROLE, msg.sender), errorMessage);
    //     _;
    // }
    modifier onlyBoardMember(string memory message){
        require( (balanceOf(msg.sender) > totalSupply()/20), message);
        _;
    }
    
    function createGeneralProposal(string memory header, string calldata description) external onlyBoardMember("Only board member with token > 5% can create proposal") {
        uint proposalId = numOfGeneralProposals++;
        GeneralProposal storage proposal = generalProposals[proposalId];
        proposal.id = proposalId;
        proposal.header = header;
        proposal.description = description;
        proposal.livePeriod = block.timestamp + minimumVotingPeriod;
        proposal.proposer = msg.sender;
        emit NewGeneralProposal(msg.sender);
    }
    
    function _vote(uint256 proposalId, bool supportProposal) external onlyBoardMember("Only board memdber with token > 5% can vot4e") {
        GeneralProposal storage proposal = generalProposals[proposalId];
        votable(proposal);
        
        if(supportProposal) proposal.votesFor++;
        else proposal.votesAgainst++;
        
        generalProposalVotes[msg.sender].push(proposal.id);
    }
    
    
    
    function votable(GeneralProposal storage generalProposal) private {
        if(generalProposal.votingPassed || generalProposal.livePeriod <= block.timestamp){
            generalProposal.votingPassed = true;
            revert("Voting Period has passed on this Proposal");
        }
        
        uint256[] memory tempVotes = generalProposalVotes[msg.sender];
        for (uint256 votes = 0; votes< tempVotes.length; votes++){
            if(generalProposal.id == tempVotes[votes])
                revert("You have already voted on this proposal");
        }
    }
    
    function getAllProposals() public view returns (GeneralProposal[] memory props){
        props = new GeneralProposal[](numOfGeneralProposals);
        
        for (uint256 index =0; index< numOfGeneralProposals; index++){
            props[index] = generalProposals[index];
        }
    }
    
    function getGeneralProposal(uint256 proposalId) public view returns (GeneralProposal memory){
        return generalProposals[proposalId];
    }
    
    function getVotingHistory() public view returns(uint256[] memory){
        return generalProposalVotes[msg.sender];
    }
    
    
    
}