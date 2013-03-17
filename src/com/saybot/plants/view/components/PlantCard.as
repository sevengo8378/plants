package com.saybot.plants.view.components
{
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.utils.GraphicsCanvas;
	
	import flash.filters.GradientBevelFilter;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PlantCard extends Sprite
	{
		private var _selected:Boolean;
		
		private var _enabled:Boolean;
		
		private var _grayFilter:ColorMatrixFilter = new ColorMatrixFilter();
		private var _canvas:GraphicsCanvas;
		
		public var sunCost:int;
		public var plantName:String;
		
		public function PlantCard(name:String, playfield:PlayfieldView)
		{
			plantName = name;
			_grayFilter = new ColorMatrixFilter();
			_grayFilter.adjustSaturation(-1);
			super();
			
			var cardImg:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("plant_card0000"));
			this.addChild(cardImg);
			
			var tName:String = "plant_"+name.toLowerCase()+"0000";
			var plantImg:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture(tName));
			plantImg.x = (cardImg.width-plantImg.width)/2
			plantImg.y = (cardImg.height-plantImg.height)/2 - 4;
			this.addChild(plantImg);
			
			
			sunCost = playfield.levelData.getPlantPtyByName(name).price;
			var sunCostTxt:TextField = new TextField(cardImg.width, 17, sunCost.toString());
			sunCostTxt.hAlign = HAlign.CENTER;
			sunCostTxt.vAlign = VAlign.BOTTOM;
			sunCostTxt.y = cardImg.height - 17;
			this.addChild(sunCostTxt);
			
			_canvas = new GraphicsCanvas(this.width+4, this.height+4);
			_canvas.x = -2;
			_canvas.y = -2;
			_canvas.drawRect(0, 0, _canvas.width-2, _canvas.height-2, 0x00ff00, 3);
			_canvas.refreshCanvas();
			this.addChild(_canvas);
			selected = false;
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(val:Boolean):void {
			_enabled = val;
			this.filter = _enabled ? null : _grayFilter;
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(val:Boolean):void {
			_selected = val;
			_canvas.visible = _selected;
		}
		
		override public function dispose():void {
			_grayFilter.dispose();
			_grayFilter = null;
			_canvas.dispose();
			_canvas = null;
			super.dispose();
		}
	}
}