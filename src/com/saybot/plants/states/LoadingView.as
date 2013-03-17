package com.saybot.plants.states
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.consts.GameState;
	import com.saybot.plants.game.GameRes;
	import com.saybot.plants.game.LevelData;
	import com.saybot.plants.vo.PtyLevel;
	import com.saybot.plants.vo.PtyRound;
	import com.saybot.plants.vo.ZombieInstance;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class LoadingView extends StateViewBase
	{
		private var _levelData:LevelData;
		private var _levelZombieInstances:Vector.<ZombieInstance>;
		
		private var _loadingText:TextField;
		
		private var _loadIndex:Number = 0;
		
		private var _gameRes:GameRes;
		
		private var _skeletonFactory:StarlingFactory;
		
		private var _delayFrames:int;
		
		public function LoadingView(initOption:Object=null)
		{
			_levelData = initOption as LevelData;
			super(null);
		}
		
		override public function doEnter():void {
			var bg:Image = new Image(AssetsMgr.getTexture("Splash"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			setTimeout(startLoading, 50);
		}
		
		override public function doExit():void {
			_levelData = null;
			_gameRes = null;
			_loadingText.dispose();
			_skeletonFactory.dispose();
			_skeletonFactory = null;
		}
		
		private function startLoading():void {
			_loadingText = new TextField(ScreenDef.GameWidth, 40, "Loading 0%", "Ubuntu", 14, 0x00ff00);
			_loadingText.hAlign = HAlign.CENTER;
			_loadingText.y = ScreenDef.GameHeight - 60;
			this.addChild(_loadingText);
			
			_gameRes = new GameRes();
			this.addEventListener(starling.events.Event.ENTER_FRAME, loadBg);
		}
		
		private function loadBg(evt:starling.events.Event):void {
//			_levelData.levelsConfig = AssetsMgr.getXML("LevelConfigXML");
			_gameRes.bg = new Image(AssetsMgr.getTexture(_levelData.crtLevel.bg as String))
			_gameRes.uiTextureAtlas = AssetsMgr.getTextureAtlas("UIPNG", "UIXml");
			AssetsMgr.loadSound(_levelData.crtLevel.music);
			updatePercent(0.2);
			this.removeEventListeners(starling.events.Event.ENTER_FRAME);
			this.addEventListener(starling.events.Event.ENTER_FRAME, loadPlantsSWF);
		}
		
		private function loadPlantsSWF(evt:starling.events.Event):void {
			_levelZombieInstances = new Vector.<ZombieInstance>;
			var rounds:Array = _levelData.crtLevel.round;
			trace(rounds.length);
			for(var i:int=0; i<rounds.length; i++) {
				var round:PtyRound = rounds[i] as PtyRound;
				for each(var zombie:ZombieInstance in round.enemy) {
					_levelZombieInstances.push(zombie);
				}
			}
			_skeletonFactory = new StarlingFactory();
			_skeletonFactory.parseData(AssetsMgr.getSWF("SkeletonPlants") as ByteArray);
			_gameRes.plantFactory = _skeletonFactory;
			_loadIndex = 0;
			this.removeEventListeners(starling.events.Event.ENTER_FRAME);
			_skeletonFactory.addEventListener( flash.events.Event.COMPLETE, loadZombieSWF);
		}
		
//		private function loadPlants(evt:*):void {
//			if(_loadIndex >= _levelData.plants.length) {
//				this.removeEventListeners(starling.events.Event.ENTER_FRAME);
//				this.addEventListener(starling.events.Event.ENTER_FRAME, loadZombieSWF);
//				return;
//			}
//			if(_loadIndex == 0) {
//				updatePercent(0.3);
//				this.addEventListener(starling.events.Event.ENTER_FRAME, loadPlants);
//			}
//			if(_delayFrames++ < GameConst.LOADING_DELAY_FRAMES)
//				return;
//			_delayFrames = 0;
//			
//			var name:String = _levelData.plants[_loadIndex] as String;
//			var armature:Armature = _skeletonFactory.buildArmature(name);
//			_gameRes.addPlant(name, armature);
//			_loadIndex ++;
//			updatePercent(0.3 + _loadIndex*0.3/_levelData.plants.length);
//		}
		
		private function loadZombieSWF(evt:*):void {
			_skeletonFactory = new StarlingFactory();
			_skeletonFactory.parseData(AssetsMgr.getSWF("SkeletonZombie") as ByteArray);
			_loadIndex = 0;
			this.removeEventListeners(starling.events.Event.ENTER_FRAME);
			_skeletonFactory.addEventListener(flash.events.Event.COMPLETE, loadZombies);
		}
		
		private function loadZombies(evt:*):void {
			if(_loadIndex >= _levelZombieInstances.length) {
				this.removeEventListeners(starling.events.Event.ENTER_FRAME);
				starlingMain.switchState(GameState.GAME, [_levelData, _gameRes]);
				return;
			}
			if(_loadIndex == 0) {
				updatePercent(0.7);
				this.addEventListener(starling.events.Event.ENTER_FRAME, loadZombies);
			}
			if(_delayFrames++ < GameConst.LOADING_DELAY_FRAMES)
				return;
			_delayFrames = 0;
			
			var armatureName:String = _levelData.getZombiePtyByName(_levelZombieInstances[_loadIndex].type).armature;
			var armature:Armature = _skeletonFactory.buildArmature(armatureName);
			_gameRes.addZombie(_levelZombieInstances[_loadIndex].name, armature);
			_loadIndex ++;
			updatePercent(0.7 + _loadIndex*0.3/_levelZombieInstances.length);
		}
		
		private function updatePercent(percent:Number):void {
			var percentStr:String = Number(percent * 100).toFixed(0);
			_loadingText.text = "Loading " + percentStr + "%";
		}
	}
}