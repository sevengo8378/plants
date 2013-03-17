package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.game.LevelData;
	import com.saybot.plants.view.components.Menu;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class MainMenuView extends StateViewBase
	{
		private var _levelData:LevelData;
		private var _ui:TextureAtlas;
		
		public function MainMenuView(levelData:LevelData)
		{
			_levelData = levelData;
			super();
		}
		
		override public function doEnter():void {
			super.doEnter();
			var bg:Image = new Image(AssetsMgr.getTexture("Splash"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);

			_ui = AssetsMgr.getTextureAtlas("UIPNG", "UIXml");
			var menu:Menu = new Menu(_ui, false);
			menu.x = (ScreenDef.GameWidth - menu.width)/2;
			menu.y = (ScreenDef.GameHeight - menu.height)/2;
			this.addChild(menu);
			this.addEventListener(Menu.EVT_MENU_ITEM_CLICK, function(evt:Event):void {
				var mi:String = evt.data as String;
				if(mi == GameConst.MI_SELECT_LEVEL) {
//					_levelData.crtLevelIndex = 
					starlingMain.switchState(GameState.SELECT_LEVEL, _levelData);
				} else if(mi == GameConst.MI_SETTING) {
					Starling.current.showStats = !Starling.current.showStats;
				}
			});
		}
		
		override public function doExit():void {
			_levelData = null;
			_ui = null;
			super.doExit();
		}
	}
}