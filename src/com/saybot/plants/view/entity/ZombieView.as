package com.saybot.plants.view.entity
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.plants.interfaces.IActor;
	import com.saybot.plants.vo.Entity;
	import com.saybot.plants.vo.ZombieInstance;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	
	public class ZombieView extends SkeletonView implements IActor
	{
		public static const EVT_ZOMBIE_ESCAPE:String = "evt_zombie_success";
		
		private var _hp:int;
		
		private var _attackTarget:PlantView;
		
		private var _escaped:Boolean;
		
		public function ZombieView(vo:Entity, armature:Armature)
		{
			super(vo, armature);
			this._hp = zombieData.ptyData.hp;
			display.scaleX = display.scaleY = zombieData.ptyData.scale;
			display.x = zombieData.ptyData.ox*display.scaleX;
			display.y = zombieData.ptyData.oy*display.scaleY;
		}
		
		public function get zombieData():ZombieInstance {
			return this.vo as ZombieInstance;
		}
		
		override public function advanceTime(time:Number):void {
			if(_isPaused)
				return;
			this.updateAI(time);
			this.updateMove(time);
			super.advanceTime(time);
		}
		
		protected function updateAI(time:Number):void {
			if(isDead())
				return;
			var intelligence:Number = zombieData.ptyData.intelligence;
			var plant:PlantView = this.getColEntity(playfield.activePlants) as PlantView;
			if(plant && this.dist2Entity(plant) < 24 && plant.plantData.ptyData.eatable == "true" && plant.x < this.x) {
				_attackTarget = plant;
				switchState(GameConst.ZOMBIE_EAT);
				return;
			}
			switch(state) {
				case GameConst.ZOMBIE_IDLE:
					if(Math.random() * 100 > 100-intelligence && stateLastTime*Math.random()*2 > (100-intelligence)*0.25)
						switchState(GameConst.ZOMBIE_WALK);
					break;
				
				case GameConst.ZOMBIE_WALK:
					if(Math.random() * 100 > intelligence && stateLastTime*Math.random() > intelligence*0.3)
						switchState(GameConst.ZOMBIE_IDLE);
					break;
			}
		}
		
		override public function switchState(st:String):void {
			if(st == state)
				return;
			super.switchState(st);
			armature.animation.gotoAndPlay("anim_" + st);
			switch(state) {
				case GameConst.ZOMBIE_IDLE:
					this.speedX = 0;
					break;
				case GameConst.ZOMBIE_WALK:
					this.speedX = zombieData.ptyData.speed;
					break;
				
				case GameConst.ZOMBIE_EAT:
					this.speedX = 0;
					break;
			}
		}
		
		override protected function armatureEventHandler(evt:AnimationEvent):void {
			if(evt.type == AnimationEvent.COMPLETE || evt.type == AnimationEvent.LOOP_COMPLETE) {
				if(evt.movementID == "anim_death") {
					setDead();
				} else if(evt.movementID == "anim_eat") {
					_attackTarget.hurt(this.attack);
					AssetsMgr.getSound(GameConst.SFX_ZOMBIE_EAT).play();
					if(_attackTarget.hp <= 0) {
						switchState(GameConst.ZOMBIE_IDLE);
					}
				}
			}
//			trace(this.plantData.name + " armature event: " + evt.type + ", animation: " + evt.movementID);
		}
		
		protected function updateMove(time:Number):void {
			if(speedX != 0)
				this.x -= time * speedX;
			
			if(this.colBox.right < 0 && !_escaped) {
				_escaped = true;
				this.dispatchEventWith(EVT_ZOMBIE_ESCAPE, true, this);
			}
		}
		
		public function hurt(value:int):void {
			_hp -= value;
			if(_hp <= 0)
				this.switchState(GameConst.ZOMBIE_DIE);
		}
		
		public function get attack():int {
			return this.zombieData.ptyData.attack;
		}
		
		public function get hp():int { return _hp; }
		
		public function setDead():void {
			playfield.removeZombie(this);
		}
		public function isDead():Boolean {
			return hp <= 0;
		}
	}
}