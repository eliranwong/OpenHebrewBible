# `morphology.sqlite` — `Translation` Alignment Fixes Applied

- **Date:** 2026-11-18
- **Target:** `data/morphology.sqlite` → table `morphology` (`564,594` total rows: `426,581` OT in `Book <= 39`, `138,013` NT in `Book > 39`)
- **Total rows updated:** `3,237` (all in OT, `Book <= 39`; NT left untouched)

---

## Background & Scope

In the OT portion of `morphology`, Hebrew graphic words are split into morpheme rows (e.g., `וְ` + `אֵת` + `הָ` + `אָרֶץ`), whereas the `Translation` column (from Berean Study Bible interlinear data) occasionally had tokens shifted onto an adjacent morpheme—most frequently onto `אֵת`/`אֶת` (`Gloss = '[object marker]'`, `MorphologyCode = 'prep'`) or onto a neighboring noun, verb, or preposition—while the corresponding `conj`, `prep`, `art`, or `.prs.` row was left empty (`''`).

The `Gloss`, `Interlinear`, and `MorphologyCode` columns were used as the ground-truth alignment reference.

---

## Rules Applied

### 1. Misplaced Conjunctions (`1,298` moves; `2,596` rows updated)
- **Condition:** A row with `MorphologyCode` not starting with `conj` (and not `advb` for adverbial conjunctions `so`/`then`/`now`/`also`/`even`) had a standalone conjunction `Translation` (`and`, `but`, `or`, `yet`, `however`, `moreover`, `therefore`, `nevertheless`, `meanwhile`, `besides`, `otherwise`, `instead`, `later`, `additionally`, `furthermore`, `so`, `then`, `now`, `also`, `even`), **or** a pure `[object marker]` row (`Gloss = '[object marker]'`, `MorphologyCode = 'prep'`) had `along with`, `as well as`, `together with`, `including`, `with`, `so that`, or `in addition to`.
- **Action:** Moved `Translation` to the matching empty `conj` row (`Translation = ''`) in the same `ClauseID` (preferring the immediately preceding `conj` row, or searching backward in the clause for capitalized clause-initial conjunctions).
- **Examples:**
  - Genesis 1:1 (`WordID 9` `אֵ֥ת` `'and'` → `WordID 8` `וְ` `'and'`)
  - Genesis 1:16 (`WordID 301` `אֶת` `'and'` → `WordID 300` `וְ` `'and'`)
  - Genesis 1:21 (`WordID 383` `אֶת` `'So'` → `WordID 380` `וַ` `'So'`)
  - Genesis 1:28 (`WordID 559` `אֱלֹהִ֗ים` `'and'` → `WordID 556` `וַ` `'and'`)
  - Genesis 3:15 (`WordID 1459` `בֵּֽינְךָ֙` `'And'` → `WordID 1456` `וְ` `'And'`)
  - Genesis 4:14 (`WordID 1903` `הָיָ֥ה` `'and'` → `WordID 1902` `וְ` `'and'`)

### 2. Misplaced Prepositions (`237` moves; `474` rows updated)
- **Condition:** A row with `MorphologyCode` not starting with `prep` or `conj` had a standalone basic preposition `Translation` (`in`, `to`, `from`, `upon`, `on`, `at`, `by`, `into`, `unto`, `for`, `of`, `with`).
- **Action:** Moved `Translation` to an empty `prep` row (excluding `[object marker]`) within ±2 positions in the same `ClauseID`.
- **Example:**
  - Genesis 7:11 (`WordID 3229` `שְׁנַ֨ת` `'In'` → `WordID 3228` `בִּ` `'In'`)

### 3. Misplaced Articles (`37` moves; `74` rows updated)
- **Condition:** A row with `MorphologyCode` not starting with `art` or `conj` had a standalone article `Translation` (`the`, `a`, `an`).
- **Action:** Moved `Translation` to an adjacent empty `art` row (`הַ` / `הָ`) at ±1 position in the same verse.
- **Example:**
  - Genesis 21:10 (`WordID 9757` `זֹּ֖את` `'the'` → `WordID 9756` `הַ` `'the'`)

