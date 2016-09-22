// Loads 3 Single's from Src to Dst
.macro LOAD3 Dst Src
    ld1.2s      {\Dst}, [\Src], 8
    ld1         {\Dst\().s}[2], [\Src]
.endm

// Loads 3 Single's from Src to Dst with writeback
.macro LOAD3WB Dst Src
    ld1.2s      {\Dst}, [\Src], 8
    ld1         {\Dst\().s}[2], [\Src], 4
.endm

// Stores 3 Single's from Src to Dst
.macro STORE3 Src Dst
    st1.2s      {\Src}, [\Dst], 8
    st1         {\Src\().s}[2], [\Dst]    
.endm

// Stores 3 Single's from Src to Dst with writeback
.macro STORE3WB Src Dst
    st1.2s      {\Src}, [\Dst], 8
    st1         {\Src\().s}[2], [\Dst], 4
.endm