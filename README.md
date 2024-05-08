# Mintify Smart Contract

This Solidity smart contract, named Mintify, implements an ERC721 token with minting functionality. It allows users to mint NFTs by paying a specified price per NFT. The contract also supports whitelisting functionality, where whitelisted users can mint tokens at a different price. The contract owner can set various parameters such as the base URI, mint price, whitelist price, maximum supply, and maximum tokens per wallet.

## Features

- Price tiers for minting: `mintPrice` and `whitelistPrice`
- Maximum supply limit: `maxSupply`
- Maximum mints per wallet limit: `maxPerWallet`
- Base URI for token metadata: `baseURI`
- Whitelist for certain addresses: `whitelisted`

## Functions

- `constructor(string memory _name, string memory _symbol, string memory _initBaseURI, uint256 _maxSupply)`: Constructor for the contract, sets up basic parameters.
- `_baseURI()`: Returns the base URI for token metadata.
- `safeMint(address to)`: Mints an NFT for a specific address (only by contract owner).
- `mintToken(uint256 _quantity)`: Allows a user to mint multiple NFTs.
- `setURI(string memory uri)`: Sets a new base URI for token metadata.
- `whitelistUser(address _user)`: Adds an address to the whitelist.
- `removeWhitelistUser(address _user)`: Removes an address from the whitelist.
- `setMintPrice(uint256 _mintPrice)`: Sets a new price for minting a single NFT.
- `setWhitelistPrice(uint256 _whitelistPrice)`: Sets a new price for minting a single NFT if the user is whitelisted.
- `setMaxSupply(uint256 _maxSupply)`: Sets a new maximum supply limit for NFTs.
- `setMaxPerWallet(uint256 _maxPerWallet)`: Sets a new maximum number of NFTs a user can mint from their wallet.
- `withdraw()`: Allows the contract owner to withdraw all funds from the contract.
- `getMyWalletMints()`: Returns the number of NFTs minted by the sender's address.
- `getTotalAmount()`: Returns the total amount of Ether (in Wei) held by this contract.

## Usage

To use this smart contract, you will need to deploy it on the Ethereum network using a compatible development environment such as Remix or Truffle. Once deployed, you can interact with the contract using its functions.

Here is the sample deployement addresss in sepolia testnet: [0xeC10B858B78BdF4E8c3609e9360e7e9f63387736](https://sepolia.etherscan.io/address/0xec10b858b78bdf4e8c3609e9360e7e9f63387736)
