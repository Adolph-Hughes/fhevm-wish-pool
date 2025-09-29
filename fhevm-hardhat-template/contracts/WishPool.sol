// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {FHE, euint256} from "@fhevm/solidity/lib/FHE.sol";
import {SepoliaConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title FHE Wish Pool Contract
/// @author Zama FHEVM Template
/// @notice A wish-making pool where users can make encrypted wishes with payment
contract WishPool is SepoliaConfig {
    struct Wish {
        address maker;
        uint256 wishId;        // Public ID
        uint256 timestamp;     // Public timestamp
        uint256 amount;        // Public amount paid
        bytes encryptedWish;   // Encrypted wish content handle (bytes)
    }

    mapping(address => Wish[]) public userWishes;
    mapping(uint256 => Wish) public allWishes;
    uint256 public totalWishes;
    uint256 public constant WISH_FEE = 0.001 ether;

    event WishMade(address indexed maker, uint256 indexed wishId, uint256 amount);
    event WishDecrypted(address indexed maker, uint256 indexed wishId);

    /// @notice Make a wish with payment and encrypted content
    /// @param encryptedWish The encrypted wish text handle from frontend
    function makeWish(bytes calldata encryptedWish) external payable {
        require(msg.value >= WISH_FEE, "Insufficient payment for wish");

        totalWishes++;

        // Create wish data (public fields are not encrypted, only wish content)
        Wish memory newWish = Wish({
            maker: msg.sender,
            wishId: totalWishes,           // Public ID
            timestamp: block.timestamp,    // Public timestamp
            amount: msg.value,             // Public amount
            encryptedWish: encryptedWish   // Encrypted content
        });

        // Store in user's wishes
        userWishes[msg.sender].push(newWish);
        allWishes[totalWishes] = newWish;

        // Set explicit ACL for the encrypted wish content
        // Note: In FHEVM, when encrypted data is created via createEncryptedInput,
        // the creator automatically gets access. But when passed to contract,
        // we may need to ensure ACL is properly maintained.

        emit WishMade(msg.sender, totalWishes, msg.value);
    }

    /// @notice Get the number of wishes made by a user
    /// @param user The address to query
    function getUserWishCount(address user) external view returns (uint256) {
        return userWishes[user].length;
    }

    /// @notice Get wish data by ID
    /// @param wishId The wish ID to query
    function getWish(uint256 wishId) external view returns (
        address maker,
        uint256 id,
        uint256 timestamp,
        uint256 amount,
        bytes memory encryptedWish
    ) {
        require(wishId > 0 && wishId <= totalWishes, "Invalid wish ID");
        Wish memory wish = allWishes[wishId];
        return (wish.maker, wish.wishId, wish.timestamp, wish.amount, wish.encryptedWish);
    }

    /// @notice Get total wishes count
    function getTotalWishes() external view returns (uint256) {
        return totalWishes;
    }

    /// @notice Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Withdraw accumulated fees (only owner - in production add access control)
    function withdrawFees() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
