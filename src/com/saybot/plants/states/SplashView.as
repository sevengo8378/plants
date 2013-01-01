package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.mgr.AssetsMgr;
	import com.saybot.plants.consts.GameState;
	
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
			
			var bg:Image = new Image(AssetsMgr.getTexture("Background"));
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
			AssetsMgr.prepareSounds();
			AssetsMgr.loadBitmapFonts();
			setTimeout(showContinueText, 800);
		}
		
		private function showContinueText():void {
			txt = new TextField(ScreenDef.GameWidth, 40, 
				"Press to Continue", "Desyrel", 20);
			txt.y = ScreenDef.GameHeight - 50;
			txt.color = 0xff0000;
			txt.hAlign = HAlign.CENTER;
			addChild(txt);
			txt.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
				if (evt.getTouch(txt, TouchPhase.ENDED))
					starlingMain.switchState(GameState.GAME);
			});
			
			var delayedCall:DelayedCall = new DelayedCall(blinkContinueText, 0.5);
			delayedCall.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(delayedCall);
		}
		
		private function blinkContinueText():void {
			txt.visible = !txt.visible
		}
	}
}