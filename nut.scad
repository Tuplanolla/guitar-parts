/*
## Worn Metrics

       5.3
      |--|

       ,-+ -
    - /  | | 8.7
5.4 | |  | |
    - +--+ -

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

      /  64
-----+.  ------------------
       `-. /  128    | 24 |
 22.5 °  o`-.  -------    | 36
             `-. /        |
               o`-. -------
*/

eps = 1.0;
q = 5.3;
r = 8.7 - 5.4;
d = 1.0;
// hx = 8.7 - 5.8;
// Add 0.5 mm of leeway.
hx = 8.7 - 6.3;
/*
w = 49.9;
bi = 3.8;
di = 7.2;
*/
// The width actually only adds up to 49.6 and
// the printed version was 0.5 too narrow on both sides.
// Adjust width and spacing as follows.
w = 49.9 + 1.1;
bi = 4.0;
di = 7.4;
z = eps + q + eps;
h = eps + hx + eps;

alpha = asin(24 / 64);
alphad = alpha * 360 / (2 * PI);
rc = q / cos(alpha);

/*
translate([0, q, 2 * rc])
rotate([0, 90, 0]) {
color("Indigo")
rotate_extrude()
translate([2 * rc, d / 2, 0])
circle(d / 2);
difference() {
cylinder(d, 4 * rc, 4 * rc);
translate([0, 0, - eps])
cylinder(eps + d + eps, 2 * rc, 2 * rc);
};
}; */

difference() {
  difference() {
    cube([w, q, 8.7]);
    difference() {
      translate([- eps, - eps, - eps])
        color("SlateBlue")
        cube([eps + w + eps, r + eps, r + eps]);
      translate([- 2 * eps, r, r])
        rotate([0, 90, 0])
        cylinder(eps + eps + w + eps + eps, r, r, $fn = 32);
    };
  };
  for(i = [0 : 5]) {
    translate([bi + (di + d) * i, - eps, - eps]) {
      translate([0, q, 2 * rc + hx])
        rotate([0, 90, 0]) {
          color("Indigo")
            rotate_extrude()
            translate([2 * rc, d / 2, 0])
            circle(d / 2, $fn = 8);
          difference() {
            cylinder(d, 3 * rc, 3 * rc, $fn = 4);
            translate([0, 0, - eps])
              cylinder(eps + d + eps, 2 * rc, 2 * rc, $fn = 32);
          };
        };
      /*
      // in too deep
      cube([d, z, h]);
      // especially with cuts
      translate([d / 2, 0, h])
      rotate([-90, 0, 0])
      cylinder(z, d / 2, d / 2); */
    };
  };
};
