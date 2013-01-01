package com.saybot.plants.consts
{
	import com.saybot.plants.states.MainMenuView;
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.plants.states.SplashView;
	
	import flash.utils.Dictionary;

	public class GameState
	{
		public function GameState()
		{
		}
		
		public static var SPLASH:String = "splash";
		
		public static var MAINMENU:String = "mainmenu";
		
		public static var GAME:String = "game";
		
		
		private static var states:Dictionary = new Dictionary();
		public static function initialize():void {
			states[SPLASH] = [SplashView];
			states[MAINMENU] = [MainMenuView];
			states[GAME] = [PlayfieldView];
		}
		
		public static function hasState(st:String):Boolean {
			return states[st] != null;
		}
		
		public static function getStateContent(st:String):Array {
			return states[st] as Array;
		}
		
		
	}
}
