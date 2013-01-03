package com.saybot.plants.vo
{
	public class PlantInstance extends Entity
	{
		public var name:String;
		
		public var lane:int;
		
		public var ptyData:PtyPlant;
		
		public function PlantInstance(data:Object=null)
		{
			super(data);
		}
	}
}