### 4. Misplaced Pronouns & Possessives on `[object marker]` (`47` cases; `93` rows updated)
Applied to remaining `Gloss = '[object marker]'` and `MorphologyCode = 'prep'` rows:
1. **Empty `.prs.` target (`15` moves):** Moved standalone object/prepositional pronouns (`him`, `them`, `you`, `it`, `her`, `me`, `us`, `to you`, `to him`, `to them`, `with them`, `in it`, etc.) onto a preceding empty `.prs.` row within the same verse (up to 4 positions back).
   - *Examples:* Genesis 1:30 (`WordID 645` `'in it—'` → `WordID 642` `בֹּו֙`); Genesis 9:3 (`WordID 4100` `'you'` → `WordID 4099` `לָכֶ֖ם`).
2. **Split object pronoun merge (`22` merges):** Appended trailing pronouns from `[object marker]` onto the preceding non-empty `.prs.` row (within −2 positions) and cleared `[object marker]`.
   - *Examples:* Genesis 44:24 (`WordID 25270` `לֹ֔ו` `'to'` + `WordID 25271` `אֵ֖ת` `'him.'` → `WordID 25270` `'to him.'`); Genesis 48:13 (`WordID 27532` `שְׁנֵיהֶם֒` `'both'` + `WordID 27533` `אֶת` `'of them—'` → `WordID 27532` `'both of them—'`).
3. **Split possessive pronoun merge (`10` merges):** Prepended possessive pronouns (`my`, `your`, `his`, `her`, `its`, `our`, `their`) from `[object marker]` onto the following `.prs.` row and cleared `[object marker]`.
   - *Example:* Genesis 24:64 (`WordID 12349` `אֶת` `'her'` + `WordID 12350` `עֵינֶ֔יהָ` `'eyes,'` → `WordID 12350` `'her eyes,'`).

---

## Intentionally Untouched / Remaining Items for Future Review

- **BSB phrase-level & English-order translations:** Cases where BSB attaches an article or preposition to a head noun (e.g., `הַ` `''` + `שָּׁמַיִם` `'the heavens'`), renders construct idioms on one word (`מַזְרִיעַ` `'seed-bearing'` + `זֶרַע` `''`), or follows English word order (`יֵּצֵא` `'David'` + `דָוִיד` `'went out'`) were preserved as-is.
- **Bracketed implied words on `[object marker]`:** Implied English additions without a Hebrew word (e.g., `WordID 311` `'[He made]'` in Genesis 1:16, `WordID 15654` `'[Jacob]'` in Genesis 30:4) were left in place.
- **Remaining non-bracketed `[object marker]` rows:** A small set of verse-specific cases (e.g., `WordID 35312` `'the Egyptians'` in Exodus 12:27, `WordID 37857` `'So'` in Exodus 16:23, `WordID 4739` `'of'` in Genesis 10:15) remain for targeted/manual review.

---

# `morphology.sqlite` — `LexicalEntry` (`H` Strong's Number) Fixes Applied

- **Date:** 2026-11-18
- **Target:** `data/morphology.sqlite` → table `morphology`, column `LexicalEntry` (`Book <= 39` OT only)
- **Total rows updated:** `1,915` (all in OT, `Book <= 39`; `0` `E...` numbers changed; `0` NT rows changed; `0` malformed `LexicalEntry` values)

## Background & Reference

In the OT portion of `morphology`, `LexicalEntry` pairs each BHSA extended Strong's number (`E7xxxx`, which maps 1-to-1 with BHSA `Lexeme`) with one or more Strong's numbers (`H...`) derived from WLC–BHS alignment in `002-BHS-with-Strong-no`. Alignment shifts, adjacent-word swaps/duplications, and POS/homograph confusions left some OT words with incorrect `H` numbers.

`018-TBESH-formatted/TBESH_parsed.csv` together with BHSA `Lexeme`, `MorphologyCode`, and `Gloss` were used as the ground-truth reference.

## Fixes Applied

