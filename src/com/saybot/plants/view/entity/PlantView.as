package com.saybot.plants.view.entity
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.plants.game.PlantSkill;
	import com.saybot.plants.interfaces.IActor;
	import com.saybot.plants.vo.BulletInstance;
	import com.saybot.plants.vo.Entity;
	import com.saybot.plants.vo.PlantInstance;
	import com.saybot.plants.vo.PtyBullet;
	import com.saybot.plants.vo.PtyPlant;
	
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.events.AnimationEvent;
	
	import starling.display.DisplayObject;
	
	public class PlantView extends SkeletonView implements IActor
	{
		private var _hp:int;
		
		public function PlantView(vo:Entity, armature:Armature)
		{
			super(vo, armature);
			_hp = plantData.ptyData.hp;
			display.scaleX = display.scaleY = plantData.ptyData.scale;
			display.x = plantData.ptyData.ox*display.scaleX;
			display.y = plantData.ptyData.oy*display.scaleY;
		}
		
		override public function advanceTime(time:Number):void {
			super.advanceTime(time);
			this.updateAI(time);
		}
		
		protected function updateAI(time:Number):void {
			var ptyData:PtyPlant = plantData.ptyData;
			switch(state) {
				case GameConst.PLANT_IDLE:
					if(stateLastTime > ptyData.cooldown) {
						if(hasSkill(PlantSkill.SHOOT))
							switchState(GameConst.PLANT_SHOOTING);
						else if(hasSkill(PlantSkill.EXPLODE)) {
							switchState(GameConst.PLANT_EXPLODE);
						}
					}
					break;
			}
		}
		
		override protected function armatureEventHandler(evt:AnimationEvent):void {
			if(evt.type == AnimationEvent.COMPLETE) {
				if(evt.movementID == "anim_shooting") {
					switchState(GameConst.PLANT_IDLE);
					shootBullet();
				} else if(evt.movementID == "anim_explode") {
					playfield.removePlant(this);
				}
			}
//			trace(this.plantData.name + " armature event: " + evt.type + ", animation: " + evt.movementID);
		}
		
		override public function switchState(st:String):void {
			if(st == state)
				return;
			super.switchState(st);
			armature.animation.gotoAndPlay("anim_" + st);
			switch(state) {
				case GameConst.PLANT_SHOOTING:
					this.speedX = 0;
					break;
				
				case GameConst.PLANT_EXPLODE:
					this.playParticleEffect("explode", 15, 5, 500);
					AssetsMgr.getSound(GameConst.SFX_EXPLODE).play();
					break;
			}
		}
		
		private function shootBullet():void {
			if(!hasSkill(PlantSkill.SHOOT))
				return;
			var bulletName:String = plantData.ptyData.bullet;
			var ptyData:PtyBullet = playfield.levelData.getBulletPtyByName(bulletName);
			var bulletInstance:BulletInstance = new BulletInstance();
			bulletInstance.ptyData = ptyData;
			bulletInstance.name = ptyData.name + "_" + playfield.totalBullets
			bulletInstance.lane = plantData.lane;
			var bulletView:BulletView = new BulletView(bulletInstance);
			bulletView.owner = this;
			var keyBone:Bone = this.armature.getBone(plantData.ptyData.key_bone);
			bulletView.x = x + display.x + (keyBone.global.x + (keyBone.display as DisplayObject).width) * display.scaleX + 2;
			bulletView.y = y + display.y + (keyBone.global.y + (keyBone.display as DisplayObject).height/2) * display.scaleY - 3;
			playfield.layerEntity.addChild(bulletView);
			playfield.addBullet(bulletView);
		}
		
		public function get plantData():PlantInstance {
			return this.vo as PlantInstance;
		}
		
		public function hasSkill(skill:String):Boolean {
			return skill == plantData.ptyData.skill;
		}
		
		public function hurt(value:int):void {
			_hp -= value;
//			if(_hp <= 0)
//				this.switchState(GameConst.ZOMBIE_DIE);
		}
		
		public function get attack():int {
			return this.plantData.ptyData.attack;
		}
		
		public function get hp():int { return _hp; }
	}
}