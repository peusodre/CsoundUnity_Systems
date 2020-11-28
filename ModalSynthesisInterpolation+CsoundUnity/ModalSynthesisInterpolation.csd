<CsoundSynthesizer>
<CsOptions>
-odac -d -n  -m0d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1


gkenv init 0
gkenv2 init 0
gkDyn  init 0
gkObject1 init 0
gkObject2 init 0
gkControl  init 0.5
gkFreqBase init 1000
kObject1  init 0.5
kObject2  init 0.5


opcode	 MODESYNTH , a, akkkkkkkkkkkkkkkkkkkkkkk
 ain,kamp, kbasfrq, kmode1, kgain1, kq1,  kmode2, kgain2,kq2, kmode3,kgain3, kq3, kgain4, kmode4,  kq4, kmode5,kgain5,  kq5, kmode6, kgain6,kq6,  kmode7,kgain7,kq7 	xin
	amix	init	0
	
#define	MODE_PARTIAL(FRQ'KQ'KG)
	#
	kgain = ampdb($KG*0.6)
	kfrq	=	kbasfrq*$FRQ
	if sr/kfrq>=$M_PI then
	 asig	mode	ain*kgain, kfrq, $KQ
	 amix	=	amix + asig
	 amix = amix*kamp
	endif
	#
	
	$MODE_PARTIAL(kmode1'kq1'kgain1)
	$MODE_PARTIAL(kmode2'kq2'kgain2)
	$MODE_PARTIAL(kmode3'kq3'kgain3)
	$MODE_PARTIAL(kmode4'kq4'kgain4)
	$MODE_PARTIAL(kmode5'kq5'kgain5)
	$MODE_PARTIAL(kmode6'kq6'kgain6)
	$MODE_PARTIAL(kmode7'kq7'kgain7)
		xout	amix/7
		clear	amix
endop

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


instr 10

	kFreqBase chnget "Freq" 
	kUnityTrigger chnget "Trigger"
	kUnityRes chnget "ResMult"
		kJitDynamic chnget "Dynamics"
		kControl chnget "Control"
		kObject1 chnget "Object1"
		kObject2 chnget "Object2"
		gkVerbSend  chnget "verbSend"
		gkVerbRatio chnget  "verbRatio"

	schedkwhen kUnityTrigger, 0.01  , 70 , 1, 0, 3 , kJitDynamic, kControl, kObject1, kObject2 , kFreqBase, gkVerbSend ,  gkVerbRatio

endin 


instr 1
gkenv linseg 1, 0.04, 0
gkenv2 linseg 1, 0.014, 0
gkDyn  = p4
gkObject1 = p6
gkObject2 = p7
gkControl = p5
iFreqBase random 0, 5
gkFreqBaseOffset = k(iFreqBase)
gkFreqBase = cpsmidinn(p8)
gkVerbSend = p9
gkVerbRatio = p10




endin


instr 30
	

are pinker
areBal =  (are*0.01)*gkenv2
ares = (are*0.005)*gkenv
ares zdf_1pole ares, gkDyn*20000, gkControl 


//## MODES FREQUENCIES ##//
	
	//Singing Bowl
		kModesSB[] fillarray 285/285, 327.6/285 , 820.9/285, 1307/ 285, 1890/285, 2518/285, 3198/285
	//Glass
		kModesG[] fillarray 826/826, 1847/826, 2785/826,3395/826, 4127/826, 5292/826, 8406/826
		//Conga
		kModesC[] fillarray 198/198, 269/198, 332.2/198, 459/198, 500/198, 588/198, 719/198
				
					
	//Whistle
		//kModes2[] fillarray 1689/1689, 1828/1689, 2061/1689, 3389/1689, 3857/1689, 5319/1689, 7908/1689
	

		
	// PlaceHolder	
		kModes[] fillarray 1, 1,  1, 1, 1, 1, 1
		
		//## MODES RE ##//
		
		//Singin Bowl
		kRESSB[]  fillarray  500, 500, 500, 500, 500, 500, 500
				//Glass
		kRESG[]  fillarray  500, 500, 500, 500, 500, 500, 500
		//Conga
		kRESC[]  fillarray 50, 47, 50, 50, 50, 50, 45
		
		kRESC[] = kRESC 
			//Other Options
			//kRESC[]  fillarray  100,  60, 50, 38, 30, 28, 30
			//kRESC[]  fillarray  80,  40, 50, 25, 15, 15, 15
			
				//Whistle
		//kRESW[]  fillarray  500,  200, 200, 200, 60, 60, 60
		
		
		// PlaceHolder
		kRES[] fillarray  70, 100, 100, 100, 100, 100, 100
		
		
			//## MODES GAIN##//
	
	//Singing Bowl
		kGainsSB[] fillarray  - 61, - 26.7, -28.9 ,-28.9  , -36.1, -38.8 ,-31.7
	//Glass
		kglassOffset = -20;
		kGainsG[] fillarray -44.1, -35.3 ,-52 ,-38.1, -34.4 ,-35.4, -48.3
		//Conga
		kGainsC[] fillarray -15, -25, -12 ,-40 ,-46, -46 ,-46
					
	//Whistle
		//kModesW[] fillarray 1689/1689, 1828/1689, 2061/1689, 3389/1689, 3857/1689, 5319/1689, 7908/1689
	

		
	// PlaceHolder	
		kGains[] fillarray 1, 1,  1, 1, 1, 1, 1
		
		
		
