use <functions.scad>
use <shapes.scad>

module block(x_part, y_part, z_part) {
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

module filleted_block(x_part, y_part, z_part, r_anchor, r_neck, r_side) {
  difference() {
    block(x_part, y_part, z_part);
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

module groove(z_part, y_grooves, r_grooves, i) {
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

module grooved_filleted_block(x_part, y_part, z_part,
    z_groove, y_grooves, y_steps, y_edge,
    alpha_grooves, r_grooves, r_anchor, r_neck, r_side) {
  let (y_grooves_sum = cumsum(y_grooves), y_steps_sum = cumsum(y_steps))
    difference() {
      filleted_block(x_part, y_part, z_part, r_anchor, r_neck, r_side);
      for (i = [0 : len(y_grooves) - 1])
        translate([0, y_edge + y_grooves_sum[i]
            + y_steps_sum[i] + y_grooves[i] / 2, - z_groove])
          groove(z_part, y_grooves, r_grooves, i);
    }
}
