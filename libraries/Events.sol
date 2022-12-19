// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

library Events {
    
    event WasCreatedSellerAccount(
        uint256 indexed IdAccount,
        string profileImage,
        address indexed seller
    );

    event WasCreatedBuyerAccount(
        uint256 indexed IdAccount,
        string profileImage,
        address indexed buyer
    );

    event WasCreatedSpecialIncentive(
        uint256 indexed IdIncentive,
        address indexed creator,
        string incentiveURI,
        uint256 price,
        uint256 discount,
        uint256 newprice,
        uint256 save
    );

    event WasCreatedIncentive(
        uint256 indexed IdIncentive,
        address indexed creator,
        string incentiveURI,
        uint256 price
    );

}