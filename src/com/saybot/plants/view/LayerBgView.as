package com.saybot.plants.view
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.interfaces.IActor;
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.plants.view.entity.PlantView;
	import com.saybot.utils.GraphicsCanvas;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class LayerBgView extends LayerViewBase
	{
		private var _debugInfo:GraphicsCanvas;
		
		private var _gridsCanvas:GraphicsCanvas;
		private var _gridEntities:Dictionary;
		
		public function LayerBgView(sceneView:PlayfieldView)
		{
			super(sceneView);
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);			
		}
		
		private function initialize(evt:Event):void {
			var bg:Image = new Image(AssetsMgr.getTexture(playfield.levelData.crtLevel.bg));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			_gridsCanvas = new GraphicsCanvas(ScreenDef.GameWidth, ScreenDef.GameHeight - ScreenDef.MARGIN_BOTTOM);
			_gridsCanvas.y = ScreenDef.MARGIN_TOP;
			_gridEntities = new Dictionary();
		}
		
		public function startGridSelect():void {
			this.addChild(_gridsCanvas);
			refreshGrids();
			this._gridsCanvas.addEventListener(TouchEvent.TOUCH, gridTouchHandler);
		}
		
		private function refreshGrids():void {
			var gridXCnt:int = ScreenDef.GameWidth/40 + 1;
			var x:int;
			var y:int;
			var color:uint;
			_gridsCanvas.clear();
			for(var gX:int=0; gX<gridXCnt; gX++) {
				for(var gY:int=0; gY<GameConst.LANE_CNT; gY++) {
					x = gX * ScreenDef.GRID_W;
					y = gY * ScreenDef.GRID_H;
					color = gridHasEntity(gX, gY) ? 0xff0000 : 0x00ff00;
					_gridsCanvas.fillRect(x, y, ScreenDef.GRID_W, ScreenDef.GRID_H, color, 0.35);
				}
			}
			_gridsCanvas.refreshCanvas();
		}
		
		public function stopGridSelect():void {
			if(_gridsCanvas) {
				this._gridsCanvas.removeEventListener(TouchEvent.TOUCH, gridTouchHandler);
				_gridsCanvas.removeFromParent();
			}
		}
		
		private function gridTouchHandler(evt:TouchEvent):void {
			var touch:Touch = evt.getTouch(_gridsCanvas);
			if(touch && touch.phase == TouchPhase.ENDED) {
				var pos:Point = touch.getLocation(_gridsCanvas);
				var gridX:int = pos.x/ScreenDef.GRID_W;
				var gridY:int = pos.y/ScreenDef.GRID_H;
				if(!gridHasEntity(gridX, gridY)) {
					var pv:PlantView = playfield.addPlant(playfield.layerHUD.crtSelectCard.plantName, gridY);
					pv.x = gridX*ScreenDef.GRID_W;
					pv.y = gridY*ScreenDef.GRID_H + ScreenDef.MARGIN_TOP;
					gridSetEntity(gridX, gridY, pv);
//					refreshGrids();
					stopGridSelect();
					playfield.layerHUD.crtSelectCard.selected = false;
				} else {
					playfield.showCenterTxt("Illegal Position!", 500, null, 0xff0000, 40);
				}
			}
		}
		
		private function getGridKey(gridX:int, gridY:int):String {
			return ""+gridX+"_"+gridY;
		}
		
		private function gridHasEntity(gridX:int, gridY:int):Boolean {
			return _gridEntities[getGridKey(gridX, gridY)] != null;
		}
		
		public function gridSetEntity(gridX:int, gridY:int, entity:PlantView):void {
			_gridEntities[getGridKey(gridX, gridY)] = entity;
			entity.gridX = gridX;
			entity.gridY = gridY;
		}
		
		public function gridRemoveEntity(gridX:int, gridY:int):void {
			delete _gridEntities[getGridKey(gridX, gridY)];
			refreshGrids();
		}
		
		public function toggleDebugInfo(val:Boolean):void {
			if(_debugInfo == null && val) {
				_debugInfo = new GraphicsCanvas(ScreenDef.GameWidth, ScreenDef.GameHeight);
				for(var lane:int=0; lane<GameConst.LANE_CNT; lane++) {
					_debugInfo.drawLine(0, ScreenDef.MARGIN_TOP+(lane+1)*ScreenDef.GRID_H, ScreenDef.GameWidth, ScreenDef.MARGIN_TOP+(lane+1)*ScreenDef.GRID_H, 0xff0000, 1);
				}
				_debugInfo.refreshCanvas();
				this.addChild(_debugInfo);
			} else if(_debugInfo){
				_debugInfo.visible = val;
			}
		}
	}
}