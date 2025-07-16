// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// ✅ 创建一个名为Voting的合约，包含以下功能：
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数


contract Voting{

    // 存储候选人票数的mapping
    // tpAccount => 投票用户账户    btAccount => 被投用户账户   voteCount => 票数
    mapping (address tpAccount => mapping (address btAccount => uint voteCount)) public voteMapping;
    mapping (address btAccount => uint voteCount) public votes;

    // 存储候选人账户的数组
    address[] public candidates;

    // 允许用户投票给某个候选人
     function vote (address btAccount) public {
        // 判断自己不能投票给自己
        // require(btAccount != msg.sender, "You can't vote for yourself");
         require(btAccount != msg.sender, unicode"你不能自己给自己投票");

        // 判断候选人不能重复投票
        require(voteMapping[msg.sender][btAccount] == 0, unicode"你已经投票，请勿重复投票");
       
        if (votes[btAccount] == 0){
            candidates.push(btAccount);
        }
        votes[btAccount]++;
        voteMapping[msg.sender][btAccount]++;
     }

    // 返回某个候选人的得票数
    function getVotes(address account)public view  returns (uint voteCount){
        voteCount = votes[account];
    }

    // 重置所有候选人的得票数
    function resetVotes() public {
        for(uint i = 0; i < candidates.length; i++){
           delete votes[candidates[i]];
        }

        delete candidates;
    }

}