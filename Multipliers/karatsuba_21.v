`include "karatsuba_11.v"

module karatsuba_21x21(input [20:0]a,
                       input [20:0]b,
                       output [40:0]c);
    /*
        Ah = a0 + a1x + ... + a10 x^10,   Al = A0 + A1x+ ... + A9 x^9
        output = (Ah x^10 + Al)(Bh x^10 + Bl)
               = Ah_Bh x^20 + {(Ah+Al)(Bh+Bl) + Ah_Bh + Al_Bl} x^10 + Al_Bl
    */

    wire [20:0]ah_bh; // for Ah*Bh
    wire [20:0]al_bl; // for Al*Bl
    wire [10:0]ah_al; // for Ah+Al
    wire [10:0]bh_bl; // for Bh+Bl
    wire [20:0]ab;    // (Ah+Al)(Bh+Bl)
    wire [20:0]tmp;   // multiplication result
    
    karatsuba_11x11 k1(a[20:10],b[20:10],ah_bh);
    karatsuba_11x11 k2({1'd0,a[9:0]},{1'd0,b[9:0]},al_bl);
    assign ah_al[9:0] = a[19:10] ^ a[9:0];
    assign ah_al[10]  = a[20];
    assign bh_bl[9:0] = b[19:10] ^ b[9:0];
    assign bh_bl[10]  = b[20];
    karatsuba_11x11 k3(ah_al,bh_bl,ab);

    assign tmp = ab ^ ah_bh ^ al_bl;
    assign c[9:0]   = al_bl[9:0];
    assign c[18:10] = al_bl[18:10] ^ tmp[8:0];
    assign c[19]    = tmp[9];
    assign c[30:20] = tmp[20:10] ^ ah_bh[10:0];
    assign c[40:31] = ah_bh[20:11];

endmodule