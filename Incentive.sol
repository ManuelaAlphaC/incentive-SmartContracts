// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./libraries/DataTypes.sol";
import "./libraries/Events.sol";

contract IncentiveHUB is ERC721, ERC721Enumerable, ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    error SoldOut();

    mapping(address => DataTypes.SellerAccount) public _sellers;  // returns all the information of a seller
    mapping(address => DataTypes.BuyerAccount) public _buyers;  // returns all information about a buyer
    mapping(uint256 => DataTypes.specialIncentive) public _specilaIncentives;  // returns all the information of a specific specialIncentive
    mapping(uint256 => DataTypes.Incentive) public _incentive;  // returns all the information of a specific Incentive
    mapping(uint256 => DataTypes.eventIncentive) public _eventIncentives; // returns all the information of a event Incentive
    mapping(address => bool) public _isSeller;  // returns TRUE if the address is owned by the Seller
    mapping(address => bool) public _isBuyer;  // returns TRUE if the address is owned by the Buyer
    mapping(uint256 => bool) public _isActive; // returns TRUE if the event incentive isn't expired


    /******************************** ARRAYS *************************************/
    DataTypes.SellerAccount[] sellers; // returns all Seller accounts
    DataTypes.BuyerAccount[] buyers; // return all Buyer accounts
    DataTypes.specialIncentive[] specialIncentives; // returns all special Incentives
    DataTypes.Incentive[] incentives; // returns all fixed price incentives
    DataTypes.eventIncentive[] eventIncentives; // returns all event Incentives

    constructor() ERC721("IncentiveHUB", "HUB"){}

      /******************* SELLER *************************/
    function createSellerProfile(
        string memory profileImage,
        address seller
    ) public {
        uint256 IdSellerAccount = _tokenIdCounter.current();
        sellers.push(DataTypes.SellerAccount(profileImage, seller, IdSellerAccount));
        _isSeller[seller] = true;
        _tokenIdCounter.increment();
        _mint(seller, IdSellerAccount);
        _setTokenURI(IdSellerAccount, profileImage);

        emit Events.WasCreatedSellerAccount(
            profileImage,
            seller,
            IdSellerAccount
        );
    }

 /******************* INCENTIVE *************************/
    function createSpecialIncentive(
        string memory incentiveURI,
        uint256 price,
        uint256 discount,
        address creator
    ) public payable {
        uint256 IdSpecialIncentive = _tokenIdCounter.current();
        uint256 newprice = price - (price * (discount/100));
        uint256 save = price * (discount/100);
        require(msg.value > save, "Insufficient funds!");
        specialIncentives.push(DataTypes.specialIncentive(incentiveURI, price, discount, IdSpecialIncentive, creator));
        _tokenIdCounter.increment();
        _mint(msg.sender, IdSpecialIncentive);
        _setTokenURI(IdSpecialIncentive, incentiveURI);

        emit Events.WasCreatedSpecialIncentive(
            incentiveURI,
            price,
            discount,
            IdSpecialIncentive,
            creator,
            newprice,
            save 
        );
    }

    function createIncentive(
        string memory incentiveURI,
        uint256 price,
        address creator
    ) public payable  {
        uint256 IdIncentive = _tokenIdCounter.current();
        require(msg.value > price, "Insufficient funds!");
        incentives.push(DataTypes.Incentive(incentiveURI, price, IdIncentive, creator));
        _tokenIdCounter.increment();
        _mint(msg.sender, IdIncentive);
        _setTokenURI(IdIncentive, incentiveURI);

        emit Events.WasCreatedIncentive(
            incentiveURI,
            price,
            IdIncentive,
            creator
        );
    }

    function createEventIncentive(
        string memory eventIncentiveImage,
        uint256 expiration,
        uint256 price,
        address creator
    ) public payable {
        uint256 IdEventIncentive = _tokenIdCounter.current();
        require(msg.value > price, "Insufficient funds!");
        if(expiration < block.timestamp) {
            eventIncentives.push(DataTypes.eventIncentive(eventIncentiveImage, expiration, price, IdEventIncentive, creator));
            _isActive[IdEventIncentive] = true;
            _tokenIdCounter.increment();
            _mint(msg.sender, IdEventIncentive);
            _setTokenURI(IdEventIncentive, eventIncentiveImage);
        } else {
            revert SoldOut();
        }
        emit Events.WasCreatedEventIncentive(
                eventIncentiveImage,
                expiration, 
                price, 
                IdEventIncentive, 
                creator
        );
    }

 /******************************** BUYER *********************************/
    function createBuyerAccount(
        string memory profileImage,
        address buyer
    ) public {
        uint256 IdBuyerAccount = _tokenIdCounter.current();
        buyers.push(DataTypes.BuyerAccount(profileImage, buyer, IdBuyerAccount));
        _isBuyer[buyer] = true;
        _tokenIdCounter.increment();
        _mint(buyer, IdBuyerAccount);
        _setTokenURI(IdBuyerAccount, profileImage);

        emit Events.WasCreatedBuyerAccount(
            profileImage,
            buyer,
            IdBuyerAccount 
        );
    }


 /************************** GET FUNCTIONS *********************************/

  // returns all Seller Accounts
    function getSellersAccounts() public view returns(DataTypes.SellerAccount[] memory) {
        return sellers;
    }

  // return all Buyer Accounts
    function getBuyersAccounts() public view returns(DataTypes.BuyerAccount[] memory) {
        return buyers;
    }

  // returns all fixed price Incentives
    function getIncentives() public view returns(DataTypes.Incentive[] memory) {
        return incentives;
    }
  
  // returns all discounted Incentives
    function getSpecialIncentives() public view returns(DataTypes.specialIncentive[] memory) {
        return specialIncentives;
    }

 /**********************************************************************/
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override (ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool){
        return super.supportsInterface(interfaceId);
    }
}