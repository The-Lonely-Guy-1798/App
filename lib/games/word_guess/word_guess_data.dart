// lib/games/word_guess/word_guess_data.dart

class WordGuessLevel {
  final String word;
  final String hint;
  final List<String>? keyboardLetters; // Optional custom keyboard

  WordGuessLevel({
    required this.word,
    required this.hint,
    this.keyboardLetters,
  });
}

// A list of levels for the game
final wordGuessLevels = [
  WordGuessLevel(
    word: "DART",
    hint: "The language of Flutter",
    keyboardLetters: ["Y", "W", "D", "F", "J", "R", "T", "E", "L", "C", "A", "X", "Z", "K", "Q", "M"],
  ),
  WordGuessLevel(
    word: "GOKU",
    hint: "An alien SAIYAN raised on Earth who constantly seeks to become the strongest fighter",
    keyboardLetters: ["M", "J", "H", "K", "B", "W", "U", "G", "L", "O", "Y", "A", "C", "X", "T", "V"],
  ),
  WordGuessLevel(
    word: "ATOM",
    hint: "The basic unit of a chemical element.",
    keyboardLetters: ["H", "Y", "Z", "R", "M", "T", "L", "K", "D", "O", "N", "P", "J", "A", "Q", "S"],
  ),
  WordGuessLevel(
    word: "THOR",
    hint: "A Norse god of thunder and a Marvel superhero.",
    keyboardLetters: ["T", "P", "R", "U", "I", "B", "K", "W", "E", "F", "C", "H", "S", "O", "M", "Q"],
  ),
  WordGuessLevel(
    word: "NOVEL",
    hint: "A long work of narrative fiction",
    keyboardLetters: ["F", "E", "B", "U", "C", "X", "Z", "O", "N", "M", "J", "T", "V", "Y", "W", "L"],
  ),
  WordGuessLevel(
    word: "PLUTO",
    hint: "A dwarf planet in the Kuiper belt.",
    keyboardLetters: ["G", "Z", "U", "P", "C", "M", "I", "N", "T", "L", "V", "S", "D", "Y", "O", "Q"],
  ),
  WordGuessLevel(
    word: "TESLA",
    hint: "Electric vehicle company founded by Elon Musk.",
    keyboardLetters: ["R", "F", "O", "Y", "S", "C", "N", "E", "V", "K", "X", "D", "A", "Z", "T", "L"],
  ),
  WordGuessLevel(
    word: "APPLE",
    hint: "A fruit and a tech company",
    keyboardLetters: ["H", "E", "M", "X", "A", "O", "Q", "T", "S", "L", "W", "P", "B", "U", "I", "Z"],
  ),
  WordGuessLevel(
    word: "MATRIX",
    hint: "Sci-fi film about simulated reality.",
    keyboardLetters: ["W", "Q", "A", "T", "I", "R", "G", "M", "P", "D", "B", "H", "Y", "Z", "F", "X"],
  ),
  WordGuessLevel(
    word: "PLAYER",
    hint: "A person taking part in a game",
    keyboardLetters: ["T", "I", "B", "R", "N", "M", "Z", "L", "Y", "Q", "C", "D", "F", "E", "A", "P"],
  ),
  WordGuessLevel(
    word: "KARMA",
    hint: "Belief in action and consequences.",
    keyboardLetters: ["I", "C", "H", "M", "B", "K", "E", "W", "L", "D", "G", "A", "R", "U", "Z", "V"],
  ),
  WordGuessLevel(
    word: "LEVI",
    hint: "Humanity's strongest soldier in the fight against Titans",
    keyboardLetters: ["L", "Z", "I", "U", "C", "D", "N", "S", "G", "V", "Q", "K", "E", "P", "J", "A"],
  ),
  WordGuessLevel(
    word: "JUDAS",
    hint: "The apostle who betrayed Jesus to the authorities for thirty pieces of silver",
    keyboardLetters: ["S", "A", "J", "T", "D", "O", "M", "G", "U", "Z", "P", "L", "C", "V", "F", "E"],
  ),
  WordGuessLevel(
    word: "DRAGON",
    hint: "A mythical fire-breathing creature.",
    keyboardLetters: ["B", "X", "J", "I", "Z", "D", "W", "F", "N", "T", "Y", "A", "O", "G", "S", "R"],
  ),
  WordGuessLevel(
    word: "SHIVA",
    hint: "Hindu god known as the destroyer.",
    keyboardLetters: ["B", "A", "H", "P", "D", "N", "I", "Y", "G", "X", "S", "V", "Q", "W", "E", "O"],
  ),
  WordGuessLevel(
    word: "PETRA",
    hint: "The Rose City of Jordan, famous for its treasury carved directly into rock",
    keyboardLetters: ["J", "A", "D", "N", "B", "L", "U", "I", "R", "T", "E", "H", "F", "W", "K", "P"],
  ),
  WordGuessLevel(
    word: "DURGA",
    hint: "Warrior goddess who defeats evil.",
    keyboardLetters: ["L", "Z", "F", "U", "H", "Y", "C", "V", "D", "P", "J", "R", "X", "Q", "A", "G"],
  ),
  WordGuessLevel(
    word: "KERALA",
    hint: "Known as Gods Own Country, this Indian state is famous for its backwaters",
    keyboardLetters: ["O", "H", "J", "L", "K", "S", "N", "E", "R", "T", "B", "A", "V", "M", "U", "I"],
  ),
  WordGuessLevel(
    word: "CRYPTO",
    hint: "Digital or virtual currency",
    keyboardLetters: ["Z", "R", "W", "T", "Y", "O", "P", "L", "B", "A", "C", "F", "G", "U", "J", "Q"],
  ),
  WordGuessLevel(
    word: "KARNA",
    hint: "The tragic, invincible warrior in the Mahabharata, son of the sun god Surya",
    keyboardLetters: ["K", "S", "Z", "N", "X", "D", "H", "W", "L", "R", "J", "T", "V", "O", "M", "A"],
  ),
  WordGuessLevel(
    word: "AVATAR",
    hint: "Sci-fi movie set on Pandora.",
    keyboardLetters: ["L", "N", "K", "X", "A", "V", "H", "T", "I", "G", "S", "P", "U", "R", "O", "J"],
  ),
  WordGuessLevel(
    word: "AKIRA",
    hint: "A landmark 1988 anime film set in a dystopian Neo-Tokyo, known for its stunning animation",
    keyboardLetters: ["Z", "C", "K", "V", "R", "Q", "F", "H", "B", "T", "A", "O", "X", "E", "U", "I"],
  ),
  WordGuessLevel(
    word: "NARUTO",
    hint: "A young ninja who dreams of becoming the leader of his village",
    keyboardLetters: ["H", "D", "G", "F", "W", "S", "V", "Y", "X", "T", "A", "Q", "N", "R", "U", "O"],
  ),
  WordGuessLevel(
    word: "BUDDHA",
    hint: "Enlightened founder of Buddhism.",
    keyboardLetters: ["S", "W", "B", "D", "Z", "V", "C", "A", "J", "U", "P", "X", "Q", "Y", "F", "H"],
  ),
  WordGuessLevel(
    word: "VEDAS",
    hint: "Ancient Hindu scriptures.",
    keyboardLetters: ["R", "S", "N", "A", "Q", "C", "E", "V", "M", "I", "W", "D", "Z", "G", "K", "J"],
  ),
  WordGuessLevel(
    word: "UTOPIA",
    hint: "An imagined place or state of things in which everything is perfect",
    keyboardLetters: ["G", "K", "O", "V", "S", "I", "R", "D", "Y", "F", "E", "U", "P", "A", "J", "T"],
  ),
  WordGuessLevel(
    word: "TRISHUL",
    hint: "The three-pronged divine trident weapon wielded by the Hindu god Shiva.",
    keyboardLetters: ["F", "K", "A", "S", "D", "W", "H", "T", "R", "V", "L", "M", "U", "I", "G", "E"],
  ),
  WordGuessLevel(
    word: "BRAHMA",
    hint: "Hindu god of creation.",
    keyboardLetters: ["I", "R", "Q", "E", "D", "J", "X", "U", "H", "F", "A", "B", "T", "M", "C", "O"],
  ),
  WordGuessLevel(
    word: "VENICE",
    hint: "The Italian City of Canals where gondolas replace cars",
    keyboardLetters: ["R", "E", "N", "Z", "X", "V", "Q", "D", "G", "I", "T", "U", "P", "C", "F", "A"],
  ),
  WordGuessLevel(
    word: "TURING",
    hint: "A British mathematician who cracked the Enigma code during WWII and is a father of computer science",
    keyboardLetters: ["B", "I", "K", "L", "W", "Q", "Y", "F", "X", "A", "U", "R", "O", "G", "N", "T"],
  ),
  WordGuessLevel(
    word: "VEGETA",
    hint: "The proud prince of the Saiyans and eternal rival to Goku",
    keyboardLetters: ["P", "N", "M", "J", "E", "V", "A", "F", "K", "T", "Z", "X", "C", "L", "G", "W"],
  ),
  WordGuessLevel(
    word: "MEMENTO",
    hint: "A Christopher Nolan film told in reverse, about a man who cannot form new memories",
    keyboardLetters: ["P", "N", "E", "S", "Z", "D", "T", "M", "J", "V", "C", "R", "F", "Q", "O", "I"],
  ),
  WordGuessLevel(
    word: "GRAVITY",
    hint: "The force that attracts objects toward one another.",
    keyboardLetters: ["W", "T", "J", "E", "I", "V", "S", "N", "G", "D", "X", "Y", "U", "P", "A", "R"],
  ),
  WordGuessLevel(
    word: "IRONMAN",
    hint: "A Marvel superhero with a high-tech suit.",
    keyboardLetters: ["L", "N", "A", "B", "R", "V", "C", "Y", "O", "K", "Q", "H", "W", "M", "I", "P"],
  ),
  WordGuessLevel(
    word: "TITANIC",
    hint: "A famous British passenger ship that sank in 1912.",
    keyboardLetters: ["T", "C", "U", "O", "H", "V", "W", "L", "A", "F", "Z", "N", "Q", "R", "D", "I"],
  ),
  WordGuessLevel(
    word: "VOLCANO",
    hint: "An opening in Earth's crust that releases molten rock.",
    keyboardLetters: ["R", "H", "I", "X", "A", "N", "V", "O", "Y", "W", "Z", "E", "L", "Q", "C", "B"],
  ),
  WordGuessLevel(
    word: "NIRVANA",
    hint: "Liberation in Buddhism.",
    keyboardLetters: ["A", "P", "Q", "L", "Z", "B", "J", "R", "N", "X", "Y", "M", "K", "E", "I", "V"],
  ),
  WordGuessLevel(
    word: "ZIDANE",
    hint: "French football legend famous for his elegance, vision, and a notorious headbutt",
    keyboardLetters: ["N", "P", "K", "X", "D", "Z", "I", "G", "S", "U", "A", "F", "B", "E", "J", "L"],
  ),
  WordGuessLevel(
    word: "CHAKRA",
    hint: "Spiritual energy centers in Hinduism.",
    keyboardLetters: ["Y", "L", "U", "D", "F", "K", "X", "V", "H", "A", "C", "O", "R", "I", "Z", "T"],
  ),
  WordGuessLevel(
    word: "ASHOKA",
    hint: "An Indian emperor of the Maurya Dynasty who converted to Buddhism and fought the battle of Kalinga after that.",
    keyboardLetters: ["P", "T", "B", "S", "Z", "D", "Y", "X", "J", "H", "C", "A", "O", "M", "K", "L"],
  ),
  WordGuessLevel(
    word: "SAMSON",
    hint: "A biblical hero whose immense strength came from his uncut hair",
    keyboardLetters: ["K", "A", "O", "R", "G", "B", "N", "H", "Y", "F", "D", "J", "M", "S", "Q", "V"],
  ),
  WordGuessLevel(
    word: "GANGES",
    hint: "Sacred Indian river worshipped as a goddess.",
    keyboardLetters: ["D", "L", "N", "S", "A", "I", "R", "C", "X", "Y", "E", "G", "U", "W", "K", "T"],
  ),
  WordGuessLevel(
    word: "JURASSIC",
    hint: "A geologic period known for the age of dinosaurs.",
    keyboardLetters: ["C", "S", "W", "J", "T", "A", "P", "U", "Z", "O", "V", "X", "I", "M", "G", "R"],
  ),
  WordGuessLevel(
    word: "ANDROID",
    hint: "A mobile operating system",
    keyboardLetters: ["C", "Q", "Z", "R", "D", "M", "N", "H", "B", "W", "T", "A", "I", "O", "F", "P"],
  ),
  WordGuessLevel(
    word: "QUANTUM",
    hint: "Smallest discrete unit of any physical property.",
    keyboardLetters: ["U", "M", "N", "F", "H", "L", "J", "S", "Y", "Q", "W", "C", "A", "E", "T", "D"],
  ),
  WordGuessLevel(
    word: "KRISHNA",
    hint: "Eighth avatar of Vishnu in Hinduism.",
    keyboardLetters: ["B", "R", "H", "I", "O", "J", "A", "M", "S", "C", "Q", "W", "F", "G", "K", "N"],
  ),
  WordGuessLevel(
    word: "ECLIPSE",
    hint: "An astronomical event where one celestial body shadows another.",
    keyboardLetters: ["Y", "X", "V", "R", "U", "O", "Q", "E", "C", "T", "I", "L", "J", "S", "H", "P"],
  ),
  WordGuessLevel(
    word: "ORIGAMI",
    hint: "The Japanese art of paper folding",
    keyboardLetters: ["M", "D", "I", "Q", "J", "V", "C", "N", "T", "X", "O", "W", "B", "A", "R", "G"],
  ),
  WordGuessLevel(
    word: "HANUMAN",
    hint: "The mighty ape-god who could change his form at will and lift mountains",
    keyboardLetters: ["V", "N", "Q", "M", "H", "U", "F", "A", "X", "P", "T", "Z", "J", "D", "B", "Y"],
  ),
  WordGuessLevel(
    word: "JODHPUR",
    hint: "The Blue City in the Thar Desert of Rajasthan, India",
    keyboardLetters: ["L", "O", "D", "K", "A", "Y", "J", "S", "H", "X", "B", "T", "P", "R", "G", "U"],
  ),
  WordGuessLevel(
    word: "NEUTRON",
    hint: "A subatomic particle with no charge.",
    keyboardLetters: ["X", "M", "H", "S", "W", "E", "J", "N", "T", "O", "C", "Y", "R", "L", "U", "P"],
  ),
  WordGuessLevel(
    word: "PARADOX",
    hint: "A seemingly absurd or self-contradictory statement that when investigated may prove to be well founded or true",
    keyboardLetters: ["N", "K", "P", "R", "O", "X", "Q", "M", "H", "V", "U", "Y", "J", "G", "A", "D"],
  ),
  WordGuessLevel(
    word: "INTERNET",
    hint: "A global system of interconnected computer networks.",
    keyboardLetters: ["X", "C", "J", "O", "P", "I", "Z", "E", "R", "M", "N", "V", "T", "Y", "L", "H"],
  ),
  WordGuessLevel(
    word: "PYRAMIDS",
    hint: "Massive structures built in ancient Egypt as tombs.",
    keyboardLetters: ["B", "Y", "D", "X", "C", "L", "E", "R", "Z", "O", "P", "S", "M", "I", "T", "A"],
  ),
  WordGuessLevel(
    word: "FIREWALL",
    hint: "A network security system that controls traffic.",
    keyboardLetters: ["V", "E", "C", "L", "S", "F", "W", "D", "I", "U", "G", "R", "Z", "P", "A", "T"],
  ),
  WordGuessLevel(
    word: "EINSTEIN",
    hint: "Developed the theory of relativity.",
    keyboardLetters: ["T", "P", "I", "S", "H", "B", "X", "V", "N", "E", "D", "M", "F", "G", "Y", "A"],
  ),
  WordGuessLevel(
    word: "AYODHYA",
    hint: "The ancient Indian city believed to be the birthplace of Lord Rama",
    keyboardLetters: ["D", "G", "N", "R", "O", "Q", "U", "T", "K", "H", "Y", "L", "V", "C", "A", "E"],
  ),
  WordGuessLevel(
    word: "RAMAYANA",
    hint: "Ancient epic about Rama.",
    keyboardLetters: ["M", "H", "A", "Q", "P", "B", "Z", "J", "S", "N", "G", "C", "D", "K", "R", "Y"],
  ),
  WordGuessLevel(
    word: "MARADONA",
    hint: "Argentinian football icon famous for the Hand of God goal",
    keyboardLetters: ["Y", "B", "X", "M", "G", "W", "U", "O", "S", "N", "J", "D", "I", "A", "R", "Z"],
  ),
  WordGuessLevel(
    word: "ZENDAYA",
    hint: "A modern Hollywood star known for her roles in Spider-Man and the series Euphoria",
    keyboardLetters: ["L", "I", "Y", "K", "G", "N", "U", "Z", "P", "D", "X", "S", "V", "E", "A", "B"],
  ),
  WordGuessLevel(
    word: "YOURNAME",
    hint: "An anime film about a boy and a girl who mysteriously swap bodies",
    keyboardLetters: ["I", "M", "D", "N", "E", "J", "X", "S", "Y", "O", "F", "R", "U", "A", "K", "W"],
  ),
  WordGuessLevel(
    word: "GANDHARI",
    hint: "The wife of King Dhritarashtra, who blindfolded herself for life.",
    keyboardLetters: ["R", "D", "N", "H", "V", "S", "G", "Q", "P", "I", "T", "E", "K", "J", "Y", "A"],
  ),
  WordGuessLevel(
    word: "ALCHEMY",
    hint: "A medieval forerunner of chemistry, concerned with transmuting base metals into gold",
    keyboardLetters: ["E", "Q", "R", "C", "U", "A", "H", "M", "J", "V", "X", "S", "Y", "N", "Z", "L"],
  ),
  WordGuessLevel(
    word: "INCEPTION",
    hint: "A Christopher Nolan film about entering dreams to steal secrets.",
    keyboardLetters: ["B", "T", "N", "Q", "O", "A", "M", "X", "P", "L", "V", "R", "C", "I", "E", "U"],
  ),
  WordGuessLevel(
    word: "SOCRATES",
    hint: "A classical Greek philosopher and a founder of Western philosophy.",
    keyboardLetters: ["T", "O", "C", "U", "S", "K", "R", "X", "E", "L", "Q", "Y", "M", "B", "N", "A"],
  ),
  WordGuessLevel(
    word: "RAGNAROK",
    hint: "The end of the world and the final battle of the gods in Norse mythology.",
    keyboardLetters: ["Z", "O", "P", "R", "K", "W", "D", "G", "H", "M", "A", "Y", "N", "B", "Q", "A"],
  ),
  WordGuessLevel(
    word: "WAKANDA",
    hint: "The technologically advanced, fictional African nation ruled by the Black Panther.",
    keyboardLetters: ["W", "B", "Z", "F", "A", "C", "M", "K", "D", "X", "N", "R", "L", "A", "J", "P"],
  ),
  WordGuessLevel(
    word: "QUASAR",
    hint: "An extremely bright and distant celestial object powered by a black hole.",
    keyboardLetters: ["P", "Z", "A", "B", "F", "U", "R", "X", "J", "K", "S", "E", "Q", "N", "O", "V"],
  ),
  WordGuessLevel(
    word: "VOLDEMORT",
    hint: "The main antagonist in the Harry Potter series, known as \"He-Who-Must-Not-Be-Named.\"",
    keyboardLetters: ["E", "R", "V", "C", "Y", "Q", "W", "B", "X", "P", "O", "D", "T", "M", "L", "Z"],
  ),
  WordGuessLevel(
    word: "BARCELONA",
    hint: "A Spanish city famous for the unique architecture of Antoni Gaudí.",
    keyboardLetters: ["N", "L", "O", "B", "Y", "E", "X", "R", "Z", "P", "A", "K", "C", "J", "Q", "S"],
  ),
  WordGuessLevel(
    word: "SHAKESPEARE",
    hint: "An English playwright considered the greatest writer in the English language.",
    keyboardLetters: ["H", "P", "Z", "B", "A", "K", "S", "J", "E", "U", "L", "C", "X", "W", "Y", "R"],
  ),
  WordGuessLevel(
    word: "SERENGETI",
    hint: "A vast national park in Tanzania famous for its massive animal migrations.",
    keyboardLetters: ["G", "N", "X", "P", "E", "Z", "O", "S", "B", "W", "K", "I", "T", "A", "R", "Y"],
  ),
  WordGuessLevel(
    word: "NEFERTITI",
    hint: "An Egyptian queen renowned for her beauty, wife of Pharaoh Akhenaten.",
    keyboardLetters: ["F", "Q", "Y", "K", "R", "O", "G", "L", "T", "I", "X", "U", "A", "B", "N", "E"],
  ),
  WordGuessLevel(
    word: "KAMIKAZE",
    hint: "A Japanese term meaning \"divine wind,\" associated with WWII pilots.",
    keyboardLetters: ["E", "X", "C", "I", "A", "Q", "M", "Y", "B", "W", "D", "P", "K", "U", "Z", "J"],
  ),
  WordGuessLevel(
    word: "DUNE",
    hint: "A classic sci-fi novel by Frank Herbert set on the desert planet Arrakis.",
    keyboardLetters: ["C", "Y", "D", "M", "W", "N", "A", "Z", "B", "U", "K", "Q", "P", "L", "E", "X"],
  ),
  WordGuessLevel(
    word: "OSAMA",
    hint: "The Islamic Terrorist responsible for 9/11.",
    keyboardLetters: ["S", "D", "Z", "M", "Q", "W", "A", "K", "P", "O", "E", "L", "C", "Y", "J", "B"],
  ),
  WordGuessLevel(
    word: "HAKUNAMATATA",
    hint: "A Swahili phrase meaning \"no worries,\" popularized by a Disney movie about a lion cub.",
    keyboardLetters: ["A", "Z", "R", "B", "C", "P", "T", "U", "N", "W", "K", "M", "H", "E", "Y", "L"],
  ),
  WordGuessLevel(
    word: "TESSERACT",
    hint: "A cosmic cube of immense power in Marvel.",
    keyboardLetters: ["X", "P", "F", "V", "U", "H", "E", "O", "C", "I", "G", "S", "T", "A", "R", "L"],
  ),
  WordGuessLevel(
    word: "BHISHMA",
    hint: "A central character in the Mahabharata, known for his vow of celibacy.",
    keyboardLetters: ["A", "M", "H", "P", "R", "I", "L", "B", "U", "T", "N", "Q", "S", "E", "D", "O"],
  ),
  WordGuessLevel(
    word: "DRAUPADI",
    hint: "The common wife of the five Pandava brothers in the Mahabharata.",
    keyboardLetters: ["W", "L", "X", "M", "P", "D", "Y", "B", "O", "E", "R", "U", "A", "Q", "J", "I"],
  ),
  WordGuessLevel(
    word: "CHARMINAR",
    hint: "A historic monument in Hyderabad, India.",
    keyboardLetters: ["A", "R", "D", "T", "J", "L", "M", "X", "B", "H", "I", "U", "S", "N", "C", "G"],
  ),
  WordGuessLevel(
    word: "SPIDERMAN",
    hint: "A superhero bitten by a radioactive spider.",
    keyboardLetters: ["D", "V", "I", "R", "J", "E", "N", "O", "C", "S", "M", "A", "Y", "P", "L", "K"],
  ),
  WordGuessLevel(
    word: "OLYMPICS",
    hint: "An international sports event held every four years.",
    keyboardLetters: ["I", "S", "O", "C", "Y", "A", "L", "Z", "D", "M", "H", "G", "X", "P", "T", "F"],
  ),
  WordGuessLevel(
    word: "AGASTYA",
    hint: "A revered Vedic sage, considered one of the seven great sages (Saptarishi), known for drinking the ocean.",
    keyboardLetters: ["R", "M", "G", "O", "N", "X", "B", "A", "Y", "S", "T", "H", "C", "U", "F", "L"],
  ),
  WordGuessLevel(
    word: "AIRAVAT",
    hint: "The divine, multi-headed white elephant who serves as the mount for the god Indra.",
    keyboardLetters: ["W", "A", "G", "H", "V", "B", "U", "S", "T", "Q", "L", "N", "I", "D", "O", "R"],
  ),
  WordGuessLevel(
    word: "BETHLEHEM",
    hint: "The small town in Judea identified as the birthplace of Jesus",
    keyboardLetters: ["B", "U", "S", "K", "Z", "T", "H", "V", "N", "X", "Y", "M", "J", "L", "I", "E"],
  ),
  WordGuessLevel(
    word: "CHERNOBYL",
    hint: "A ghost city in Ukraine, frozen in 1986 due to a catastrophic nuclear accident",
    keyboardLetters: ["F", "B", "Y", "N", "V", "C", "E", "G", "D", "R", "X", "O", "H", "W", "A", "L"],
  ),
  WordGuessLevel(
    word: "MEDITATION",
    hint: "Focused mental practice.",
    keyboardLetters: ["C", "O", "K", "A", "P", "D", "F", "J", "S", "Z", "T", "M", "I", "N", "E", "G"],
  ),
  WordGuessLevel(
    word: "SANSKRIT",
    hint: "Ancient Indian language used in Hindu scriptures.",
    keyboardLetters: ["U", "A", "C", "R", "D", "S", "H", "W", "N", "E", "Y", "M", "O", "T", "K", "I"],
  ),
  WordGuessLevel(
    word: "ABHIMANYU",
    hint: "The son of Arjuna, a tragic hero of the Kurukshetra War.",
    keyboardLetters: ["Q", "T", "S", "U", "D", "L", "B", "A", "C", "M", "F", "X", "N", "Y", "H", "I"],
  ),
  WordGuessLevel(
    word: "ONEPIECE",
    hint: "A sprawling anime adventure about a boy made of rubber searching for the ultimate treasure",
    keyboardLetters: ["Z", "O", "I", "M", "S", "V", "L", "P", "F", "T", "E", "X", "B", "N", "C", "J"],
  ),
  WordGuessLevel(
    word: "SUPERNOVA",
    hint: "The explosive death of a massive star",
    keyboardLetters: ["E", "B", "W", "N", "Y", "K", "S", "U", "Z", "R", "P", "G", "D", "O", "V", "A"],
  ),
  WordGuessLevel(
    word: "PUSHPAKA",
    hint: "Ravana's mythical flying chariot that could travel at the speed of mind",
    keyboardLetters: ["W", "P", "X", "J", "Y", "A", "G", "K", "U", "H", "B", "M", "L", "N", "C", "S"],
  ),
  WordGuessLevel(
    word: "ALHAMBRA",
    hint: "A stunning palace and fortress of the Moorish rulers in Granada Spain",
    keyboardLetters: ["Q", "G", "E", "Z", "L", "W", "T", "B", "V", "H", "M", "S", "R", "A", "F", "X"],
  ),
  WordGuessLevel(
    word: "SPIELBERG",
    hint: "The iconic director behind Jaws, E.T., and Jurassic Park",
    keyboardLetters: ["G", "R", "N", "D", "Y", "B", "V", "J", "P", "X", "Q", "L", "I", "S", "C", "E"],
  ),
  WordGuessLevel(
    word: "BLOCKCHAIN",
    hint: "A decentralized ledger used in cryptocurrencies.",
    keyboardLetters: ["N", "O", "A", "K", "Y", "G", "H", "I", "L", "D", "W", "M", "B", "C", "J", "E"],
  ),
  WordGuessLevel(
    word: "EVANGELION",
    hint: "A mecha anime series about teenagers piloting giant cyborgs to fight angelic beings.",
    keyboardLetters: ["R", "O", "H", "F", "A", "D", "N", "S", "E", "G", "Q", "L", "V", "M", "J", "I"],
  ),
  WordGuessLevel(
    word: "BRAHMASTRA",
    hint: "A mythical weapon in Indian mythology.",
    keyboardLetters: ["A", "B", "T", "C", "Z", "Q", "D", "M", "R", "X", "N", "P", "S", "H", "I", "U"],
  ),
  WordGuessLevel(
    word: "BLACKHOLE",
    hint: "A region of spacetime where gravity is so strong that nothing, not even light, can escape",
    keyboardLetters: ["U", "A", "M", "O", "B", "G", "H", "I", "C", "D", "T", "E", "L", "J", "K", "R"],
  ),
  WordGuessLevel(
    word: "GALAPAGOS",
    hint: "The islands that inspired Charles Darwin's theory of evolution",
    keyboardLetters: ["P", "N", "O", "J", "K", "A", "B", "U", "Z", "D", "G", "M", "L", "V", "S", "E"],
  ),
  WordGuessLevel(
    word: "ACROPOLIS",
    hint: "An ancient citadel on a rocky outcrop above Athens.",
    keyboardLetters: ["A", "P", "O", "I", "D", "N", "R", "S", "J", "C", "U", "H", "B", "L", "G", "T"],
  ),
  WordGuessLevel(
    word: "ERENYEAGER",
    hint: "The protagonist of Attack on Titan who holds a deep-seated hatred for the giant humanoids",
    keyboardLetters: ["C", "A", "R", "Z", "S", "B", "Y", "V", "X", "H", "D", "G", "Q", "N", "E", "M"],
  ),
  WordGuessLevel(
    word: "GETHSEMANE",
    hint: "A garden at the foot of the Mount of Olives where Jesus prayed before his crucifixion.",
    keyboardLetters: ["T", "Y", "B", "E", "R", "Z", "O", "H", "N", "M", "I", "P", "S", "G", "X", "A"],
  ),
  WordGuessLevel(
    word: "STEINSGATE",
    hint: "This anime involves a group of friends who discover a way to send messages to the past.",
    keyboardLetters: ["Q", "I", "N", "Z", "O", "U", "M", "P", "R", "C", "L", "A", "G", "E", "S", "T"],
  ),
  WordGuessLevel(
    word: "PULPFICTION",
    hint: "A 1994 crime film by Quentin Tarantino known for its nonlinear narrative.",
    keyboardLetters: ["M", "X", "U", "B", "I", "L", "O", "C", "G", "Y", "T", "Z", "P", "F", "N", "V"],
  ),
  WordGuessLevel(
    word: "OPPENHEIMER",
    hint: "The father of the atomic bomb",
    keyboardLetters: ["R", "I", "A", "F", "P", "E", "Z", "N", "O", "T", "D", "U", "Q", "L", "H", "M"],
  ),
  WordGuessLevel(
    word: "MARIECURIE",
    hint: "A pioneering physicist and chemist who conducted groundbreaking research on radioactivity",
    keyboardLetters: ["P", "D", "A", "I", "G", "U", "Y", "L", "T", "R", "E", "H", "M", "C", "N", "W"],
  ),
  WordGuessLevel(
    word: "CHANDRAYAAN",
    hint: "India's lunar exploration program.",
    keyboardLetters: ["D", "Q", "P", "V", "L", "O", "E", "N", "H", "G", "J", "K", "R", "A", "Y", "C"],
  ),
  WordGuessLevel(
    word: "PARASHURAMA",
    hint: "The sixth avatar of Vishnu, a warrior sage with an axe.",
    keyboardLetters: ["R", "U", "M", "Y", "C", "E", "Q", "W", "D", "S", "P", "H", "N", "A", "O", "Z"],
  ),
  WordGuessLevel(
    word: "DALAILAMA",
    hint: "The spiritual leader of Tibetan Buddhism, believed to be a reincarnation",
    keyboardLetters: ["B", "T", "R", "L", "I", "U", "S", "A", "D", "K", "E", "V", "J", "M", "H", "W"],
  ),
  WordGuessLevel(
    word: "BLADERUNNER",
    hint: "A sci-fi noir film questioning what it means to be human, featuring replicants",
    keyboardLetters: ["W", "R", "Z", "D", "V", "A", "U", "P", "O", "E", "B", "L", "S", "F", "G", "N"],
  ),
  WordGuessLevel(
    word: "DEMONSLAYER",
    hint: "An anime about a boy who joins a secret corps to hunt demons after his family is slaughtered",
    keyboardLetters: ["M", "L", "R", "X", "O", "H", "U", "S", "Y", "A", "N", "E", "D", "P", "F", "B"],
  ),
  WordGuessLevel(
    word: "SCORSESE",
    hint: "Director of gritty crime films like Goodfellas and The Departed",
    keyboardLetters: ["R", "W", "C", "K", "L", "H", "U", "F", "X", "Y", "Z", "O", "A", "I", "S", "E"],
  ),
  WordGuessLevel(
    word: "ESPIONAGE",
    hint: "The practice of spying or of using spies, typically by governments to obtain political and military information",
    keyboardLetters: ["Z", "G", "O", "L", "F", "C", "X", "I", "D", "A", "Q", "B", "E", "P", "N", "S"],
  ),
  WordGuessLevel(
    word: "PANGONGTSO",
    hint: "A stunning high-altitude lake in the Himalayas that stretches from India to China",
    keyboardLetters: ["H", "F", "O", "S", "W", "K", "A", "E", "P", "Z", "U", "X", "N", "G", "T", "Q"],
  ),
  WordGuessLevel(
    word: "ISAACNEWTON",
    hint: "An English physicist who formulated the laws of motion and universal gravitation.",
    keyboardLetters: ["I", "W", "D", "Y", "T", "A", "M", "E", "S", "L", "C", "B", "J", "N", "O", "U"],
  ),
  WordGuessLevel(
    word: "ASHWATTHAMA",
    hint: "A powerful warrior and son of Drona in the Mahabharata.",
    keyboardLetters: ["P", "J", "B", "V", "W", "H", "D", "I", "S", "Q", "N", "T", "A", "Y", "F", "M"],
  ),
  WordGuessLevel(
    word: "LIGHTYAGAMI",
    hint: "A brilliant high school student who finds a notebook that can kill anyone whose name is written inside",
    keyboardLetters: ["H", "L", "V", "B", "Y", "Z", "M", "F", "I", "T", "R", "U", "K", "G", "W", "A"],
  ),
  WordGuessLevel(
    word: "RESURRECTION",
    hint: "The Christian belief that Jesus rose from the dead.",
    keyboardLetters: ["B", "L", "Y", "E", "T", "O", "W", "C", "S", "V", "I", "N", "U", "A", "R", "M"],
  ),
  WordGuessLevel(
    word: "JALLIKATTU",
    hint: "A traditional bull-taming sport practiced in the Indian state of Tamil Nadu",
    keyboardLetters: ["V", "K", "N", "L", "R", "U", "B", "J", "Y", "A", "I", "F", "O", "G", "T", "H"],
  ),
  WordGuessLevel(
    word: "GANESHA",
    hint: "This elephant-headed deity is revered as the remover of obstacles.",
    keyboardLetters: ["L", "S", "J", "U", "Y", "W", "N", "G", "X", "K", "H", "E", "D", "B", "R", "A"],
  ),
  WordGuessLevel(
    word: "MAHABHARATA",
    hint: "Epic of ancient India.",
    keyboardLetters: ["D", "I", "S", "R", "N", "K", "X", "O", "A", "M", "H", "Q", "G", "B", "J", "T"],
  ),
  WordGuessLevel(
    word: "INTERSTELLAR",
    hint: "A film where humanity searches for a new home through a wormhole near Saturn",
    keyboardLetters: ["Y", "T", "U", "G", "X", "S", "R", "I", "L", "M", "P", "C", "A", "E", "J", "N"],
  ),
  WordGuessLevel(
    word: "CRUCIFIXION",
    hint: "The method of execution used on Jesus Christ at Calvary",
    keyboardLetters: ["X", "P", "F", "A", "H", "D", "Q", "Z", "O", "R", "E", "N", "U", "V", "I", "C"],
  ),
  WordGuessLevel(
    word: "HIEROGLYPHS",
    hint: "The ancient Egyptian writing system using pictures and symbols",
    keyboardLetters: ["O", "E", "P", "C", "R", "Z", "B", "J", "V", "I", "H", "L", "Y", "S", "G", "T"],
  ),
  WordGuessLevel(
    word: "KEANUREEVES",
    hint: "Known for playing Neo in The Matrix and the titular assassin in John Wick",
    keyboardLetters: ["F", "T", "L", "P", "U", "D", "N", "E", "S", "R", "V", "A", "J", "K", "G", "Z"],
  ),
  WordGuessLevel(
    word: "THEGODFATHER",
    hint: "A crime film epic about the head of a powerful Italian-American crime family",
    keyboardLetters: ["D", "O", "F", "E", "H", "G", "K", "U", "M", "R", "S", "W", "T", "P", "A", "X"],
  ),
  WordGuessLevel(
    word: "YUDHISHTHIRA",
    hint: "The eldest of the Pandava brothers, known for his righteousness.",
    keyboardLetters: ["D", "T", "U", "R", "A", "B", "G", "E", "I", "P", "F", "S", "Y", "X", "K", "H"],
  ),
  WordGuessLevel(
    word: "EDWARDELRIC",
    hint: "The Fullmetal Alchemist who lost an arm and a leg in a failed attempt to resurrect his mother",
    keyboardLetters: ["D", "W", "L", "S", "E", "B", "Z", "Y", "A", "R", "C", "K", "N", "I", "J", "P"],
  ),
  WordGuessLevel(
    word: "SHINKANSEN",
    hint: "Japan's high-speed bullet train network",
    keyboardLetters: ["V", "N", "S", "I", "M", "C", "E", "T", "A", "K", "Z", "H", "U", "B", "X", "Q"],
  ),
  WordGuessLevel(
    word: "SCHRODINGER",
    hint: "His famous thought experiment involves a cat that is simultaneously alive and dead",
    keyboardLetters: ["C", "D", "R", "X", "O", "H", "Y", "T", "G", "E", "V", "B", "N", "S", "P", "I"],
  ),
  WordGuessLevel(
    word: "VISHWAMITRA",
    hint: "A great sage who was once a king and became a revered Brahmin through penance",
    keyboardLetters: ["T", "D", "Z", "X", "A", "B", "P", "E", "R", "U", "M", "W", "I", "V", "S", "H"],
  ),
  WordGuessLevel(
    word: "SATORUGOJO",
    hint: "The overwhelmingly powerful and charismatic jujutsu sorcerer from Jujutsu Kaisen",
    keyboardLetters: ["C", "Q", "S", "P", "J", "T", "N", "G", "D", "X", "U", "R", "O", "L", "F", "A"],
  ),
  WordGuessLevel(
    word: "MICHAELJORDAN",
    hint: "A legendary basketball player with six NBA titles.",
    keyboardLetters: ["H", "L", "O", "J", "S", "E", "R", "A", "N", "B", "X", "C", "K", "D", "M", "I"],
  ),
  WordGuessLevel(
    word: "ANGELINAJOLIE",
    hint: "Famous for playing Lara Croft and the dark fairy Maleficent",
    keyboardLetters: ["B", "L", "C", "G", "R", "T", "E", "Q", "P", "J", "D", "A", "W", "I", "O", "N"],
  ),
  WordGuessLevel(
    word: "ROGERFEDERER",
    hint: "Swiss tennis maestro known for his graceful style and numerous Grand Slam titles",
    keyboardLetters: ["L", "A", "R", "F", "Z", "X", "J", "D", "Y", "G", "B", "M", "E", "O", "U", "I"],
  ),
  WordGuessLevel(
    word: "KURUKSHETRA",
    hint: "The battlefield where the epic war of the Mahabharata was fought",
    keyboardLetters: ["A", "S", "B", "H", "E", "G", "J", "K", "Y", "U", "D", "X", "T", "Z", "R", "L"],
  ),
  WordGuessLevel(
    word: "JOHNTTHEBAPTIST",
    hint: "A Jewish preacher who is revered as a major religious figure in Christianity.",
    keyboardLetters: ["G", "T", "F", "O", "D", "P", "B", "J", "N", "H", "A", "I", "Y", "E", "C", "S"],
  ),
  WordGuessLevel(
    word: "SPIKESPIEGEL",
    hint: "The impossibly cool, laid-back bounty hunter from Cowboy Bebop",
    keyboardLetters: ["R", "T", "V", "K", "A", "I", "G", "W", "P", "S", "M", "N", "L", "X", "O", "E"],
  ),
  WordGuessLevel(
    word: "MACHIAVELLI",
    hint: "An Italian diplomat whose name is synonymous with cunning and political scheming",
    keyboardLetters: ["E", "Y", "R", "L", "S", "X", "H", "V", "F", "J", "I", "M", "C", "W", "A", "U"],
  ),
  WordGuessLevel(
    word: "SIMONEBILES",
    hint: "The most decorated American gymnast, known for performing skills of incredible difficulty",
    keyboardLetters: ["N", "Z", "A", "V", "B", "U", "Z", "P", "R", "L", "Y", "S", "M", "E", "W", "I", "O", "T"],
  ),
  WordGuessLevel(
    word: "DHRITARASHTRA",
    hint: "The blind king of Hastinapura and father of the Kauravas in the Mahabharata.",
    keyboardLetters: ["O", "V", "K", "B", "Y", "M", "S", "A", "P", "U", "X", "H", "R", "T", "N", "W", "I", "D"],
  ),
  WordGuessLevel(
    word: "CATEBLANCHETT",
    hint: "She has played both an elf queen (Galadriel) and Queen Elizabeth I",
    keyboardLetters: ["N", "M", "K", "Z", "X", "F", "Y", "H", "U", "L", "T", "C", "J", "A", "O", "B", "I", "E"],
  ),
  WordGuessLevel(
    word: "SACHINTENDULKAR",
    hint: "An Indian former international cricketer, widely regarded as one of the greatest batsmen in the history of cricket.",
    keyboardLetters: ["B", "N", "T", "X", "P", "Q", "C", "H", "R", "A", "U", "D", "K", "E", "I", "L", "S", "M"],
  ),
  WordGuessLevel(
    word: "GHOSTINTHESHELL",
    hint: "A cyberpunk anime that explores themes of identity and consciousness in a technologically advanced future",
    keyboardLetters: ["O", "T", "P", "Y", "E", "D", "C", "B", "Z", "H", "I", "L", "V", "X", "S", "W", "N", "G"],
  ),
  WordGuessLevel(
    word: "DENZELWASHINGTON",
    hint: "An American actor known for his roles in Training Day and Glory.",
    keyboardLetters: ["A", "T", "O", "P", "Q", "R", "S", "G", "Z", "I", "D", "L", "H", "W", "E", "N", "V", "Y"],
  ),
  WordGuessLevel(
    word: "LEONARDODICAPRIO",
    hint: "Famously fought a bear to win his first Oscar for The Revenant",
    keyboardLetters: ["L", "J", "P", "O", "A", "K", "B", "S", "V", "D", "Z", "R", "Q", "U", "E", "N", "C", "I"],
  ),
  WordGuessLevel(
    word: "PHOTOSYNTHESIS",
    hint: "The process by which plants convert sunlight into energy.",
    keyboardLetters: ["S", "D", "N", "V", "H", "W", "M", "Q", "Z", "C", "Y", "L", "I", "A", "P", "T", "E", "O"],
  ),
  WordGuessLevel(
    word: "LEONARDODAVINCI",
    hint: "An Italian polymath of the High Renaissance, painter of the Mona Lisa.",
    keyboardLetters: ["D", "C", "O", "K", "Y", "S", "N", "P", "E", "A", "Q", "R", "I", "U", "F", "V", "L", "M"],
  ),
  WordGuessLevel(
    word: "MYHEROACADEMIA",
    hint: "An anime set in a world where most people have superpowers, or Quirks.",
    keyboardLetters: ["C", "E", "R", "F", "B", "L", "N", "I", "A", "H", "M", "D", "Z", "T", "Y", "V", "U", "O"],
  ),
  WordGuessLevel(
    word: "MARTINLUTHER",
    hint: "An American Baptist minister and activist who was a prominent leader in the Civil Rights Movement.",
    keyboardLetters: ["Q", "H", "L", "K", "B", "P", "R", "E", "U", "M", "D", "A", "W", "N", "T", "G", "J", "I"],
  ),
];
