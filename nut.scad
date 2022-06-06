$e = 0.01;
$fn = 16;

use <functions.scad>
use <shapes.scad>

/// Depth of the part (along the neck).
x_part = 5.4;
/// Width of the part (across the neck).
y_part = 50.0 + 1.4;
/// Height of the part (through the neck).
/// TODO Try to drop this by 0.4 to adjust the action.
z_part = 8.8 - 0.4;

/// How much shallower the grooves should be to account for wear.
z_extra = 0.5;
/// Depths of the grooves on the sharp edge (with room to accommodate wear).
z_groove = 3.0 - z_extra;
echo(z_groove = z_groove);
assert(z_groove < z_part,
    "Grooves are deeper than they should be!");
/// How much fitting room the strings should have.
d_extra = 0.1;
/// Diameters of the strings.
d_strings = [0.7112, 0.8128, 1.016, 0.7747, 0.9144, 1.143];
/// Widths of the grooves (with room to accommodate fitting).
y_grooves = [for (d_string = d_strings) d_extra + d_string];
echo(y_grooves = y_grooves);
/// Cumulative widths of the grooves.
y_grooves_sum = cumsum(y_grooves);
/// Distances between the grooves.
y_steps = rep(len(y_grooves) - 1, 7.4);
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
alpha_anchors = [asin(34 / 58), asin(42 / 94), asin(48 / 128)];
/// Angles at which the grooves turn.
alpha_grooves = concat(alpha_anchors, rev(alpha_anchors));
echo(alpha_grooves = alpha_grooves);
assert(max(alpha_grooves) < 90,
    "Grooves turn more than they should!");
/// Radii of curvature of the grooves.
r_grooves = [for (alpha_groove = alpha_grooves) x_part / sin(alpha_groove)];
echo(r_grooves = r_grooves);
/// Radius of curvature of the round edge (farther away from the neck).
r_anchor = z_part - 5.6;
echo(r_anchor = r_anchor);
/// Radius of curvature of the sharp edge (closer to the neck).
r_neck = 0.8;
/// Radii of curvature of the sides.
r_side = 1.6;
assert(r_anchor + r_neck < x_part && 2 * r_side < y_part,
    "Fillets are larger than they should be!");

module block() {
  cube([x_part, y_part, z_part]);
}

module fillet(r, a) {
  translate([- r, 0, - r])
    difference() {
      translate([0, - $e, 0])
        cube([$e + r, 2 * $e + a, $e + r]);
      translate([0, - 2 * $e, 0])
        rotate([- 90, 0, 0])
        cylinder(4 * $e + a, r, r);
    }
}

module filleted_block() {
  difference() {
    block();
    translate([x_part, 0, z_part])
      fillet(r_anchor, y_part);
    translate([0, 0, z_part])
      mirror([1, 0, 0])
      fillet(r_neck, y_part);
    translate([0, 0, z_part])
      rotate([0, 0, - 90])
      fillet(r_side, x_part);
    translate([0, y_part, z_part])
      mirror([0, 1, 0])
      rotate([0, 0, - 90])
      fillet(r_side, x_part);
  }
}

module groove(i) {
  let (y_groove = y_grooves[i], r_groove = r_grooves[i])
    translate([0, 0, z_part + y_groove - r_groove])
    rotate([90, 0, 0])
    let (h = y_groove, r0 = r_groove, r1 = z_part + r_groove)
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
        groove(i);
  }
}

grooved_filleted_block();
