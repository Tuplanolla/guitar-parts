// Do the same trick as with the nut,
// except bulk curves on the sides and slots do not curve at all.

/*
## Worn Metrics

       2.8 + 0.1
      |--|

      +--+ -
      |  | | 8.0 + 0.4
      |  | |
      +--+ -

       76 + 1
|--------------|

lesser   greater
+--------------+
|              |
|              |
+---^--^-------+

|---|--|
13   10  (actually with error 13 + 0.5)
    edge-to-edge
    ||
    1.0 nock

The thing here is that the bridge part may be too high.
We should lower it and might also have to add nocks.
*/

$e = 1e-3;
$fn = 16;
$csi = 0;

use <functions.scad>
use <shapes.scad>

// Height of the nut (perpendicular to the neck).
h = 8.0;
// Depth of the nut (along the neck).
d = 2.8;
// Radius of curvature of the rounded edge (towards the tuners).
r = 0.5;
// Radius of curvature of the rounded sides.
rs = 3.0;
// Radius of curvature of the other rounded edge (towards the neck).
rn = 0.5;
// Cut depth of slots on the sharp edge.
cutdepth = 0.5;
// Width of the nut (same as the width of the neck).
w = 76;
// Distances of the first and last slots from the edges.
// bi = 3.8;
// Distance between slots.
di = 10.0;
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
alpha0 = atan2(10, 20);
// Angle at which the two middle strings turn to the tuner.
alpha1 = atan2(10, 20);
// Maximum angle at which the strings turn to the tuner.
alpha = max([alpha0, alpha1]);
echo(alpha = alpha);
assert(alpha < 90, "Slots turn more than they should!");
// Radius of curvature of the bottom of each slot.
rc = d / sin(alpha);

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

module done() {
  difference () {
    uncut_diamond();
    for (i = [0 : nslot - 1])
      translate([0, bi + di * i + ads[i] + dds[i] / 2, - cutdepth])
      cutting_plane(i);
  }
}

done();
