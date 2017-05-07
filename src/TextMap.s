* Needs to be included in file with "WinRastPort" set and FPutByte available.
* enter with: a0=address to write ($400-$7ff for PBTxt1), and d1=data.

	SECTION	APPLEII,CODE
	EVEN
	CNOP	0,4
PBTxt1	cmp.b	(Mem_Ptr,a0.l),d1	;1st check if mem is different!
	beq.b	.rts			;mem is same so video is same; don't change anything
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$800,a1
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]

.Do_txt	move.l	Gr1_Planes,a0		;a0 -> GR1 Plane1	... (new test)
	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8

	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8
.rts
AnRts	rts

****************************************************

	CNOP	0,4
PBGr1	cmp.b	(Mem_Ptr,a0.l),d1	;1st check if mem is different!
	beq.b	AnRts			;mem is same so video is same; don't change anything
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$800,a1
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	AnRts

.dogr	move.l	Gr1_Planes,a0		;a0 -> GR1 Plane1

GRFX	add.w	d1,a0			;a0 -> GrPlane1 Start Loc (d1 still there???)
	move.w	a6,d1

****** Top 4 pixel lines of byte data.... *****
*** (Done top 4 then bottom 4 in order to check bit data with LSR's)
*** BitPlane 1			**** Opt later by LSR'ing a Dn instead of Btsts on Mem...
	lsr.b	#1,d1		*** Opt later by only drawing 1 line for each color via Copper magic!
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,(a0)			;line 1
	move.b	d0,40(a0)		;line 2
	move.b	d0,80(a0)		;line 3
	move.b	d0,120(a0)		;line 4
**** BitPlane 2
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,LINES*40(a0)			;line 1
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
**** BitPlane 3
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,LINES*40*2(a0)			;line 1
	move.b	d0,40+LINES*40*2(a0)		;line 2
	move.b	d0,80+LINES*40*2(a0)		;line 3
	move.b	d0,120+LINES*40*2(a0)		;line 4
**** BitPlane 4
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,0+LINES*40*3(a0)			;line 1
	move.b	d0,40+LINES*40*3(a0)		;line 2
	move.b	d0,80+LINES*40*3(a0)		;line 3
	move.b	d0,120+LINES*40*3(a0)		;line 4

******* Bottom 4 lines based on byte data,,,
*** BitPlane 1
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,160(a0)		;line 5
	move.b	d0,200(a0)		;line 6
	move.b	d0,240(a0)		;line 7
	move.b	d0,280(a0)		;line 8
**** BitPlane 2
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8
**** BitPlane 3
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,160+LINES*40*2(a0)		;line 5
	move.b	d0,200+LINES*40*2(a0)		;line 6
	move.b	d0,240+LINES*40*2(a0)		;line 7
	move.b	d0,280+LINES*40*2(a0)		;line 8
**** BitPlane 4
	lsr.b	#1,d1
	scs.b	d0			;bit set? Put a $ff in d0. Else, put $00 in d0!

	move.b	d0,160+LINES*40*3(a0)		;line 5
	move.b	d0,200+LINES*40*3(a0)		;line 6
	move.b	d0,240+LINES*40*3(a0)		;line 7
	move.b	d0,280+LINES*40*3(a0)		;line 8

	rts

***********************************************
	CNOP	0,4

PBGrTxt1:
	cmp.b	(Mem_Ptr,a0.l),d1	;1st check if mem is different!
	beq.b	.rts			;mem is same so video is same; don't change anything
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$800,a1
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	Gr1_Planes,a0

.choose	cmp.w	#20*320+00,d1		;cmp to 1st txt line addr...
	bhs.b	.txt
	
.do_gr	bra	GRFX			;Go draw grfx block (a0/d1 set)

.rts	rts	

.txt	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]

	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8

	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8

	rts


**************************************
	CNOP	0,4
	;This routine ONLY draws the bottom 4 lines of text into HiRes BPlanes...

