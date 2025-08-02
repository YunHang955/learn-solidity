// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// ### ✅ 作业3：编写一个讨饭合约
// 任务目标
// 1. 使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
// 2. 记录每个捐赠者的地址和捐赠金额。
// 3. 允许合约所有者提取所有捐赠的资金。

// 任务步骤
// 1. 编写合约
//   - 创建一个名为 BeggingContract 的合约。
//   - 合约应包含以下功能：
//   - 一个 mapping 来记录每个捐赠者的捐赠金额。
//   - 一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
//   - 一个 withdraw 函数，允许合约所有者提取所有资金。
//   - 一个 getDonation 函数，允许查询某个地址的捐赠金额。
//   - 使用 payable 修饰符和 address.transfer 实现支付和提款。
// 2. 部署合约
//   - 在 Remix IDE 中编译合约。
//   - 部署合约到 Goerli 或 Sepolia 测试网。
// 3. 测试合约
//   - 使用 MetaMask 向合约发送以太币，测试 donate 功能。
//   - 调用 withdraw 函数，测试合约所有者是否可以提取资金。
//   - 调用 getDonation 函数，查询某个地址的捐赠金额。

// 任务要求
// 1. 合约代码：
//   - 使用 mapping 记录捐赠者的地址和金额。
//   - 使用 payable 修饰符实现 donate 和 withdraw 函数。
//   - 使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
// 2. 测试网部署：
//   - 合约必须部署到 Goerli 或 Sepolia 测试网。
// 3. 功能测试：
//   - 确保 donate、withdraw 和 getDonation 函数正常工作。
// 额外挑战（可选）
// 捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
// 捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
// 时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。

contract BeggingContract {
    // 记录每个捐赠者的地址和捐赠金额
    mapping (address => uint256) public donationsRel;

    // 记录合约所有者的地址
    address public owner;

    // 记录总捐赠金额
    uint256 public totalDonations;

    // 记录所有的捐赠者
    address[] public donations;

    // 记录所有的捐赠金额
    uint256[] amounts;
    // 事件限制： 添加一个时间限制，只有在特定的时间内才能捐赠
    uint256 startTime;
    uint256 endTime;


    // 记录捐赠者地址
    constructor() {
        owner = msg.sender;

        // bolck.timestamp的单位是秒
        startTime = block.timestamp;
        endTime = block.timestamp + 1 * 60 *60 ; // 一小时
    }

    // 额外挑战：捐赠事件
    event Donation(address donor, uint256 amount);


    // 额外挑战：捐赠排行榜结构
    struct TopDonor{
        address donor;
        uint256 amount;
    }
    TopDonor[] public topDonors;
    
    // donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
    function donate() external payable {
        require(block.timestamp <= endTime,unicode"捐赠时期已过!");
        donationsRel[msg.sender] += msg.value;
        totalDonations += msg.value;

         // 更新排行榜
        updateTopDonors(msg.sender, donationsRel[msg.sender]);

        // 判断是否捐赠过
        if (donationsRel[msg.sender] == 0){
            donations.push(msg.sender);
        }
        amounts.push(msg.value);
        emit Donation(msg.sender, msg.value);
    }


    // withdraw 函数，允许合约所有者提取所有资金。 
    function withdraw() external payable {
        require(msg.sender == owner,"Only owner can withdraw");

        uint256 balance =  address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);

    }

    receive() external payable { }

    fallback() external payable { }

    //  getDonation 函数，允许查询某个地址的捐赠金额。
    function getDonation(address _donor)public view returns (uint256){
        require(_donor != address(0), "error  address");
        return  donationsRel[_donor];
    }

    // 更新排行榜数据
    function updateTopDonors(address donor,uint256 amount) private {
        for(uint i = 0;i < 3;i++){
            if(amount > topDonors[i].amount){
                 // 将新捐赠者插入到合适位置
                for (uint j = 2; j > i; j--) {
                    topDonors[j] = topDonors[j-1];
                }
                topDonors[i] = TopDonor(donor, amount);
                break;
            }
        }
    }

    // 显示捐赠金额最多的前 3 个地址
    function getTopDonation() public view  returns(TopDonor[] memory){
       return topDonors;
    }
}