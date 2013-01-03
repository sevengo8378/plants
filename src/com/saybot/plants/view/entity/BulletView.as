package com.saybot.plants.view.entity
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.plants.vo.BulletInstance;
	import com.saybot.plants.vo.Entity;
	import com.saybot.plants.vo.PlantInstance;
	import com.saybot.plants.vo.ZombieInstance;
	import com.saybot.utils.CollisionUtil;
	
	import starling.display.Image;
	
	public class BulletView extends EntityViewBase
	{
		public var owner:EntityViewBase;
		
		public function BulletView(vo:Entity)
		{
			var resName:String = (vo as BulletInstance).ptyData.display;
			var img:Image = new Image(playfield.gameRes.uiTextureAtlas.getTexture(resName));
			this.display = img;
			super(vo);
			this.speedX = bulletData.ptyData.speedX;
			this.speedY = bulletData.ptyData.speedY;
		}
		
		override public function advanceTime(time:Number):void {
			super.advanceTime(time);
			this.updateMove(time);
			this.checkCollision();
		}
		
		protected function updateMove(time:Number):void {
			if(speedX != 0)
				this.x += time * speedX;
			if(speedY != 0)
				this.y += time * speedX;
		}
		
		protected function checkCollision():void {
//			trace("bullet check collision: "+this.bulletData.name);
			var originTargets:Array = this.owner is PlantView ? playfield.activeZombies : playfield.activePlants;
			var targets:Array = [];
			var entiView:EntityViewBase;
			for each(entiView in originTargets) {
				if(Object(entiView.vo).lane == this.bulletData.lane)
					targets.push(entiView);
			}
			for each(entiView in targets) {
				if(CollisionUtil.checkCol(this.colBox, entiView.colBox)) {
					entiView.switchState(GameConst.ZOMBIE_DIE);
					playfield.removeBullet(this);
					AssetsMgr.getSound("Click").play();
					break;
				}
			}
		}
		
		public function get bulletData():BulletInstance {
			return this.vo as BulletInstance;
		}

	}
}