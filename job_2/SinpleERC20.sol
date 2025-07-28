// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
// 1.合约包含以下标准 ERC20 功能：
// 2.balanceOf：查询账户余额。
// 3.transfer：转账。
// 4.approve 和 transferFrom：授权和代扣转账。
// 5.使用 event 记录转账和授权操作。
// 6.提供 mint 函数，允许合约所有者增发代币。
// 提示：
// 使用 mapping 存储账户余额和授权信息。
// 使用 event 定义 Transfer 和 Approval 事件。
// 部署到sepolia 测试网，导入到自己的钱包


contract SimpleERC20 {

    // 代币名称
    string public name;

    // 代币符号
    string public symbol;

    // 代币小数位数
    uint8 public decimals;

    // 代币总供应量
    uint256 public  totalSupply;

    // 账户余额映射： 地址  => 余额
    mapping (address => uint256) public  balances;

    // 授权额度映射： 授权人 => (被授权人 => 授权额度)
    mapping (address => mapping (address => uint256)) public allowances;

    // 合约所有者地址
    address public  owner;

    // 转账事件
    event Transfer(address indexed form,address indexed to,uint256 value);

    // 授权事件
    event Approval(address indexed owner,address indexed spender,uint256 value);


    /**
     * @dev 构造函数，初始化代币信息和初始供应量
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _decimals 小数位数
     * @param _initialSupply 初始供应量（不含小数）
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply; // 初始供应量分配给合约部署者

        owner = msg.sender;

        emit Transfer(address(0), msg.sender, totalSupply);

    }


    // 定义一个函数修改器
    modifier onlyOwner(){
        // 判断此函数调用者是否为 owner
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }



    /**
     * @dev 转账函数，将代币从调用者转给指定地址
     * @param to 接收方地址
     * @param value 转账数量
     * @return 是否转账成功
     */
    function transfer(address to, uint256 value) external returns (bool){
        _transfer(msg.sender,to,value);
        return true;
    }


    /**
     * @dev 授权函数，允许 spender 代替调用者花费指定数量的代币
     * @param spender 被授权地址
     * @param value 授权额度
     * @return 是否授权成功
     */
     function approval(address spender, uint256 value) external  returns(bool){
        _approval(msg.sender, spender, value);
        return true;
     }



    /**
     * @dev 代扣转账函数，允许 spender 从 from 地址转账到 to 地址
     * @param from 代币来源地址
     * @param to 接收方地址
     * @param value 转账数量
     * @return 是否转账成功
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool){
        require(allowances[from][msg.sender] >= value,unicode"超出额度");
        _transfer(from, to, value);
        _approval(from, msg.sender, allowances[from][msg.sender] - value);

        return true;
    }


    /**
     * @dev 增发代币函数，仅限合约所有者调用
     * @param to 接收增发代币的地址
     * @param value 增发数量
     */
    function mint(address to, uint256 value) external onlyOwner{
       
        _mint(to, value);
    }




     /**
     * @dev 内部转账函数，实现实际的余额转移和事件触发
     * @param from 发送方地址
     * @param to 接收方地址
     * @param value 转账数量
     */

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(balances[from] >= value, unicode"余额不足");


        balances[from] -= value;
        balances[to] += value;

        emit Transfer(from, to, value);
    }


     /**
     * @dev 内部授权函数，实现授权额度的设置和事件触发
     * @param _owner 授权人地址
     * @param spender 被授权人地址
     * @param value 授权额度
     */
     function _approval(
        address _owner, 
        address spender, 
        uint256 value
     )internal {
        require(_owner != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");

        allowances[_owner][spender] = value;

        emit Approval(_owner, spender, value);
     }


    /**
     * @dev 内部增发函数，实现代币的增发和事件触发
     * @param account 接收增发代币的地址
     * @param amount 增发数量
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero address");

        totalSupply += amount;
        balances[account] += amount;


        emit Transfer(address(0), account, amount);
    }

}