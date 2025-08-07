// lib/games/word_connect/word_connect_data.dart

class WordConnectLevel {
  /// The letters to be displayed in the circle, in order.
  final String letters;
  
  /// A set of all valid words that can be formed. Using a Set for fast lookups.
  final Set<String> solutions;

  WordConnectLevel({
    required this.letters,
    required this.solutions,
  });
}

final wordConnectLevels = [
  // --- 20 Four-Letter Puzzles (6 solutions each) ---
  WordConnectLevel(letters: "LMAE", solutions: {"AM", "ELM", "ALE", "MALE", "MEAL", "LAME"}),
  WordConnectLevel(letters: "REAC", solutions: {"ACE", "ARC", "CAR", "CARE", "EAR", "RACE"}),
  WordConnectLevel(letters: "ATSR", solutions: {"ART", "RAT", "SAT", "STAR", "TAR", "TSAR"}),
  WordConnectLevel(letters: "ADTE", solutions: {"ATE", "EAT", "TAD", "TEA", "DATE", "TEAD"}),
  WordConnectLevel(letters: "ALPE", solutions: {"ALP", "APE", "LAP", "LEA", "PALE", "PEAL"}),
  WordConnectLevel(letters: "BREA", solutions: {"ARE", "BAR", "BARE", "EAR", "ERA", "BEAR"}),
  WordConnectLevel(letters: "TMAE", solutions: {"ATE", "EAT", "MAT", "MEAT", "TAM", "TEAM"}),
  WordConnectLevel(letters: "FCEA", solutions: {"ACE", "CAF", "FAE", "FACE", "CAFE", "FECA"}),
  WordConnectLevel(letters: "VAHE", solutions: {"AVE", "EVE", "HAVE", "VAE", "HAE", "EAVE"}),
  WordConnectLevel(letters: "NLIE", solutions: {"LIE", "NIL", "LINE", "LIEN", "LEI", "LINT"}),
  WordConnectLevel(letters: "MDOE", solutions: {"DOE", "DOM", "ODE", "MODE", "DEMO", "DOME"}),
  WordConnectLevel(letters: "RDIE", solutions: {"DIE", "IRE", "RED", "RIDE", "DIRE", "REID"}),
  WordConnectLevel(letters: "EALS", solutions: {"ALE", "SEA", "SAL", "SALE", "SEAL", "LEAS"}),
  WordConnectLevel(letters: "WDRA", solutions: {"RAW", "WAR", "WAD", "WARD", "DRAW", "RAD"}),
  WordConnectLevel(letters: "CNOR", solutions: {"CON", "NOR", "CORN", "ROC", "ORC", "RON"}),
  WordConnectLevel(letters: "DWRA", solutions: {"RAW", "WAR", "WAD", "DRAW", "RAD", "DWARF"}),
  WordConnectLevel(letters: "FMLI", solutions: {"FILM", "FILL", "MIL", "ILL", "IF", "FLIM"}),
  WordConnectLevel(letters: "DLOG", solutions: {"GOD", "LOG", "OLD", "GOLD", "DOG", "GLOD"}),
  WordConnectLevel(letters: "EPOH", solutions: {"HOPE", "HOP", "HOE", "OPE", "POE", "ECHO"}),
  WordConnectLevel(letters: "DINK", solutions: {"INK", "DIN", "KID", "KIND", "DINK", "KING"}),

  // --- 20 Five-Letter Puzzles (7 solutions each) ---
  WordConnectLevel(letters: "ALPEP", solutions: {"APE", "APP", "LAP", "PAL", "PALE", "PEA", "APPLE"}),
  WordConnectLevel(letters: "BCEHA", solutions: {"ACE", "ACHE", "BACH", "BEACH", "CAB", "EACH", "HEBE"}),
  WordConnectLevel(letters: "CRAIH", solutions: {"ARC", "CAR", "CHAR", "CHI", "HAIR", "RICH", "CHAIR"}),
  WordConnectLevel(letters: "AREDM", solutions: {"ARM", "DAM", "DRAM", "DREAM", "EAR", "ERA", "MADRE"}),
  WordConnectLevel(letters: "TREAH", solutions: {"ART", "EAR", "EAT", "HEART", "RAT", "TAR", "EARTH"}),
  WordConnectLevel(letters: "WOLFER", solutions: {"FOE", "FOR", "LOW", "OWE", "ROLE", "WORE", "FLOWER"}),
  WordConnectLevel(letters: "PARGE", solutions: {"APE", "ARE", "GAP", "GRAPE", "PARE", "PEA", "REAP"}),
  WordConnectLevel(letters: "OUSHE", solutions: {"USE", "SUE", "SHOE", "HOSE", "HOE", "HUE", "HOUSE"}),
  WordConnectLevel(letters: "DIINA", solutions: {"AID", "AND", "DAN", "DIN", "INDIA", "IN", "NADIR"}),
  WordConnectLevel(letters: "LIMSE", solutions: {"SMILE", "SLIM", "MILE", "LIME", "LIES", "MISE", "ISLE"}),
  WordConnectLevel(letters: "FINKE", solutions: {"FEN", "FIN", "FINK", "IF", "INK", "KINE", "KNIFE"}),
  WordConnectLevel(letters: "MOELN", solutions: {"LEMON", "LONE", "MEN", "EON", "MELON", "NOM", "MOLE"}),
  WordConnectLevel(letters: "NEOMY", solutions: {"MONEY", "EON", "MEN", "MON", "ONE", "YEN", "MOY"}),
  WordConnectLevel(letters: "RTONH", solutions: {"HON", "HOT", "NOT", "NTH", "RHO", "ROT", "NORTH"}),
  WordConnectLevel(letters: "AEOCN", solutions: {"OCEAN", "CANOE", "CANE", "CONE", "CON", "CAN", "ONCE"}),
  WordConnectLevel(letters: "NIPAO", solutions: {"AIN", "ION", "NAP", "NIP", "PAIN", "PAN", "PIANO"}),
  WordConnectLevel(letters: "EUQEN", solutions: {"EEN", "NEE", "QUE", "QUEN", "UNE", "NE", "QUEEN"}),
  WordConnectLevel(letters: "DARIO", solutions: {"AID", "AIR", "OAR", "RAD", "RAID", "RID", "RADIO"}),
  WordConnectLevel(letters: "RHSAK", solutions: {"SHARK", "HARK", "RASH", "ARK", "ASH", "ASK", "SHAK"}),
  WordConnectLevel(letters: "LABTE", solutions: {"ABE", "ABLE", "ALE", "BALE", "BAT", "BET", "TABLE"}),

  // --- 10 Six-Letter Puzzles (8 solutions each) ---
  WordConnectLevel(letters: "RAOGNE", solutions: {"ORANGE", "RANGE", "RANG", "GEAR", "RAGE", "NEAR", "EARN", "GORE"}),
  WordConnectLevel(letters: "UMSRME", solutions: {"SUMMER", "MUSER", "RUM", "SUM", "SUE", "USE", "RUSE", "MUSE"}),
  WordConnectLevel(letters: "NIWRET", solutions: {"WINTER", "WRITE", "RENT", "TIRE", "WREN", "TERN", "TWIN", "WINE"}),
  WordConnectLevel(letters: "TUANMU", solutions: {"AUTUMN", "ANT", "AUNT", "MAN", "MAT", "MINT", "NUT", "TUNA"}),
  WordConnectLevel(letters: "APLTNE", solutions: {"PLANET", "PLANT", "LANE", "LATE", "PANE", "PANT", "PEAT", "LEAPT"}),
  WordConnectLevel(letters: "RPSNIG", solutions: {"SPRING", "RING", "GRIN", "PIG", "PIN", "RIG", "RIP", "GRIP"}),
  WordConnectLevel(letters: "IRBEDG", solutions: {"BRIDGE", "RIDGE", "RIDE", "GRID", "DIRE", "BRED", "BRIG", "GIRD"}),
  WordConnectLevel(letters: "IUGATR", solutions: {"AIR", "ART", "GUT", "RAG", "RAT", "RUG", "TAG", "GUITAR"}),
  WordConnectLevel(letters: "CAJEKT", solutions: {"ACE", "ACT", "ATE", "CAT", "EAT", "JET", "TEA", "JACKET"}),
  WordConnectLevel(letters: "OLFREW", solutions: {"FLOWER", "FOWL", "FORE", "FLOW", "WOLF", "ROLE", "FOE", "LOWER"}),
];
