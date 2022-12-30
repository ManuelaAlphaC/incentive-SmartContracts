// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

library Events {
    
    event WasCreatedSellerAccount(
        string profileImage,
        address indexed seller,
        uint256 indexed IdSellerAccount
    );

    event WasCreatedBuyerAccount(
        string profileImage,
        address indexed buyer,
        uint256 indexed IdBuyerAccount
    );

    event WasCreatedSpecialIncentive(
        string incentiveURI,
        uint256 price,
        uint256 discount,
        uint256 indexed IdSpecialIncentive,
        address indexed creator,
        uint256 newprice,
        uint256 save,
        bool paid
    );

    event WasCreatedIncentive(
        string incentiveURI,
        uint256 price,
        uint256 indexed IdIncentive,
        address indexed creator,
        bool paid
    );

    event WasCreatedEventIncentive(
        string eventIncentiveImage,
        uint256 expiration,
        uint256 price,
        uint256 indexed IdEventIncentive,
        address indexed creator,
        bool paid
    );

}