PBHgrTxt1:
	cmp.b	(Mem_Ptr,a0.l),d1	;1st check if mem is different!
	beq.b	.rts			;mem is same so video is same; don't change anything
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$800,a1
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	Hgr1_Planes,a0

.choose	cmp.w	#20*320+00,d1		;cmp to 1st txt line addr...
	bhs.b	.txt
.rts	rts	

.txt	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]

	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8

	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8

	rts

***********************************************************************
* enter with: a0=address to write ($800-$bff for PBTxt2), and d1=data.
***********************************************************************
	CNOP	0,4
PBTxt2	cmp.b	(Mem_Ptr,a0.l),d1
	beq.b	.rts
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$1000,a1	;- $800 * 2
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]


.do_txt	move.l	Gr2_Planes,a0		;a0 -> BitPlane1
	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8
	
	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8
.rts	rts

*****************************

	CNOP	0,4
PBGr2	cmp.b	(Mem_Ptr,a0.l),d1
	beq.b	.rts
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$1000,a1	;- $800 * 2
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

.do_gr	move.l	Gr2_Planes,a0
	bra	GRFX
.rts	rts

***************************
	CNOP	0,4
	
PBGrTxt2:
	cmp.b	(Mem_Ptr,a0.l),d1
	beq.b	.rts
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$1000,a1	;- $800 * 2
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	Gr2_Planes,a0

.choose	cmp.w	#20*320+00,d1		;cmp to 1st txt line addr...
	bhs.b	.txt
	
.do_gr	bra	GRFX			;Go draw grfx block (a0/d1 set)
.rts	rts	

.txt	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]

	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8
	
	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8

	rts

***************************
	CNOP	0,4
	
PBHgrTxt2:
	cmp.b	(Mem_Ptr,a0.l),d1
	beq.b	.rts
	move.b	d1,(Mem_Ptr,a0.l)	;FPUBYTE, write data to mem...
	and.w	#$ff,d1
	move.w	d1,a6

	move.l	#TxtLookUp-$1000,a1	;- $800 * 2
	move.w	(a1,a0.w*2),d1		;d1 = BPlane Ptr Offset for particular address
	bmi.b	.rts

	move.l	Hgr2_Planes,a0

.choose	cmp.w	#20*320+00,d1		;cmp to 1st txt line addr...
	bhs.b	.txt
.rts	rts	

.txt	move.l	#IIeCharSet,a1						[03]
	lea	(a1,a6.w*8),a1		;a1 -> CharSet for letter!!! 	[08]

	add.w	d1,a0			;a0 -> Plane1StartLoc

	move.b	(a1)+,(a0)		;line 1
	move.b	(a1)+,40(a0)		;line 2
	move.b	(a1)+,80(a0)		;line 3
	move.b	(a1)+,120(a0)		;line 4
	move.b	(a1)+,160(a0)		;line 5
	move.b	(a1)+,200(a0)		;line 6
	move.b	(a1)+,240(a0)		;line 7
	move.b	(a1)+,280(a0)		;line 8
	
	move.l	#IIeCharSet2,a1
	move.b	(a1,a6.w),d0		;a6 still present from above...!

	move.b	d0,0+LINES*40(a0)
	move.b	d0,40+LINES*40(a0)		;line 2
	move.b	d0,80+LINES*40(a0)		;line 3
	move.b	d0,120+LINES*40(a0)		;line 4
	move.b	d0,160+LINES*40(a0)		;line 5
	move.b	d0,200+LINES*40(a0)		;line 6
	move.b	d0,240+LINES*40(a0)		;line 7
	move.b	d0,280+LINES*40(a0)		;line 8

	rts


	

	SECTION	TABLES,DATA
** TxtLookUp is an entire BitMap Offset to draw a character onto based upon an absolute addr.
** For a number ($400-$7ff) it returns a word offset, or -1 if in a video "hole".
** Offset = Line # * 8 (Lines Per Character) * 40 (BytesPerLine) + Horizontal Byte Offset.
	CNOP	0,4
