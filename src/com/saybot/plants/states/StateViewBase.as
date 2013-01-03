package com.saybot.plants.states
{
	import com.saybot.plants.StarlingMain;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class StateViewBase extends Sprite
	{
		public function StateViewBase(initOption:Object=null)
		{
			super();
		}
		
		public function doEnter():void {
		}
		
		public function doExit():void {
		}
		
		public function get starlingMain():StarlingMain {
			return this.parent as StarlingMain;
		}
		
		public function toggleDebugInfo(val:Boolean):void {
		}
	}
}