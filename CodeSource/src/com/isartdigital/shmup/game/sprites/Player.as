package com.isartdigital.shmup.game.sprites
{
	import com.greensock.TweenLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.layers.ScrollingLayer;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
	import com.isartdigital.shmup.game.sprites.collectibles.CollectableFirePower;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy2;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.effects.Trail;
	import com.isartdigital.utils.game.ColliderType;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe du joueur (Singleton)
	 * En tant que classe héritant de StateObject, Player contient un certain nombre d'états définis par les constantes LEFT_STATE, RIGHT_STATE, etc.
	 * @author Mathieu ANTHOINE
	 */
	public class Player extends StateObject
	{
		protected var speedGround:Number = 0;
		/**
		 * instance unique de la classe Player
		 */
		protected static var instance:Player;
		
		/**
		 * controleur de jeu
		 */
		public var controller:Controller;
		public var onTransparence:Boolean = false;
		public var weaponLevel:int = 0;
		private var mcWeapon:MovieClip;
		private var weaponClass:Class;
		public var isTouched:Boolean = false;
		private var weapon:MovieClip;
		private var countFrame:int = 0;
		private var waitingTime:int = 10;
		public var nbBomb:int = 4;
		public var shotLevel:int = 0;
		public var onGodMod:Boolean = false;
		public var specialCharge:int = 0;
		private var onSpecialCharge:Boolean = false;
		public var life:int = 4;
		public var countFramePlayer:int = 0;
		public var trail:Trail = new Trail();
		private var wasGodMod:Boolean = false;
		private var barIntro0:MovieClip;
		private var barIntro1:MovieClip;
		private var barIntro0class:Class; 
		private var barIntro1class:Class; 
		private var countFrameBar:int = 0;
		
		private var targetScore:int = 200;
		/**
		 * vitesse du joueur
		 */
		protected var speed:Number = 25;
		
		public function Player()
		{
			super();
			controller = GameManager.controller;
			
			TweenPlugin.activate([VisiblePlugin, TintPlugin,RemoveTintPlugin]);
			
			weaponSet();
			//Monitor.getInstance().addSlideBar("WeaponLevel", 0, 2, 0, 1, weaponUpgrade);
			//Monitor.getInstance().addSlideBar("ShotLevel", 0, 2, 0, 1, shotUpgrade);
		
		}
		
		override public function start():void
		{
			super.start();
			barIntro0class = Class(getDefinitionByName("BarIntro0"));
			barIntro1class = Class(getDefinitionByName("BarIntro1"));
		     barIntro0 = new barIntro0class();
			barIntro1 = new barIntro1class();
			parent.addChild(barIntro0);
			parent.addChild(barIntro1);
			barIntro1.y = stage.stageHeight+350;
			
			trail.init(this, 40, 0.6, 15);
			trail.closed = false;
			trail.color = 0x18EC24;
			trail.persistence = 30;
			trail.alpha = 1;
		}
		
		private function scrollingSpeed(pEven:Event):void
		{
			speed = pEven.target.value;
		}
		
		private function shotUpgrade(pEvent:Event):void
		{
			shotLevel = pEvent.target.value;
		}
		
		private function weaponUpgrade(pEvent:Event):void
		{
			weaponLevel = pEvent.target.value;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance():Player
		{
			if (instance == null) instance = new Player();
			return instance;
		}
		
		override protected function doActionNormal():void
		{
			if (countFrameBar++ ==300) 
			{
				//barIntro0.visible = false;
				//barIntro1.visible = false;
				TweenLite.to(barIntro0, 2, {y: -300});
				TweenLite.to(barIntro1, 2, {y: 2000});
				countFrameBar = 0;
			}
			//if (barIntro0.y< GameLayer.getInstance().screenLimits.top-270) 
			//{
				//parent.removeChild(barIntro0);
				//
			//}
			//if (barIntro1.y> GameLayer.getInstance().screenLimits.bottom+270) 
			//{
				////GameLayer.getInstance().removeChild(barIntro1);
			//}
			var countFrameBomb:int = 0;
			x += GameLayer.getInstance().speed;
			var lWaitingTime:int = 2;
			var lHorizontal:Number = controller.right - controller.left;
			var lVertival:Number = controller.down - controller.up;
			var lHypotenus:Number = Math.sqrt(lHorizontal * lHorizontal + lVertival * lVertival);
			if (lHypotenus > 1)
			{
				lHorizontal /= lHypotenus;
				lVertival /= lHypotenus;
			}
			x += lHorizontal * speed;
			y += lVertival * speed;
			playerState();
			weaponSet();
			if (countFrame++ >=lWaitingTime) 
			{
				setShot();
				countFrame = 0;
			}
			//if (ShotEnemy.isDead == true) 
			//{
				//trail.color =  0xFD0303;
			//}
			
			godMod();
			if (onTransparence)
			{
				countFramePlayer++;
			}
			if (countFramePlayer>=300) 
			{
				onTransparence = false;
				Hud.getInstance().mcTopLeft.mcSpecialBar.mcBar.x = -300;
				SoundManager.getNewSoundFX("special").start();
				trail.alpha = 1;
				
				TweenLite.to(this, 2, {alpha: 1, alpha: 1});
				countFramePlayer = 0;
			}
			animPlayer();
			
			if (nbBomb>0) 
			{
				countFrameBomb++;
				if (countFrameBomb >= 1) 
				{
					setBomb();
				countFrameBomb = 0;
				}
				
			}
				
				
			
			
			Hud.getInstance().scoreUpdate();
			doLife();
			stopX();
			stopY();
			getCollectable();
			trail.draw();
			
			if (Hud.getInstance().mcTopLeft.mcSpecialBar.mcBar.x >0)
				{
			transparence();
			
				}
			
			if (onTransparence == false)
			{
				colliderObstacleEnemy();
				colliderShotEnemy();
			}
		
		}
		
		private function colliderShotEnemy():void
		{
			for (var i:int = 0; i < ShotEnemy.shotsEnemy.length; i++)
			{
				
				if (CollisionManager.hasCollision(hitBox, ShotEnemy.shotsEnemy[i], hitPoints))
				{
					
					if (life > 0)
					{
						setState("hurt");
						
					}
					if (life <= 0)
					{
						setState("explosion");
					}
				}
			}
		}
		
		private function doLife():void
		{
			if (life == 4) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = true;
				Hud.getInstance().mcTopRight.mcGuide3.visible = true;
				
			}
			if (life == 3) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = true;
				Hud.getInstance().mcTopRight.mcGuide3.visible = false;
				
			}
			if (life == 2) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = false;
				Hud.getInstance().mcTopRight.mcGuide3.visible = false;
			
			}
			if (life == 1) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;
				Hud.getInstance().mcTopRight.mcGuide0.visible = false;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;

			}
			if (life == 0) 
			{
				setState("explosion");
				
				Hud.getInstance().mcTopRight.mcGuide0.visible = false;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;
				Hud.getInstance().mcTopRight.mcGuide0.visible = false;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;

			}
		
		}
		
		private function getCollectable():void
		{
			for (var i:int = 0; i < Collectable.list.length; i++)
			{
				
				if (CollisionManager.hasCollision(hitBox, Collectable.list[i].hitBox))
				{
					Collectable.list[i].doAction();
					
				}
			}
		}
		
		private function setBomb():void
		{
			
			if (controller.bomb == true)
			{
				var lBomb:Bomb;
				lBomb = new Bomb("Bomb");
				parent.addChild(lBomb);
				Bomb.list.push(lBomb);
				lBomb.x = x + collider.mcWeapon0.x;
				lBomb.y = y + collider.mcWeapon0.y;
				nbBomb--;
				//Hud.getInstance().mcTopLeft.mcGuide1.visible = false;
				
				SoundManager.getNewSoundFX("bomb").start();
				lBomb.start();
				
			}
			if (nbBomb==2) 
			{
				Hud.getInstance().mcTopLeft.mcGuide0.visible = true;
				Hud.getInstance().mcTopLeft.mcGuide1.visible = true;
			}
			if (nbBomb==1) 
			{
				Hud.getInstance().mcTopLeft.mcGuide0.visible = true;
				Hud.getInstance().mcTopLeft.mcGuide1.visible = false;
			}
			if (nbBomb==0) 
			{
				Hud.getInstance().mcTopLeft.mcGuide0.visible = false;
				Hud.getInstance().mcTopLeft.mcGuide1.visible = false;
			}
		}
		
		private function setShot():void
		{
			
			if (controller.fire == true)
			{
				//for (var i:int = 0; i < Enemy2.list.length; i++) 
				//{
				//Enemy2.list[i].RandomMove();
				//}
				
				setShot0();
				SoundManager.getNewSoundFX("playerShoot0").start();
				weapon.play();
				TweenLite.to(mcWeapon, 1, {scaleX: 1, scaleY: 1, onComplete: onTweenComplete});
				
				if (weaponLevel == 1)
				{
					weaponLevel1();
				}
				
				if (weaponLevel == 2)
				{
					weaponLevel2();
				}
				
			}
		
		}
		
		private function onTweenComplete():void
		{
			TweenLite.to(mcWeapon, 1, {scaleX: 1, scaleY: 1});
		}
		
		private function setShot0():void
		{
			var lShot:ShotPlayer;
			
			lShot = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot);
			ShotPlayer.shots.push(lShot);
			lShot.velocity.setTo(1, 0);
			lShot.x = x + collider.mcWeapon0.x;
			lShot.y = y + collider.mcWeapon0.y;
			lShot.start();
		}
		
		private function weaponLevel1():void
		{
			var lShot2:ShotPlayer;
			var lShot3:ShotPlayer;
			
			lShot2 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot2);
			lShot2.velocity.setTo(Math.cos(collider.mcWeapon1.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon1.rotation * (Math.PI / 180)));
			lShot2.x = x + collider.mcWeapon1.x;
			lShot2.y = y + collider.mcWeapon1.y;
			lShot2.rotation = collider.mcWeapon1.rotation;
			lShot2.start();
			
			lShot3 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot3);
			lShot3.velocity.setTo(Math.cos(collider.mcWeapon2.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon2.rotation * (Math.PI / 180)));
			lShot3.x = x + collider.mcWeapon2.x;
			lShot3.y = y + collider.mcWeapon2.y;
			lShot3.rotation = collider.mcWeapon2.rotation;
			lShot3.start();
		}
		
		private function weaponLevel2():void
		{
			var lShot2:ShotPlayer;
			var lShot3:ShotPlayer;
			var lShot4:ShotPlayer;
			var lShot5:ShotPlayer;
			
			lShot2 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot2);
			lShot2.velocity.setTo(Math.cos(collider.mcWeapon1.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon1.rotation * (Math.PI / 180)));
			lShot2.x = x + collider.mcWeapon1.x;
			lShot2.y = y + collider.mcWeapon1.y;
			lShot2.rotation = collider.mcWeapon1.rotation;
			lShot2.start();
			
			lShot3 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot3);
			lShot3.velocity.setTo(Math.cos(collider.mcWeapon2.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon2.rotation * (Math.PI / 180)));
			lShot3.x = x + collider.mcWeapon2.x;
			lShot3.y = y + collider.mcWeapon2.y;
			lShot3.rotation = collider.mcWeapon2.rotation;
			lShot3.start();
			
			lShot4 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot4);
			lShot4.velocity.setTo(Math.cos(collider.mcWeapon3.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon3.rotation * (Math.PI / 180)));
			lShot4.x = x + collider.mcWeapon3.x;
			lShot4.y = y + collider.mcWeapon3.y;
			lShot4.rotation = collider.mcWeapon3.rotation;
			lShot4.start();
			
			lShot5 = new ShotPlayer("ShootPlayer" + shotLevel);
			parent.addChild(lShot5);
			lShot5.velocity.setTo(Math.cos(collider.mcWeapon4.rotation * (Math.PI / 180)), Math.sin(collider.mcWeapon4.rotation * (Math.PI / 180)));
			lShot5.x = x + collider.mcWeapon4.x;
			lShot5.y = y + collider.mcWeapon4.y;
			lShot5.rotation = collider.mcWeapon4.rotation;
			lShot5.start();
		
		}
		
		override public function get hitPoints():Vector.<Point>
		{
			var lPoint0:Point = new Point(collider.mcHitPoint1.x, collider.mcHitPoint1.y);
			var lPoint1:Point = new Point(collider.mcHitPoint2.x, collider.mcHitPoint2.y);
			var lPoint2:Point = new Point(collider.mcHitPoint3.x, collider.mcHitPoint3.y);
			return new <Point>[collider.localToGlobal(lPoint0), collider.localToGlobal(lPoint1), collider.localToGlobal(lPoint2)];
		}
		
		private function colliderObstacleEnemy():void
		{
			
			for (var l:int = 0; l < Obstacle.list.length; l++)
			{
				if (CollisionManager.hasCollision(hitBox, Obstacle.list[l].hitBox, hitPoints))
				{
					if (x >= Obstacle.list[l].hitBox.x)
					{
						x = Obstacle.list[l].x - width;
						setState("hurt");
					}
					
				}
				
			}
		}
		
		private function weaponSet():void
		{
			if (weapon.currentFrame >= weapon.totalFrames)
			{
				weapon.gotoAndStop(0);
			}
		}
		
		private function stopX():void
		{
			if (x >= GameLayer.getInstance().screenLimits.right - 10)
			{
				x = GameLayer.getInstance().screenLimits.right - 10;
				
			}
			
			if (x <= GameLayer.getInstance().screenLimits.left - 10)
			{
				
				x = GameLayer.getInstance().screenLimits.left - 10;
				
			}
		
		}
		
		private function stopY():void
		{
			if (y <= GameLayer.getInstance().screenLimits.top - 10)
			{
				y = GameLayer.getInstance().screenLimits.top - 10;
				
			}
			
			if (y >= GameLayer.getInstance().screenLimits.bottom - 10)
			{
				
				y = GameLayer.getInstance().screenLimits.bottom - 10;
				
			}
		}
		
		private function playerState():void
		{
			if (controller.left == 1)
			{
				setState("left");
				weaponSet();
				
			}
			if (controller.right == 1)
			{
				setState("right");
				weaponSet();
				
			}
			if (controller.up == 1)
			{
				setState("up");
				weaponSet();
			}
			if (controller.down == 1)
			{
				setState("down");
				weaponSet();
			}
			else if (controller.down == 0 && controller.up == 0 && controller.right == 0 && controller.left == 0 && state != "default")
			{
				setState("default");
				weaponSet();
			}
		}
		
		private function transparence():void
		{
			
			if (controller.special == true)
			{
				onTransparence = true;
				SoundManager.getNewSoundFX("special").start();
				if (onTransparence == true)
				{
					TweenLite.to(this, 2, {alpha: 0.2, alpha: 0.2});
					trail.alpha = 0.2;
				}
				
			}

		
		}
		
		private function godMod():void
		{
			if (controller.god && !wasGodMod)
			{
				onGodMod = !onGodMod;
				TweenLite.to(this, 0.75, {tint: 0xF2F126})
				trail.color = 0xC426F2;
			}
			wasGodMod = controller.god;
			if (onGodMod == false) 
			{
				TweenLite.to(this, 0.75, {removeTint: true})
				trail.color = 0x18EC24;
			}
			
		}
		
		override protected function setState(pState:String, pLoop:Boolean = false, pStart:uint = 1):void
		{
			super.setState(pState, pLoop, pStart);
			
			mcWeapon = MovieClip(renderer.getChildAt(0)).mcWeapon;
			
			weaponClass = getDefinitionByName("Weapon" + weaponLevel) as Class;
			weapon = new weaponClass();
			weapon.stop();
			mcWeapon.addChild(weapon);
		
		}
		
		private function animPlayer():void
		{
			if (isTouched == true)
			{
				setState("hurt");
				trail.color = 0xFD0303;
				TweenLite.to(this, 3, {tint:0xFD0303});
				isTouched = !isTouched;
			}
		
		}

		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void
		{
			instance = null;
			super.destroy();
		}
	
	}

}