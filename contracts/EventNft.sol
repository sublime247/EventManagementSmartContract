// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";

contract EventNFT is ERC721URIStorage {
     uint256 tokenIds;

    constructor() ERC721("EventNFT", "EVT") {}

    function mintNft(string memory tokenURI)
        public
        returns (uint256)
    {
        tokenIds++;

        uint256 newItemId = tokenIds;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}



