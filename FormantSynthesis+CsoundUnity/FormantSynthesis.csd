<CsoundSynthesizer>
<CsOptions>
-odac -d -n  -m0d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

opcode shimmer_reverb, aa, aakkkkkk
	al, ar, kpredelay, krvbfblvl, krvbco, kfblvl, kfbdeltime, kratio  xin

  ; pre-delay
  al = vdelay3(al, kpredelay, 1000)
  ar = vdelay3(ar, kpredelay, 1000)
 
  afbl init 0
  afbr init 0

  al = al + (afbl * kfblvl)
  ar = ar + (afbr * kfblvl)

  ; important, or signal bias grows rapidly
  al = dcblock2(al)
  ar = dcblock2(ar)

	; tanh for limiting
  al = tanh(al)
  ar = tanh(ar)

  al, ar reverbsc al, ar, krvbfblvl, krvbco 

  ifftsize  = 2048 
  ioverlap  = ifftsize *0.25
  iwinsize  = ifftsize 
  iwinshape = 1; von-Hann window 

  fftin     pvsanal al, ifftsize, ioverlap, iwinsize, iwinshape 
  fftscale  pvscale fftin, kratio, 0, 1
  atransL   pvsynth fftscale

  fftin2    pvsanal ar, ifftsize, ioverlap, iwinsize, iwinshape 
  fftscale2 pvscale fftin2, kratio, 0, 1
  atransR   pvsynth fftscale2

  ;; delay the feedback to let it build up over time
  afbl = vdelay3(atransL, kfbdeltime, 4000)
  afbr = vdelay3(atransR, kfbdeltime, 4000)

  xout al, ar
endop


turnon 1

instr 1

kRes[] fillarray 60, 60, 30, 15

;asig pinker 
;asig = asig *0.001

kjit1 = 0.5 + jitter:k( 0.5, 0.4, 0.5)
kjit2 = 0.5 + jitter:k( 0.5, 0.4, 0.5)
kjit3 = 0.5 + jitter:k( 0.5, 0.4, 0.5)

kjit10 =  1+ jitter:k( 1, 0.4, 0.5)


kX = chnget:k("X")/360
kX port kX, 0.05
kY = chnget:k("Y") /360
kY port kY, 0.05
kZ = chnget:k("Z") /360
kZ port kZ, 0.05

krand randh 100, 0.25
kpitch = 300+krand
kpitch port kpitch, 0.2
asig vco2 0.3*0.1, (kpitch)*kX
asig zdf_1pole asig, 19000 * (kpitch/ 600)

kBase1[] fillarray 600, 1000, 2520, 3340
kBase2[] fillarray 360, 1540, 2340, 3400

kBasea[] fillarray 360, 1540, 2340, 3400

	#define	KMODESPORT1(ARRN1)
	#
kBasea[$ARRN1] ntrpol  kBase2[$ARRN1], kBase1[$ARRN1], (1*kjit1)*kY
	#
// Generate
	$KMODESPORT1(0)
	$KMODESPORT1(1)
	$KMODESPORT1(2)
	$KMODESPORT1(3)
	
kBase3[] fillarray 290, 680, 2320, 3150
kBase4[] fillarray 360, 2240, 2880, 3460

kBaseb[] fillarray 360, 1540, 2340, 3400

	#define	KMODESPORT2(ARRN2)
	#
kBaseb[$ARRN2] ntrpol  kBase3[$ARRN2], kBase4[$ARRN2], 1*kY
	#
// Generate
	$KMODESPORT2(0)
	$KMODESPORT2(1)
	$KMODESPORT2(2)
	$KMODESPORT2(3)
	
kBase[] fillarray 360, 1540, 2340, 3400
	
		#define	KMODESPORT3(ARRN3)
	#
kBase[$ARRN3] ntrpol  kBasea[$ARRN3], kBaseb[$ARRN3], 1*kZ
	#
// Generate
	$KMODESPORT3(0)
	$KMODESPORT3(1)
	$KMODESPORT3(2)
	$KMODESPORT3(3)
	
	
	

asug0 mode asig, kBase[0], kRes[0]
asug1 mode asig*0.5, kBase[1], kRes[1]
asug2 mode 0.2*asig, kBase[2], kRes[2]
asug3 mode 0.2*asig, kBase[3], kRes[3]

asug = (asug0 + asug1 + asug2 + asug3)/70

outs asug, asug 


gaverb = butterlp:a( asug*0.2, 13000)

endin 

turnon 5

instr 5

	
	gal, gar shimmer_reverb gaverb, gaverb, 0.1, .95, 10000, 0.45, 100, 0
  outs gal, gar
endin


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>624</x>
 <y>248</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>Y</objectName>
  <x>154</x>
  <y>73</y>
  <width>20</width>
  <height>100</height>
  <uuid>{4fbe1c9d-17dc-4264-a342-22a9c0b88c66}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>360.00000000</maximum>
  <value>64.80000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>X</objectName>
  <x>86</x>
  <y>84</y>
  <width>20</width>
  <height>100</height>
  <uuid>{3453515a-2eba-406b-b9ea-9d3f52dff7c9}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>360.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>Z</objectName>
  <x>207</x>
  <y>95</y>
  <width>20</width>
  <height>100</height>
  <uuid>{5381849f-419f-4b9d-b2cf-fff128e70976}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>360.00000000</maximum>
  <value>118.80000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
