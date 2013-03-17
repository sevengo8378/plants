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
	import com.saybot.utils.CollisionUtil;
	
	import flash.geom.Rectangle;
	
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.events.AnimationEvent;
	
	import starling.display.DisplayObject;
	
	public class PlantView extends SkeletonView implements IActor
	{
		private var _hp:int;
		
		public var gridX:int;
		public var gridY:int;
		
		private var _attackCnt:int;
		
		private var _attackTarget:ZombieView;
		
		public function PlantView(vo:Entity, armature:Armature)
		{
			super(vo, armature);
			_hp = plantData.ptyData.hp;
			display.scaleX = display.scaleY = plantData.ptyData.scale;
			display.x = plantData.ptyData.ox*display.scaleX;
			display.y = plantData.ptyData.oy*display.scaleY;
		}
		
		override public function advanceTime(time:Number):void {
			if(_isPaused)
				return;
			super.advanceTime(time);
			this.updateAI(time);
		}
		
		protected function updateAI(time:Number):void {
			if(isDead())
				return;
			var ptyData:PtyPlant = plantData.ptyData;
			switch(state) {
				case GameConst.PLANT_IDLE:
					if(hasSkill(PlantSkill.SHOOT) || hasSkill(PlantSkill.EXPLODE)) {
						if(stateLastTime > ptyData.cooldown) {
							if(hasSkill(PlantSkill.SHOOT))
								switchState(GameConst.PLANT_SHOOTING);
							else if(hasSkill(PlantSkill.EXPLODE)) {
								switchState(GameConst.PLANT_EXPLODE);
							}
						}
					} else if(hasSkill(PlantSkill.BITE)) {
						if(_attackCnt == 0 || stateLastTime > ptyData.cooldown) {
							var zombie:ZombieView = this.getColEntity(playfield.activeZombies) as ZombieView;
							if(zombie && this.dist2Entity(zombie) <= 25) {
								_attackTarget = zombie;
								this.switchState(GameConst.PLANT_BITE);
							}
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
				} else if(evt.movementID == "anim_bite") {
					_attackTarget.hurt(this.attack);
					AssetsMgr.getSound(GameConst.SFX_PLANT_BITE).play();
					if(_attackTarget.hp<=0) {
						playAction("anim_chew");
					} else {
						switchState(GameConst.PLANT_IDLE);
					}
				} else if(evt.movementID == "anim_chew") {
					playAction("anim_swallow");
				} else if(evt.movementID == "anim_swallow") {
					switchState(GameConst.PLANT_IDLE);
					_attackTarget = null;
				}
			}
//			trace(this.plantData.name + " armature event: " + evt.type + ", animation: " + evt.movementID);
		}
		
		public function playAction(action:String, loop:*=null):void {
			armature.animation.gotoAndPlay(action, -1, -1, loop);
		}
		
		override public function switchState(st:String):void {
			if(st == state)
				return;
			super.switchState(st);
			playAction("anim_" + st);
			switch(state) {
				case GameConst.PLANT_SHOOTING:
					this.speedX = 0;
					_attackCnt++;
					break;
				
				case GameConst.PLANT_EXPLODE:
					this.playParticleEffect("explode", 15, 5, 400, explode);
					AssetsMgr.getSound(GameConst.SFX_EXPLODE).play();
					_attackCnt++;
					break;
				
				case GameConst.PLANT_BITE:
					_attackCnt++;
					break;
			}
		}
		
		private function explode():void {
			var b:Rectangle = new Rectangle(this.colBox.x, this.colBox.y, this.colBox.width, this.colBox.height);
			b.x = b.x - b.width;
			b.y = b.y - b.height;
			b.width = b.width * 3;
			b.height = b.height * 3;
			var targets:Array = playfield.activeZombies;
			var entiView:EntityViewBase;
			for each(entiView in targets) {
				if(CollisionUtil.checkCol(b, entiView.colBox)) {
					(entiView as IActor).hurt(this.attack);
				}
			}
			setDead();
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
			if(_hp <= 0)
				setDead();
		}
		
		public function get attack():int {
			return this.plantData.ptyData.attack;
		}
		
		public function get hp():int { return _hp; }
		
		public function setDead():void {
			playfield.removePlant(this);
			this.playfield.layerBg.gridRemoveEntity(this.gridX, this.gridY);
		}
		public function isDead():Boolean {
			return hp <= 0;
		}
	}
}