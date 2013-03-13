package com.saybot.plants.view.entity
{
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.interfaces.IActor;
	import com.saybot.plants.vo.Entity;
	import com.saybot.plants.vo.ZombieInstance;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	
	import starling.display.DisplayObject;
	
	public class ZombieView extends SkeletonView implements IActor
	{
		private var _hp:int;
		
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
			super.advanceTime(time);
			this.updateAI(time);
			this.updateMove(time);
		}
		
		protected function updateAI(time:Number):void {
			var intelligence:Number = zombieData.ptyData.intelligence;
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
			}
		}
		
		override protected function armatureEventHandler(evt:AnimationEvent):void {
			if(evt.type == AnimationEvent.COMPLETE) {
				if(evt.movementID == "anim_death") {
					playfield.removeZombie(this);
				}
			}
//			trace(this.plantData.name + " armature event: " + evt.type + ", animation: " + evt.movementID);
		}
		
		protected function updateMove(time:Number):void {
			if(speedX != 0)
				this.x -= time * speedX;
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
	}
}