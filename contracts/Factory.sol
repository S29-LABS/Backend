// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract GiftCardFactory is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address public implementation;
    mapping(uint256 => address) public giftCards;

    event GiftCardCreated(address indexed creator, address indexed recipient, uint256 tokenId);

    constructor(address _implementation) ERC721("GiftCard", "GC") {
        implementation = _implementation;
    }

    function createGiftCard(address recipient, string memory message) external {
        address newGiftCard = clone(implementation);
        uint256 tokenId = _tokenIds.current();
        _mint(msg.sender, tokenId); // Use _mint instead of _safeMint
        _setTokenURI(tokenId, message);
        giftCards[tokenId] = newGiftCard;
        emit GiftCardCreated(msg.sender, recipient, tokenId);
        
        _tokenIds.increment();
    }

    function redeemGiftCard(uint256 tokenId) external {
        address giftCard = giftCards[tokenId];
        require(giftCard != address(0), "GiftCardFactory: Invalid token ID");

        // Additional logic to redeem the gift card on L2
        // ...
    }

    function clone(address target) internal returns (address result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
        let clone := mload(0x40)
        mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
        mstore(add(clone, 0x14), targetBytes)
        mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
        let success := create(0, clone, 0x37)
        if success {
            result := address(result)
        }
    }
}
