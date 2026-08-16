# sArena — Conquest of Azeroth Port

> **Enjoying these ports?**
> If they've saved you some time, you can [buy me a coffee ☕](https://ko-fi.com/albusdev).
> Totally optional — everything here is free and always will be.

---

A port of the **sArena** enhanced arena frames addon, updated for **Conquest of
Azeroth** (Project Ascension's 21-class realm).

The existing Ascension build of sArena predates CoA — it was written for the
classless Bronzebeard/Malfurion realms, and its own README flagged the DR and
trinket trackers as needing spell ID updates. On CoA, DR tracking and spec
detection didn't function at all, and the class icon was visibly broken. This port
addresses all of that. 

## What this port adds

### DR tracking for CoA
**189 CoA abilities** added to the diminishing returns list, across all 21 classes:

| Category | Count |
|---|---|
| Incapacitate | 67 |
| Stun | 47 |
| Root | 33 |
| Silence | 30 |
| Disarm | 12 |

### Class & spec detection
Detection runs in two stages, so the icon is populated **as the gates open** rather
than whenever the enemy first happens to act:

1. **Class, at the gates.** **248 class buffs** across all 21 classes. Every CoA class
   has long-duration (mostly 30 minute) buffs that players put up during the
   preparation phase, so they're already on the enemy the moment the gates open and
   the frames become readable. Each of these names maps to exactly one class with no
   collisions anywhere in the ability data, so a match is never ambiguous.
2. **Spec, once they show it.** **832 signature abilities** across 70 class/spec
   combinations. The first one seen upgrades the frame from a class icon to a spec
   icon.

**Stage 1 is what you get by default — spec detection ships turned off.** The class
icon is known at the gates and then stays put for the whole match, whereas a spec can
only be pinned down once the enemy uses a signature ability, so turning spec detection
on means accepting an icon that changes partway through the match. Enable it under
`/sarena` → **Enable Spec Detection** if that trade is worth it to you.

A class buff only counts when the enemy is its own aura source. These buffs have
30–40 yd range and get handed to the whole enemy team, so an unfiltered scan would
report one player's class on every enemy frame.

Both stages work differently from the stock detection for a specific reason: sArena's
normal spec detection is gated behind `UnitClass()`, and there's no verified public
mapping of which base WotLK class each CoA class runs on underneath. Rather than
guess and risk silently wrong results, CoA detection runs as a fully independent
path that ignores `UnitClass()` entirely.

Class buffs are also deliberately never read as evidence of a spec. 48 of them also
appear in the spec table against one arbitrary spec of their class, but any spec of
that class can carry them — previously that could pin a wrong spec to a frame for the
rest of the match.

### Class icon fix
sArena crops class icons out of a shared 10-class texture sheet. For CoA characters
the lookup failed, which errored and left the icon displaying the **entire uncropped
sheet** — every class icon at once. Now handled safely, falling back to a real CoA
class icon.

### Module toggles (new)
Previously all-or-nothing. Now individually switchable:
- **Enable Diminishing Returns Tracking** — master switch on the DR tab
- **Enable Spec Detection** — **off by default.** Turn it on to have the class icon
  upgrade to a spec icon once the enemy uses a signature ability. This now does what it
  says on CoA: with it off, the class icon still resolves from the enemy's buffs and
  only the spec is suppressed. Previously it switched off the one detection path CoA
  had, leaving a question mark for the whole match.
- **Enable Class/Spec Icons** — hides the icons entirely and stops detection running
- **Enable Cast Bar** — hides the cast bar module

### Other fixes
- Trinket icon is now consistently the plain faction insignia (Horde/Alliance)
  rather than switching to a different icon for Human characters
- Removed a dangling reference to `Modules/ArenaCountDown.lua`, a file that doesn't
  exist in the upstream repo

## Known limitations

- **Trinket tracking covers the standard PvP trinket and Every Man for Himself
  only.** CoA classes have their own personal CC-break abilities, but sArena has a
  single trinket slot per frame with no concept of "this is the real trinket" — so
  adding them caused a class ability's short cooldown to display *as if* it were the
  enemy's trinket, which is worse than not tracking them at all. Left out deliberately.
- **The spec icon resolves progressively, which is why it's opt-in.** The class icon is
  up as the gates open, but narrowing a class to one of its specs needs the enemy to use
  a signature ability. With **Enable Spec Detection** turned on, the frame therefore
  shows class-only for the opening moments and then switches icon mid-match.
- **Gates-open class detection assumes the enemy buffed up.** That's essentially
  universal in arena, but an unbuffed opponent falls back to being identified from
  their first cast, as before.
- **There is no API shortcut for this on CoA.** The 3.3.5 client has no arena-prep
  spec API, `UnitClass()` doesn't report CoA classes, and Ascension exposes no
  custom call for an opponent's class — reading the enemy's auras is the only thing
  available at the gates.

## How it works

sArena replaces the default arena frames with customisable ones showing enemy
health, casts, trinket cooldowns, DR tracking, and class/spec icons.

- `/sarena` to open settings
- **Ctrl + Shift + click** to drag the frames
- Three layouts included (Blizz, Flat, Xaryu), each fully customisable

## Installation

1. Download and extract
2. Place the `sArena` folder into `Interface\AddOns\` (make sure the folder is
   named exactly `sArena`, with no version suffix like `-master`)
3. Enable **"Load out-of-date AddOns"** on the character select screen if it
   doesn't appear
4. `/reload` or restart the game

## Credits

All credit for the original addon goes to its authors — this port updates spell
data and fixes CoA-specific breakage.

- Original addon: sArena by **Stako**, with edits by **Aeded**, **Xyz**, and **Hannahmckay**
- Ascension base used for this port: [MCribari/sArena-Ascension](https://github.com/MCribari/sArena-Ascension)
- Additional credits from the original: Tekkub, Starship, Kouri, Kollektiv, Lyn,
  haste, evl, Zork, jturel, wardz
- CoA spell data sourced from [johnayoung/coa-arena](https://github.com/johnayoung/coa-arena)

This port is not affiliated with or endorsed by the original authors, Project
Ascension, or Blizzard Entertainment.
