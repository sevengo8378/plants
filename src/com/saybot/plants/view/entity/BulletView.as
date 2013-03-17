package com.saybot.plants.view.entity
{
	import com.saybot.AssetsMgr;
	import com.saybot.GameConst;
	import com.saybot.ScreenDef;
	import com.saybot.plants.interfaces.IActor;
	import com.saybot.plants.vo.BulletInstance;
	import com.saybot.plants.vo.Entity;
	import com.saybot.utils.CollisionUtil;
	
	import starling.display.Image;
	
	public class BulletView extends EntityViewBase
	{
		public var owner:IActor;
		
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
			if(_isPaused)
				return;
			super.advanceTime(time);
			this.updateMove(time);
			this.checkCollision();
			this.checkScreenBound();
		}
		
		protected function updateMove(time:Number):void {
			if(speedX != 0)
				this.x += time * speedX;
			if(speedY != 0)
				this.y += time * speedX;
		}
		
		protected function checkCollision():void {
			var colEntiView:EntityViewBase = this.getColEntity(this.owner is PlantView ? playfield.activeZombies : playfield.activePlants);
			if(colEntiView) {
				(colEntiView as IActor).hurt(this.owner.attack);
				playfield.removeBullet(this);
				AssetsMgr.getSound(GameConst.SFX_SHOOT_HURT).play();
			}
		}
		
		protected function checkScreenBound():void {
			if(!this.colBox)
				return;
			if(colBox.left+colBox.width<0 || colBox.right > ScreenDef.GameWidth) {
//				trace("bullet out of scrren");
				playfield.removeBullet(this);
			}
		}
		
		public function get bulletData():BulletInstance {
			return this.vo as BulletInstance;
		}

	}
}