/// SELECT OBJECT 
				kmo oscil 0.3, 0.3
				kmoC oscil 0.3, 4
				kRES[] =(kRES*(gkFreqBase*0.0054054054))*kmoC
			
		kmod = kmo +1
		if gkObject1 >= 0 &&  gkObject1 < 1 then
		kModes1[] =kModesSB
		kRES1[] =kRESSB*1+kmod
		kGains1[] =kGainsSB
		kAmp1 = 0.85
		elseif gkObject1 >= 1 && gkObject1 <=2 then
		kModes1[] =kModesG
		kRES1[] =kRESG
		kGains1[] =kGainsG
		kAmp1 = 0.60
		elseif gkObject1 >= 2 &&  gkObject1 <=3 then
		kModes1[] =kModesC
		kRES1[] =kRESC
		kGains1[] =kGainsC
		kAmp1 = 0.75
		endif
		
		if gkObject2 >= 0 &&  gkObject2 < 1 then
		kModes2[] =kModesSB
		kRES2[] =kRESSB
		kGains2[] =kGainsSB
		kAmp2 = 0.85
		elseif gkObject2 >= 1 &&  gkObject2 <2  then
		kModes2[] =kModesG
		kRES2[] =kRESG
		kGains2[] =kGainsG
		kAmp2 =0.60
		elseif gkObject2 >= 2 &&  gkObject2 <=3 then
		kModes2[] =kModesC
		kRES2[] =kRESC
		kGains2[] =kGainsC
		kAmp2 = 0.75
		endif
	
	
	
	
	
	
	
	
// Using #define to make each individual element of the array interpolate to the other

// Define 	
	#define	KMODESPORT(ARRN)
	#
kModes[$ARRN] ntrpol  kModes2[$ARRN], kModes1[$ARRN], 1-gkControl
;kModes[$ARRN] port kModes[$ARRN],  0.002

kSmallResMod oscil 0.2, 70

if (gkControl > 0) &&( gkControl < 1) then
kRES[$ARRN] ntrpol  (kRES2[$ARRN]*(kSmallResMod+1))*1.6, kRES1[$ARRN], 1-gkControl
elseif (1-gkControl == 0) then
kRES[$ARRN] = (kRES2[$ARRN]*(kSmallResMod+1))*1.6
elseif (1-gkControl == 1) then
kRES[$ARRN] =  kRES1[$ARRN]
endif

;kRES[$ARRN] port kRES[$ARRN],  0.002 

kGains[$ARRN] ntrpol  kGains2[$ARRN], kGains1[$ARRN], 1-gkControl

kAmp ntrpol  kAmp2, kAmp1, 1-gkControl

	#
	
// Generate
	$KMODESPORT(0)
	$KMODESPORT(1)
	$KMODESPORT(2)
	$KMODESPORT(3)
	$KMODESPORT(4)	
	$KMODESPORT(5)
	$KMODESPORT(6)


		asig MODESYNTH, ares,kAmp,  gkFreqBase,  kModes[0], kGains[0],    kRES[0] ,   kModes[1],kGains[1],   kRES[1] ,   kModes[2],kGains[2],   kRES[2] ,  kModes[3],kGains[3],   kRES[3] ,   kModes[4],kGains[4],   kRES[4] ,   kModes[5], kGains[5],  kRES[5] ,   kModes[6],kGains[6],   kRES[6] 
	
	
	
	kPitchScale =   limit:k((gkFreqBase-30)* 0.1,0, 1)

	
	aclick1 mpulse 0.001, 40
	aclick1 zdf_1pole aclick1, (gkDyn*20000), 0
	aclick2 = areBal*0.01
	aclick = aclick1*kPitchScale + aclick2*kPitchScale
	
	
kNoClic linseg 0, 0.1, 1, 1000-0.5, 1, 0.5, 0
	
	aout= (asig*30)+aclick*(kAmp*1.42857142857)
	
	outs (aout*7)*kNoClic, (aout*7)*kNoClic
	gasigFinal = (asig*10)
	

	gaverb = ((asig*1.5)*kNoClic)*gkVerbSend
	
	endin


instr 5

	
	gal, gar shimmer_reverb gaverb, gaverb, 0.1, .95, 16000, 0.45, 100, gkVerbRatio
  outs gal, gar
endin


</CsInstruments>
<CsScore>
i 10 0 1000
i 30 0 1000
i 5 0 1000

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
