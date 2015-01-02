﻿**C0***
.protect
.lib 'E:\Program\ESE\Hspice\TD-LO18-SP-2003v4R\l018ll_io50_v1p3.lib' TT
.unprotect
.temp 25


.subckt trg gn gp in out vdd vss
M0 out gp in vdd p18ll w=0.18u l=0.18u
M1 out gn in vss n18ll w=0.18u l=0.18u
.ends

.subckt invter in out vdd vss 
M0 out in vdd vdd p18ll w=0.18u l=0.18u
M1 out in vss vss n18ll w=0.18u l=0.18u
.ends

.subckt AB inA inB out vdd vss
M0 out inA vdd vdd p18ll w=0.76u l=0.18u
M1 out inB vdd vdd p18ll w=0.76u l=0.18u
M2 out inA AB vss n18ll w=0.36u l=0.18u
M3 AB inB vss vss n18ll w=0.36u l=0.18u
.ends

.subckt NOR inA inB out vdd vss
M0 AOB inA vdd vdd p18ll w=0.72u l=0.18u
M1 out inB AOB vdd p18ll w=0.72u l=0.18u
M2 out inA vss vss n18ll w=0.18u l=0.18u
M3 out inB vss vss n18ll w=0.18u l=0.18u
.ends

*XORC
.subckt XORC inA inB out vdd vss 
x1 inA AQ vdd vss invter
*定义共栅的p/nmos传输管
M0 out inB inA vdd p18ll w=0.18u l=0.18u
M1 out inB AQ vss n18ll w=0.18u l=0.18u
*以下是传输门
M2 out inA inB vdd p18ll w=0.18u l=0.18u
M3 out AQ inB vss n18ll w=0.18u l=0.18u
.ends

.subckt C0 C A B out vdd vss
x1 A B AXB vdd vss XORC
x2 AXB AXBQ vdd vss invter
x3 AXB AXBQ C out vdd vss trg
x4 A B G vdd vss AB
x5 A B D vdd vss NOR
M0 out G vdd vdd p18ll w=2.00u l=0.18u
M1 out D vss vss n18ll w=1.00u l=0.18u
.ends

*加负载
x1 vss A B out vdd vss C0
C1 out vss 0.2pf

*设置vdd
VDD vdd 0 dc 'vddvalue_vdd'
.param vddvalue_vdd=1.8v

*设置vss
VSS vss 0 dc 'vddvalue_vss'
.param vddvalue_vss=0v

*设置输入
vin0 A 0 PWL 170ns 0v, 171ns 1.8v, 330ns 1.8v, 331ns 0v, 490ns 0v, 491ns 1.8v
vinb0 B 0 PWL 50ns 0v, 51ns 1.8v, 90ns 1.8v, 91ns 0v, 130ns 0v, 131ns 1.8v, 
+170ns 1.8v, 171ns 0v, 210ns 0v, 211ns 1.8v, 250ns 1.8v, 251ns 0v, 290ns 0v, 
+291ns 1.8v,330ns 1.8v, 331ns 0v, 370ns 0v, 371ns 1.8v, 410ns 1.8v, 411ns 0v, 
+450ns 0v, 451ns 1.8v, 490ns 1.8v, 491ns 0v, 530ns 0v, 531ns 1.8v, 570ns 1.8v, 
+571ns 0v, 610ns 0v, 611ns 1.8v

*瞬态仿真
.tran 1ns 650ns
.ic Q 0v
.PROBE v(out) v(in)

.end

