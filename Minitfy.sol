// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";

/**
 * @title Mintify
 * @dev This contract implements an ERC721 token with minting functionality.
 * It allows users to mint NFTs by paying a specified price per token.
 * The contract also supports whitelisting functionality, where whitelisted users can mint tokens at a different price.
 * The contract owner can set various parameters such as the base URI, mint price, whitelist price, maximum supply, and maximum tokens per wallet.
 */
contract Mintify is ERC721, Ownable {
    // State variables
    uint256 public totalMints = 0;
    uint256 public mintPrice = 10000 wei;
    uint public whitelistPrice = 50000 wei;
    uint256 public maxSupply = 10;
    uint256 public maxPerWallet = 2;

    string public baseURI;

    mapping(address => uint256) public walletMints;
    mapping(address => bool) public whitelisted;

    /**
     * @dev Constructor function
     * @param _name The name of the ERC721 token
     * @param _symbol The symbol of the ERC721 token
     * @param _initBaseURI The initial base URI for token metadata
     */
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) {
        require(
            bytes(_name).length > 0 && bytes(_name).length <= 50,
            "Invalid name length"
        );
        require(
            bytes(_symbol).length > 0 && bytes(_symbol).length <= 10,
            "Invalid symbol length"
        );
        require(bytes(_initBaseURI).length > 0, "Invalid base URI");
        setURI(_initBaseURI);
    }

    /**
     * @dev Internal function to get the base URI for token metadata
     * @return The base URI string
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev Mints a token and assigns it to the specified address
     * @param to The address to mint the token to
     */
    function safeMint(address to) public onlyOwner {
        require(totalMints < maxSupply, "All NFTs are minted");
        _safeMint(to, totalMints);
        totalMints += 1;
    }

    /**
     * @dev Mints multiple tokens based on the specified quantity
     * @param _quantity The quantity of tokens to mint
     */
    function mintToken(uint256 _quantity) public payable {
        require(_quantity > 0, "Quantity must be greater than zero");
        if (whitelisted[msg.sender] == true) {
            require(
                _quantity * whitelistPrice == msg.value,
                "Wrong amount sent"
            );
        } else {
            require(_quantity * mintPrice == msg.value, "Wrong amount sent");
        }
        require(
            walletMints[msg.sender] + _quantity <= maxPerWallet,
            "Mints per wallet exceeded"
        );
        require(_quantity + totalMints < maxSupply, "Insufficient NFTs");

        walletMints[msg.sender] += _quantity;
        for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(msg.sender, totalMints);
            totalMints += 1;
        }
    }

    /**
     * @dev Sets the base URI for token metadata
     * @param uri The new base URI string
     */
    function setURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    /**
     * @dev Adds a user to the whitelist
     * @param _user The address of the user to be whitelisted
     */
    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    /**
     * @dev Removes a user from the whitelist
     * @param _user The address of the user to be removed from the whitelist
     */
    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    /**
     * @dev Sets the mint price for tokens
     * @param _mintPrice The new mint price
     */
    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    /**
     * @dev Sets the whitelist price for tokens
     * @param _whitelistPrice The new whitelist price
     */
    function setWhitelistPrice(uint256 _whitelistPrice) public onlyOwner {
        whitelistPrice = _whitelistPrice;
    }

    /**
     * @dev Sets the maximum supply of tokens
     * @param _maxSupply The new maximum supply
     */
    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    /**
     * @dev Sets the maximum tokens per wallet
     * @param _maxPerWallet The new maximum tokens per wallet
     */
    function setMaxPerWallet(uint256 _maxPerWallet) public onlyOwner {
        maxPerWallet = _maxPerWallet;
    }

    /**
     * @dev Allows the contract owner to withdraw the contract balance
     */
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /**
     * @dev Gets the number of tokens minted by the caller's wallet
     * @return The number of tokens minted by the caller's wallet
     */
    function getMyWalletMints() public view returns (uint256) {
        return walletMints[msg.sender];
    }

    /**
     * @dev Gets the total amount of Ether held by the contract
     * @return The total amount of Ether held by the contract
     */
    function getTotalAmount() public view returns (uint256) {
        return address(this).balance;
    }
}
