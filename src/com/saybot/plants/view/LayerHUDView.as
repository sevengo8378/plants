package com.saybot.plants.view
{
	import com.saybot.GameConst;
	import com.saybot.plants.states.PlayfieldView;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class LayerHUDView extends LayerViewBase
	{
		private var sunTxt:TextField;
		
		public function LayerHUDView(sceneView:PlayfieldView)
		{
			super(sceneView);
//			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
			initialize(null);
		}
		
		private function initialize(evt:Event):void {
			var hud:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("hud0000"));
			hud.x = 5;
			hud.y = 1;
			this.addChild(hud);
				
			sunTxt = new TextField(30, 17, "");
			sunTxt.hAlign = HAlign.CENTER;
			sunTxt.x = 10;
			sunTxt.y = 30;
//			sunTxt.border = true;
			this.addChild(sunTxt);
		}
		
		public function updateSunshine(val:Number):void {
			sunTxt.text = val.toString();
		}
	}
}