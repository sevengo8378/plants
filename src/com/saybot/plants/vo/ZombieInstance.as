package com.saybot.plants.vo
{

	public class ZombieInstance extends Entity
	{
		public var name:String;
		
		public var delay:Number; //seconds
		
		public var lane:int;
		
		public var type:String;
		
		public var ptyData:PtyZombie;
		
		public function ZombieInstance(data:Object=null)
		{
			super(data);
		}
	}
}