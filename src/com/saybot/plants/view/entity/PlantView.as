package com.saybot.plants.view.entity
{
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.game.PlantSkill;
	import com.saybot.plants.vo.BulletInstance;
	import com.saybot.plants.vo.Entity;
	import com.saybot.plants.vo.PlantInstance;
	import com.saybot.plants.vo.PtyBullet;
	import com.saybot.plants.vo.PtyPlant;
	import com.saybot.plants.vo.ZombieInstance;
	
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.events.AnimationEvent;
	import dragonBones.objects.Node;
	
	import starling.display.DisplayObject;
	
	public class PlantView extends SkeletonView
	{
		public function PlantView(vo:Entity, armature:Armature)
		{
			super(vo, armature);
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
					if(hasSkill(PlantSkill.SHOOT) && stateLastTime > ptyData.cooldown) {
						switchState(GameConst.PLANT_SHOOTING);
					}
					break;
			}
		}
		
		override protected function armatureEventHandler(evt:AnimationEvent):void {
			if(evt.type == AnimationEvent.COMPLETE) {
				if(evt.movementID == "anim_shooting") {
					switchState(GameConst.PLANT_IDLE);
					shootBullet();
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
		
	}
}