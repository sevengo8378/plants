package com.saybot.plants.view.components
{
	import com.saybot.GameConst;
	import com.saybot.plants.game.LevelData;
	import com.saybot.plants.vo.PtyLevel;
	
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class MenuSelectLevel extends Sprite
	{
		public static const EVT_LEVEL_SELECTED:String = "evt_level_SELECTED";
		
		private var _ui:TextureAtlas;
		
		private var _levelData:LevelData;
		
		public function MenuSelectLevel(ui:TextureAtlas, levelData:LevelData)
		{
			super();
			_ui = ui;
			_levelData = levelData;
			buildMenuItems();
		}
		
		private function buildMenuItems():void {
			var menuBg:Image = new Image(_ui.getTexture("menu_panel_bg0000"));
			this.addChild(menuBg);
			
			var levels:Vector.<PtyLevel> = _levelData.levels;
			var mi:MyButton;
			var label:String;
			var bmd:BitmapData;
			for(var i:int=0; i<levels.length; i++) {
				label = (levels[i] as PtyLevel).name;
				bmd = new BitmapData(120, 30, false, 0x999900);
				mi = new MyButton(Texture.fromBitmapData(bmd, false), label);
				bmd.dispose();
				mi.x = (menuBg.width - mi.width)/2;
				var yGap:Number = (menuBg.height - mi.height*levels.length)/(levels.length+1);
				mi.y = yGap * (i+1) + mi.height*i;
				this.addChild(mi);
				addMITouchHandler(mi, levels[i] as PtyLevel);
			}
		}
		
		private function addMITouchHandler(mi:MyButton, level:PtyLevel):void {
			mi.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
				var touch:Touch = evt.getTouch(mi);
				if(touch && touch.phase == TouchPhase.ENDED)
					this.dispatchEventWith(EVT_LEVEL_SELECTED, true, level);
			});
		}
	}
}