// Диффузионный колпак над электрохимическим сенсором ZE07-CO.
// Стакан надевается на сенсор, фланец ложится на плату через прокладку из силиконового листа
// 1 мм (или термоклей по периметру). Две ёлочки навстречу друг другу у верха стакана — газ
// обтекает мембрану сенсора без прямой струи.
include <params.scad>
use <lib.scad>

in_d   = ec_d + 1.5;
in_h   = ec_h + 3;
od     = in_d + 2 * wall;
fl_od  = od + 8;
fl_t   = 2;
barb_z = in_h - 4;

module ze07_cap() {
    difference() {
        union() {
            cylinder(d = od, h = in_h + wall);
            cylinder(d = fl_od, h = fl_t);
            for (s = [-1, 1]) translate([0, s * (od / 2 - 0.5), barb_z]) rotate([-s * 90, 0, 0]) barb();
        }
        translate([0, 0, -1]) cylinder(d = in_d, h = in_h + 1);
        for (s = [-1, 1]) translate([0, s * (in_d / 2 - 1), barb_z]) rotate([-s * 90, 0, 0]) cylinder(d = barb_id, h = wall + 3);
    }
}

ze07_cap();
