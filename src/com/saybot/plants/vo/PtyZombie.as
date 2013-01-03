package com.saybot.plants.vo
{

	public class PtyZombie extends ValueObjectBase
	{
		public var name:String;
		
		public var hp:int;
		
		public var armature:String;
		
		public var speed:Number;
		
		public var scale:Number;
		
		public var attack:int;
		
		public var intelligence:int;
		
		public var ox:Number;
		public var oy:Number;
		
		public function PtyZombie(data:Object=null)
		{
			super(data);
		}
	}
}