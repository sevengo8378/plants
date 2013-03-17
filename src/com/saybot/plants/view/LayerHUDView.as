package com.saybot.plants.view
{
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.plants.view.components.Menu;
	import com.saybot.plants.view.components.PlantCard;
	import com.saybot.plants.view.components.Sunshine;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class LayerHUDView extends LayerViewBase
	{
		private var sunTxt:TextField;
		
		private var _plantCards:Vector.<PlantCard>;
		
		private var _sunshines:Vector.<Sunshine>;
		private var _sunshineContainer:Sprite;
		
		public function LayerHUDView(sceneView:PlayfieldView)
		{
			super(sceneView);
			_plantCards  = new Vector.<PlantCard>;
			_sunshines = new Vector.<Sunshine>;
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
			
			var igm:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture("indicator0000"));
			this.addChild(igm);
			igm.scaleY = 0.7;
			igm.x = ScreenDef.GameWidth - igm.width;
			igm.y = 0;
			igm.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
				var touch:Touch = evt.getTouch(igm);
				if(touch && touch.phase == TouchPhase.ENDED) {
					callIGM();
				}
			});
			
			var plantsCnt:int = playfield.ptyLevel.plants.length;
			var xStart:Number = 50;
			for(var i:int=0; i<plantsCnt; i++) {
				addPlantCard(playfield.ptyLevel.plants[i], xStart + i*42);
			}
			
			_sunshineContainer = new Sprite();
			this.addChild(_sunshineContainer);
			this.addEventListener(Sunshine.EVT_HARVEST, harvestSunshine);
			this.addEventListener(Sunshine.EVT_OUT_SCREEN, function(evt:Event):void {
				removeSunshine(evt.data as Sunshine);
			});
		}
		
		override public function setPaused(val:Boolean):void {
			super.setPaused(val);
			for each(var sunshine:Sunshine in _sunshines) {
				sunshine.setPaused(val);
			}
		}
		
		private function callIGM():void {
			playfield.pauseGame();
			var menu:Menu = new Menu(playfield.gameRes.uiTextureAtlas, true);
			menu.x = (ScreenDef.GameWidth - menu.width)/2;
			menu.y = (ScreenDef.GameHeight - menu.height)/2;
			this.addChild(menu);
			this.addEventListener(Menu.EVT_MENU_ITEM_CLICK, function(evt:Event):void {
				var mi:String = evt.data as String;
				if(mi == GameConst.MI_BACK) {
					playfield.resumeGame();
					menu.removeFromParent(true);
				} else if(mi == GameConst.MI_SETTING) {
					Starling.current.showStats = !Starling.current.showStats;
				}
			});
		}
		
		public function spawnSunshine():void {
			var textures:Vector.<Texture> = playfield.gameRes.uiTextureAtlas.getTextures("sun");
			var sun:Sunshine = new Sunshine(textures);
			sun.x = 40 + Math.random() * (ScreenDef.GameWidth - 100);
			sun.y = Math.random() * ScreenDef.GameHeight * 0.5 + ScreenDef.GameHeight*0.5;
			_sunshineContainer.addChild(sun);
			_sunshines.push(sun);
		}
		
		private function harvestSunshine(evt:Event):void {
			playfield.updateSunshine(25);
			var sun:Sunshine = evt.data as Sunshine;
			removeSunshine(sun);
		}
		
		private function removeSunshine(sun:Sunshine):void {
			_sunshineContainer.removeChild(sun, true);
			var index:int = _sunshines.indexOf(sun);
			if(index >= 0) {
				_sunshines.splice(index, 1);
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
		
		override public function dispose():void {
			sunTxt.dispose();
			sunTxt = null;
			
			var card:PlantCard = _plantCards.pop(); 
			while(card) {
				card.dispose();
				card = _plantCards.pop();
			}
			_plantCards = null;
			var sunshine:Sunshine = _sunshines.pop(); 
			while(sunshine) {
				sunshine.dispose();
				sunshine = _sunshines.pop();
			}
			_sunshines = null;
			_sunshineContainer.removeChildren(0, -1, true);
			this.removeEventListener(Sunshine.EVT_HARVEST, harvestSunshine);
			this.removeEventListeners(Sunshine.EVT_OUT_SCREEN);
			super.dispose();
		}
	}
}