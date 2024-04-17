package com.isartdigital.shmup.game.sprites.enemies
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotEnemy;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.maths.MathTools;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
	import com.isartdigital.shmup.game.sprites.Teleguided;
	import com.isartdigital.utils.game.ColliderType;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Boss extends StateObject
	{
		public static var list:Vector.<Boss> = new Vector.<Boss>();
		public var lifeBoss:int = 2500;
		private var pos1:Boolean = false;
		private var countFrame:int = 0;
		private var waitingTime:int = 100;
		private var countFrame1:int = 0;
		
		
		public function Boss(pAsset:String)
		{
			assetName = pAsset;
			SoundManager.getNewSoundFX("bossLoop0").loop();
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			var lWaitingTime:int = 100;
			colliderShot();
			colliderPlayer();
			patt0();
			if (x >= GameLayer.getInstance().screenLimits.right - width)
			{
				x = GameLayer.getInstance().screenLimits.right - 450;
				x += GameLayer.getInstance().speed;
			}
			//trace(renderer.mcBody.getChildByName("mcLife"));
			if (assetName == "Boss0")
			{
				
				
				if (countFrame++ >= lWaitingTime)
				{
					setShotBoss();
					setState("endFire");
					countFrame = 0;
					
				}
				
			}
			//if (countFrame1++ >= 200)
			//{
				//if (assetName == "Boss1")
				//{
					//setState("endFire");
					//setShotBoss1();
				//}
				//countFrame1 = 0;
			//}
			if (countFrame++ >= waitingTime)
			{
				if (assetName == "Boss2")
				{
					setShotBoss2();
					setState("endFire");
				}
				countFrame = 0;
			}
			
			if (assetName == "Boss1")
			{
				if (countFrame1++ >= 70)
				{
					
					setShotBoss1();
					countFrame1 = 0;
				}
				
			}
		
		}
		
		private function colliderShot():void
		{
			
			for (var i:int = 0; i < ShotPlayer.shots.length; i++)
			{
				if (CollisionManager.hasCollision(hitBox, ShotPlayer.shots[i].hitBox))
				{
					setState("hurt");
					lifeBoss--;
					//mcLife.scaleX--;
					//mcLife.scaleY--;
					
					if (lifeBoss < 2000 && assetName == "Boss0")
					{
						
						setState("explosion");
						
						//SoundManager.getNewSoundFX("bossExplosion").start();
						
					}
					if (lifeBoss < 1200 && assetName == "Boss1")
					{
						setState("explosion");
						
						//SoundManager.getNewSoundFX("bossExplosion").start();
						
					}
					if (lifeBoss < 0 && assetName == "Boss2")
					{
						
						setState("explosion");
						doAction = doActionExplo;
						
						SoundManager.getNewSoundFX("bossExplosion").start();
						ColliderType.MULTIPLE
					}
				}
			}
			if (isAnimEnd() && state == "hurt")
			{
				setState("default");
				
			}
			
			if (isAnimEnd() && state == "explosion" && assetName == "Boss0")
			{
				//onPatt0Finish = false;
				
				assetName = "Boss1";
				setState("default");
				
				SoundManager.stopSounds();
				SoundManager.getNewSoundFX("bossLoop1").loop();
				
			}
			if (isAnimEnd() && state == "explosion" && assetName == "Boss1")
			{
				
				assetName = "Boss2";
				setState("default");
				SoundManager.stopSounds();
				SoundManager.getNewSoundFX("bossLoop2").loop();
				
			}
			if (isAnimEnd() && state == "explosion" && assetName == "Boss2")
			{
				
				destroy();
				
				SoundManager.stopSounds();
				
			}
		
		}
		
		private function patt0():void
		{
			
			var bossSpeed:int = 7;
			y += bossSpeed * scaleY;
			
			if (y > GameLayer.getInstance().screenLimits.bottom - 250)
			{
				scaleY = -1;
				
			}
			else if (y < GameLayer.getInstance().screenLimits.top + 250)
			{
				scaleY = 1;
			}
		
		}
		
		private function patt1():void
		{
			setShotBoss1();
			
		}
		
		override public function doActionExplo():void
		{
			clearCollider();
			if (isAnimEnd() && state == "explosion")
			{
				
				Hud.getInstance().scores += 1000;
				destroy();
				
			}
		}
		
		private function colliderPlayer():void
		{
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox))
			{
				setState("hurt");
			}
		}
		
		private function setShotBoss():void
		{
			lShotBoss = new ShotEnemy("ShootBoss");
			var lShotBoss:ShotEnemy;
			parent.addChild(lShotBoss);
			lShotBoss.x = x;
			lShotBoss.y = y;
			lShotBoss.start();
			
			lShotBoss1 = new ShotEnemy("ShootBoss");
			var lShotBoss1:ShotEnemy;
			parent.addChild(lShotBoss1);
			lShotBoss1.x = x;
			lShotBoss1.y = lShotBoss.y + 100;
			//angle += 35;
			//lShotBoss.y -= Math.sin(angle * (Math.PI / 180)) * 10;
			lShotBoss1.start();
			
			lShotBoss2 = new ShotEnemy("ShootBoss");
			var lShotBoss2:ShotEnemy;
			parent.addChild(lShotBoss2);
			lShotBoss2.x = x;
			lShotBoss2.y = lShotBoss.y - 100;
			lShotBoss2.start();
			
			lShotBoss3 = new ShotEnemy("ShootBoss");
			var lShotBoss3:ShotEnemy;
			parent.addChild(lShotBoss3);
			lShotBoss3.x = x;
			lShotBoss3.y = y + 100;
			lShotBoss3.start();
			
			lShotBoss4 = new ShotEnemy("ShootBoss");
			var lShotBoss4:ShotEnemy;
			parent.addChild(lShotBoss4);
			lShotBoss4.x = x;
			lShotBoss4.y = y - 200;
			lShotBoss4.start();
			
			lShotBoss5 = new ShotEnemy("ShootBoss");
			var lShotBoss5:ShotEnemy;
			parent.addChild(lShotBoss5);
			lShotBoss5.x = x;
			lShotBoss5.y = y + 200;
			lShotBoss5.start();
			
			//doActionArc();
			SoundManager.getNewSoundFX("bossShoot").start();
		}
		
		private function setShotBoss1():void
		{
			
			var lShotTeleguided:Teleguided = new Teleguided("ShootEnemy2");
			parent.addChild(lShotTeleguided);
			lShotTeleguided.x = x + collider.mcWeapon0.x
			lShotTeleguided.y = y + collider.mcWeapon0.y
			Teleguided.list.push(lShotTeleguided);
			lShotTeleguided.start();
			
			var lShotBoss1:ShotEnemy;
			lShotBoss1 = new ShotEnemy("ShootBoss");
			parent.addChild(lShotBoss1);
			lShotBoss1.x = x + collider.mcWeapon1.x;
			lShotBoss1.y = y + collider.mcWeapon1.y;
			lShotBoss1.start();
			
			var lShotBoss2:ShotEnemy;
			lShotBoss2 = new ShotEnemy("ShootBoss");
			parent.addChild(lShotBoss2);
			lShotBoss2.x = x + collider.mcWeapon2.x;
			lShotBoss2.y = y + collider.mcWeapon2.y;
			lShotBoss2.start();
			//setState("fire");
			SoundManager.getNewSoundFX("bossShoot").start();
		}
		
		private function setShotBoss2():void
		{
			lShotBoss = new ShotEnemy("ShootBoss");
			var lShotBoss:ShotEnemy;
			parent.addChild(lShotBoss);
			lShotBoss.x = x;
			lShotBoss.y = y;
			
			lShotBoss.start();
			
			var lShotBoss1:ShotEnemy;
			lShotBoss1 = new ShotEnemy("ShootBoss");
			parent.addChild(lShotBoss1);
			lShotBoss1.x = x + collider.mcWeapon1.x;
			lShotBoss1.y = y + collider.mcWeapon1.y;
			lShotBoss1.start();
			
			var lShotBoss2:ShotEnemy;
			lShotBoss2 = new ShotEnemy("ShootBoss");
			parent.addChild(lShotBoss2);
			lShotBoss2.x = x + collider.mcWeapon2.x;
			lShotBoss2.y = y + collider.mcWeapon2.y;
			lShotBoss2.start();
			
			var lShotTeleguided:Teleguided = new Teleguided("ShootEnemy2");
			parent.addChild(lShotTeleguided);
			lShotTeleguided.x = x + collider.mcWeapon3.x
			lShotTeleguided.y = y + collider.mcWeapon3.y
			Teleguided.list.push(lShotTeleguided);
			lShotTeleguided.start();
			
			var lShotTeleguided2:Teleguided = new Teleguided("ShootEnemy2");
			parent.addChild(lShotTeleguided2);
			lShotTeleguided2.x = x + collider.mcWeapon4.x
			lShotTeleguided2.y = y + collider.mcWeapon4.y
			Teleguided.list.push(lShotTeleguided2);
			lShotTeleguided2.start();
			//	setState("fire");
			SoundManager.getNewSoundFX("bossShoot").start();
			
			if (countFrame++ >= waitingTime)
			{
				countFrame = 0
				lShotBoss.scaleX = 4;
				lShotBoss.scaleY = 4;
				lShotBoss1.scaleX = 4;
				lShotBoss1.scaleY = 4;
				lShotBoss2.scaleX = 4;
				lShotBoss2.scaleY = 4;
				lShotTeleguided.scaleX = 4;
				lShotTeleguided.scaleY = 4;
				lShotTeleguided2.scaleX = 4;
				lShotTeleguided2.scaleY = 4;
				
			}
		}
		
		
		override protected function get colliderType():int
		{
			return ColliderType.MULTIPLE;
		}
		
	}

}