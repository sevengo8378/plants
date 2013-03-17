package com.saybot.plants.view.components
{
	import com.saybot.ScreenDef;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Sunshine extends MovieClip
	{
		public static const EVT_HARVEST:String = "evt_harvest";
		public static const EVT_OUT_SCREEN:String = "evt_out_screen";
		
		private var _floatingStarted:Boolean;
		private var _direction:int;
		private var _dirTimer:Timer;
		
		private var _paused:Boolean;
		
		public function Sunshine(textures:Vector.<Texture>)
		{
			super(textures, 6);
			this.addEventListener(Event.ADDED_TO_STAGE, startFloating);
		}
		
		private function startFloating(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, startFloating);
			_floatingStarted = true;
			_direction = 1;
			_dirTimer = new Timer(1500);
			_dirTimer.addEventListener(TimerEvent.TIMER, changeDirection);
			_dirTimer.start();
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.juggler.add(this);
		}
		
		private function changeDirection(evt:TimerEvent):void {
			_direction = _direction == 1 ? -1 : 1;
		}
		
		override public function advanceTime(passedTime:Number):void {
			if(_paused)
				return;
			if(_floatingStarted) {
				this.y -= (0.1 + Math.random()*0.3);
				this.x += this._direction * (0.2 + Math.random()*0.4);
			}
			var colBox:Rectangle = this.bounds;
			if(colBox.bottom < 0 || colBox.top > ScreenDef.GameHeight) {
				this.dispatchEventWith(EVT_OUT_SCREEN, true, this);
			}
			super.advanceTime(passedTime);
		}
		
		private function onTouch(evt:TouchEvent):void {
			var touch:Touch = evt.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED) {
				this.dispatchEventWith(EVT_HARVEST, true, this);
			}
		}
		
		override public function dispose():void {
			Starling.juggler.remove(this);
			this.removeEventListeners(Event.ADDED_TO_STAGE);
			this.removeEventListeners(EVT_HARVEST);
			if(_dirTimer) {
				_dirTimer.stop();
				_dirTimer.removeEventListener(TimerEvent.TIMER, changeDirection);
				_dirTimer = null;
			}
			super.dispose();
		}
		
		public function setPaused(val:Boolean):void {
			_paused = val;
		}
	}
}