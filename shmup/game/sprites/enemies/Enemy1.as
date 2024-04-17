package com.isartdigital.shmup.game.sprites.enemies
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotEnemy;
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
	import com.isartdigital.shmup.game.sprites.Teleguided;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.maths.MathTools;
	import com.isartdigital.utils.maths.geometry.VectorTools;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Enemy1 extends EnemyNormal
	{
		protected var shotLevel:int = 0;
		protected var countFrame:int = 0;
		protected var waitingTime:int = 10;
		
		public static var list:Vector.<Enemy1> = new Vector.<Enemy1>();
		
		public function Enemy1(pAsset:String)
		{
			assetName = pAsset;
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			
			if (Player.getInstance().onTransparence == false && Player.getInstance().onGodMod ==false)
			{
				enemy1ColliderPlayer();
			}
			if (countFrame++>waitingTime) 
			{
			setTeleguided();
			
					
					countFrame = 0;
			}
				for (var k:int = 0; k < list.length; k++)
			{
				
				if (x < GameLayer.getInstance().screenLimits.left )
				{
					list[k].destroy();
					
				}
			}
			if (x >= GameLayer.getInstance().screenLimits.right - width)
			{
				x = GameLayer.getInstance().screenLimits.right - 200;
				x += GameLayer.getInstance().speed;
			}
			
			enemy1Hurt();
		}
		
		private function enemy1Hurt():void
		{
			
			if (EnemyIsTouched == true)
			{
				
				setState("hurt");
				EnemyIsTouched = !EnemyIsTouched;
				Hud.getInstance().scores += 200;
				
				
				if (undergoesDamage >= 30)
				{
					setState("explosion");
					SoundManager.getNewSoundFX("enemyExplosion").start();
					doAction = doActionExplo;
					
				}
				if (isAnimEnd() && state == "hurt")
				{
					
					setState("default");
					
				}
			}
		
		}
		
		override public function doActionExplo():void
		{
			clearCollider();
			var score200:MovieClip;
			var score200Class:Class = Class(getDefinitionByName("Score200"));
			
			if (isAnimEnd() && state == "explosion")
			{
				Hud.getInstance().scores += 200;
				Collectable.Createcollectible(x,y);
				destroy();
				score200 = new score200Class();
				Hud.getInstance().addChild(score200);
				
				var lPoint:Point = new Point(x, y);
				var lPoint2:Point = GameLayer.getInstance().localToGlobal(lPoint);
				var lPoint3:Point = Hud.getInstance().globalToLocal(lPoint2);
				
				GameLayer.getInstance().localToGlobal(lPoint);
				Hud.getInstance().globalToLocal(lPoint);
				Hud.getInstance().mcTopCenter.globalToLocal(lPoint2);
			
				score200.x = lPoint3.x;
				score200.y = lPoint3.y;	
				
				TweenLite.to(score200, 2, {x:Hud.getInstance().mcTopCenter.x, y:Hud.getInstance().mcTopCenter.y + Hud.getInstance().mcTopCenter.height / 2,visible:false}); 
				TweenLite.to(score200, 0.1, {tint: Math.random()*0xFFFFFF}); 
				
			}
		}
		
		
		
		private function enemy1ColliderPlayer():void
		{
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints))
			{
				Player.getInstance().isTouched = true;
				setState("explosion");
				clearCollider();
				Player.getInstance().life--;
				SoundManager.getNewSoundFX("explosion").start();
				
			}
			if (isAnimEnd() && state == "explosion")
			{
				destroy();
			}
		}
		
		
		private function setTeleguided():void
		{
			
			var lTeleguidedShot:Teleguided;
			shotLevel = 2;
			lTeleguidedShot = new Teleguided("ShootEnemy" + shotLevel);
			parent.addChild(lTeleguidedShot);
			lTeleguidedShot.x = x;
			lTeleguidedShot.y = y;
			Teleguided.list.push(lTeleguidedShot);
			lTeleguidedShot.start();
			
			var lTeleguidedShot2:Teleguided;
			shotLevel = 2;
			lTeleguidedShot2 = new Teleguided("ShootEnemy" + shotLevel);
			parent.addChild(lTeleguidedShot2);
			lTeleguidedShot2.x = x + collider.mcWeapon2.x;
			lTeleguidedShot2.y = y + collider.mcWeapon2.y;
			Teleguided.list.push(lTeleguidedShot2);
			lTeleguidedShot2.start();
			
			var lTeleguidedShot1:Teleguided;
			shotLevel = 2;
			lTeleguidedShot1 = new Teleguided("ShootEnemy" + shotLevel);
			parent.addChild(lTeleguidedShot1);
			lTeleguidedShot1.x = x + collider.mcWeapon1.x;
			lTeleguidedShot1.y = y + collider.mcWeapon1.y;
			Teleguided.list.push(lTeleguidedShot1);
			lTeleguidedShot1.start();
		
		}
		
		
	}

}