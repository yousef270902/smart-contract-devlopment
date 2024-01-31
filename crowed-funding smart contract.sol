// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract crowedfunding
{
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountcollected;
        address[] donators;
        uint256[] donations;
    }
    mapping (uint256=>Campaign) public Campaigns;
    uint256 public numberofcampaign =0;
    function createCampaign(address _owner , string memory  _title , string memory  _description , uint256 _target , uint256 _deadline  ) public returns( uint256 )
    {
        Campaign storage campaign= Campaigns[numberofcampaign];
        require(campaign.deadline<block.timestamp,"the deadline should be in the future");
        campaign.owner= _owner;
        campaign.title= _title;
        campaign.description= _description;
        campaign.target= _target;
        campaign.deadline = _deadline;
        campaign.amountcollected=0;
        numberofcampaign++;
        return numberofcampaign -1;
    }
    function donatetocampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = Campaigns[ _id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        (bool sent ,) =payable(campaign.owner).call{value: amount}("");
        if(sent)
        {
            campaign.amountcollected= campaign.amountcollected + amount;
        }
    }
    function getdonators(uint256 _id) view public returns (address[] memory , uint256[] memory)
    {
        return(Campaigns[_id].donators, Campaigns[ _id].donations);
    }
    function getcampaign() public view returns(Campaign[] memory)
    {
        Campaign[] memory allCampaigns =new Campaign[] (numberofcampaign);

        for(uint i=0; i<numberofcampaign;i++)
        {
            Campaign storage item =Campaigns[i];
            allCampaigns[i]=item;
        }
        return allCampaigns;
    }
}
