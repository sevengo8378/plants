package com.saybot
{
	public final class GameConst
	{
		public function GameConst()
		{
		}
		
		public static const LOADING_DELAY_FRAMES:int = 1;
		
		public static const LANE_CNT:int = 5;
		
		public static const LAYER_BG:int = 0;
		public static const LAYER_HUD:int = LAYER_BG + 1;
		public static const LAYER_ENTITY:int = LAYER_HUD + 1;
		public static const LAYER_EFFECT:int = LAYER_ENTITY + 1;
		public static const LAYER_POPUP:int = LAYER_EFFECT + 1;
		public static const LAYER_CNT:int = LAYER_POPUP + 1;
		
		public static const ZOMBIE_IDLE:String = "idle";
		public static const ZOMBIE_WALK:String = "walk";
		public static const ZOMBIE_EAT:String = "eat";
		public static const ZOMBIE_DIE:String = "death";
		
		public static const PLANT_IDLE:String = "idle";
		public static const PLANT_SHOOTING:String = "shooting";
		public static const PLANT_BITE:String = "bite";
		
	}
}