TxtLookUp:
	dc.w	00*320+00,00*320+01,00*320+02,00*320+03,00*320+04,00*320+05,00*320+06,00*320+07,00*320+08,00*320+09,00*320+10,00*320+11,00*320+12,00*320+13,00*320+14,00*320+15,00*320+16,00*320+17,00*320+18,00*320+19
	dc.w	00*320+20,00*320+21,00*320+22,00*320+23,00*320+24,00*320+25,00*320+26,00*320+27,00*320+28,00*320+29,00*320+30,00*320+31,00*320+32,00*320+33,00*320+34,00*320+35,00*320+36,00*320+37,00*320+38,00*320+39		;$400 -> $427
	dc.w	08*320+00,08*320+01,08*320+02,08*320+03,08*320+04,08*320+05,08*320+06,08*320+07,08*320+08,08*320+09,08*320+10,08*320+11,08*320+12,08*320+13,08*320+14,08*320+15,08*320+16,08*320+17,08*320+18,08*320+19
	dc.w	08*320+20,08*320+21,08*320+22,08*320+23,08*320+24,08*320+25,08*320+26,08*320+27,08*320+28,08*320+29,08*320+30,08*320+31,08*320+32,08*320+33,08*320+34,08*320+35,08*320+36,08*320+37,08*320+38,08*320+39		;$428...
	dc.w	16*320+00,16*320+01,16*320+02,16*320+03,16*320+04,16*320+05,16*320+06,16*320+07,16*320+08,16*320+09,16*320+10,16*320+11,16*320+12,16*320+13,16*320+14,16*320+15,16*320+16,16*320+17,16*320+18,16*320+19
	dc.w	16*320+20,16*320+21,16*320+22,16*320+23,16*320+24,16*320+25,16*320+26,16*320+27,16*320+28,16*320+29,16*320+30,16*320+31,16*320+32,16*320+33,16*320+34,16*320+35,16*320+36,16*320+37,16*320+38,16*320+39 	;$450...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$478 -> $47f
	dc.w	01*320+00,01*320+01,01*320+02,01*320+03,01*320+04,01*320+05,01*320+06,01*320+07,01*320+08,01*320+09,01*320+10,01*320+11,01*320+12,01*320+13,01*320+14,01*320+15,01*320+16,01*320+17,01*320+18,01*320+19
	dc.w	01*320+20,01*320+21,01*320+22,01*320+23,01*320+24,01*320+25,01*320+26,01*320+27,01*320+28,01*320+29,01*320+30,01*320+31,01*320+32,01*320+33,01*320+34,01*320+35,01*320+36,01*320+37,01*320+38,01*320+39		;$480...
	dc.w	09*320+00,09*320+01,09*320+02,09*320+03,09*320+04,09*320+05,09*320+06,09*320+07,09*320+08,09*320+09,09*320+10,09*320+11,09*320+12,09*320+13,09*320+14,09*320+15,09*320+16,09*320+17,09*320+18,09*320+19
	dc.w	09*320+20,09*320+21,09*320+22,09*320+23,09*320+24,09*320+25,09*320+26,09*320+27,09*320+28,09*320+29,09*320+30,09*320+31,09*320+32,09*320+33,09*320+34,09*320+35,09*320+36,09*320+37,09*320+38,09*320+39		;$4a8...
	dc.w	17*320+00,17*320+01,17*320+02,17*320+03,17*320+04,17*320+05,17*320+06,17*320+07,17*320+08,17*320+09,17*320+10,17*320+11,17*320+12,17*320+13,17*320+14,17*320+15,17*320+16,17*320+17,17*320+18,17*320+19
	dc.w	17*320+20,17*320+21,17*320+22,17*320+23,17*320+24,17*320+25,17*320+26,17*320+27,17*320+28,17*320+29,17*320+30,17*320+31,17*320+32,17*320+33,17*320+34,17*320+35,17*320+36,17*320+37,17*320+38,17*320+39		;$4d0...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$4f8 -> $4ff
	dc.w	02*320+00,02*320+01,02*320+02,02*320+03,02*320+04,02*320+05,02*320+06,02*320+07,02*320+08,02*320+09,02*320+10,02*320+11,02*320+12,02*320+13,02*320+14,02*320+15,02*320+16,02*320+17,02*320+18,02*320+19
	dc.w	02*320+20,02*320+21,02*320+22,02*320+23,02*320+24,02*320+25,02*320+26,02*320+27,02*320+28,02*320+29,02*320+30,02*320+31,02*320+32,02*320+33,02*320+34,02*320+35,02*320+36,02*320+37,02*320+38,02*320+39		;$500...
	dc.w	10*320+00,10*320+01,10*320+02,10*320+03,10*320+04,10*320+05,10*320+06,10*320+07,10*320+08,10*320+09,10*320+10,10*320+11,10*320+12,10*320+13,10*320+14,10*320+15,10*320+16,10*320+17,10*320+18,10*320+19
	dc.w	10*320+20,10*320+21,10*320+22,10*320+23,10*320+24,10*320+25,10*320+26,10*320+27,10*320+28,10*320+29,10*320+30,10*320+31,10*320+32,10*320+33,10*320+34,10*320+35,10*320+36,10*320+37,10*320+38,10*320+39		;$528...
	dc.w	18*320+00,18*320+01,18*320+02,18*320+03,18*320+04,18*320+05,18*320+06,18*320+07,18*320+08,18*320+09,18*320+10,18*320+11,18*320+12,18*320+13,18*320+14,18*320+15,18*320+16,18*320+17,18*320+18,18*320+19
	dc.w	18*320+20,18*320+21,18*320+22,18*320+23,18*320+24,18*320+25,18*320+26,18*320+27,18*320+28,18*320+29,18*320+30,18*320+31,18*320+32,18*320+33,18*320+34,18*320+35,18*320+36,18*320+37,18*320+38,18*320+39		;$550...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$578 -> $57f
	dc.w	03*320+00,03*320+01,03*320+02,03*320+03,03*320+04,03*320+05,03*320+06,03*320+07,03*320+08,03*320+09,03*320+10,03*320+11,03*320+12,03*320+13,03*320+14,03*320+15,03*320+16,03*320+17,03*320+18,03*320+19
	dc.w	03*320+20,03*320+21,03*320+22,03*320+23,03*320+24,03*320+25,03*320+26,03*320+27,03*320+28,03*320+29,03*320+30,03*320+31,03*320+32,03*320+33,03*320+34,03*320+35,03*320+36,03*320+37,03*320+38,03*320+39		;$580...
	dc.w	11*320+00,11*320+01,11*320+02,11*320+03,11*320+04,11*320+05,11*320+06,11*320+07,11*320+08,11*320+09,11*320+10,11*320+11,11*320+12,11*320+13,11*320+14,11*320+15,11*320+16,11*320+17,11*320+18,11*320+19
	dc.w	11*320+20,11*320+21,11*320+22,11*320+23,11*320+24,11*320+25,11*320+26,11*320+27,11*320+28,11*320+29,11*320+30,11*320+31,11*320+32,11*320+33,11*320+34,11*320+35,11*320+36,11*320+37,11*320+38,11*320+39		;$5a8...
	dc.w	19*320+00,19*320+01,19*320+02,19*320+03,19*320+04,19*320+05,19*320+06,19*320+07,19*320+08,19*320+09,19*320+10,19*320+11,19*320+12,19*320+13,19*320+14,19*320+15,19*320+16,19*320+17,19*320+18,19*320+19
	dc.w	19*320+20,19*320+21,19*320+22,19*320+23,19*320+24,19*320+25,19*320+26,19*320+27,19*320+28,19*320+29,19*320+30,19*320+31,19*320+32,19*320+33,19*320+34,19*320+35,19*320+36,19*320+37,19*320+38,19*320+39		;$5d0...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$5f8 -> $5ff
	dc.w	04*320+00,04*320+01,04*320+02,04*320+03,04*320+04,04*320+05,04*320+06,04*320+07,04*320+08,04*320+09,04*320+10,04*320+11,04*320+12,04*320+13,04*320+14,04*320+15,04*320+16,04*320+17,04*320+18,04*320+19
	dc.w	04*320+20,04*320+21,04*320+22,04*320+23,04*320+24,04*320+25,04*320+26,04*320+27,04*320+28,04*320+29,04*320+30,04*320+31,04*320+32,04*320+33,04*320+34,04*320+35,04*320+36,04*320+37,04*320+38,04*320+39		;$600...
	dc.w	12*320+00,12*320+01,12*320+02,12*320+03,12*320+04,12*320+05,12*320+06,12*320+07,12*320+08,12*320+09,12*320+10,12*320+11,12*320+12,12*320+13,12*320+14,12*320+15,12*320+16,12*320+17,12*320+18,12*320+19
	dc.w	12*320+20,12*320+21,12*320+22,12*320+23,12*320+24,12*320+25,12*320+26,12*320+27,12*320+28,12*320+29,12*320+30,12*320+31,12*320+32,12*320+33,12*320+34,12*320+35,12*320+36,12*320+37,12*320+38,12*320+39		;$628...
	dc.w	20*320+00,20*320+01,20*320+02,20*320+03,20*320+04,20*320+05,20*320+06,20*320+07,20*320+08,20*320+09,20*320+10,20*320+11,20*320+12,20*320+13,20*320+14,20*320+15,20*320+16,20*320+17,20*320+18,20*320+19
	dc.w	20*320+20,20*320+21,20*320+22,20*320+23,20*320+24,20*320+25,20*320+26,20*320+27,20*320+28,20*320+29,20*320+30,20*320+31,20*320+32,20*320+33,20*320+34,20*320+35,20*320+36,20*320+37,20*320+38,20*320+39		;$650...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$678 -> $67f
	dc.w	05*320+00,05*320+01,05*320+02,05*320+03,05*320+04,05*320+05,05*320+06,05*320+07,05*320+08,05*320+09,05*320+10,05*320+11,05*320+12,05*320+13,05*320+14,05*320+15,05*320+16,05*320+17,05*320+18,05*320+19
	dc.w	05*320+20,05*320+21,05*320+22,05*320+23,05*320+24,05*320+25,05*320+26,05*320+27,05*320+28,05*320+29,05*320+30,05*320+31,05*320+32,05*320+33,05*320+34,05*320+35,05*320+36,05*320+37,05*320+38,05*320+39		;$680...
	dc.w	13*320+00,13*320+01,13*320+02,13*320+03,13*320+04,13*320+05,13*320+06,13*320+07,13*320+08,13*320+09,13*320+10,13*320+11,13*320+12,13*320+13,13*320+14,13*320+15,13*320+16,13*320+17,13*320+18,13*320+19
	dc.w	13*320+20,13*320+21,13*320+22,13*320+23,13*320+24,13*320+25,13*320+26,13*320+27,13*320+28,13*320+29,13*320+30,13*320+31,13*320+32,13*320+33,13*320+34,13*320+35,13*320+36,13*320+37,13*320+38,13*320+39		;$6a8...
	dc.w	21*320+00,21*320+01,21*320+02,21*320+03,21*320+04,21*320+05,21*320+06,21*320+07,21*320+08,21*320+09,21*320+10,21*320+11,21*320+12,21*320+13,21*320+14,21*320+15,21*320+16,21*320+17,21*320+18,21*320+19
	dc.w	21*320+20,21*320+21,21*320+22,21*320+23,21*320+24,21*320+25,21*320+26,21*320+27,21*320+28,21*320+29,21*320+30,21*320+31,21*320+32,21*320+33,21*320+34,21*320+35,21*320+36,21*320+37,21*320+38,21*320+39		;$6d0...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$6f8 -> $6ff
	dc.w	06*320+00,06*320+01,06*320+02,06*320+03,06*320+04,06*320+05,06*320+06,06*320+07,06*320+08,06*320+09,06*320+10,06*320+11,06*320+12,06*320+13,06*320+14,06*320+15,06*320+16,06*320+17,06*320+18,06*320+19
	dc.w	06*320+20,06*320+21,06*320+22,06*320+23,06*320+24,06*320+25,06*320+26,06*320+27,06*320+28,06*320+29,06*320+30,06*320+31,06*320+32,06*320+33,06*320+34,06*320+35,06*320+36,06*320+37,06*320+38,06*320+39		;$700...
	dc.w	14*320+00,14*320+01,14*320+02,14*320+03,14*320+04,14*320+05,14*320+06,14*320+07,14*320+08,14*320+09,14*320+10,14*320+11,14*320+12,14*320+13,14*320+14,14*320+15,14*320+16,14*320+17,14*320+18,14*320+19
	dc.w	14*320+20,14*320+21,14*320+22,14*320+23,14*320+24,14*320+25,14*320+26,14*320+27,14*320+28,14*320+29,14*320+30,14*320+31,14*320+32,14*320+33,14*320+34,14*320+35,14*320+36,14*320+37,14*320+38,14*320+39		;$728...
	dc.w	22*320+00,22*320+01,22*320+02,22*320+03,22*320+04,22*320+05,22*320+06,22*320+07,22*320+08,22*320+09,22*320+10,22*320+11,22*320+12,22*320+13,22*320+14,22*320+15,22*320+16,22*320+17,22*320+18,22*320+19
	dc.w	22*320+20,22*320+21,22*320+22,22*320+23,22*320+24,22*320+25,22*320+26,22*320+27,22*320+28,22*320+29,22*320+30,22*320+31,22*320+32,22*320+33,22*320+34,22*320+35,22*320+36,22*320+37,22*320+38,22*320+39		;$750...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$778 -> $77f
	dc.w	07*320+00,07*320+01,07*320+02,07*320+03,07*320+04,07*320+05,07*320+06,07*320+07,07*320+08,07*320+09,07*320+10,07*320+11,07*320+12,07*320+13,07*320+14,07*320+15,07*320+16,07*320+17,07*320+18,07*320+19
	dc.w	07*320+20,07*320+21,07*320+22,07*320+23,07*320+24,07*320+25,07*320+26,07*320+27,07*320+28,07*320+29,07*320+30,07*320+31,07*320+32,07*320+33,07*320+34,07*320+35,07*320+36,07*320+37,07*320+38,07*320+39		;$780...
	dc.w	15*320+00,15*320+01,15*320+02,15*320+03,15*320+04,15*320+05,15*320+06,15*320+07,15*320+08,15*320+09,15*320+10,15*320+11,15*320+12,15*320+13,15*320+14,15*320+15,15*320+16,15*320+17,15*320+18,15*320+19
	dc.w	15*320+20,15*320+21,15*320+22,15*320+23,15*320+24,15*320+25,15*320+26,15*320+27,15*320+28,15*320+29,15*320+30,15*320+31,15*320+32,15*320+33,15*320+34,15*320+35,15*320+36,15*320+37,15*320+38,15*320+39		;$7a8...
	dc.w	23*320+00,23*320+01,23*320+02,23*320+03,23*320+04,23*320+05,23*320+06,23*320+07,23*320+08,23*320+09,23*320+10,23*320+11,23*320+12,23*320+13,23*320+14,23*320+15,23*320+16,23*320+17,23*320+18,23*320+19
	dc.w	23*320+20,23*320+21,23*320+22,23*320+23,23*320+24,23*320+25,23*320+26,23*320+27,23*320+28,23*320+29,23*320+30,23*320+31,23*320+32,23*320+33,23*320+34,23*320+35,23*320+36,23*320+37,23*320+38,23*320+39		;$7d0...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1					;$7f8 -> $7ff
