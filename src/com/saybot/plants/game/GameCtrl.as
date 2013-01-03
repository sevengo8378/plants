package com.saybot.plants.game
{
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;

	public class GameCtrl
	{
		private var _pendingCalls:Array;
		
		public function GameCtrl()
		{
			_pendingCalls = [];
		}
		
		public function addTask(func:Function, delay:Number, args:Array=null, repeatCnt:int=1):void {
			var delayedCall:DelayedCall = new DelayedCall(func, delay, args);
			delayedCall.repeatCount = repeatCnt;
			delayedCall.addEventListener(Event.REMOVE_FROM_JUGGLER, selfRemoveFromjuggler);
			Starling.juggler.add(delayedCall);
			_pendingCalls.push(delayedCall);
		}
		
		private function selfRemoveFromjuggler(evt:Event):void {
			var delayedCall:DelayedCall = evt.target as DelayedCall;
			var index:int = _pendingCalls.indexOf(delayedCall);
			if(index >= 0) {
				_pendingCalls.splice(index, 1);
				Starling.juggler.remove(delayedCall);
			}
		}
		
		public function removeAllTasks():void {
			for each(var delayedCall:DelayedCall in _pendingCalls) {
				Starling.juggler.remove(delayedCall);
			}
			_pendingCalls = [];
		}
		
		public function dispose():void {
			removeAllTasks();
		}
	}
}