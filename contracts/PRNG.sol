//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Pig is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter public idCounter;

    enum Rarity {
        COMMON,
        RARE,
        LEGENDARY
    }

    event MintRequested(address to, uint256 targetBlock);
    event PigMinted(address to, uint256 id, Rarity rarity);

    mapping(address => uint256[]) public mintRequests;
    mapping(address => uint256[]) public tokenIds;
    mapping(uint256 => Rarity) public pigRarity;

    uint256 public mintPrice;

    constructor() ERC721("Pig", "PIG") {
        mintPrice = 0.0001 ether;
    }

    function mint() external payable {
        require(msg.value == mintPrice, "Wrong amount of native token");
        address to = _msgSender();

        requestRandomPig(to);
    }

    function requestRandomPig(address to) private {
        // Needed to be + 1 to avoid miner withholding
        uint256 targetBlock = block.number + 1;

        mintRequests[to].push(targetBlock);

        emit MintRequested(msg.sender, targetBlock);
    }

    function processMintRequests() external {
        address to = msg.sender;

        uint256[] storage requests = mintRequests[to];
        for (uint256 i = requests.length; i > 0; --i) {
            uint256 targetBlock = requests[i - 1];
            require(block.number > targetBlock, "Target block not arrived");

            uint256 seed = uint256(blockhash(targetBlock));
            // 256 blocks after
            require(seed != 0, "Hash block isn't available");

            createPig(to, seed);
            requests.pop();
        }
    }

    function createPig(address to, uint256 seed) internal {
        uint256 id = idCounter.current();
        idCounter.increment();
        uint256 randomNumber = uint256(keccak256(abi.encode(seed, id)));
        Rarity rarity = Rarity(randomNumber % 3);
        pigRarity[id] = Rarity(rarity);
        _safeMint(to, id);
        emit PigMinted(to, id, rarity);
    }

    function getRarity(uint256 id) public view returns (Rarity) {
        return pigRarity[id];
    }
}
