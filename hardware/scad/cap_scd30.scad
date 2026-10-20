// Проточный колпак SCD30: коробка без дна + плоское основание.
// Модуль кладётся на основание, колпак накрывается сверху и приклеивается термоклеем по
// периметру; провода выходят через щель в торце (тоже залить). Две ёлочки по диагонали сверху.
include <params.scad>
use <lib.scad>

inner = [scd_dims[0] + 1.0, scd_dims[1] + 1.0, scd_dims[2] + 2.5];
outer = [inner[0] + 2 * wall, inner[1] + 2 * wall, inner[2] + wall];
barb_in = 6;   // отступ ёлочек от стенок

module scd_cap() {
    difference() {
        union() {
            cube(outer);
            translate([wall + barb_in, wall + barb_in, outer[2]]) barb();
            translate([outer[0] - wall - barb_in, outer[1] - wall - barb_in, outer[2]]) barb();
        }
        translate([wall, wall, -1]) cube([inner[0], inner[1], inner[2] + 1]);
        // щель под провода в торце x=0, у основания
        translate([-1, outer[1] / 2 - 6, -1]) cube([wall + 2, 12, 3.5 + 1]);
        // боры ёлочек сквозь верх
        translate([wall + barb_in, wall + barb_in, outer[2] - wall - 1]) cylinder(d = barb_id, h = wall + 2);
        translate([outer[0] - wall - barb_in, outer[1] - wall - barb_in, outer[2] - wall - 1]) cylinder(d = barb_id, h = wall + 2);
    }
}

module scd_base() {
    cube([outer[0] + 8, outer[1] + 8, 2]);
}

scd_cap();
translate([0, outer[1] + 15, 0]) scd_base();
