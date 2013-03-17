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
		public static const LAYER_ENTITY:int = LAYER_BG + 1;
		public static const LAYER_HUD:int = LAYER_ENTITY + 1;
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
		public static const PLANT_EXPLODE:String = "explode";
		
		public static const SFX_CLICK:String = "SFX_CLICK";
		public static const SFX_EXPLODE:String = "SFX_EXPLODE";
		public static const SFX_PLANT_BITE:String = "SFX_PLANT_BITE";
		public static const SFX_SHOOT_HURT:String = "SFX_SHOOT_HURT";
		public static const SFX_ZOMBIE_EAT:String = "SFX_ZOMBIE_EAT";
		public static var SFX_ALL:Array = [SFX_CLICK, SFX_EXPLODE, SFX_PLANT_BITE, SFX_SHOOT_HURT, SFX_ZOMBIE_EAT];
		
		public static const MI_BACK:String = "mi_back";
		public static const MI_SELECT_LEVEL:String = "mi_select_level";
		public static const MI_SETTING:String = "mi_setting";
		
	}
}