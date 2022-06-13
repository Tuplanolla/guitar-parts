# Guitar Parts

Let the `x` axis go along the neck,
growing from the saddle towards the nut.
Let the `y` axis go across the neck,
growing from the first (highest) string towards the last (lowest) one.
Let the `z` axis go through the neck,
growing from the heel towards the fretboard.
Let the strings be numbered from `1` to `6`,
as the strange yet common convention suggests.
Let the unit of measurement be `1` millimeter.

We measured old and worn parts of a classical guitar,
documented them with hasty drawings and
based this parametric model on them.
The goal of the project was to get acquainted with OpenSCAD and
to manufacture better replacement parts
than there are commercially available.

We did not know which strings the guitar originally had,
so we measured them and compared them to new
Augustine Concert Blue (High Tension) and
Augustine Concert Black (Low Tension) strings,
whose dimensions were kindly provided by Strings by Mail.

|     Strings     |  Specifications | Measurements |
| Ordinal | Pitch |   Blue |  Black | Blue | Black |
|--------:|:------|-------:|-------:|-----:|------:|
|       1 | E4    | 0.7112 | 0.7112 |  0.7 |   0.7 |
|       2 | B3    | 0.8128 | 0.8128 |  0.8 |   0.8 |
|       3 | G3    | 1.0160 | 1.0160 |  1.0 |   1.0 |
|       4 | D3    | 0.7747 | 0.7239 |  0.7 |   0.7 |
|       5 | A2    | 0.9144 | 0.8255 |  0.9 |   0.9 |
|       6 | E2    | 1.1430 | 1.1049 |  1.1 |   1.1 |

For the remaining parts,
we used a vernier caliper and a steel ruler
to make sufficiently accurate measurements.
We assumed measurements to have an absolute uncertainty of `0.1`,
with the exception of measurements marked with

* `+` to indicate an uncertainty of `0.2`,
* `+2` to indicate an uncertainty of `0.4`,
* `+3` to indicate an uncertainty of `0.8`,
* `+4` to indicate an uncertainty of `1.6` (actually rounded up to `2`),
* `+5` to indicate an uncertainty of `3.2` (actually rounded up to `4`),
* ...
* `+n` to indicate an uncertainty of `0.1 * 2 ^ n`
  (actually rounded up to `let x = 0.1 * 2 ^ n in
  let r = 10 ^ (floor (log10 (x))) in
  r * ceil (x / r)`).

## Nut

```
              2.2+3
              |--|
              |  |
    --------- ,--.
    |         |   . ---------
8.8 |      -- ,-. |         |
    | 6.8+ |  |  `. --      | 5.6+3
    |      |  |   |  | 5.6+ |
z   --------- +---+ ---------
^             |   |
|             |---|
+--> x         5.4
```

```
                                 50.0
         |---------------------------------------------------|
         |   0.8    0.9      1.1     0.8    1.0      1.2     |
         |   |-|   |---|   |-----|   |-|   |---|   |-----|   |
         |   | |   |   |   |     |   | |   |   |   |     |   |
      --- ,--. ,---.   ,---.     ,---. ,---.   ,---.     ,--.
1.6+3 |  ,   | |   |   |   |     |   | |   |   |   |     |   .
      -- |   `-'   `---'   `-----'   `-'   `---'   `-----'   |
       ,-+---------------------------------------------------+-.
       | |   | |   |   |   |     |   | |   |   |   |     |   | |
z      ` |---| |---|   |---|     |---| |---|   |---|     |---| '
^      |  3.8+  7.4     7.4       7.4   7.4     7.4       3.8+ |
|      |-------------------------------------------------------|
+--> y                           51.4
```

The widths sum up to 49.8 instead of 50.0.

```
          /.
         /  `-.
        /.     `-.
       /  `-.     `-.  128+4
      /.     `-. 94+4`-.
     /  `-. 58+4`-.     `-.
----.      `-.     `-.     `-.
  | |`-.      `/      `/      `/
--+-+---`-.---/-. ----/-------/----------------
           >-.   `-. /       /  | 34+5 |      |
----.      |o|`-.   /-. ----/----      | 42+5 |
     `-. / `-'   >-.   `-. /           |      | 48+5
        /-. /    |o|`-.   /-. ----------      |
       /   /-.   `-'   >-.   `-.              |
      /.  /   `-.      |o|      `, ------------
z   9.0 `/       `-.   `-'      /
^                   `-.        /
|                      `-.    /
+--> x                    `-.'
```

## Saddle

```
               0.8+3
               |-|
               | |
     --------  ,-.
     |        ,   . --------
8.0+ |        |   |        |
     |        |   |        | 7.0+
     |        |   |        |
z    -------- +---+ --------
^             |   |
|             |---|
+--> x         2.8
```

```
                                 76.8
         |---------------------------------------------------|
         |   0.8    0.9      1.1     0.8    1.0      1.2     |
         |   |-|   |---|   |-----|   |-|   |---|   |-----|   |
         |   | |   |   |   |     |   | |   |   |   |     |   |
         |   ,-.   ,---.   ,-----.   ,-.   ,---.   ,-----.   |
      --- ,--`-'---`---'---`-----'---`-'---`---'---`-----'--.
2.0+3 |  ,                                                   .
      -- |                                                   |
       ,-+---------------------------------------------------+-.
       | |   | |   |   |   |     |   | |   |   |   |     |   | |
z      ` |---| |---|   |---|     |---| |---|   |---|     |---| '
^      | 12.2+  9.4     9.4       9.4   9.4     9.4      12.2+ |
|      |-------------------------------------------------------|
+--> y                          77.0
```

The widths sum up to 77.2 instead of 76.8.

```
                             ,\
                     12+4 ,-'  \
                       ,-'      \
                    ,-'          \
                  \'              ,--------- ------------
                   \           ,-'   .            |     |
      ---- ,--------\.      ,-'  |   |            | 3.2 |
  4.2 |   ,          \.  ,-'  ,--|   |--. ---------     | 13.0
      --- >-----------<-'    /   |   |   .  | 5.0 | 9.8 |
  5.6 |   |            `----'    +---+ --|---     |     |
z   ------+------------------------------+-----------------
^         |           |      |           |
|         |-----------|      |-----------|
+--> x        12.0+2             12.0+2
```

## Fretboard

```
z       ,---------------------------------------------------------.
        | |   |                |          6.2 |   2.6 |  1.8 |  | |
^       | |   | 13.6      11.4 |  +---------(12)-----(1)----(0)-+-+
|       | |   |                |  |  | 5.2
+--> x  +-+-(oo)-------------(20)-+ --
```
