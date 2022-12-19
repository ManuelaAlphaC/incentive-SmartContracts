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

    mapping(address => DataTypes.SellerAccount) public _sellers;  // returns all the information of a seller
    mapping(address => DataTypes.BuyerAccount) public _buyers;  // returns all information about a buyer
    mapping(uint256 => DataTypes.specialIncentive) public _specilaIncentives;  // returns all the information of a specific specialIncentive
    mapping(uint256 => DataTypes.Incentive) public _incentive;  // returns all the information of a specific Incentive
    mapping(address => bool) public _isSeller;  // returns TRUE if the address is owned by the Seller
    mapping(address => bool) public _isBuyer;  // returns TRUE if the address is owned by the Buyer


    /******************************** ARRAYS *************************************/
    DataTypes.SellerAccount[] sellers; // returns all Seller accounts
    DataTypes.BuyerAccount[] buyers; // return all Buyer accounts
    DataTypes.specialIncentive[] specialIncentives; // returns all specialIncentives
    DataTypes.Incentive[] incentives; // returns all fixed price incentives

    constructor() ERC721("IncentiveHUB", "HUB"){}

      /******************* SELLER *************************/
    function createSellerProfile(
        string memory profileImage,
        address seller
    ) public {
        uint256 IdAccount = _tokenIdCounter.current();
        sellers.push(DataTypes.SellerAccount(profileImage, seller, IdAccount));
        _isSeller[seller] = true;
        _tokenIdCounter.increment();
        _mint(seller, IdAccount);
        _setTokenURI(IdAccount, profileImage);

        emit Events.WasCreatedSellerAccount(
            IdAccount,
            profileImage,
            seller
        );
    }

 /******************* INCENTIVE *************************/
    function createSpecialIncentive(
        string memory incentiveURI,
        uint256 price,
        uint256 discount,
        address creator
    ) public  {
        uint256 IdIncentive = _tokenIdCounter.current();
        uint256 newprice = price - (price * (discount/100));
        uint256 save = price * (discount/100);
        specialIncentives.push(DataTypes.specialIncentive(incentiveURI, price, discount, IdIncentive, creator));
        _tokenIdCounter.increment();
        _mint(msg.sender, IdIncentive);
        _setTokenURI(IdIncentive, incentiveURI);

        emit Events.WasCreatedSpecialIncentive(
            IdIncentive,
            creator,
            incentiveURI,
            price,
            discount,
            newprice,
            save 
        );
    }

    function createIncentive(
        string memory incentiveURI,
        uint256 price,
        address creator
    ) public  {
        uint256 IdIncentive = _tokenIdCounter.current();
        incentives.push(DataTypes.Incentive(incentiveURI, price, IdIncentive, creator));
        _tokenIdCounter.increment();
        _mint(msg.sender, IdIncentive);
        _setTokenURI(IdIncentive, incentiveURI);

        emit Events.WasCreatedIncentive(
            IdIncentive,
            creator,
            incentiveURI,
            price
        );
    }

 /******************************** BUYER *********************************/
    function createBuyerAccount(
        string memory profileImage,
        address buyer
    ) public {
        uint256 IdAccount = _tokenIdCounter.current();
        buyers.push(DataTypes.BuyerAccount(profileImage, buyer, IdAccount));
        _isBuyer[buyer] = true;
        _tokenIdCounter.increment();
        _mint(buyer, IdAccount);
        _setTokenURI(IdAccount, profileImage);

        emit Events.WasCreatedBuyerAccount(
            IdAccount,
            profileImage,
            buyer 
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