# OpenSCAD Colors

The default color is `Gold`.
Its hue rotations are the following.

|       | Start |   End |
| Index | Angle | Angle | Name
|------:|------:|------:|:-----
|     0 |   353 |     4 | `Gold`
|     1 |     4 |    19 | `Yellow`
|     2 |    21 |    27 | `GreenYellow`
|     3 |    27 |    39 | `Chartreuse`
|     4 |    34 |    49 | `LawnGreen`
|     5 |    54 |    83 | `Lime`
|     6 |    90 |   101 | `SpringGreen`
|     7 |   102 |   115 | `MediumSpringGreen`
|     8 |   124 |   133 | `Aqua`
|     9 |   139 |   149 | `DeepSkyBlue`
|    10 |   152 |   158 | `DodgerBlue`
|    11 |   178 |   207 | `Blue`
|    12 |   223 |   234 | `DarkViolet`
|    13 |   235 |   261 | `Fuchsia`
|    14 |   263 |   283 | `DeepPink`
|    15 |   286 |   296 | `Crimson`
|    16 |   298 |   316 | `Red`
|    17 |   321 |   333 | `OrangeRed`
|    18 |   334 |   344 | `DarkOrange`
|    19 |   345 |   353 | `Orange`

Cull the table to get this even palette at 30 degree increments.

|   Old |   New | Start |   End | Rough |
| Index | Index | Angle | Angle | Angle | Name
|------:|------:|------:|------:|------:|:-----
|     0 |     0 |   353 |     4 |     0 | `Gold`
|     3 |     1 |    27 |    39 |    30 | `Chartreuse`
|     5 |     2 |    54 |    83 |    60 | `Lime`
|     6 |     3 |    90 |   101 |    90 | `SpringGreen`
|     8 |     4 |   124 |   133 |   120 | `Aqua`
|    10 |     5 |   152 |   158 |   150 | `DodgerBlue`
|    11 |     6 |   178 |   207 |   180 | `Blue`
|    12 |     7 |   223 |   234 |   210 | `DarkViolet`
|    13 |     8 |   235 |   261 |   240 | `Fuchsia`
|    14 |     9 |   263 |   283 |   270 | `DeepPink`
|    16 |    10 |   298 |   316 |   300 | `Red`
|    17 |    11 |   321 |   333 |   330 | `OrangeRed`

Cull further to get this even palette at 60 degree increments.

|   Old |   New | Start |   End | Rough |
| Index | Index | Angle | Angle | Angle | Name
|------:|------:|------:|------:|------:|:-----
|     0 |     0 |   353 |     4 |     0 | `Gold`
|     5 |     1 |    54 |    83 |    60 | `Lime`
|     8 |     2 |   124 |   133 |   120 | `Aqua`
|    11 |     3 |   178 |   207 |   180 | `Blue`
|    13 |     4 |   235 |   261 |   240 | `Fuchsia`
|    16 |     5 |   298 |   316 |   300 | `Red`

Cull another way to get this even palette at 90 degree increments.

|   Old |   New | Start |   End | Rough |
| Index | Index | Angle | Angle | Angle | Name
|------:|------:|------:|------:|------:|:-----
|     0 |     0 |   353 |     4 |     0 | `Gold`
|     6 |     1 |    90 |   101 |    90 | `SpringGreen`
|    11 |     2 |   178 |   207 |   180 | `Blue`
|    14 |     3 |   263 |   283 |   270 | `DeepPink`
