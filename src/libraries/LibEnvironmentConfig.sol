// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibEnvironment} from "../../lib/cu-osc-common/src/libraries/LibEnvironment.sol";

import {LibShadowcorn} from "./LibShadowcorn.sol";
import {LibHatching} from "./LibHatching.sol";
import {LibNames} from "./LibNames.sol";
import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";
import {LibStats} from "./LibStats.sol";

library LibEnvironmentConfig {
    // address gameBank, address unim, address rbw, address terminus
    function configureProject(
        address vrfClientWallet,
        uint16 blocksToRespond
    ) internal {
        LibERC721.erc721Storage().name = "Crypto Unicorns: Shadowcorns";
        LibERC721.erc721Storage().symbol = "SHADOWCORN";
        LibERC721
            .erc721Storage()
            .contractURI = "https://arweave.net/HNvtS6fber4NC80_sEd0MAiUr7UyA3R4GpEFFqyRZAk";
        LibERC721
            .erc721Storage()
            .licenseURI = "https://arweave.net/520gStGJ4Fla9GeG0U9UIm1vYnei8dOnDfznCaJy0IY";

        LibHatching.setHatchingCosts(
            10000000000000000000, //  10 CU (100 RBW)
            10000000000000000000000 //  10,000 UNIM
        );

        LibShadowcorn.shadowcornStorage().targetDNAVersion = 1;
        LibShadowcorn.shadowcornStorage().commonEggPoolId = 1;
        LibShadowcorn.shadowcornStorage().rareEggPoolId = 2;
        LibShadowcorn.shadowcornStorage().mythicEggPoolId = 3;

        LibStats.initializeData();

        // RNG initialization
        LibRNG.rngStorage().supraClientWallet = vrfClientWallet;
        LibRNG.rngStorage().blocksToRespond = blocksToRespond;
    }

    function loadContent() internal {
        configureNFTImages();
        loadFirstNames();
        loadLastNames();
    }

    function configureNFTImages() internal {
        //  Fire
        LibShadowcorn.shadowcornStorage().shadowcornImage[1][
            1
        ] = "https://arweave.net/k0YZHFW0K1MIBTRFHC-Y-CYJHMV8tngrJSL4lXhvNgA";
        LibShadowcorn.shadowcornStorage().shadowcornImage[1][
            2
        ] = "https://arweave.net/EHtorB5YKBuARjE_cEtHTbGsjLDorXobbTHh9hpMNyI";
        LibShadowcorn.shadowcornStorage().shadowcornImage[1][
            3
        ] = "https://arweave.net/H75TfJyT-poVsx0fxJmSxRyOVIcoJQFErLz-qJdsv7I";

        //  Slime
        LibShadowcorn.shadowcornStorage().shadowcornImage[2][
            1
        ] = "https://arweave.net/eGk_PrhDsErxkxjsREDInRYgPLwIGuZCeYhFnKOIKJw";
        LibShadowcorn.shadowcornStorage().shadowcornImage[2][
            2
        ] = "https://arweave.net/KJwypo7T3FX6G9xAnkV1paQJslj7g2cNcL8pwrSxHhQ";
        LibShadowcorn.shadowcornStorage().shadowcornImage[2][
            3
        ] = "https://arweave.net/vKVSHaaEWzU82fVjORTH-EOpU7szcNr5-rX0DiKKlM4";

        //  Volt
        LibShadowcorn.shadowcornStorage().shadowcornImage[3][
            1
        ] = "https://arweave.net/16zaHmtg1-P3WVMwUbVzcrO7tKnInIXPDkFJtQPU2ik";
        LibShadowcorn.shadowcornStorage().shadowcornImage[3][
            2
        ] = "https://arweave.net/GjQgAbekiVZWPHWVfhLrI3EQxHavEhYYZiSUuVUzpGQ";
        LibShadowcorn.shadowcornStorage().shadowcornImage[3][
            3
        ] = "https://arweave.net/0Ei7Pjp-f6eeBEOaZPCNoyBgg4T89qfIX0VcseiAh_4";

        //  Soul
        LibShadowcorn.shadowcornStorage().shadowcornImage[4][
            1
        ] = "https://arweave.net/sTcwcrlzrHBOh2QY9dHo2MNev1mEuycJeBLs-6yP-iI";
        LibShadowcorn.shadowcornStorage().shadowcornImage[4][
            2
        ] = "https://arweave.net/o-O6U7r86A0FTk1N-5E9Eb1P0ErsiH7zIe3_HrsZ-j0";
        LibShadowcorn.shadowcornStorage().shadowcornImage[4][
            3
        ] = "https://arweave.net/8k-dupLqRauWoE_Kj5NH0dsyJHN3N5mzKjESl7dql1o";

        //  Nebula
        LibShadowcorn.shadowcornStorage().shadowcornImage[5][
            1
        ] = "https://arweave.net/FkMyMACA8qaJe8ZE7r007s14vhtoA4XD30zPtr7PDj0";
        LibShadowcorn.shadowcornStorage().shadowcornImage[5][
            2
        ] = "https://arweave.net/50OgI8izh3plQtZSfGdH4Ajg2Jra02shNdOnJ2W0oX4";
        LibShadowcorn.shadowcornStorage().shadowcornImage[5][
            3
        ] = "https://arweave.net/iRbNewXcfFmDPccCJ1sqPjECNoPOAdKSieFV6phubO0";
    }

    function loadFirstNames() internal {
        LibNames.NamesStorage storage ns = LibNames.namesStorage();
        ns.firstNamesList[1] = "Ageless";
        ns.firstNamesList[2] = "Anthracite";
        ns.firstNamesList[3] = "Asbestos";
        ns.firstNamesList[4] = "Awful";
        ns.firstNamesList[5] = "Babyface";
        ns.firstNamesList[6] = "Baleful";
        ns.firstNamesList[7] = "Barbed Foot";
        ns.firstNamesList[8] = "Battleborn";
        ns.firstNamesList[9] = "BBEG";
        ns.firstNamesList[10] = "Bear Market";
        ns.firstNamesList[11] = "Bellicose";
        ns.firstNamesList[12] = "Bizarro";
        ns.firstNamesList[13] = "Black Fire";
        ns.firstNamesList[14] = "Black Magic";
        ns.firstNamesList[15] = "Black Maw";
        ns.firstNamesList[16] = "Blackhearted";
        ns.firstNamesList[17] = "Blister Eyed";
        ns.firstNamesList[18] = "Blood Moon";
        ns.firstNamesList[19] = "Bulldozer";
        ns.firstNamesList[20] = "Cassanova";
        ns.firstNamesList[21] = "Chill";
        ns.firstNamesList[22] = "Crass";
        ns.firstNamesList[23] = "Creeping";
        ns.firstNamesList[24] = "Crimson";
        ns.firstNamesList[25] = "Cruel";
        ns.firstNamesList[26] = "Cursed";
        ns.firstNamesList[27] = "Dark";
        ns.firstNamesList[28] = "Darth";
        ns.firstNamesList[29] = "Delinquent";
        ns.firstNamesList[30] = "Derelict";
        ns.firstNamesList[31] = "Dismal";
        ns.firstNamesList[32] = "Doubting";
        ns.firstNamesList[33] = "Dread";
        ns.firstNamesList[34] = "Dreadlord";
        ns.firstNamesList[35] = "Dusk";
        ns.firstNamesList[36] = "Eldritch";
        ns.firstNamesList[37] = "Eternal";
        ns.firstNamesList[38] = "Fallen";
        ns.firstNamesList[39] = "Fearful";
        ns.firstNamesList[40] = "Fetid";
        ns.firstNamesList[41] = "Fiendish";
        ns.firstNamesList[42] = "Footloose";
        ns.firstNamesList[43] = "Forgotten";
        ns.firstNamesList[44] = "Forsaken";
        ns.firstNamesList[45] = "Foul";
        ns.firstNamesList[46] = "Ghastly";
        ns.firstNamesList[47] = "Ghoulish";
        ns.firstNamesList[48] = "Gnarles";
        ns.firstNamesList[49] = "Gothic";
        ns.firstNamesList[50] = "Grape Flavored";
        ns.firstNamesList[51] = "Grim";
        ns.firstNamesList[52] = "Grizzlejaw";
        ns.firstNamesList[53] = "Grizzly";
        ns.firstNamesList[54] = "Grouchy";
        ns.firstNamesList[55] = "Gunmetal";
        ns.firstNamesList[56] = "Hidden";
        ns.firstNamesList[57] = "Hidebehind";
        ns.firstNamesList[58] = "Hipster";
        ns.firstNamesList[59] = "Impermanent";
        ns.firstNamesList[60] = "Impermanent Loss";
        ns.firstNamesList[61] = "Inky";
        ns.firstNamesList[62] = "Inside Out";
        ns.firstNamesList[63] = "Irredeemable";
        ns.firstNamesList[64] = "Lurking";
        ns.firstNamesList[65] = "Macabre";
        ns.firstNamesList[66] = "Malformed";
        ns.firstNamesList[67] = "Malicious";
        ns.firstNamesList[68] = "Malodorous";
        ns.firstNamesList[69] = "Menacing";
        ns.firstNamesList[70] = "Mournful";
        ns.firstNamesList[71] = "Nocturnal";
        ns.firstNamesList[72] = "Oil Claw";
        ns.firstNamesList[73] = "Ominous";
        ns.firstNamesList[74] = "Onyx";
        ns.firstNamesList[75] = "Paper Handed";
        ns.firstNamesList[76] = "Phantom";
        ns.firstNamesList[77] = "Proof of Evil";
        ns.firstNamesList[78] = "Protean";
        ns.firstNamesList[79] = "Razor Knees";
        ns.firstNamesList[80] = "Rotten";
        ns.firstNamesList[81] = "Rouge";
        ns.firstNamesList[82] = "Scarred";
        ns.firstNamesList[83] = "Scathing";
        ns.firstNamesList[84] = "Shrouded";
        ns.firstNamesList[85] = "Sinister";
        ns.firstNamesList[86] = "Smoke Mane";
        ns.firstNamesList[87] = "Snake Tongue";
        ns.firstNamesList[88] = "Soulless";
        ns.firstNamesList[89] = "Spider Eyes";
        ns.firstNamesList[90] = "Tentacle Prince";
        ns.firstNamesList[91] = "Twisted";
        ns.firstNamesList[92] = "Umbral";
        ns.firstNamesList[93] = "Uncertain";
        ns.firstNamesList[94] = "Uncouth";
        ns.firstNamesList[95] = "Undead";
        ns.firstNamesList[96] = "Undying";
        ns.firstNamesList[97] = "Unkempt";
        ns.firstNamesList[98] = "Unknown";
        ns.firstNamesList[99] = "Unpleasant";
        ns.firstNamesList[100] = "Unstoppable";
        ns.firstNamesList[101] = "Unwilling";
        ns.firstNamesList[102] = "Vengeful";
        ns.firstNamesList[103] = "Venomous";
        ns.firstNamesList[104] = "Viewtiful";
        ns.firstNamesList[105] = "Visceral";
        ns.firstNamesList[106] = "Viscous";
        ns.firstNamesList[107] = "Widdershins";
        ns.firstNamesList[108] = "Wild Eye";
        ns.firstNamesList[109] = "Wisp Light";
        ns.firstNamesList[110] = "Wraith Form";
        ns.firstNamesList[111] = "Wretched";
        ns.firstNamesList[112] = "Wry";

        for (uint256 i = 1; i < 112; ++i) {
            ns.validFirstNames.push(i);
        }
    }

    function loadLastNames() internal {
        LibNames.NamesStorage storage ns = LibNames.namesStorage();
        ns.lastNamesList[1] = "Agonizer";
        ns.lastNamesList[2] = "Ankle Licker";
        ns.lastNamesList[3] = "Arsonist";
        ns.lastNamesList[4] = "Bad-Horse";
        ns.lastNamesList[5] = "Baddie";
        ns.lastNamesList[6] = "Bandwidth Hog";
        ns.lastNamesList[7] = "Battery Licker";
        ns.lastNamesList[8] = "Betrayer";
        ns.lastNamesList[9] = "Blight Bringer";
        ns.lastNamesList[10] = "Bone Masher";
        ns.lastNamesList[11] = "Brain Freezer";
        ns.lastNamesList[12] = "Chaos Blaster";
        ns.lastNamesList[13] = "Chestburster";
        ns.lastNamesList[14] = "Cloud Thief";
        ns.lastNamesList[15] = "Con Artist";
        ns.lastNamesList[16] = "Cornivore";
        ns.lastNamesList[17] = "Crawler";
        ns.lastNamesList[18] = "Creeper";
        ns.lastNamesList[19] = "Crow";
        ns.lastNamesList[20] = "Death Shroud";
        ns.lastNamesList[21] = "DeFiler";
        ns.lastNamesList[22] = "Destructor";
        ns.lastNamesList[23] = "Doomweaver";
        ns.lastNamesList[24] = "Draco";
        ns.lastNamesList[25] = "Dream Burner";
        ns.lastNamesList[26] = "Edgar";
        ns.lastNamesList[27] = "Egg Snatcher";
        ns.lastNamesList[28] = "Fade";
        ns.lastNamesList[29] = "Fate Twister";
        ns.lastNamesList[30] = "Force Pusher";
        ns.lastNamesList[31] = "Franken";
        ns.lastNamesList[32] = "Frankenstein";
        ns.lastNamesList[33] = "Frownikins";
        ns.lastNamesList[34] = "FUD Monger";
        ns.lastNamesList[35] = "Fun Police";
        ns.lastNamesList[36] = "Genestealer";
        ns.lastNamesList[37] = "Glitterthief";
        ns.lastNamesList[38] = "Gloomspinner";
        ns.lastNamesList[39] = "Gnasher";
        ns.lastNamesList[40] = "Grave Robber";
        ns.lastNamesList[41] = "Grendal";
        ns.lastNamesList[42] = "Grief Connoisseur";
        ns.lastNamesList[43] = "Gristle Breath";
        ns.lastNamesList[44] = "Grotesk";
        ns.lastNamesList[45] = "Groucho";
        ns.lastNamesList[46] = "Henchman";
        ns.lastNamesList[47] = "Hoof Boiler";
        ns.lastNamesList[48] = "Hoof Grabber";
        ns.lastNamesList[49] = "Hooligan";
        ns.lastNamesList[50] = "Horn Collector";
        ns.lastNamesList[51] = "Influencer";
        ns.lastNamesList[52] = "Joy Melter";
        ns.lastNamesList[53] = "Joy Skinner";
        ns.lastNamesList[54] = "Kill Stealer";
        ns.lastNamesList[55] = "Knuckle Cracker";
        ns.lastNamesList[56] = "Loin Rustler";
        ns.lastNamesList[57] = "LP Drainer";
        ns.lastNamesList[58] = "Maniac";
        ns.lastNamesList[59] = "Mario";
        ns.lastNamesList[60] = "Market Breaker";
        ns.lastNamesList[61] = "Marshmallow Impaler";
        ns.lastNamesList[62] = "Masher";
        ns.lastNamesList[63] = "Meme Deleter";
        ns.lastNamesList[64] = "Milk Curdler";
        ns.lastNamesList[65] = "Mind Stinger";
        ns.lastNamesList[66] = "Mindthief";
        ns.lastNamesList[67] = "Miscreant";
        ns.lastNamesList[68] = "Muzzle Twister";
        ns.lastNamesList[69] = "Necromancer";
        ns.lastNamesList[70] = "NFT Forger";
        ns.lastNamesList[71] = "Nightmare";
        ns.lastNamesList[72] = "Nocturne";
        ns.lastNamesList[73] = "Nyx";
        ns.lastNamesList[74] = "Oberon";
        ns.lastNamesList[75] = "Osiris";
        ns.lastNamesList[76] = "Ozul";
        ns.lastNamesList[77] = "Party Crasher";
        ns.lastNamesList[78] = "Peg Horn";
        ns.lastNamesList[79] = "Pestilence";
        ns.lastNamesList[80] = "Predator";
        ns.lastNamesList[81] = "Rabobi";
        ns.lastNamesList[82] = "Rager";
        ns.lastNamesList[83] = "Ramsey";
        ns.lastNamesList[84] = "Rarity Sniper";
        ns.lastNamesList[85] = "Rascal";
        ns.lastNamesList[86] = "Ravager";
        ns.lastNamesList[87] = "Raven";
        ns.lastNamesList[88] = "Reaper";
        ns.lastNamesList[89] = "Reckoning";
        ns.lastNamesList[90] = "Rib Poker";
        ns.lastNamesList[91] = "Rift Ambusher";
        ns.lastNamesList[92] = "Rug Puller";
        ns.lastNamesList[93] = "Sand Chewer";
        ns.lastNamesList[94] = "Scallywag";
        ns.lastNamesList[95] = "Screen Toucher";
        ns.lastNamesList[96] = "Serpent";
        ns.lastNamesList[97] = "Shade Strider";
        ns.lastNamesList[98] = "Sight Blinder";
        ns.lastNamesList[99] = "Sinatra";
        ns.lastNamesList[100] = "Skelecorn";
        ns.lastNamesList[101] = "Skin Tickler";
        ns.lastNamesList[102] = "Smile Inverter";
        ns.lastNamesList[103] = "Sneakthief";
        ns.lastNamesList[104] = "Sparkle Annihilator";
        ns.lastNamesList[105] = "Spectre";
        ns.lastNamesList[106] = "Spice Miser";
        ns.lastNamesList[107] = "Spine Stealer";
        ns.lastNamesList[108] = "Steven";
        ns.lastNamesList[109] = "Sun Gobbler";
        ns.lastNamesList[110] = "Sysadmin";
        ns.lastNamesList[111] = "Tail Puller";
        ns.lastNamesList[112] = "Time Bender";
        ns.lastNamesList[113] = "Tokoloshe";
        ns.lastNamesList[114] = "Tooth Cruncher";
        ns.lastNamesList[115] = "Troll";
        ns.lastNamesList[116] = "Tyrant";
        ns.lastNamesList[117] = "Umbra";
        ns.lastNamesList[118] = "Unicorn Conqueror";
        ns.lastNamesList[119] = "Void Caster";
        ns.lastNamesList[120] = "Warlock";
        ns.lastNamesList[121] = "Watcher";
        ns.lastNamesList[122] = "World Ender";
        ns.lastNamesList[123] = "Wrathmonger";
        ns.lastNamesList[124] = "Wren";

        for (uint256 i = 1; i < 124; ++i) {
            ns.validLastNames.push(i);
        }
    }
}
