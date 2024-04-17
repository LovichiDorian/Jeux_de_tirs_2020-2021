package com.isartdigital.shmup.game.sprites
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.layers.ScrollingLayer;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class ShotEnemy extends StateObject
	{
		//protected var shotLevel:int = 0;
		private var counter:int = 0;
		private var counterFrame:int = 0;
		public static var shotsEnemy:Vector.<ShotEnemy> = new Vector.<ShotEnemy>();
		private var isDead:Boolean = false;
		
		public function ShotEnemy(pAsset:String)
		{
			assetName = pAsset;
			shotsEnemy.push(this);
			//SoundManager.getNewSoundFX("enemyShoot").start();
			TweenPlugin.activate([VisiblePlugin, TintPlugin, RemoveTintPlugin]);
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			x -= 10;
			colliderShotEnemyToPlayer();
			
			if (x <= GameLayer.getInstance().screenLimits.left + 10)
			{
				
				destroy();
				clearCollider();
				
			}
			if (isDead)
			{
				if (counterFrame++ >= 120)
				{
					
					Player.getInstance().trail.color = 0x18EC24;
					isDead = !isDead;
					counterFrame = 0;
				}
			}
		
		}
		
		private function colliderShotEnemyToPlayer():void
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
					//Player.getInstance().destroy();
					
					isDead = true;
					
					
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
					isDead = true;
					Player.getInstance().trail.color = 0xFD0303;
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
					isDead = true;
					Player.getInstance().trail.color = 0xFD0303;
					
				}
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints) && Player.getInstance().life == 1)
				{
					Player.getInstance().isTouched = true;
					setState("explosion");
					clearCollider();
					Hud.getInstance().mcTopRight.mcGuide0.visible = false;
					Player.getInstance().life--;
					SoundManager.getNewSoundFX("loseLife").start();
					GameLayer.getInstance().removeChild(Player.getInstance());
					
					isDead = true;
					Player.getInstance().trail.color = 0xFD0303;
					
				}
				
			}
			if (isAnimEnd() && state == "explosion")
			{
				destroy();
			}
		
		}
	
	}
}

