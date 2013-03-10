package com.saybot.plants.view
{
	import com.saybot.GameConst;
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.plants.view.components.PlantCard;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class LayerHUDView extends LayerViewBase
	{
		private var sunTxt:TextField;
		
		private var _plantCards:Vector.<PlantCard>;
		public function LayerHUDView(sceneView:PlayfieldView)
		{
			super(sceneView);
			_plantCards  = new Vector.<PlantCard>;
			initialize(null);
		}
		
		private function initialize(evt:Event):void {
			var hud:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("hud0000"));
			hud.x = 0;
			hud.y = 0;
			this.addChild(hud);
				
			sunTxt = new TextField(60, 20, "");
			sunTxt.hAlign = HAlign.CENTER;
			sunTxt.x = 0;
			sunTxt.y = 45;
//			sunTxt.border = true;
			this.addChild(sunTxt);
			
			var sunImg:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("sun0000"));
			this.addChild(sunImg);
			sunImg.x = 8;
			sunImg.y = 9;
			
			var spadeImg:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("spade0000"));
			this.addChild(spadeImg);
			spadeImg.scaleX = spadeImg.scaleY = 0.7;
			spadeImg.x = 309;
			spadeImg.y = 17;
			
			var plantsCnt:int = playfield.levelData.plants.length;
			var xStart:Number = 50;
			for(var i:int=0; i<plantsCnt; i++) {
				addPlantCard(playfield.levelData.plants[i], xStart + i*42);
			}
		}
		
		public function updateSunshine(val:Number):void {
			for each(var card:PlantCard in _plantCards) {
				card.enabled = playfield.sunshine >= card.sunCost;
			}
			sunTxt.text = val.toString();
		}
		
		private function addPlantCard(name:String, x:Number):void {
			var plantCard:PlantCard = new PlantCard(name, playfield);
			plantCard.x = x;
			plantCard.y = 5;
			plantCard.addEventListener(TouchEvent.TOUCH, function plantCardClickHandler(evt:TouchEvent):void {
				if (evt.getTouch(plantCard, TouchPhase.ENDED) == null) 
					return;
				if(plantCard.enabled) {
					if(!plantCard.selected) {
						plantCard.selected = true;
						playfield.layerBg.startGridSelect();
						for each(var card:PlantCard in _plantCards) {
							if(card.plantName != name)
								card.selected = false;
						}
					} else {
						plantCard.selected = false;
						playfield.layerBg.stopGridSelect();
					}
				}
			});
			_plantCards.push(plantCard);
			plantCard.enabled = playfield.sunshine >= plantCard.sunCost;
			this.addChild(plantCard);
		}
		
		public function get crtSelectCard():PlantCard {
			for each(var card:PlantCard in _plantCards) {
				if(card.selected)
					return card;
			}
			return null;
		}
	}
}