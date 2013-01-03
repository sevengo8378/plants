package com.saybot.plants.view
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.utils.GraphicsCanvas;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class LayerBgView extends LayerViewBase
	{
		private var _debugInfo:GraphicsCanvas;
		
		public function LayerBgView(sceneView:PlayfieldView)
		{
			super(sceneView);
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);			
		}
		
		private function initialize(evt:Event):void {
			var bg:Image = new Image(AssetsMgr.getTexture(playfield.levelData.crtLevel.bg));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
		}
		
		public function toggleDebugInfo(val:Boolean):void {
			if(_debugInfo == null && val) {
				_debugInfo = new GraphicsCanvas(ScreenDef.GameWidth, ScreenDef.GameHeight);
				for(var lane:int=0; lane<GameConst.LANE_CNT; lane++) {
					_debugInfo.drawLine(0, ScreenDef.MARGIN_TOP+(lane+1)*ScreenDef.LANE_HEIGHT, ScreenDef.GameWidth, ScreenDef.MARGIN_TOP+(lane+1)*ScreenDef.LANE_HEIGHT, 0xff0000, 1);
				}
				_debugInfo.refreshCanvas();
				this.addChild(_debugInfo);
			} else if(_debugInfo){
				_debugInfo.visible = val;
			}
		}
	}
}