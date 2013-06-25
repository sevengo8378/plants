package com.saybot.plants.view.components
{
	import com.saybot.GameConst;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	public class Menu extends Sprite
	{
		public static const EVT_MENU_ITEM_CLICK:String = "evt_menu_item_click";
		
		private var _ui:TextureAtlas;
		
		private var _isIGM:Boolean;
		
		public function Menu(ui:TextureAtlas, isIGM:Boolean)
		{
			super();
			_ui = ui;
			_isIGM = isIGM;
			buildMenuItems();
		}
		
		private function buildMenuItems():void {
			var menuBg:Image = new Image(_ui.getTexture("menu_panel_bg0000"));
			this.addChild(menuBg);
			
			var itemTextures:Array = _isIGM ? [GameConst.MI_BACK, GameConst.MI_SETTING] : [GameConst.MI_SELECT_LEVEL, GameConst.MI_SETTING];
			var mi:Image;
			var label:String;
			for(var i:int=0; i<itemTextures.length; i++) {
				label = itemTextures[i] as String;
				mi = new Image(_ui.getTexture(label+"0000"));
				mi.x = (menuBg.width - mi.width)/2;
				var yGap:Number = (menuBg.height - mi.height*itemTextures.length)/(itemTextures.length+1);
				mi.y = yGap * (i+1) + mi.height*i;
				this.addChild(mi);
				addMITouchHandler(mi, label);
			}
		}
		
		private function addMITouchHandler(mi:Image, miName:String):void {
			mi.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
				var touch:Touch = evt.getTouch(mi);
				if(touch && touch.phase == TouchPhase.ENDED)
					dispatchEventWith(EVT_MENU_ITEM_CLICK, true, miName);
			});
		}
	}
}