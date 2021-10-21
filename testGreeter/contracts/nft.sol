pragma solidity 0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";
// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint private seed;
// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 100 100'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='white' />";
  // string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 8 8"><rect fill="#c03b27" x="2" y="0" width="4" height="1" /> <rect fill="#c03b27" x="0" y="1" width="7" height="6" /> <rect fill="#c03b27" x="1" y="7" width="5" height="1" /> <rect fill="#f3d097" x="1" y="3" width="5" height="2" /> <rect fill="#f3d097" x="1" y="5" width="1" height="1" /> <rect fill="#f3d097" x="5" y="5" width="1" height="1" /> <rect fill="#f3d097" x="2" y="6" width="3" height="1" />';
  // string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["phlebotinum", "oxygen", "magic", "merry", "fill", "water"];
  string[] secondWords = ["micrphone", "book", "headset", "controller", "mouse", "keyboard"];
  string[] thirdWords = ["figure", "pin", "marvelous", "stars", "circle", "square"];

  // int[] size = [1,2,3,4,5,6,7,8];
  // string person = '<rect fill="#c03b27" x="2" y="0" width="4" height="1" /> <rect fill="#c03b27" x="0" y="1" width="7" height="6" /> <rect fill="#c03b27" x="1" y="7" width="5" height="1" /> <rect fill="#f3d097" x="1" y="3" width="5" height="2" /> <rect fill="#f3d097" x="1" y="5" width="1" height="1" /> <rect fill="#f3d097" x="5" y="5" width="1" height="1" /> <rect fill="#f3d097" x="2" y="6" width="3" height="1" />';
  string[] rectangles = ['<rect fill="#c4dc98" x="0" y="1" width="2" height="1" /> ','<rect fill="#1F7F0A" x="1" y="0" width="3" height="2" /> ','<rect fill="#dec51c" x="6" y="0" width="3" height="1" /> ','<rect fill="#ffffff" x="5" y="1" width="2" height="13" /> ','<rect fill="#e7e7e7" x="7" y="61" width="4" height="23" /> ','<rect fill="#857EAB" x="7" y="3" width="4" height="23" /> ','<rect fill="#c4dc98" x="8" y="0" width="5" height="15" /> ','<rect fill="#07ccf9" x="0" y="0" width="31" height="1" /> ','<rect fill="#66ba7b" x="0" y="1" width="2" height="1" /> ','<rect fill="#ffffff" x="7" y="5" width="3" height="2" /> ','<rect fill="#dec51c" x="3" y="5" width="3" height="3" />  ','<rect fill="#c4dc98" x="10" y="11" width="12" height="11" /> ','<rect fill="#1F7F0A" x="11" y="10" width="13" height="12" /> ','<rect fill="#66ba7b" x="31" y="21" width="31" height="12" /> ','<rect fill="#9603db" x="13" y="31" width="14" height="12" /> ','<rect fill="#07ccf9" x="15" y="12" width="11" height="31" /> ','<rect fill="#5d712f" x="12" y="51" width="12" height="21" /> ','<rect fill="#719843" x="13" y="31" width="31" height="12" /> ','<rect fill="#24bab5" x="15" y="13" width="13" height="12" /> ','<rect fill="#000000" x="16" y="13" width="12" height="31" /> ','<rect fill="#dec51c" x="61" y="10" width="13" height="11" /> ','<rect fill="#ffffff" x="51" y="11" width="21" height="11" /> ','<rect fill="#e7e7e7" x="71" y="11" width="41" height="21" /> ','<rect fill="#857EAB" x="17" y="13" width="41" height="12" /> ','<rect fill="#c4dc98" x="18" y="10" width="15" height="11" /> ','<rect fill="#07ccf9" x="10" y="10" width="11" height="11" /> ','<rect fill="#c4dc98" x="10" y="11" width="21" height="11" /> ','<rect fill="#857EAB" x="10" y="10" width="11" height="11" /> ','<rect fill="#66ba7b" x="10" y="11" width="12" height="1" /> ','<rect fill="#ffffff" x="71" y="15" width="13" height="12" /> ','<rect fill="#dec51c" x="31" y="51" width="31" height="31" />','<rect fill="#dec51c" x="63" y="56" width="63" height="63" /> <rect fill="#857EAB" x="90" y="19" width="19" height="91" /> ','<rect fill="#c4dc98" x="18" y="81" width="82" height="18" /> ','<rect fill="#1F7F0A" x="71" y="17" width="16" height="62" /> ','<rect fill="#f80632" x="62" y="16" width="72" height="81" /> ','<rect fill="#66ba7b" x="41" y="61" width="31" height="72" /> ','<rect fill="#9603db" x="63" y="36" width="64" height="16" /> ','<rect fill="#07ccf9" x="15" y="12" width="51" height="34" /> ','<rect fill="#5d712f" x="42" y="51" width="42" height="21" /> ','<rect fill="#719843" x="33" y="81" width="71" height="72" /> ','<rect fill="#24bab5" x="65" y="16" width="63" height="62" /> ','<rect fill="#857EAB" x="50" y="90" width="41" height="31" /> ','<rect fill="#000000" x="76" y="53" width="52" height="31" /> ','<rect fill="#dec51c" x="61" y="19" width="93" height="91" /> ','<rect fill="#ffffff" x="91" y="91" width="21" height="14" /> ','<rect fill="#857EAB" x="40" y="14" width="41" height="14" /> ','<rect fill="#e7e7e7" x="75" y="51" width="31" height="14" /> ','<rect fill="#857EAB" x="67" y="53" width="71" height="2" /> ','<rect fill="#c4dc98" x="84" y="50" width="1" height="11" /> ','<rect fill="#07ccf9" x="90" y="70" width="75" height="2" /> ','<rect fill="#c4dc98" x="40" y="61" width="21" height="5" /> ','<rect fill="#857EAB" x="56" y="85" width="54" height="4" /> ','<rect fill="#66ba7b" x="48" y="91" width="52" height="8" /> ','<rect fill="#ffffff" x="75" y="17" width="43" height="2" /> ','<rect fill="#dec51c" x="91" y="91" width="11" height="3" />'];
  // We need to pass the name of our NFTs token and it's symbol.
event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("OrbWgeorgio", "ORBGEORGIO") {
    console.log("This is my NFT contract. Woah!");
  }

function makeSquare() public returns (string memory){
  for (uint256 i = 0; i < rectangles.length; i++) {
        uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp))) % (rectangles.length - i);
        string memory temp = rectangles[n];
        rectangles[n] = rectangles[i];
        rectangles[i] = temp;
    }
  string memory finalString = '';
  // uint randomNumberForMakeSquare = uint(block.difficulty + block.timestamp + seed) % rectangles.length +1;
    for (uint256 i = 0; i < 12; i++) {
      finalString = string(abi.encodePacked(finalString, " ", rectangles[i]));
    }
return string(abi.encodePacked(finalString));
}
  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }
function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return _tokenIds.current();
    }
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }
    function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    
    string memory combinedWord = string(abi.encodePacked(first, second, third));
string memory theSquareFunc = makeSquare();

    // string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    string memory finalSvg = string(abi.encodePacked(baseSvg, theSquareFunc, "</svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
    
  }
}