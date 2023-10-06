// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {NFTMarket} from "../src/NFTMarket.sol";
import "../src/ERC721Mock.sol";
import "./Helpers.sol";

contract NFTMarketTest is Helpers {
    NFTMarket mPlace;
    OurNFT nft;

    uint256 currentListingId;

    address userA;
    address userB;

    uint256 privKeyA;
    uint256 privKeyB;

    NFTMarket.ListingData l;

    function setUp() public {
        mPlace = new NFTMarket();
        nft = new OurNFT();

        (userA, privKeyA) = mkaddr("USERA");
        (userB, privKeyB) = mkaddr("USERB");

        l = NFTMarket.ListingData({
           tokenAddress: address(nft),
            tokenId: 1,
           priceInWei: 1e18,
            signature: bytes(""),
            expiryTime: 0,
           listerAddress: address(userA),
           isActive: false
        });

        // mint NFT
        nft.mint(userA, 1);
    }

    function testNotOwnerListing() public {
        l.listerAddress = userB;
        switchSigner(userB);

        vm.expectRevert(NFTMarket.NotOwner.selector);
        mPlace.createCustomListing(l);
    }

    function testNonApproved() public {
        switchSigner(userA);
        vm.expectRevert(NFTMarket.NotApproved.selector);
        mPlace.createCustomListing(l);
    }

    function testMinPriceTooLow() public {
        switchSigner(userA);
        nft.setApprovalForAll(address(mPlace), true);
        l. priceInWei = 0.5e18;
        vm.expectRevert(NFTMarket.MinPriceTooLow.selector);
        mPlace.createCustomListing(l);
    }

    function testMinDurationNotMet() public {
        switchSigner(userA);
        nft.setApprovalForAll(address(mPlace), true);
        vm.expectRevert(NFTMarket. MinDurationNotMet.selector);
        mPlace.createCustomListing(l);
    }

    // function testNotMetDuration() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.deadline = uint88(block.timestamp + 59 minutes);
    //     vm.expectRevert(NFTMarket.MinDurationNotMet.selector);
    //     mPlace.createListing(l);
    }

    // function testValidSignature() {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.expiryTime = uint88(block.timestamp + 120 minutes);
    //     l. signature = constructSig(
    //         l.tokenAddress,
    //         l.tokenId,
    //         l. priceInWei,
    //         l.expiryTime,
    //         l.listerAddress,
    //         privKeyB
    //     );
    //     vm.expectRevert(NFTMarket.InvalidSignature.selector);
    //     mPlace. createCustomListing(l);
    // }
    

    // // EDIT LISTING
    // function testListingNotExistent() public {
    //     switchSigner(userA);
    //     vm.expectRevert(NFTMarket.ListingNotExistent.selector);
    //     mPlace.editListing(1, 0, false);
    // }

    // function testEditListingNotOwner() public {
    //     switchSigner(userA);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     vm.expectRevert(NFTMarket.ListingNotExistent.selector);
    //     uint256 lId = mPlace.createListing(l);

    //     switchSigner(userB);
    //     vm.expectRevert(NFTMarket.NotOwner.selector);
    //     mPlace.editListing(lId, 0, false);
    // }

    // function testEditListing() public {
    //     switchSigner(userA);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     uint256 lId = mPlace.createListing(l);
    //     mPlace.editListing(lId, 0.01 ether, false);

    //    NFTMarket.ListingData memory t = mPlace.getListing(lId);
    //     assertEq(t.price, 0.01 ether);
    //     assertEq(t.active, false);
    // }

    // // EXECUTE LISTING
    // function testExecuteNonValidListing() public {
    //     switchSigner(userA);
    //     vm.expectRevert(NFTMarket.ListingNotExistent.selector);
    //     mPlace.executeListing(1);
    // }

    // function testExecuteExpiredListing() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    // }

    // function testExecuteListingNotActive() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     uint256 lId = mPlace.createListing(l);
    //     switchSigner(userB);
    //     vm.expectRevert(NFTMarket.ListingNotActive.selector);
    //     mPlace.executeListing(lId);
    // }

    // function testExecutePriceNotMet() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     uint256 lId = mPlace.createListing(l);
    //     switchSigner(userB);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             NFTMarket.PriceNotMet.selector,
    //             l.price - 0.9 ether
    //         )
    //     );
    //     mPlace.executeListing{value: 0.9 ether}(lId);
    // }

    // /*function testExecutePriceNotMet() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     uint256 lId = mPlace.createListing(l);
    //     switchSigner(userB);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //           NFTMarket.PriceNotMet.selector,
    //             l.price - 0.9 ether
    //         )
    //     );
    //     mPlace.executeListing{value: 1.1 ether}(lId);
    // }*/

    // function testExecute() public {
    //     switchSigner(userA);
    //     nft.setApprovalForAll(address(mPlace), true);
    //     l.deadline = uint88(block.timestamp + 120 minutes);
    //     l.sig = constructSig(
    //         l.token,
    //         l.tokenId,
    //         l.price,
    //         l.deadline,
    //         l.lister,
    //         privKeyA
    //     );
    //     uint256 lId = mPlace.createListing(l);
    //     switchSigner(userB);
    //     uint256 userABalanceBefore = userA.balance;

    //     mPlace.executeListing{value: l.price}(lId);

    //    NFTMarket.ListingData memory t = mPlace.getListing(lId);
    //     assertEq(t.price, 0.01 ether);
    //     assertEq(t.active, false);

    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //           NFTMarket.PriceNotMet.selector,
    //             l.price - 0.9 ether
    //         )
    //     );
    //     assertEq(t.active, false);
    //     assertEq(ERC721(l.token).ownerOf(l.tokenId), userB);
    // }
// }

