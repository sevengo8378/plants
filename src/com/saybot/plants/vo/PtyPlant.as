package com.saybot.plants.vo
{
	public class PtyPlant extends ValueObjectBase
	{
		public var name:String;
		
		public var hp:int;
		
		public var armature:String;
		
		public var skill:String;
		
		public var attack:int;
		
		public var cooldown:Number;
		
		public var price:int;
		
		public var scale:Number;
		public var ox:Number;
		public var oy:Number;
		
		// optional properties
		public var bullet:String;
		public var key_bone:String;
		
		
		public function PtyPlant(data:Object=null)
		{
			super(data);
		}
	}
}