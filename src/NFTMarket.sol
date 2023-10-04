// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";

contract NFTMarket is ERC721{
 
 uint256 public tokenId;
 uint256 public counter = 1; 

    struct Order {
        address tokenOwner;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bool isActive;
        uint256 deadline;
        bytes signature;
    }
        mapping(bytes32 => Order) public orders;

         modifier onlyTokenOwner(address tokenAddress, uint256 _tokenId) {
        require(
            IERC721(tokenAddress).ownerOf(tokenId) == msg.sender,
            "Not the token owner"
        );
        _;
    }

   function createOrder(
    address tokenAddress,
    uint256 _tokenId,
    uint256 price,
    uint256 deadline,
    bytes memory signature
) external onlyTokenOwner(tokenAddress, tokenId) {
    require(tokenAddress != address(0), "Invalid token address");
    require(price > 0, "Price must be greater than 0");
    require(deadline > block.timestamp, "Invalid deadline");

  
    uint256 order = Order();

    require(IERC721(tokenAddress).ownerOf(tokenId) == msg.sender, "Not the token owner");

    bytes32 orderHash = Orders(msg.sender, tokenAddress, tokenId, price, deadline);

    // Verify the signature

    require(signature.recover(orderHash) == msg.sender, "Invalid signature");

     bytes32 createOrder = keccak256(
        abi.encodePacked(
            msg.sender,
            tokenAddress,
            tokenId,
            price,
            deadline
        )
    );
       Order();
       emit createOrder(orders, msg.sender, tokenAddress, tokenId, price, deadline);
}

    function executeOrder(
        address tokenAddress,
        uint256 _tokenId,
        uint256 price,
        uint256 deadline,
        bytes memory signature,
        uint256 executeOrderId
    ) external payable onlyTokenOwner(
        keccak256(
            abi.encodePacked(
                msg.sender,
                tokenAddress,
                tokenId,
                price,
                deadline
            )
        )
    ) {
        bytes32 orderHash = keccak256(
            abi.encodePacked(
                msg.sender,
                tokenAddress,
                tokenId,
                price,
                deadline
            )
        );
            // retrieve order bsed on hash
        Order storage order = orders[orderHash];

        //Ether transfer
        address seller = order.tokenOwner;
        require(msg.value >= order.price, "Insufficient funds");
        (bool transferSuccess, ) = seller.call{value: order.price}("");
        require(transferSuccess, "Ether transfer failed");

        //transfer NFT
        IERC721(order.tokenAddress).safeTransferFrom(seller, msg.sender, order.tokenId);

        counter++;

          emit executeOrderId(
            executeOrderId,
            order.tokenOwner,
            msg.sender,
            order.tokenAddress,
            order.tokenId,
            order.price
        );


}
}