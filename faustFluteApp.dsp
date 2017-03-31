import("stdfaust.lib");

declare interface "SmartKeyboard{
	'Number of Keyboards':'3',
	'Keyboard 0 - Number of Keys':'1',
  'Keyboard 0 - Show Labels':'0',
  'Keyboard 0 - Static Mode':'1',
  'Keyboard 0 - Send Freq':'0',
  'Keyboard 1 - Number of Keys':'1',
  'Keyboard 1 - Show Labels':'0',
  'Keyboard 1 - Static Mode':'1',
  'Keyboard 1 - Send Freq':'0',
  'Keyboard 2 - Number of Keys':'8',
  'Keyboard 2 - Piano Keyboard':'1',
  'Keyboard 2 - Scale':'1',
  'Keyboard 2 - Static Mode':'1',
  'Keyboard 2 - Send X':'0'
}";

key = nentry("key",0,0,7,1) : int;
keyboard = nentry("keyboard",0,0,7,1) ;
gate = button("gate") : si.smoo;

freqHz = (key == 0) * 261.6 + (key == 1) * 293.7 + (key == 2) * 329.6 +
  (key == 3) * 349.2 + (key == 4) * 392.0 + (key == 5) * 440 + (key == 6) * 493.9 +
  (key == 7) * 523.3;

x = hslider("x",0.5,0,1,0.5) : si.smoo;
hCut = (5000*x)+50;
cutOff = fi.lowpass(2, hCut);

vibRate = hslider("vibRate[acc: 1 0 -30 0 10]",0,0,4,1) : si.smoo;
vibFunc = pf.phaser2_mono(1,0,500,200,0.8,1500,vibRate,2,0,0);

triangleWave = os.triangle(freqHz) * os.sawtooth(freqHz) * gate ;
process = (an.amp_follower_ud(0.1,0.5)*triangleWave*2) : cutOff : vibFunc <: _,_;
// process = triangleWave : cutOff;


// problems: vibrato orientation/depth, weird cutoff slider characteristics
