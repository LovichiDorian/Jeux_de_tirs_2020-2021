package com.isartdigital.shmup.game.levelDesign 
{
	
	import com.isartdigital.shmup.game.sprites.enemies.Boss;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy2;
	import com.isartdigital.shmup.game.sprites.enemies.EnemyNormal;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	/**
	 * Classe qui permet de générer des classes d'ennemis
	 * TODO: S'inspirer de la classe ObstacleGenerator pour le développement
	 * @author Mathieu ANTHOINE
	 */
	public class EnemyGenerator extends GameObjectGenerator 
	{
		
		public function EnemyGenerator() 
		{
			super();
			
		}
		override public function generate():void 
		{
			var lNum:String = getQualifiedClassName(this).substr( -1);
	
			
			if (lNum=="1") 
			{
				var lEnemy1:Enemy1 = new Enemy1("Enemy"+lNum); 
				lEnemy1.x = x;
				lEnemy1.y = y;
				lEnemy1.start();
				parent.addChild(lEnemy1);
				Enemy1.list.push(lEnemy1);
				super.generate();
			}
			else if (lNum == "2") 
			{
				var lEnemy2:Enemy2 = new Enemy2("Enemy"+lNum); 
				lEnemy2.x = x;
				lEnemy2.y = y;
				lEnemy2.start();
				parent.addChild(lEnemy2);
				Enemy2.list.push(lEnemy2);
				super.generate();
			}
			else if (lNum == "n") 
			{
				var lBoss:Boss = new Boss("Boss0");
				lBoss.x = x;
				lBoss.y = y;
				lBoss.start();
				parent.addChild(lBoss);
				Boss.list.push(lBoss);
				SoundManager.stopSounds();
				SoundManager.getNewSoundFX("bossLoop0").loop();
				super.generate();
			}

			else 
			{
				var lEnemy:Enemy0 = new Enemy0("Enemy"+lNum);
				lEnemy.x = x;
				lEnemy.y = y;
				lEnemy.start();
				parent.addChild(lEnemy);
				EnemyNormal.list.push(lEnemy);
				super.generate();
			}

		}
	}

}