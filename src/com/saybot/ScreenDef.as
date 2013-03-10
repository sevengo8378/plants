package com.saybot
{
	public class ScreenDef
	{
		public static const GameWidth:int  = 480;
		public static const GameHeight:int = 320;
		
		public static const CenterX:int = GameWidth / 2;
		public static const CenterY:int = GameHeight / 2;
		
		public static const MARGIN_TOP:int = 60;
		public static const MARGIN_BOTTOM:int = 30;
		public static const LANE_HEIGHT:Number = (ScreenDef.GameHeight - MARGIN_TOP - MARGIN_BOTTOM) / GameConst.LANE_CNT;
		
		public static const GRID_W:int = 40;
		public static const GRID_H:int = LANE_HEIGHT;
	}
}