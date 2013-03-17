package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.ScreenDef;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.game.LevelData;
	import com.saybot.plants.view.components.MenuSelectLevel;
	import com.saybot.plants.vo.PtyLevel;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class LevelSelectView extends StateViewBase
	{
		private var _levelData:LevelData;
		private var _ui:TextureAtlas;
		
		public function LevelSelectView(levelData:LevelData)
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
			var menu:MenuSelectLevel = new MenuSelectLevel(_ui, _levelData);
			menu.x = (ScreenDef.GameWidth - menu.width)/2;
			menu.y = (ScreenDef.GameHeight - menu.height)/2;
			this.addChild(menu);
			this.addEventListener(MenuSelectLevel.EVT_LEVEL_SELECTED, function(evt:Event):void {
				_levelData.crtLevelIndex = (evt.data as PtyLevel).id; 
				starlingMain.switchState(GameState.LOADING, _levelData);
			});
		}
		
		override public function doExit():void {
			_levelData = null;
			_ui = null;
			super.doExit();
		}
	}
}