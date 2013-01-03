package com.saybot.plants.vo
{
	public class PtyBullet extends ValueObjectBase
	{
		public var name:String;
		
		public var display:String;
		
		public var speedX:Number;
		
		public var speedY:Number;
		
		public function PtyBullet(data:Object=null)
		{
			super(data);
		}
	}
}