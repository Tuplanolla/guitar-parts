$e = 0.01;
$fn = 16;

use <functions.scad>
use <shapes.scad>

/// Depth of the part (along the neck).
x_part = 2.8;
/// Width of the part (across the neck).
y_part = 76.8 + 0.2;
/// Height of the part (through the neck).
/// TODO Try to drop this by 3.6 to adjust the action.
z_part = 8.0 - 3.6;

/// How much shallower the grooves should be to account for wear.
z_extra = 0.0;
/// Depths of the grooves on the sharp edge (with room to accommodate wear).
z_groove = 0.5 - z_extra;
echo(z_groove = z_groove);
assert(z_groove < z_part,
    "Grooves are deeper than they should be!");
/// How much fitting room the strings should have.
d_extra = 0.0;
/// Diameters of the strings.
d_strings = [0.7112, 0.8128, 1.016, 0.7747, 0.9144, 1.143];
/// Widths of the grooves (with room to accommodate fitting).
y_grooves = [for (d_string = d_strings) d_extra + d_string];
echo(y_grooves = y_grooves);
/// Cumulative widths of the grooves.
y_grooves_sum = cumsum(y_grooves);
/// Distances between the grooves.
y_steps = rep(len(y_grooves) - 1, 9.4);
assert(1 + len(y_steps) == len(y_grooves),
    "Grooves are more or less numerous than they should be!");
/// Cumulative distances between the grooves.
y_steps_sum = cumsum(y_steps);
/// Distance between the first (and last) groove and the edge.
y_edge = (y_part - y_grooves_sum[len(y_grooves)]
    - y_steps_sum[len(y_grooves) - 1]) / 2;
echo(y_edge = y_edge);
assert(y_edge >= 0,
    "Grooves are wider than they should be!");

/// Angles at which the strings turn
/// from the neck towards their anchoring points.
alpha_anchors = [atan((13.0 - 5.6 - 8.0 + z_part)
    / (12 * cos(asin((13.0 - 5.6) / 12))))];
/// Angles at which the grooves turn.
alpha_grooves = rep(6, alpha_anchors);
echo(alpha_grooves = alpha_grooves);
assert(max(alpha_grooves) < 90,
    "Grooves turn more than they should!");
/// Radii of curvature of the grooves.
r_grooves = [for (alpha_groove = alpha_grooves) x_part / sin(alpha_groove)];
echo(r_grooves = r_grooves);
/// Radius of curvature of the round edge (farther away from the neck).
r_anchor = 1.0;
echo(r_anchor = r_anchor);
/// Radius of curvature of the sharp edge (closer to the neck).
r_neck = 1.0;
/// Radii of curvature of the sides.
r_side = 2.0;
assert(r_anchor + r_neck < x_part && 2 * r_side < y_part,
    "Fillets are larger than they should be!");

module block() {
  cube([x_part, y_part, z_part]);
}

module fillet(r) {
  translate([- r, 0, - r])
    difference() {
      translate([0, - $e, 0])
        cube([$e + r, 2 * $e + y_part, $e + r]);
      translate([0, - 2 * $e, 0])
        rotate([- 90, 0, 0])
        cylinder(4 * $e + y_part, r, r);
    }
}

module filleted_block() {
  difference() {
    block();
    translate([x_part, 0, z_part])
      fillet(r_anchor);
    translate([0, 0, z_part])
      mirror([1, 0, 0])
      fillet(r_neck);
    translate([0, 0, z_part])
      rotate([0, 0, - 90])
      fillet(r_side);
    translate([0, y_part, z_part])
      mirror([0, 1, 0])
      rotate([0, 0, - 90])
      fillet(r_side);
  }
}

module grooves(i) {
  let (y_groove = y_grooves[i], r_groove = r_grooves[i])
    let (h = y_groove, r0 = r_groove, r1 = z_part + r_groove)
    translate([0, 0, z_part + h - r0])
    rotate([90, 0, 0])
    difference() {
      /// This rotation is here just to accommodate low values of `$fn`.
      rotate([0, 0, 180 / $fn]) {
        translate([0, 0, - h])
          hollow_cylinder(2 * h, r0, r1);
        torus(r0, h);
      }
      difference() {
        translate([- r1, - r1, - 2 * $e - h])
          cube([$e + 2 * r1, $e + 2 * r1, 4 * $e + 2 * h]);
        translate([- $e, 0, - 3 * $e - h])
          cube([3 * $e + r1, 2 * $e + r1, 6 * $e + 2 * h]);
      }
    }
}

module grooved_filleted_block() {
  difference() {
    filleted_block();
    for (i = [0 : len(y_grooves) - 1])
      translate([0, y_edge + y_grooves_sum[i]
          + y_steps_sum[i] + y_grooves[i] / 2, - z_groove])
        grooves(i);
  }
}

mirror([1, 0, 0])
  grooved_filleted_block();
