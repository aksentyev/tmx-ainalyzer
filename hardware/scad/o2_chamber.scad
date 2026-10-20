// Камера O2-ячейки: стакан + крышка.
// Ячейка опускается в стакан носиком вниз; носик проходит в отверстие в дне стакана (Ø отверстия =
// Ø камеры под ним — уступа нет, длина носика не критична); плечо ячейки давит на торцевой
// O-ring 21×2 в канавке на дне. Под носиком — газовая камера ≈2 мл с двумя ёлочками (±Y).
// Ухо на −X: двухуровневый карман BMP390 — внизу газовая полость, соединённая с камерой,
// над ней полка, на которую плата ложится сенсором ВНИЗ (эпоксидка по периметру платы
// герметизирует полость), выше — провода и заливка. Открыт сверху — печатается без мостов,
// кроме потолка полости (10 мм).
// Крышка прижимает ячейку тремя саморезами M3 в бобышки; в крышке вырез под разъём ячейки.
include <params.scad>
use <lib.scad>

cup_wall     = 2.4;
cup_od       = cell_d + 2 * cup_wall;
bottom_t     = 3;
floor_t      = 3;
base_h       = bottom_t + o2_chamber_h + floor_t;   // высота нижнего блока (16)
cup_h        = base_h + cell_h - cell_press;
hole_d       = nose_d + nose_clr;                    // отверстие носика = Ø камеры
boss_r       = cup_od / 2 + 1.5;
boss_d       = 8;
boss_pilot   = 2.6;
boss_angles  = [0, 135, 225];                        // ухо на 180°, ёлочки на ±90°: до бобышек ≥7 мм
groove_depth = 0.7 * o2_face_oring_cs;
groove_w     = 1.35 * o2_face_oring_cs;
barb_z       = bottom_t + o2_chamber_h / 2;

// карман BMP390 (в локальных координатах уха вдоль +X, потом поворот на 180°)
pk          = [bmp_pcb[0] + 2 * clr, bmp_pcb[1] + 2 * clr];   // карман под плату
cav         = [pk[0] - 3.3, pk[1] - 3.3, 3];                     // газовая полость под полкой
pk_x0       = cell_d / 2 + 3.3;                                  // карман целиком вне посадки ячейки (+ стенка)
pk_xc       = pk_x0 + pk[0] / 2;
ear         = [pk[0] + 4, pk[1] + 4];
ear_x0      = pk_x0 - 2;
cav_z0      = 4;                                                 // дно полости
shelf_z     = cav_z0 + cav[2];                                   // полка: плата лежит здесь
lid_t       = 3;

module ear_block() {
    translate([ear_x0, -ear[1] / 2, 0]) cube([ear[0], ear[1], base_h]);
}

module ear_cuts() {
    // газовая полость
    translate([pk_xc - cav[0] / 2, -cav[1] / 2, cav_z0]) cube([cav[0], cav[1], cav[2]]);
    // карман под плату и заливку, открыт сверху
    translate([pk_xc - pk[0] / 2, -pk[1] / 2, shelf_z]) cube([pk[0], pk[1], base_h - shelf_z + 1]);
    // соединение полости с камерой
    translate([hole_d / 2 - 1, 0, cav_z0 + cav[2] / 2]) rotate([0, 90, 0])
        cylinder(d = chan_d, h = pk_xc - cav[0] / 2 - hole_d / 2 + 2);
}

module o2_cup() {
    difference() {
        union() {
            cylinder(d = cup_od, h = cup_h);
            for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, 0]) cylinder(d = boss_d, h = cup_h);
            rotate([0, 0, 180]) ear_block();
            for (s = [-1, 1]) translate([0, s * (cup_od / 2 - 0.5), barb_z]) rotate([-s * 90, 0, 0]) barb();
        }
        // посадка тела ячейки
        translate([0, 0, base_h]) cylinder(d = cell_d, h = cell_h + 10);
        // носик + камера под ним: один Ø, уступа нет
        translate([0, 0, bottom_t]) cylinder(d = hole_d, h = o2_chamber_h + floor_t + 1);
        // торцевая канавка O-ring на дне стакана
        translate([0, 0, base_h - groove_depth])
            difference() {
                cylinder(d = o2_face_oring_id - 0.2 + 2 * groove_w, h = groove_depth + 1);
                cylinder(d = o2_face_oring_id - 0.2, h = groove_depth + 1);
            }
        // каналы ёлочек в камеру
        for (s = [-1, 1]) translate([0, s * (hole_d / 2 - 1), barb_z])
            rotate([-s * 90, 0, 0]) cylinder(d = barb_id, h = cup_od);
        rotate([0, 0, 180]) ear_cuts();
        // пилотные отверстия под саморезы M3 в бобышках
        for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, cup_h - 10]) cylinder(d = boss_pilot, h = 11);
    }
}

module o2_lid() {
    difference() {
        union() {
            cylinder(d = cup_od, h = lid_t);
            for (a = boss_angles) rotate([0, 0, a]) {
                translate([boss_r, 0, 0]) cylinder(d = boss_d, h = lid_t);
                translate([cup_od / 2 - 2, -boss_d / 2, 0]) cube([boss_r - cup_od / 2 + 2, boss_d, lid_t]);
            }
        }
        translate([-molex_slot[0] / 2, -molex_slot[1] / 2, -1]) cube([molex_slot[0], molex_slot[1], lid_t + 2]);
        for (a = boss_angles) rotate([0, 0, a]) translate([boss_r, 0, -1]) cylinder(d = 3.2, h = lid_t + 2);
    }
}

o2_cup();
translate([cup_od + 24, 0, 0]) o2_lid();
