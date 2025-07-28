// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// ✅ 作业2：在测试网上发行一个图文并茂的 NFT
// 任务目标
// 1. 使用 Solidity 编写一个符合 ERC721 标准的 NFT 合约。
// 2. 将图文数据上传到 IPFS，生成元数据链接。
// 3. 将合约部署到以太坊测试网（如 Goerli 或 Sepolia）。
// 4. 铸造 NFT 并在测试网环境中查看。
// 任务步骤
// 1. 编写 NFT 合约
// - 使用 OpenZeppelin 的 ERC721 库编写一个 NFT 合约。
// - 合约应包含以下功能：
// - 构造函数：设置 NFT 的名称和符号。
// - mintNFT 函数：允许用户铸造 NFT，并关联元数据链接（tokenURI）。
// - 在 Remix IDE 中编译合约。
// 2. 准备图文数据
// - 准备一张图片，并将其上传到 IPFS（可以使用 Pinata 或其他工具）。https://app.pinata.cloud/ipfs/files
// - 创建一个 JSON 文件，描述 NFT 的属性（如名称、描述、图片链接等）。
// - 将 JSON 文件上传到 IPFS，获取元数据链接。
//   ipfs://bafkreiak6oneza3c3u72kpm34tqnaogginqz7vey24yam2cvpeenuyzdke
//   ipfs://bafkreihqcvyxxxc5kglegakwamsca2pfwkm3vs2aktkni6d6tw3ilhpbs4
// - JSON文件参考 https://docs.opensea.io/docs/metadata-standards
// 3. 部署合约到测试网
// - 在 Remix IDE 中连接 MetaMask，并确保 MetaMask 连接到 Goerli 或 Sepolia 测试网。
// - 部署 NFT 合约到测试网，并记录合约地址。 0xcCdE516cD8D64cB035e7853de62056062FaF2a0a
// 4. 铸造 NFT
// - 使用 mintNFT 函数铸造 NFT：
// - 在 recipient 字段中输入你的钱包地址。
// - 在 tokenURI 字段中输入元数据的 IPFS 链接。
// - 在 MetaMask 中确认交易。
// 5. 查看 NFT
// - 打开 OpenSea 测试网 或 Etherscan 测试网。
// - 连接你的钱包，查看你铸造的 NFT。


contract SimpleNFT is ERC721, Ownable {
    uint256 private  _tokenIdCounter;

    // 存储每个token的URI
    mapping (uint256 => string) private  _tokenURIs;

    // 合约名称和符号
    constructor() ERC721("MyNFT","MNFT") Ownable(msg.sender){}


    // 铸造新NFT的函数，仅限合约所有者调用
    function mintNFT(address recipient,string memory tokenURI) public onlyOwner{
        uint256 tokenId = _tokenIdCounter;
        // 计数器加一，为下一个NFT 预留新的tokenId
        _tokenIdCounter++;
        // 安全的铸造一个NFT,分配给地址 recipient，tokenId为当前值
        _safeMint(recipient,tokenId);

       
        // 为编号为 tokenId 的 NFT 设置元数据的 URI 地址，让每个 NFT 都能有独立的描述信息（如图片、属性等）。
        _setTokenURI(tokenId, tokenURI);

    }


    // 设置tokenURI 
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
        _tokenURIs[tokenId] = tokenURI;
    }

    // 获取 token URI
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory uri = _tokenURIs[tokenId];
        require(bytes(uri).length > 0, "URI query for nonexistent token");
        return uri;
    }
}