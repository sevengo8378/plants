package com.saybot.plants.vo
{
	public class BulletInstance extends Entity
	{
		public var name:String;
		
		public var lane:int;
		
		public var ptyData:PtyBullet;
		
		public function BulletInstance(data:Object=null)
		{
			super(data);
		}
	}
}