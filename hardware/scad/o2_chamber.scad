// Камера O2-ячейки: стакан + крышка.
// Ячейка опускается в стакан носиком вниз; носик проходит в отверстие в дне стакана, плечо
// ячейки давит на торцевой O-ring 20×2 в канавке на дне. Под носиком — газовая камера ≈2 мл с
// двумя ёлочками (вход/выход напротив). Сбоку — карман под плату BMP390, соединён с камерой,
// открыт наружу (плата внутрь, провода наружу, залить). Крышка прижимает ячейку тремя
// саморезами M3 в бобышки, в крышке вырез под разъём ячейки.
include <params.scad>
use <lib.scad>

cup_wall = 2.4;
cup_od   = cell_d + 2 * cup_wall;
bottom_t = 3;
floor_t  = 3;
base_h   = bottom_t + o2_chamber_h + floor_t;   // высота нижнего блока
cell_press = 0.5;                                // на сколько ячейка выступает над стаканом (прижим)
cup_h    = base_h + cell_h - cell_press;
boss_r   = cup_od / 2 + 1.5;
boss_d   = 7;
boss_angles = [60, 180, 300];
groove_depth = 1.4;
groove_w  = 2.7;
ear       = [bmp_pcb[0] + 2 * clr + 6, bmp_pcb[1] + 2 * clr + 4];   // боковой блок под карман BMP390
ear_x0    = o2_chamber_d / 2 + 2;                                    // от стенки камеры

module o2_cup() {
    difference() {
        union() {
            cylinder(d = cup_od, h = cup_h);
            for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, 0]) cylinder(d = boss_d, h = cup_h);
            // ухо под BMP390 на +X
            translate([ear_x0, -ear[1] / 2, 0]) cube([ear[0], ear[1], base_h]);
            // ёлочки на ±Y на высоте камеры
            for (s = [-1, 1]) translate([0, s * (cup_od / 2 - 0.5), bottom_t + o2_chamber_h / 2])
                rotate([-s * 90, 0, 0]) barb();
        }
        // посадка тела ячейки
        translate([0, 0, base_h]) cylinder(d = cell_d, h = cell_h + 10);
        // отверстие под носик
        translate([0, 0, base_h - floor_t - 1]) cylinder(d = nose_d + 0.4, h = floor_t + 2);
        // торцевая канавка O-ring на дне стакана
        translate([0, 0, base_h - groove_depth])
            difference() {
                cylinder(d = o2_face_oring_id + 2 * groove_w, h = groove_depth + 1);
                cylinder(d = o2_face_oring_id - 0.4, h = groove_depth + 1);
            }
        // газовая камера под носиком
        translate([0, 0, bottom_t]) cylinder(d = o2_chamber_d, h = o2_chamber_h);
        // каналы ёлочек в камеру
        for (s = [-1, 1]) translate([0, s * (o2_chamber_d / 2 - 1), bottom_t + o2_chamber_h / 2])
            rotate([-s * 90, 0, 0]) cylinder(d = barb_id, h = cup_od);
        // карман BMP390: открыт с +X
        translate([ear_x0 + 2, -(bmp_pcb[1] + 2 * clr) / 2, bottom_t + 1])
            cube([ear[0], bmp_pcb[1] + 2 * clr, bmp_pcb[2] + 3.5]);
        // соединение кармана с камерой
        translate([o2_chamber_d / 2 - 1, 0, bottom_t + 2.5]) rotate([0, 90, 0]) cylinder(d = chan_d, h = 6);
        // отверстия под саморезы M3 в бобышках
        for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, cup_h - 10]) cylinder(d = 2.5, h = 11);
    }
}

module o2_lid() {
    lid_t = 3;
    difference() {
        union() {
            cylinder(d = cup_od, h = lid_t);
            for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, 0]) cylinder(d = boss_d, h = lid_t);
            for (a = boss_angles) rotate([0, 0, a]) translate([cup_od / 2 - 2, -boss_d / 2, 0]) cube([boss_r - cup_od / 2 + 2, boss_d, lid_t]);
        }
        translate([-molex_slot[0] / 2, -molex_slot[1] / 2, -1]) cube([molex_slot[0], molex_slot[1], lid_t + 2]);
        for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, -1]) cylinder(d = 3.2, h = lid_t + 2);
    }
}

o2_cup();
translate([cup_od + 20, 0, 0]) o2_lid();
