package com.saybot.plants.vo
{

	public class PtyLevel extends ValueObjectBase
	{
		public var id:int;
		
		public var name:String;
		
		public var bg:String;
		
		public var music:String;
		
		public var init_shushine:int;
		
		public var sunshine_delay:Number;
		
		public var round:Array;
		
		public var plantsStr:String;
		
		public var plants:Array;
		
		public function PtyLevel(data:Object=null)
		{
			super(data);
			plants = plantsStr.split(",");
		}
	}
}