package com.isartdigital.shmup.game.sprites
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.maths.MathTools;
	import com.isartdigital.utils.maths.geometry.VectorTools;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Teleguided extends StateObject
	{
		public static var list:Vector.<Teleguided> = new Vector.<Teleguided>();
		private var isDead:Boolean = false;
		private var counterFrame:int = 0;
		
		public function Teleguided(pAsset:String)
		{
			assetName = pAsset;
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			inertie();
			colliderEnemyTeleguided();
			collisionShotPlayer();
			if (x <= GameLayer.getInstance().screenLimits.left + 10)
				{
					
					destroy();
					clearCollider();
					
				}
				//if (isDead)
			//{
				//if (counterFrame++ >= 10)
				//{
					//isDead = !isDead;
					//GameLayer.getInstance().addChild(Player.getInstance());
					//Player.getInstance().trail.visible = true;
					//
					//counterFrame = 0;
				//}
			//}
		
		}
		
		private function inertie():void
		{
			var lForward:Point = Point.polar(150, rotation * MathTools.DEG2RAD);
			
			var lEnemPos:Point = new Point(x, y);
			var lPlayerPos:Point = new Point(Player.getInstance().x, Player.getInstance().y);
			
			var lEnemToPlayer:Point = lPlayerPos.subtract(lEnemPos);
			
			//var lDot:Number = VectorTools.dotProduct(lForward, lEnemToPlayer);
			
			const SPEED:Number = 4;
			
			var lNextPos:Point = VectorTools.moveToward(lEnemPos, lPlayerPos, SPEED);
			
			x = lNextPos.x;
			y = lNextPos.y;
			
			if (x<Player.getInstance().x) 
			{
				destroy();
				clearCollider();
			}
		}
		
		private function colliderEnemyTeleguided():void
		{
				if (Player.getInstance().onTransparence == false && Player.getInstance().onGodMod == false)
			{
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints) && Player.getInstance().life == 4)
				{
					Player.getInstance().isTouched = true;
					setState("explosion");
					clearCollider();
					Hud.getInstance().mcTopRight.mcGuide3.visible = false;
					Player.getInstance().life--;
					SoundManager.getNewSoundFX("loseLife").start();
					//GameLayer.getInstance().removeChild(Player.getInstance());
					//isDead = true;
					//Player.getInstance().trail.visible = false;
					
				}
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints) && Player.getInstance().life == 3)
				{
					Player.getInstance().isTouched = true;
					setState("explosion");
					clearCollider();
					Hud.getInstance().mcTopRight.mcGuide2.visible = false;
					Player.getInstance().life--;
					SoundManager.getNewSoundFX("loseLife").start();
					//GameLayer.getInstance().removeChild(Player.getInstance());
					//isDead = true;
					//Player.getInstance().trail.visible = false;
				}
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints) && Player.getInstance().life == 2)
				{
					Player.getInstance().isTouched = true;
					setState("explosion");
					clearCollider();
					Hud.getInstance().mcTopRight.mcGuide1.visible = false;
					Player.getInstance().life--;
					SoundManager.getNewSoundFX("loseLife").start();
					//GameLayer.getInstance().removeChild(Player.getInstance());
					//isDead = true;
					//Player.getInstance().trail.visible = false;
					
				}
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints) && Player.getInstance().life == 1)
				{
					Player.getInstance().isTouched = true;
					setState("explosion");
					clearCollider();
					Hud.getInstance().mcTopRight.mcGuide0.visible = false;
					Player.getInstance().life--;
					SoundManager.getNewSoundFX("loseLife").start();
					//GameLayer.getInstance().removeChild(Player.getInstance());
					//isDead = true;
					//Player.getInstance().trail.visible = false;
				}
				
				
			}
			
			if (isAnimEnd() && state == "explosion")
			{
				destroy();
			}
		
		}
		override public function doActionExplo():void 
		{
			clearCollider();
			if (isAnimEnd() && state == "explosion")
			{
				//Player.getInstance().score++;
				Hud.getInstance().scores++;
				destroy();
				
			}
		}
		private function collisionShotPlayer():void 
		{
			for (var i:int = 0; i < ShotPlayer.shots.length; i++) 
			{
				if (CollisionManager.hasCollision(ShotPlayer.shots[i].hitBox, hitBox))
				{
					setState("explosion");
				}
			}
			
		}
	}

}