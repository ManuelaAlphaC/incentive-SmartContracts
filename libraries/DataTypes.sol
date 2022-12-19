// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

library DataTypes {
    /**
  * @notice The data needed to create a seller account
  * 
  * @param profileImage Profile image of the Seller
  * @param seller The address of the owner of this profile coincides with the sender
  * @param IdAccount The account Id
  */
    struct SellerAccount{
        string profileImage;
        address seller;
        uint256 IdAccount;
    }

 /**
  * @notice The data needed to create a seller account
  * 
  * @param profileImage Profile image of the Buyer
  * @param buyer The address of the owner of this profile coincides with the sender
  * @param IdAccount The account Id
  */
    struct BuyerAccount{
        string profileImage;
        address buyer;
        uint256 IdAccount;
    }

 /**
  * @notice Incentive to which a discount is applied
  * 
  * @param incentiveURI Image/video representing the incentive
  * @param price The starting price of the incentive --> da spostare nello SC marketplace
  * @param discount The discount to be applied to the incentive, without percentage 20 = 20% --> da spostare nello SC marketplace
  * @param IdIncentive The account Id
  * @param creator The address of the seller account and must coincide with the sender
  */
    struct specialIncentive{
        string incentiveURI;
        uint256 price;
        uint256 discount;
        uint256 IdIncentive;
        address creator;
    }

 /**
  * @notice Incentive with fixed price
  * 
  * @param incentiveURI Image/video representing the incentive
  * @param price The fixed price of the incentive --> da spostare nello SC marketplace
  * @param IdIncentive The account Id
  * @param creator The address of the creator account and must coincide with the seller
  */
    struct Incentive {
        string incentiveURI;
        uint256 price;
        uint256 IdIncentive;
        address creator;
    }

}