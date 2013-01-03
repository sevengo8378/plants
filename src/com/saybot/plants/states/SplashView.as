package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.AssetsMgr;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.game.LevelData;
	
	import flash.display.TriangleCulling;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class SplashView extends StateViewBase
	{
		private var txt:TextField;
		private var delayedCall:DelayedCall;
		
		public function SplashView()
		{
			super();
		}
		
		override public function doEnter():void {
			
			var bg:Image = new Image(AssetsMgr.getTexture("Splash"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			setTimeout(initCommonLoading, 100);
		}
		
		override public function doExit():void {
			if(txt) {
				txt.removeEventListeners();
				if(delayedCall)
					Starling.juggler.remove(delayedCall);
			}
		}
		
		private function initCommonLoading():void {
			// prepare assets
			AssetsMgr.prepareCommonSounds();
			AssetsMgr.loadBitmapFonts();
//			setTimeout(showContinueText, 800);
			setTimeout(start, 100);
		}
		
		private function showContinueText():void {
			txt = new TextField(ScreenDef.GameWidth, 40, 
				"Press to Continue", "Desyrel", 20);
			txt.y = ScreenDef.GameHeight - 50;
			txt.color = 0xff0000;
			txt.hAlign = HAlign.CENTER;
			addChild(txt);
			txt.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
				if (evt.getTouch(txt, TouchPhase.ENDED)) {
					start();
				}
			});
			
			delayedCall = new DelayedCall(blinkContinueText, 0.5);
			delayedCall.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(delayedCall);
		}
		
		private function blinkContinueText():void {
			txt.visible = !txt.visible
		}
		
		private function start():void {
			var levelData:LevelData = new LevelData();
			levelData.level = 0;
			levelData.plants = ["chomper", "fume_shroom", "jalapeno", "puff_shroom"];
			starlingMain.switchState(GameState.LOADING, levelData);
		}
	}
}