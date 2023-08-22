`include "modulo.v"
`include "karatsuba_82.v"

module karatsuba_163x163(input [162:0]a,
                         input [162:0]b,
                         output [162:0]out);
    /*
        Ah = a0 + a1x + ... + a81 x^81,   Al = A0 + A1x+ ... + A80 x^80
        output = (Ah x^81 + Al)(Bh x^81 + Bl)
               = Ah_Bh x^162 + {(Ah+Al)(Bh+Bl) + Ah_Bh + Al_Bl} x^81 + Al_Bl
    */

    wire [162:0]ah_bh; // for ah*bh
    wire [162:0]al_bl; // for al*bl
    wire [81:0]ah_al;  // for ah+al
    wire [81:0]bh_bl;  // for bh+bl
    wire [162:0]ab;    // for (ah+al)*(bh+bl)
    wire [324:0]c;     // multiplication output
    wire [162:0]tmp;   // final modulo output
    

    karatsuba_82x82 k1(a[162:81],b[162:81],ah_bh);
    karatsuba_82x82 k2({1'b0,a[80:0]},{1'b0,b[80:0]},al_bl);
    assign ah_al[80:0] = a[161:81] ^ a[80:0];
    assign bh_bl[80:0] = b[161:81] ^ b[80:0];
    assign ah_al[81] = a[162];
    assign bh_bl[81] = b[162];
    karatsuba_82x82 k3(ah_al,bh_bl,ab);

    assign tmp = ab ^ ah_bh ^ al_bl;
    assign c[80:0] = al_bl[80:0];
    assign c[160:81] = al_bl[160:81] ^ tmp[79:0];
    assign c[161] = tmp[80];
    assign c[243:162] = tmp[162:81] ^ ah_bh[81:0];
    assign c[324:244] = ah_bh[162:82];

    modulo m1(c,out);

endmodule