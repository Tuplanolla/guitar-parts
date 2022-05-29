$e = 1e-3;
$fn = 16;
$pal = ["Gold", "Lime", "Aqua", "Blue", "Fuchsia", "Red"];

// The invocation `sum(v, i, a)` yields the sum
// of the elements of the vector `v`,
// starting from the index `i` and the accumulator value `a`.
function sum(v, i = 0, a = 0) =
  i < len(v) ? sum(v, 1 + i, a + v[i]) : a;

// The invocation `cumsum(v, i, a)` yields a vector
// of the cumulative partial sums of the elements of the vector `v`,
// starting from the index `i` and the accumulator value `a`.
function cumsum(v, i = 0, a = 0) =
  i < len(v) ? concat([a], cumsum(v, 1 + i, a + v[i])) : a;

// The invocation `hue(i)` colors its children
// with the color at the index `i`
// in the current palette `$pal`.
module hue(i) {
  color($pal[i % len($pal)])
    children();
}

// The invocation `hollow_cylinder(h, r0, r1)` produces a hollow cylinder
// with the height `h`, the inner radius `r0` and the outer radius `r1`.
// The base of the cylinder is placed at the origin and
// its height grows along the `z` axis.
module hollow_cylinder(h, r0, r1) {
  difference() {
    hue(3)
      cylinder(h, r1, r1);
    translate([0, 0, - $e])
      hue(4)
      cylinder(2 * $e + h, r0, r0);
  }
}

// The invocation `torus(r0, r1)` produces a torus
// with the toroidal radius (the distance
// from the center of mass of the torus
// to the centerline of the tube) `r0` and
// the poloidal radius (the distance
// from the centerline of the tube
// to the surface of the torus) `r1`.
// The center of mass of the torus is placed at the origin and
// the tube revolves around the `z` axis.
module torus(r0, r1) {
  translate([0, 0, - r1])
    hue(5)
    rotate_extrude()
    translate([r0, r1, 0])
    circle(r1);
}

/*
According to Strings by Mail,
Augustine Concert Blue strings have these diameters.

| I | N | Diameter
|--:|:--|:---------
| 1 | E | 0.7112
| 2 | B | 0.8128
| 3 | G | 1.016
| 4 | D | 0.7747
| 5 | A | 0.9144
| 6 | E | 1.143

## Worn Metrics

### Block

       5.3
      |--|

       ,-+ -
    - /  | | 8.7
5.4 | |  | |
    - +--+ -

### Slots

       49.9
|--------------|

lesser   greater
+--------------+ -                -
|              | | 6.8 sharp edge | 5.8 round edge
| |  |         | -                -
+-^--^---------+

|-|--|
3.8 7.2
    edge-to-edge
  ||
  1.0 hole

### Slot Curvature

      /  64
-----+.  ------------------
       `-. /  128    | 24 |
 22.5 °  o`-.  -------    | 36
             `-. /        |
               o`-. -------
*/

// Height of the nut (perpendicular to the neck).
h = 8.7;
// Depth of the nut (along the neck).
d = 5.3;
// Radius of curvature of the rounded edge.
r = h - 5.4;
// Cut depth of slots on the sharp edge.
cutdepth_worn = h - 5.8;
// We add leeway to accommodate wear.
cutdepth = h - (5.8 + 0.5);
// Width of the nut (same as the width of the neck).
w_trial = 49.9;
// The width of the printed version is 49.9 wide,
// but still seems to be 0.5 too narrow on both sides.
// We add leeway to correct for this.
w = 49.9 + 1.1;
// Distances of the first and last slots from the edges.
// bi = 3.8;
// Distance between slots.
di = 7.2;
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
bi = (w - ads[nslot] - di * (nslot - 1)) / 2;
echo(bi = bi);
assert(bi >= 0, "Slots are wider than they should be!");
// Angle at which the lowest and highest strings turn to the tuner.
alpha0 = atan2(24, 64);
// Angle at which the two middle strings turn to the tuner.
alpha1 = atan2(36, 128);
// Maximum angle at which the strings turn to the tuner.
alpha = max([alpha0, alpha1]);
echo(alpha = alpha);
assert(alpha < 90, "Slots turn more than they should!");
// Radius of curvature of the bottom of each slot.
rc = d / sin(alpha);

module bulk() {
  hue(0)
    cube([d, w, h]);
}

module removed_quad() {
  hue(1)
    translate([0, - $e, 0])
    cube([$e + r, 2 * $e + w, $e + r]);
}

module round_shaping() {
  hue(2)
    translate([0, - 2 * $e, 0])
    rotate([- 90, 0, 0])
    cylinder(4 * $e + w, r, r);
}

module cut_out() {
  translate([- r, 0, - r])
    difference() {
      removed_quad();
      round_shaping();
    }
}

module uncut_diamond() {
  difference() {
    bulk();
    translate([d, 0, h])
      cut_out();
  }
}

module cutting_plane(i) {
  let (d = dds[i])
    translate([0, 0, h - rc + d])
    // This rotation is here just to accommodate low values of `$fn`.
    rotate([0, 180 / $fn, 0])
    rotate([90, 0, 0]) {
      translate([0, 0, - d])
        hollow_cylinder(2 * d, rc, h + rc);
      torus(rc, d);
    }
}

difference () {
  uncut_diamond();
  for (i = [0 : nslot - 1])
    translate([0, bi + di * i + ads[i] + dds[i] / 2, - cutdepth])
    cutting_plane(i);
}
