/** # Guitar Nut

    Let the $x$ axis go along the neck,
    growing from the bridge to the nut.
    Let the $y$ axis go across the neck,
    growing from the first (highest) string to the last (lowest) one.
    Let the $z$ axis go through the neck,
    growing from the heel to the fretboard.

    We measured the worn nut on the guitar.

    The strings are numbered as follows.
    According to Strings by Mail,
    strings have the following dimensions.
    We have Augustine Concert Blue (High Tension) and
    Augustine Concert Black (Low Tension) strings.

    |     String     |   Specification |  Measurement |
    | Ordinal | Note |   Blue |  Black | Blue | Black |
    |--------:|:-----|-------:|-------:|-----:|------:|
    |       1 | E4   | 0.7112 | 0.7112 |  0.7 |   0.7 |
    |       2 | B3   | 0.8128 | 0.8128 |  0.8 |   0.8 |
    |       3 | G3   | 1.0160 | 1.0160 |  1.0 |   1.0 |
    |       4 | D3   | 0.7747 | 0.7239 |  0.7 |   0.7 |
    |       5 | A2   | 0.9144 | 0.8255 |  0.9 |   0.9 |
    |       6 | E2   | 1.1430 | 1.1049 |  1.1 |   1.1 |

    We could call the things *groove* or *slot*.
    By default, quantities have uncertainties of 0.1.

    ```
                 2.2++
                 |--|
                 |  |
        -------- ,--.
        |        |   . --------
    8.8 |     -- ,-. |        |
        | 6.8+|  |  `. --     | 5.6++
        |     |  |   |  | 5.6+|
    z   -------- +---+ --------
    ^            |   |
    |            |---|
    +--> x        5.4
    ```

    The quantities marked with `+` have uncertainties of 0.2 and
    the quantities marked with `++` have uncertainties of 0.8.

    ```
             3.8   7.4     7.4       7.4   7.4     7.4       3.8
            |---| |---|   |---|     |---| |---|   |---|     |---|
            |   | |   |   |   |     |   | |   |   |   |     |   |
            ,---. ,---.   ,---.     ,---. ,---.   ,---.     ,---.
            |   | |   |   |   |     |   | |   |   |   |     |   |
            |   `-'   `---'   `-----'   `-'   `---'   `-----'   |
            +---------------------------------------------------+
            |   | |   |   |   |     |   | |   |   |   |     |   |
            |   |-|   |---|   |-----|   |-|   |---|   |-----|   |
    z       |   0.7    0.8      1.0     0.7    0.9      1.1     |
    ^       |                                                   |
    |       |---------------------------------------------------|
    +--> y                          50.0
    ```

    The small quantities sum up to 49.8.

    ```
               /.
              /  `-.
             /.     `-.
            /  `-.     `-.  128+
           /.     `-. 92+ `-.
          /  `-. 58+ `-.     `-.
        ,-.     `-.     `-.     `-.
    ----| |-.      `/      `/      `/
    ----+-+--`-.---/-. ----/-------/----------------
                >-.   `-. /       /  | 36++ |      |
    -----.      |o|`-.   /-. ----/----      | 46++ |
          `-.   `-'   >-.   `-. /           |      | 56++
             `-.      |o|`-.   /-. ----------      |
                `-.   `-'   >-.   `-.              |
                   `-.      |o|      `, ------------
    z                 `-.   `-'      /
    ^                    `-.        /
    |                       `-.    /
    +--> x                     `-.'
    ```

    The quantities marked with `+` have uncertainties of 2 and
    the quantities marked with `++` have uncertainties of 8. */

$e = 1e-3;
$fn = 16;
$csi = 0;

use <functions.scad>
use <shapes.scad>

// Height of the nut (perpendicular to the neck).
h = 8.7;
// Depth of the nut (along the neck).
d = 5.3;
// Radius of curvature of the rounded edge (towards the tuners).
r = h - 5.4;
// Radius of curvature of the rounded sides.
rs = 1.6;
// Radius of curvature of the other rounded edge (towards the neck).
rn = 0.8;
// Cut depth of slots on the sharp edge.
cutdepth_worn = h - 5.8;
// We add leeway to accommodate wear.
cutdepth = h - (5.8 + 0.5);
// Width of the nut (same as the width of the neck).
w_trial = 50.0;
// The width of the printed version is 50.0 wide,
// but still seems to be 1.0 too narrow on both sides.
// We add leeway to correct for this.
w = 50.0 + 2.0;
// Distances of the first and last slots from the edges.
// we = 3.8;
// Distance between slots.
// Here 8 would probably be nicer (it divides 48).
di = 7.4;
// String widths from highest to lowest string.
sds = [0.7112, 0.8128, 1.016, 0.7747, 0.9144, 1.143];
// Wiggle room.
dwiggle = 0.1;
// Slot widths from highest to lowest string.
dds = [for (d = sds) dwiggle + d];
ads = cumsum(dds);
// Number of slots.
nslot = len(dds);
// Distances of the first and last slots from the edges.
we = (w - ads[nslot] - di * (nslot - 1)) / 2;
echo(we = we);
assert(we >= 0, "Grooves are wider than they should be!");
// Angle at which the lowest and highest strings turn to the tuner.
alpha0 = atan2(36, 58);
// Angle at which the second and fourth strings turn to the tuner.
alpha1 = atan2(46, 92);
// Angle at which the two middle strings turn to the tuner.
alpha2 = atan2(56, 128);
alphas = [alpha0, alpha1, alpha2, alpha2, alpha1, alpha0];
// Maximum angle at which the strings turn to the tuner.
echo(alphas = alphas);
assert(max(alphas) < 90, "Grooves turn more than they should!");
// Radius of curvature of the bottom of each slot.
rcs = [for (alpha = alphas) d / sin(alpha)];

module bulk() {
  cube([d, w, h]);
}

module removed_quad(r) {
  translate([0, - $e, 0])
    cube([$e + r, 2 * $e + w, $e + r]);
}

module round_shaping(r) {
  translate([0, - 2 * $e, 0])
    rotate([- 90, 0, 0])
    cylinder(4 * $e + w, r, r);
}

module cut_out(r) {
  translate([- r, 0, - r])
    difference() {
      removed_quad(r);
      round_shaping(r);
    }
}

module uncut_diamond() {
  difference() {
    bulk();
    translate([d, 0, h])
      cut_out(r);
    translate([0, 0, h])
      mirror([1, 0, 0])
      cut_out(rn);
    translate([0, 0, h])
      rotate([0, 0, - 90])
      cut_out(rs);
    translate([0, w, h])
      mirror([0, 1, 0])
      rotate([0, 0, - 90])
      cut_out(rs);
  }
}

module cutting_plane(i) {
  let (d = dds[i], rc = rcs[i])
    translate([0, 0, h - rc + d])
    // This rotation is here just to accommodate low values of `$fn`.
    rotate([0, 180 / $fn, 0])
    rotate([90, 0, 0]) {
      translate([0, 0, - d])
        hollow_cylinder(2 * d, rc, h + rc);
      torus(rc, d);
    }
}

module done() {
  difference () {
    uncut_diamond();
    for (i = [0 : nslot - 1])
      translate([0, we + di * i + ads[i] + dds[i] / 2, - cutdepth])
      cutting_plane(i);
  }
}

done();
