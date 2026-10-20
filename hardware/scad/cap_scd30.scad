// Проточная коробка SCD30: корпус (открыт сверху) + крышка.
// У SCD30 отверстия CO2- и RH/T-сенсоров — на НИЖНЕЙ стороне платы, выводы (7 × 2.54 вдоль
// длинной кромки) тоже торчат вниз. Поэтому модуль лежит на четырёх угловых столбиках над
// газовым зазором, ёлочки — в коротких стенках на уровне зазора (поток идёт под платой вдоль),
// провода — через паз в длинной стенке у выводов (залить термоклеем). Крышка — плоская с
// бортиком, на термоклей. Печать: корпус открытой стороной вверх, крышка плашмя — без мостов.
include <params.scad>
use <lib.scad>

gap_h    = scd_pin_len;                                    // зазор под платой
inner    = [scd_dims[0] + 1.0, scd_dims[1] + 3.0, gap_h + scd_dims[2] + 2.0];
floor_t  = 2;
outer    = [inner[0] + 2 * wall, inner[1] + 2 * wall, inner[2] + floor_t];
post     = [3, 3, gap_h];
barb_z   = floor_t + gap_h / 2;
barb_in  = 6;                                              // отступ ёлочек от длинных стенок (по диагонали)

module scd_box() {
    difference() {
        union() {
            cube(outer);
            // ёлочки в коротких стенках, по диагонали
            translate([0.5, wall + barb_in, barb_z]) rotate([0, -90, 0]) barb();
            translate([outer[0] - 0.5, outer[1] - wall - barb_in, barb_z]) rotate([0, 90, 0]) barb();
        }
        translate([wall, wall, floor_t]) cube([inner[0], inner[1], inner[2] + 1]);
        // боры ёлочек сквозь стенки
        translate([-1, wall + barb_in, barb_z]) rotate([0, 90, 0]) cylinder(d = barb_id, h = wall + 3);
        translate([outer[0] - wall - 2, outer[1] - wall - barb_in, barb_z]) rotate([0, 90, 0]) cylinder(d = barb_id, h = wall + 3);
        // паз под провода у выводов: длинная стенка y=0, от пола до верха зазора + 2
        translate([outer[0] / 2 - scd_pins_w / 2, -1, floor_t]) cube([scd_pins_w, wall + 2, gap_h + 2]);
    }
    // угловые столбики под плату
    for (x = [wall, wall + inner[0] - post[0]], y = [wall, wall + inner[1] - post[1]])
        translate([x, y, floor_t]) cube(post);
}

module scd_lid() {
    union() {
        cube([outer[0], outer[1], 2]);
        translate([wall + 0.2, wall + 0.2, 2]) cube([inner[0] - 0.4, inner[1] - 0.4, 1.5]);
    }
}

scd_box();
translate([0, outer[1] + 12, 0]) scd_lid();
