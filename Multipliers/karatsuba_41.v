`include "karatsuba_21.v"

module karatsuba_41x41(input [40:0]a,
                       input [40:0]b,
                       output [80:0]c);
    /*
        Ah = a0 + a1x + ... + a20 x^20,   Al = A0 + A1x+ ... + A19 x^19
        output = (Ah x^20 + Al)(Bh x^20 + Bl)
               = Ah_Bh x^40 + {(Ah+Al)(Bh+Bl) + Ah_Bh + Al_Bl} x^20 + Al_Bl
    */

    wire [40:0]ah_bh; // for Ah*Bh
    wire [40:0]al_bl; // for Al*Bl
    wire [20:0]ah_al; // for Ah+Al
    wire [20:0]bh_bl; // for Bh+Bl
    wire [40:0]ab;    // for (Ah+Al)(Bh+Bl)
    wire [40:0]tmp;   // multiplication result

    karatsuba_21x21 k1(a[40:20],b[40:20],ah_bh);
    karatsuba_21x21 k2({1'd0,a[19:0]},{1'd0,b[19:0]},al_bl);
    assign ah_al[19:0] = a[39:20] ^ a[19:0];
    assign ah_al[20]   = a[40];
    assign bh_bl[19:0] = b[39:20] ^ b[19:0];
    assign bh_bl[20]   = b[40];
    karatsuba_21x21 k3(ah_al,bh_bl,ab);

    assign tmp = ab ^ ah_bh ^ al_bl;
    assign c[19:0]  = al_bl[19:0];
    assign c[38:20] = al_bl[38:20] ^ tmp[18:0];
    assign c[39]    = tmp[19];
    assign c[60:40] = tmp[40:20] ^ ah_bh[20:0];
    assign c[80:61] = ah_bh[40:21]; 

endmodule