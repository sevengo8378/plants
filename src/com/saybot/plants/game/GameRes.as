package com.saybot.plants.game
{
	import flash.utils.Dictionary;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class GameRes
	{
		public var bg:Image;
		public var uiTextureAtlas:TextureAtlas;
		
		private var _plants:Dictionary;
		
		private var _zombies:Dictionary;
		
		private var _plantFactory:StarlingFactory;
		
		public function GameRes()
		{
			_zombies = new Dictionary();
			_plants = new Dictionary();
		}
		
		public function addPlant(name:String, armature:Armature):void {
			_plants[name] = armature;
		}
		
		public function getPlant(instanceName:String, armatureName:String):Armature {
			if(_plants[instanceName] == null) {
				var armature:Armature = _plantFactory.buildArmature(armatureName);
				addPlant(instanceName, armature);
			}
			return _plants[instanceName] as Armature;
		}
		
		public function addZombie(name:String, armature:Armature):void {
			_zombies[name] = armature;
		}
		
		public function getZombie(name:String):Armature {
			return _zombies[name] as Armature;
		}
		
		public function dispose():void {
			if(bg) {
				bg.dispose();
				bg = null;
			}
			if(uiTextureAtlas) {
				uiTextureAtlas.dispose();
			}
			if(_plants) {
				for(var d:String in _plants) {
					(_plants[d] as Armature).dispose();
					delete _plants[d];
				}
				_plants = null;
			}
			if(_zombies) {
				for(d in _zombies) {
					(_zombies[d] as Armature).dispose();
					delete _zombies[d];
				}
				_zombies = null;
			}
		}
		
		public function set plantFactory(fac:StarlingFactory):void {
			_plantFactory = fac;
		}
	
	}
}