chars_base.init() {
    chars_base.__init() {
        # Find a good list of useful chars here:
        # http://www.fileformat.info/info/unicode/category/So/list.htm
        declare -g -A __chars_BOX
        chars_base.loadBoxChars

        declare -g -A __chars_FIG
        chars_base.loadFigChars
    }
    chars_base.loadFigChars() {
        __chars_FIG['SKLL_N_CB']="\xE2\x98\xA0" # ☠
        __chars_FIG['SKULL']="\xF0\x9F\x92\x80" # 💀
        __chars_FIG['INFO']="\xE2\x84\xB9" # ℹ
        __chars_FIG['INFO_ROUND']="\xF0\x9F\x9B\x88" # 🛈
        __chars_FIG['WARN']="\xE2\x9A\xA0" # ⚠
        __chars_FIG['TICK']="\xF0\x9F\x97\xB8" # 🗸
        __chars_FIG['FISHEYE']="\xE2\x97\x89" # ◉
        __chars_FIG['CIRCLE']="\xE2\x97\x8F" # ●
        __chars_FIG['SMALL_CIRCLE']="\xE2\x9A\xAC" # ⚬
        __chars_FIG['POINT_RIGHT']="\xF0\x9F\x91\x89" # 👉
        __chars_FIG['CLOCK']="\xF0\x9F\x95\x93" # 🕓
        __chars_FIG['STAR']="\xE2\x98\x85" # ★
        __chars_FIG['TRI_SOLID_RIGHT']="\xE2\x96\xB6" # ▶
        __chars_FIG['TRI_THIN_RIGHT']="\xE2\x96\xBB" # ▻
            # echo -n '▻' |xxd -p -u
    }
    chars_base.loadBoxChars() {

        # echo -n '╪' |xxd -p -u

        __chars_BOX['DBL_SE']="\xE2\x95\x94" # ╔
        __chars_BOX['DBL_SW']="\xE2\x95\x97"
        __chars_BOX['DBL_NW']="\xE2\x95\x9D" # ╝
        __chars_BOX['DBL_NE']="\xE2\x95\x9A" # ╚
        __chars_BOX['DBL_NSE']="\xE2\x95\xA0" # ╠
        __chars_BOX['DBL_NSW']="\xE2\x95\xA3" # ╣
        __chars_BOX['DBL_EW']="\xE2\x95\x90" # ═
        __chars_BOX['DBL_SEW']="\xE2\x95\xA6" # ╦
        __chars_BOX['DBL_NS']="\xE2\x95\x91" # ║
        __chars_BOX['DBL_NEW']="\xE2\x95\xA9" # ╩

        __chars_BOX['DBL_W_THIN_S']="\xE2\x95\x95" # ╕
        __chars_BOX['DBL_E_THIN_S']="\xE2\x95\x92" # ╒
        __chars_BOX['DBL_EW_THIN_S']="\xE2\x95\xA4" # ╤
        __chars_BOX['DBL_EW_THIN_N']="\xE2\x95\xA7" # ╧
        __chars_BOX['DBL_EW_THIN_NS']="\xE2\x95\xAA" # ╪

        __chars_BOX['ANGLE_BS']="\xE2\x95\xB2" # ╲
        __chars_BOX['ANGLE_FS']="\xE2\x95\xB1" # ╱

        __chars_BOX['THIN_SE']="\xE2\x94\x8C" # ┌
        __chars_BOX['THIN_SW']="\xE2\x94\x90" # ┐
        __chars_BOX['THIN_NS']="\xE2\x94\x82" # │
        __chars_BOX['THIN_EW']="\xE2\x94\x80" # ─
        __chars_BOX['THIN_NE']="\xE2\x94\x94" # └
        __chars_BOX['THIN_NW']="\xE2\x94\x98" # ┘
    }
}
