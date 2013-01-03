package com.saybot.plants
{
	import com.saybot.AssetsMgr;
	import com.saybot.ScreenDef;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.states.StateViewBase;
	
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	
	public class StarlingMain extends Sprite
	{
		private var _crtState:String;
		private var _crtStateView:StateViewBase;
		
		private var _showDebugInfo:Boolean;
		
		private static var _instance:StarlingMain;
		
		public function StarlingMain()
		{
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			GameState.initialize();
			switchState(GameState.SPLASH);
		}
	
		private function keyHandler(event:Event, keyCode:uint):void
		{
			if (keyCode == Keyboard.V) {
				_showDebugInfo = !_showDebugInfo;
				toggleDebugInfo(_showDebugInfo);
			}
		}
		
		private function toggleDebugInfo(val:Boolean):void {
			if(_crtStateView) {
				_crtStateView.toggleDebugInfo(val);
			}
		}
		
		public function switchState(st:String, initOptions:Object=null):Boolean {
			var stateContent:Array = GameState.getStateContent(st);
			var stateViewCls:Class = stateContent[0] as Class;
			if(stateContent == null || stateViewCls == null)
				return false;
			if(_crtStateView) {
				_crtStateView.doExit();
				this.removeChild(_crtStateView, true);
			}
			_crtStateView = initOptions ? new stateViewCls(initOptions) as StateViewBase : new stateViewCls() as StateViewBase;
			_crtStateView.doEnter();
			this.addChild(_crtStateView);
			_crtState = st;
			return true;
		}
		
		public function get crtState():String {
			return _crtState;
		}
		
		public function get crtStateView():StateViewBase {
			return _crtStateView;
		}
		
		public static function getInstance():StarlingMain {
			return _instance;
		}
	}
}
