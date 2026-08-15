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
**832 signature abilities** mapped across all 21 CoA classes and 70 class/spec
combinations.

This works differently from the stock detection for a specific reason: sArena's
normal spec detection is gated behind `UnitClass()`, and there's no verified public
mapping of which base WotLK class each CoA class runs on underneath. Rather than
guess and risk silently wrong results, CoA detection runs as a fully independent
path that identifies class and spec directly from the ability cast, ignoring
`UnitClass()` entirely.

### Class icon fix
sArena crops class icons out of a shared 10-class texture sheet. For CoA characters
the lookup failed, which errored and left the icon displaying the **entire uncropped
sheet** — every class icon at once. Now handled safely, falling back to a real CoA
class icon.

### Module toggles (new)
Previously all-or-nothing. Now individually switchable:
- **Enable Diminishing Returns Tracking** — master switch on the DR tab
- **Enable Spec Detection** — turn off to show only class, never spec
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
- **Spec detection may take a moment** at the start of a match, since it can only
  identify a spec once that player casts a signature ability.

## How it works

sArena replaces the default arena frames with customisable ones showing enemy
health, casts, trinket cooldowns, DR tracking, and class/spec icons.

- `/sarena` to open settings
- **Ctrl + Shift + click** to drag the frames
- Three layouts included (Blizz, Flat, Xaryu), each fully customisable

## Installation

1. Download and extract
2. Place the `sArena` folder into `Interface\AddOns\`
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
