package com.saybot.plants
{
	import com.saybot.AssetsMgr;
	import com.saybot.ScreenDef;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.mvc.ApplicationFacade;
	import com.saybot.plants.states.StateViewBase;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class StarlingMain extends Sprite
	{
		private var _crtState:String;
		private var _crtStateView:StateViewBase;
		
		public function StarlingMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			GameState.initialize();
			switchState(GameState.SPLASH);
		}
		
		public function switchState(st:String):Boolean {
			var stateContent:Array = GameState.getStateContent(st);
			var stateViewCls:Class = stateContent[0] as Class;
			if(stateContent == null || stateViewCls == null)
				return false;
			if(_crtStateView) {
				_crtStateView.doExit();
				this.removeChild(_crtStateView, true);
			}
			_crtStateView = new stateViewCls as StateViewBase;
			_crtStateView.doEnter();
			this.addChild(_crtStateView);
			_crtState = st;
			return true;
		}
	}
}
