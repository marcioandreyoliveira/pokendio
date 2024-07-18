// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// See https://eips.ethereum.org/EIPS/eip-721
contract PokenDio is ERC721 {

    uint constant LEVEL_1 = 1;

    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor () ERC721 ("PokenDIO", "PKD") {
        // The one the created the contract is the game owner
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint _monsterId) {
        // The monster owner must be the on that created the transaction
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com esse Pokemon.");
        _;
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) {
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        if (attacker.level > defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons.");

        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, LEVEL_1, _img));
        // Let us create the token
        _safeMint(_to, id);
    }


} 
