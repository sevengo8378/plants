package com.saybot.plants.vo
{

	public class PtyRound extends ValueObjectBase
	{
		public var id:int;
		
		public var delay:Number; //seconds
		
		public var enemy:Array;
		
		public function PtyRound(data:Object=null)
		{
			super(data);
		}
	}
}