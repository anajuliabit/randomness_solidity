//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Pig is ERC721, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter public idCounter;

    bytes32 internal keyHash;
    uint256 internal fee;

    enum Rarity {
        COMMON,
        RARE,
        LEGENDARY
    }

    event MintRequested(address to, bytes32 requestId);
    event PigMinted(address to, uint256 id, Rarity rarity);

    mapping(address => uint256[]) public tokenIds;
    mapping(uint256 => Rarity) public pigRarity;

    uint256 public mintPrice;

    mapping(bytes32 => address) private requestToSender;
    mapping(bytes32 => uint256) private requestToTokenId;

    constructor()
        ERC721("Pig", "PIG")
        VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255,
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        )
    {
        mintPrice = 0.0001 ether;
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 ether;
    }

    function mint() external payable {
        require(msg.value == mintPrice, "Wrong amount of native token");

        requestRandomPig(_msgSender());
    }

    function requestRandomPig(address to) private {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        bytes32 requestId = requestRandomness(keyHash, fee);

        uint256 id = idCounter.current();
        idCounter.increment();
        requestToSender[requestId] = to;
        requestToTokenId[requestId] = id;

        emit MintRequested(msg.sender, requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 id = requestToTokenId[requestId];
        address to = requestToSender[requestId];

        Rarity rarity = Rarity(randomNumber % 3);
        pigRarity[id] = Rarity(rarity);
        _safeMint(to, id);
        emit PigMinted(to, id, rarity);
    }

    function getRarity(uint256 id) public view returns (Rarity) {
        return pigRarity[id];
    }

    function totalSupply() public view returns (uint256) {
        return idCounter.current();
    }
}
