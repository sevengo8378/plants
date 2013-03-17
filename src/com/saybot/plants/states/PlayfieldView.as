package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.game.GameCtrl;
	import com.saybot.plants.game.GameRes;
	import com.saybot.plants.game.LevelData;
	import com.saybot.plants.view.LayerBgView;
	import com.saybot.plants.view.LayerEntityView;
	import com.saybot.plants.view.LayerHUDView;
	import com.saybot.plants.view.entity.BulletView;
	import com.saybot.plants.view.entity.EntityViewBase;
	import com.saybot.plants.view.entity.PlantView;
	import com.saybot.plants.view.entity.ZombieView;
	import com.saybot.plants.vo.PlantInstance;
	import com.saybot.plants.vo.PtyLevel;
	import com.saybot.plants.vo.PtyPlant;
	import com.saybot.plants.vo.PtyRound;
	import com.saybot.plants.vo.ZombieInstance;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import dragonBones.Armature;
	
	import starling.animation.DelayedCall;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class PlayfieldView extends StateViewBase
	{
		private var _levelData:LevelData;
		private var _gameRes:GameRes;
		private var _ptyLevel:PtyLevel;

		private var _crtRoundIndex:int;
		private var _activeZombies:Array = [];
		private var _activePlants:Array = [];
		private var _activeBullets:Array = [];
		public var totalZombies:uint;
		public var totalPlants:uint;
		public var totalBullets:uint;
		private var _deadPlants:int;
		
		private var _gameCtrl:GameCtrl;
		private var _sunshineVal:int;
		
		private var _centerTxt:TextField;
		private var _centerTxtTid:int;
		
		private var _sunshineDelay:Number;
		private var _sunshineTask:DelayedCall;
		
		private var _escapeZombieCnt:int;
		
		public function PlayfieldView(initOption:Array)
		{
			super();
			_levelData = initOption[0] as LevelData;
			_ptyLevel = _levelData.crtLevel
			_gameRes = initOption[1] as GameRes;
			_gameCtrl = new GameCtrl();
			_sunshineVal = _ptyLevel.init_shushine;
		}
		
		override public function doEnter():void {
			initLayers();
			layerHUD.updateSunshine(_sunshineVal);
			resetSunshineDelay();
			startSunshine();
			AssetsMgr.getSound(_ptyLevel.music).play(0, 10);
			setTimeout(startRound, 3000);
			this.addEventListener(ZombieView.EVT_ZOMBIE_ESCAPE, function(evt:Event):void {
				_escapeZombieCnt++;
				this.removeZombie(evt.data as ZombieView);
				trace("zombie escape count: " + _escapeZombieCnt);
				if(_escapeZombieCnt >= 3)
					gameLose();
			});
		}
		
		override public function doExit():void {
			_gameCtrl.dispose();
			_activeZombies = _activePlants = _activeBullets = null;
		}
		
		private function startSunshine():void {
			if(_sunshineTask) {
				_gameCtrl.removeTask(_sunshineTask);
			}
			_sunshineTask = _gameCtrl.addTask(spawnSunshine, _sunshineDelay, null, int.MAX_VALUE);
			trace("spawn sunshine in "+_sunshineDelay.toString());
		}
		
		private function spawnSunshine():void {
			this.layerHUD.spawnSunshine();
			resetSunshineDelay();
		}
		
		public function updateSunshine(val:int):void {
			trace("sunshine");
			_sunshineVal += val;
			this.layerHUD.updateSunshine(_sunshineVal);
		}
		
		private function resetSunshineDelay():void {
			var sunPlantCnt:int = 0;
			for each(var plant:PlantView in _activePlants) {
				if(plant.plantData.ptyData.name == "marigold") {
					sunPlantCnt++;
				}
			}
			if(sunPlantCnt <= 15) {
				_sunshineDelay = _ptyLevel.sunshine_delay - _ptyLevel.sunshine_delay*0.057*sunPlantCnt; 
			} else {
				_sunshineDelay = _ptyLevel.sunshine_delay*0.15;
			}
			startSunshine();
		} 
		
		public function get sunshine():int {
			return _sunshineVal;
		}
		
		private function startRound():void {
			var crtRound:PtyRound = _ptyLevel.round[_crtRoundIndex];
			var roundDelay:Number = crtRound.delay;
			var roundTxt:String = "Round "+(_crtRoundIndex+1); 
			if(_crtRoundIndex == _ptyLevel.round.length -1)
				roundTxt = "Last Round";
			showCenterTxt(roundTxt, 2000, null, 0x00ff00, 70);
			for each(var zombie:ZombieInstance in crtRound.enemy) {
				_gameCtrl.addTask(spwanZombie, zombie.delay+roundDelay, [zombie]);
			}
		}
		
		private function checkNextRound():void {
			if(_crtRoundIndex >= _ptyLevel.round.length - 1) {
				gameWin();
			} else {
				_crtRoundIndex++;
				_gameCtrl.removeAllTasks();
				startSunshine();
				startRound();
			}
		}
		
		private function spwanZombie(zombieInstance:ZombieInstance):void {
			zombieInstance.ptyData = _levelData.getZombiePtyByName(zombieInstance.type); 
			var armature:Armature = _gameRes.getZombie(zombieInstance.name);
			var zombieView:ZombieView = new ZombieView(zombieInstance, armature);
			zombieView.x = ScreenDef.GameWidth + 10;
			zombieView.y = ScreenDef.MARGIN_TOP + (zombieInstance.lane+1)*ScreenDef.LANE_HEIGHT - zombieView.height;
			layerEntity.addChild(zombieView);
			_activeZombies.push(zombieView);
			totalZombies++;
			trace("zombie spawn: " + zombieInstance.name + ", lane " + zombieInstance.lane);
		}
		
		public function removeZombie(view:ZombieView):Boolean {
			var index:int = _activeZombies.indexOf(view);
			if(index < 0) {
				trace("Error: zombie not found!");
				return false;
			}
			_activeZombies.splice(index, 1);
			view.parent.removeChild(view);
			view.dispose();
			if(_activeZombies.length == 0) {
				checkNextRound();
			}
			return true;
		}
		
		public function addBullet(bulletView:BulletView):void {
			_activeBullets.push(bulletView);
			totalBullets++;
		}
		
		public function removeBullet(view:BulletView):Boolean {
			var index:int = _activeBullets.indexOf(view);
			if(index < 0) {
				trace("Error: bullet not found!");
				return false;
			}
			_activeBullets.splice(index, 1);
			view.parent.removeChild(view);
			view.dispose();
			return true;
		}
		
		public function addPlant(name:String, lane:int):PlantView {
			var ptyData:PtyPlant = _levelData.getPlantPtyByName(name);
			var plantInstance:PlantInstance = new PlantInstance();
			plantInstance.name = ptyData.name + "_"+ totalPlants;
			plantInstance.ptyData = ptyData;
			plantInstance.lane = lane;
			var armature:Armature = _gameRes.getPlant(plantInstance.name, ptyData.armature);
			var plantView:PlantView = new PlantView(plantInstance, armature);
			plantView.y = ScreenDef.MARGIN_TOP + (plantInstance.lane+1)*ScreenDef.LANE_HEIGHT - plantView.height;
			layerEntity.addChild(plantView);
			_activePlants.push(plantView);
			totalPlants++;
			updateSunshine(-ptyData.price);
			trace("new plant " + name + " at lane " +plantInstance.lane);
			return plantView;
		}
		
		public function removePlant(view:PlantView):Boolean {
			var index:int = _activePlants.indexOf(view);
			if(index < 0) {
				trace("Error: plant not found!");
				return false;
			}
			_activePlants.splice(index, 1);
			view.parent.removeChild(view);
			view.dispose();
			if(view.plantData.ptyData.name != "jalapeno") 
				_deadPlants++;
			return true;
		}
		
		private function initLayers():void {
			var layer:Sprite;
			var layersCls:Array = [LayerBgView, LayerEntityView, LayerHUDView, Sprite, Sprite]
			for(var layerId:int=0; layerId<GameConst.LAYER_CNT; layerId++) {
				var layerCls:Class = layersCls[layerId] as Class; 
				layer = layerCls == Sprite ? new layerCls() : new layerCls(this);
				this.addChild(layer);
			}
			_centerTxt = new TextField(ScreenDef.GameWidth, ScreenDef.GameHeight, "", "Desyrel", 60);
			_centerTxt.hAlign = HAlign.CENTER;
			_centerTxt.vAlign = VAlign.CENTER;
		}
		
		public function showCenterTxt(msg:String, duration:int, callback:Function=null, color:uint=0xff0000, size:int=50):void {
			_centerTxt.text = msg;
			_centerTxt.color = color;
			_centerTxt.fontSize = size;
			this.addChild(_centerTxt);
			var finishFunc:Function = function ():void {
				clearTimeout(_centerTxtTid);
				_centerTxt.removeFromParent();
				if(callback)
					callback.call();
			};
			_centerTxtTid = setTimeout(finishFunc, duration);
		}
		
		public function pauseGame():void {
			var entities:Array = _activePlants.concat(_activeZombies).concat(_activeBullets);
			for each(var enti:EntityViewBase in entities) {
				enti.isPaused = true;
			}
			layerHUD.setPaused(true);
		}
		
		public function resumeGame():void {
			var entities:Array = _activePlants.concat(_activeZombies).concat(_activeBullets);
			for each(var enti:EntityViewBase in entities) {
				enti.isPaused = false;
			}
			layerHUD.setPaused(false);
		}
		
		private function gameLose():void {
			pauseGame();
			showCenterTxt("Game Lose!", 4000, null, 0xff0000, 80);
			
		}
		
		private function gameWin():void {
			pauseGame();
			showCenterTxt("Game Win!", 4000, null, 0xff0000, 80);
		}
		
		override public function toggleDebugInfo(val:Boolean):void {
			(getLayer(GameConst.LAYER_BG) as LayerBgView).toggleDebugInfo(val);
			layerEntity.toggleDebugInfo(val);
		}
		
		public function getLayer(layerId:int):Sprite {
			return this.getChildAt(layerId) as Sprite;
		}
		
		public function get layerHUD():LayerHUDView {
			return getLayer(GameConst.LAYER_HUD) as LayerHUDView;
		}
		
		public function get layerBg():LayerBgView {
			return getLayer(GameConst.LAYER_BG) as LayerBgView;
		}
		
		public function get layerEntity():LayerEntityView {
			return getLayer(GameConst.LAYER_ENTITY) as LayerEntityView;
		}
		
		public function get levelData():LevelData {
			return this._levelData;
		}
		
		public function get gameRes():GameRes {
			return this._gameRes;
		}
		
		public function get activeBullets():Array {
			return _activeBullets;
		}
		public function get activePlants():Array {
			return _activePlants;
		}
		public function get activeZombies():Array {
			return _activeZombies;
		}
		
		public function get ptyLevel():PtyLevel {
			return this._ptyLevel;
		}
	}
}