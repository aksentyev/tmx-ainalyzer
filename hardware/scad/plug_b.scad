// Пробка B — микрофон в центре внутреннего торца, выход газа через камеру с TMP117.
// Микрофон: плата лежит в углублении внутреннего торца портом в трубу (bottom-port, плоской
// стороной к газу), компонентами к пробке; две капли эпоксидки по углам; провода — через
// отверстие Ø3.5 у края платы наружу, залить.
// Газ: трубка → осевой канал → радиальный канал (над платой TMP117) → карман-камера в лаге →
// ёлочка. Карман открыт с наружного торца: плата TMP117 кладётся на дно сенсором вверх,
// провода выходят через паз в стенке кармана, сверху приклеивается крышка (tmp_cover) —
// заливать карман НЕ надо, иначе компаунд перекроет устья каналов.
// Печатать фланцем на стол (как A): карман смотрит в стол, его дно — мост 12.8 мм.
include <params.scad>
use <lib.scad>

pocket    = [tmp_pcb[0] + 2 * clr, tmp_pcb[1] + 2 * clr, tmp_pocket_depth];
pocket_yc = -(flange_d / 2 + lug_len_b / 2);          // центр кармана по Y
cover     = [pocket[0] + 4, pocket[1] + 4, tmp_cover_t];

module plug_b(fit = plug_fit) {
    d           = bore_d - fit;
    lug_y0      = -(flange_d / 2 + lug_len_b);
    top         = plug_depth + flange_t;
    zc          = top - 2.5;                           // каналы на 2.5 ниже наружного торца — над платой (дно + 1.6)
    pocket_near = pocket_yc + pocket[1] / 2;           // ближняя к оси стенка кармана
    wire_notch  = [3, 4, 2];                           // паз под провода TMP117 в стенке кармана (+X)

    difference() {
        union() {
            plug_body(d, lug_w_b, lug_len_b);
            barb_neg_y(lug_y0, zc);
        }
        // углубление под плату микрофона на внутреннем торце
        translate([-(mic_pcb[0] + clr) / 2, -(mic_pcb[1] + clr) / 2, -1])
            cube([mic_pcb[0] + clr, mic_pcb[1] + clr, mic_recess_depth + 1]);
        // провода микрофона наружу (внутри углубления у края платы)
        translate([mic_wire_pos[0], mic_wire_pos[1], mic_recess_depth - 0.5]) cylinder(d = mic_wire_d, h = top);
        // осевой выходной канал
        translate([0, out_y_b, -1]) cylinder(d = out_d_b, h = zc + 1);
        // радиальный канал до кармана
        cyl_neg_y([0, out_y_b, zc], chan_d, out_y_b - pocket_near + 1);
        // карман TMP117 = газовая камера, открыт с наружного торца
        translate([-pocket[0] / 2, pocket_yc - pocket[1] / 2, top - pocket[2]])
            cube([pocket[0], pocket[1], pocket[2] + 1]);
        // паз под провода из кармана наружу (+X), у наружного торца
        translate([pocket[0] / 2 - 0.5, pocket_yc - wire_notch[1] / 2, top - wire_notch[2]])
            cube([lug_w_b / 2 - pocket[0] / 2 + 1, wire_notch[1], wire_notch[2] + 1]);
        // канал из кармана в ёлочку
        cyl_neg_y([0, pocket_yc, zc], barb_id, pocket_yc - lug_y0 + barb_len + 2);
    }
}

// Крышка кармана TMP117: клеится на наружный торец лага поверх кармана (RTV/эпоксидка по периметру).
module tmp_cover() {
    cube(cover);
}

plug_b();
translate([flange_d / 2 + 10, -cover[1] / 2, 0]) tmp_cover();
