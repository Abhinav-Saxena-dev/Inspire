// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.9;
 
import "./../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./../node_modules/@openzeppelin/contracts/access/Ownable.sol";
 
contract Inspire is ERC721URIStorage, Ownable {
 
    uint tokenId;
    address[] public entries;
    mapping(address => uint256) public winnings;
 
    event Registered(address indexed user);
    event WinnerChosen(address indexed winner);
 
    string baseUri = "";
 
    constructor() ERC721("Inspire", "ISP") {}
 
    function register() public {
        entries.push(msg.sender);
        emit Registered(msg.sender);
    }

    function getEntries() view public returns(address[] memory) {
        return entries;
    }
 
    function chooseWinner() public onlyOwner {
        require(entries.length > 0, "No entries today :(");
 
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.number, entries.length)
            )
        ) % entries.length;
 
        address winner = entries[randomNumber];
 
        winnings[winner]++;
        _emptyentriesArray();
 
        emit WinnerChosen(winner);
    }
 
    function setBaseUri(string calldata _baseUri) public onlyOwner {
        baseUri = _baseUri;
    }
 
    function claimWinning() public {
        require(winnings[msg.sender] > 0, "No winnings for you");
        winnings[msg.sender]--;
        tokenId++;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, baseUri);
    }
 
    function _emptyentriesArray() internal {
        while(entries.length > 0){
            entries.pop();
        }
    }
}