package com.saybot.plants.game
{
	import com.saybot.plants.vo.PtyBullet;
	import com.saybot.plants.vo.PtyLevel;
	import com.saybot.plants.vo.PtyPlant;
	import com.saybot.plants.vo.PtyZombie;
	import com.saybot.plants.vo.ValueObjectBase;
	import com.saybot.utils.XML2JSON;
	
	import flash.utils.Dictionary;

	public class LevelData
	{
		public var level:int;
		
		public var plants:Array; 
		
		private var _levelConfig:XML;
		
		private var _crtLevel:PtyLevel;
		
		private var _zombiesPtyData:Dictionary;
		private var _plantsPtyData:Dictionary;
		private var _bulletsPtyData:Dictionary;
		
		public function LevelData()
		{
		}
		
		public function get crtLevel():PtyLevel {
			return _crtLevel;
		}
		
		public function set levelsConfig(xml:XML):void {
			_levelConfig = xml;
			XML2JSON.arrays = ["level", "zombie", "round", "plant", "enemy"];
			var jsonData:Object = XML2JSON.parse(_levelConfig);
			_crtLevel = ValueObjectBase.translateObject2VO(XML2JSON.parse(_levelConfig.level.(@id == level))) as PtyLevel;
			var obj:*;
			var pty:ValueObjectBase;
			_zombiesPtyData = new Dictionary();
			for each(obj in jsonData.zombie) {
				pty = ValueObjectBase.translateObject2VO(obj) as ValueObjectBase;
				_zombiesPtyData[(pty as PtyZombie).name] = pty;
			}
			_plantsPtyData = new Dictionary();
			for each(obj in jsonData.plant) {
				pty = ValueObjectBase.translateObject2VO(obj) as ValueObjectBase;
				_plantsPtyData[(pty as PtyPlant).name] = pty;
			}
			_bulletsPtyData = new Dictionary();
			for each(obj in jsonData.bullet) {
				pty = ValueObjectBase.translateObject2VO(obj) as ValueObjectBase;
				_bulletsPtyData[(pty as PtyBullet).name] = pty;
			}
		}
		
		public function getZombiePtyByName(name:String):PtyZombie {
			return _zombiesPtyData[name] as PtyZombie;
		}
		
		public function getPlantPtyByName(name:String):PtyPlant {
			return _plantsPtyData[name] as PtyPlant;
		}
		
		public function getBulletPtyByName(name:String):PtyBullet {
			return _bulletsPtyData[name] as PtyBullet;
		}
	}
}
