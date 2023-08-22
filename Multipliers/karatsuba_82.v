`include "karatsuba_41.v"

module karatsuba_82x82(input [81:0]a,
                       input [81:0]b,
                       output [162:0]c);
    /*
        Ah = a0 + a1x + ... + a40 x^40,   Al = A0 + A1x+ ... + A40 x^40
        output = (Ah x^41 + Al)(Bh x^41 + Bl)
               = Ah_Bh x^82 + {(Ah+Al)(Bh+Bl) + Ah_Bh + Al_Bl} x^41 + Al_Bl
    */

    wire [80:0]ah_bh; // for Ah*Bh
    wire [80:0]al_bl; // for Al*Bl
    wire [40:0]ah_al; // for Ah+Al
    wire [40:0]bh_bl; // for Bh+Bl
    wire [80:0]ab;    // for (Ah+Al)(Bh+Bl)
    wire [80:0]tmp;   // for final multiplication
    
    karatsuba_41x41 k1(a[81:41],b[81:41],ah_bh);
    karatsuba_41x41 k2(a[40:0],b[40:0],al_bl);
    assign ah_al = a[81:41] ^ a[40:0];
    assign bh_bl = b[81:41] ^ b[40:0];
    karatsuba_41x41 k3(ah_al,bh_bl,ab);

    assign tmp = ab ^ ah_bh ^ al_bl;
    assign c[40:0] = al_bl[40:0];
    assign c[80:41] = al_bl[80:41] ^ tmp[39:0];
    assign c[81] = tmp[40];
    assign c[121:82] = tmp[80:41] ^ ah_bh[39:0];
    assign c[162:122] = ah_bh[80:40];

endmodule