1. **Unrelated / Misaligned `H` Numbers (Consonant-Skeleton & Alignment Fixes):**
   - Corrected minority `H` numbers whose TBESH Hebrew/Aramaic lexeme did not match the row's `Lexeme` consonant skeleton (e.g., adjacent-word swaps/duplications and prefix misalignments).
   - *Examples:*
     - 1 Kings 17:14 (`WordID 190106` `יְהוָ֛ה` `E70113,H5414,` → `E70113,H3068,`)
     - 2 Chronicles 28:3 (`WordID 420378` `הֹרִ֣ישׁ` `E70746,H3068,` → `E70746,H3423,`; `WordID 420379` `יְהוָ֔ה` `E70113,H3423,` → `E70113,H3068,`)
     - 2 Kings 5:18 (`WordID 197922` `יִסְלַח` `E72427,H5545,H4994,` → `E72427,H5545,`)
     - Prefixes/particles: `לְ` (`E70028`/`E75936` `H1992`/`H3606`/`H3808`/etc. → `H9005`), `מִן` (`E70038` `H1992`/etc. → `H4480`), `בְּ` (`E70001` `H2004`/etc. → `H9003`), `שַׁ` (`E70363` 53 misaligned `H` numbers → `H7945`), `אֲרָם` (`E70556` `H6307` → `H758`), `אִישׁ` (`E70186` `H582` → `H376`).
2. **Part-of-Speech & Homograph Mismatches:**
   - Corrected `H` numbers where a verb `E`-number was tagged with a noun/adjective `H`-number (or vice versa), or homographs were swapped.
   - *Examples:* `אֵת` `[object marker]` (`E70005` `H854` → `H853`), `אֵת` `together with` (`E70264` `H853` → `H854`), `טוב` verb (`E70024` `H2896` → `H2895`), `עֹמֶד` noun (`E78183` `H5975` → `H5977`), `מעל`/`מַעַל` (`E72482`/`E72483` → `H4603`/`H4604`), `מָוֶת` noun (`E70947` `H4191` → `H4194`), `אֶל`/`אַל` (`E70043`/`E70653` → `H413`/`H408`), `לֵוִי` (`E71874` Levite → `H3881`; `E71220` Levi → `H3878`).
3. **Hebrew vs. Aramaic Mismatches:**
   - Corrected Aramaic `E`-numbers tagged with Hebrew `H`-numbers and vice versa (e.g., Aramaic `עַל` `E77672` `H5921` → `H5922`, Aramaic `כֹּל` `E76970` `H3605` → `H3606`, Hebrew `קָצָה` `E72238` `H7118` → `H7098`).
4. **Single-`H` Mapping Errors:**
   - Isa 7:19 (`WordID 214600` `נַּהֲלֹלִֽים` `E75237,H5285,` → `E75237,H5097,`)
   - Isa 30:10 (`WordID 221973` `מַהֲתַלֹּֽות` `E75567,H2372,` → `E75567,H4123,`)
   - Jer 29:17 (`WordID 249842` `שֹּׁ֣עָרִ֔ים` `E76038,H8384,` → `E76038,H8182,`)
   - Ezek 47:2 (`WordID 289724` `מְפַכִּ֔ים` `E76434,H6349,` → `E76434,H6379,`)
   - Job 9:30 (`WordID 338532` `שָׁ֑לֶג` `E77073,H4325,` → `E77073,H7950,`)
   - Prov 24:31 (`WordID 353674` `קִמְּשֹׂנִ֗ים` `E77335,H2738,` → `E77335,H7063,`)

## Intentionally Preserved

- All `E...` extended Strong's numbers in `LexicalEntry` and all NT rows (`Book > 39`).
- Compound proper names with multiple `H` numbers (e.g., `בֶן־הִנֹּם` `E73634,H1121,H2011,`).
- Legitimate Strong's distinctions sharing one `E` number (e.g., `H3068`/`H3069` for `יְהוָה`, `H1167`/`H1168` for `בַּעַל`, `H905`/`H906` for `בַּד`, `H2009`/`H2005` for `הִנֵּה`/`הֵן`, `H4714`/`H4713` for Egypt/Egyptian, singular/tens number pairs, biform roots, and Kethib/Qere pairs).


