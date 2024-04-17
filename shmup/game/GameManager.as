package com.isartdigital.shmup.game {
	
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.layers.ScrollingLayer;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.ui.help.HelpSpecial;
	import flash.display.StageQuality;
	
	import com.isartdigital.shmup.game.sprites.Teleguided;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
	import com.isartdigital.shmup.game.sprites.enemies.Boss;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy2;
	import com.isartdigital.shmup.game.sprites.enemies.EnemyNormal;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotEnemy;
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.WinScreen;
	import com.isartdigital.shmup.ui.PauseScreen;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.game.CollisionManager;
    import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
    import flash.display.Sprite;
	import flash.events.Event;
    import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Manager (Singleton) en charge de gérer le déroulement d'une partie
	 * @author Mathieu ANTHOINE
	 */
	public class GameManager
	{
		/**
		 * jeu en pause ou non
		 */
		protected  static var foreground:ScrollingLayer;
		protected static var background1:ScrollingLayer;
		protected static var background2:ScrollingLayer;
		
		
		protected static var isPause:Boolean = true;
		
		/**
		 * controlleur
		 */
		protected static var _controller:Controller;
        
        public static function get controller():Controller 
        {
            return _controller;
        }
		

		public function GameManager() { }

		public static function start (): void {
			// Lorsque la partie démarre, le type de controleur déterminé est actionné
			if (Controller.type == Controller.PAD) 
                _controller = ControllerPad.getInstance();
			else if (Controller.type == Controller.TOUCH) 
                _controller = ControllerTouch.getInstance();
			else 
                _controller = ControllerKey.getInstance();

			Monitor.getInstance().addButton("Game Over",cheatGameOver);
			Monitor.getInstance().addButton("Win", cheatWin);
			Monitor.getInstance().addButton("Colliders", cheatCollider);
			Monitor.getInstance().addButton("Renderers", cheatRenderer);
			//Monitor.getInstance().destroy();
			UIManager.startGame();
			
			// TODO: votre code d'initialisation commence ici
			
			SoundManager.getNewSoundFX("levelLoop").loop();
			
			var lForegroundClass:Class = Class(getDefinitionByName("Foreground"));
			var lBackground1Class:Class = Class(getDefinitionByName("Background1"));
			var lBackground2Class:Class = Class(getDefinitionByName("Background2"));
			
			
			foreground= new lForegroundClass();
			background1 = new lBackground1Class();
			background2 = new lBackground2Class();
			background1.init(0.3,GameLayer.getInstance());
			background2.init(0.6,GameLayer.getInstance());
			foreground.init(1.5, GameLayer.getInstance());
			//GameLayer.getInstance().init( -10, null);
			
			GameStage.getInstance().getGameContainer().addChild(background1);
			GameStage.getInstance().getGameContainer().addChild(background2);
			GameStage.getInstance().getGameContainer().addChild(foreground);
			GameStage.getInstance().getGameContainer().addChild(GameLayer.getInstance());
            GameLayer.getInstance().addChild(Player.getInstance());
			HelpSpecial.getInstance().destroy();
			
			var lGlobalPlayerPosition : Point = new Point(Config.stage.stageWidth / 3, Config.stage.stageHeight / 2);
			var lPlayerPosition:Point = GameLayer.getInstance().globalToLocal(lGlobalPlayerPosition);
			Player.getInstance().y = lPlayerPosition.y;
			Player.getInstance().x = lPlayerPosition.x;
			Player.getInstance().start();
			GameLayer.getInstance().start();
			background1.start();
			background2.start();
			foreground.start();
            GameLayer.getInstance().stage.quality = StageQuality.LOW;
            //background1.cacheAsBitmap = true;
			//foreground.cacheAsBitmap = true	;
			//background2.cacheAsBitmap = true;
			
			resume();
		}
		
		// ==== Mode Cheat =====
		
		protected static function cheatCollider (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.colliderAlpha < 1) StateObject.colliderAlpha = 1; else StateObject.colliderAlpha = 0;
		}
		
		protected static function cheatRenderer (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.rendererAlpha < 1) StateObject.rendererAlpha = 1; else StateObject.rendererAlpha = 0;
		}
		
		protected static function cheatGameOver (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Player.getInstance().destroy();
			gameOver();
		}
		
		protected static function cheatWin (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			win();
		}
		
		/**
		 * boucle de jeu (répétée à la cadence du jeu en fps)
		 * @param	pEvent
		 */
		protected static function gameLoop (pEvent:Event): void {
			// TODO: votre code de gameloop commence ici
			GameLayer.getInstance().doAction();
			Player.getInstance().doAction();
			foreground.doAction();
			background2.doAction();
			background1.doAction();
			
			
			for (var j:int = 0; j < EnemyNormal.list.length; j++) 
			{
				EnemyNormal.list[j].doAction();
			}
			
			ShotPlayer.shots;
			
			for (var i:int = 0; i < ShotPlayer.shots.length; i++) 
			{
				ShotPlayer.shots[i].doAction();
			}
			for (var k:int = 0; k <ShotEnemy.shotsEnemy.length ; k++) 
			{
			ShotEnemy.shotsEnemy[k].doAction();
			}
			for (var n:int = 0; n < Bomb.list.length; n++) 
			{
				Bomb.list[n].doAction();
			}
			for (var l:int = 0; l < Obstacle.list.length; l++) 
			{
				Obstacle.list[l].doAction();
			}
			for (var m:int = 0; m < Boss.list.length; m++) 
			{
				Boss.list[m].doAction();
				if (Boss.list[m].lifeBoss < 0) 
				{
					
					win();
					Boss.list[m].lifeBoss = 2000;
				}
			}
			for (var o:int = 0; o < Teleguided.list.length; o++) 
			{
				Teleguided.list[o].doAction();
			}
			
		
			
			if (controller.pause)
			{
				SoundManager.stopSounds();
				pause();
				
			}
			if (Player.getInstance().life==0) 
			{
				SoundManager.getNewSoundFX("playerExplosion");
				SoundManager.stopSounds();
				Hud.getInstance().mcTopRight.mcGuide0.visible = false;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;
				gameOver();
			}
			
			
		}
		
		public static function gameOver ():void {
			GameOver.getInstance().score.text = Hud.getInstance().scores.toString();
			pause();
			UIManager.addScreen(GameOver.getInstance());
			
			SoundManager.getNewSoundFX("gameoverJingle").loop();
		}
		
		public static function win():void {
			WinScreen.getInstance().score.text =  Hud.getInstance().scores.toString();
			pause();
			
			UIManager.addScreen(WinScreen.getInstance());
		}
		
		public static function pause (): void {
			
				if (!isPause) {
				isPause = true;
				Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
				UIManager.addScreen(PauseScreen.getInstance());
				SoundManager.getNewSoundFX("uiLoop").loop();
				
			}
			
		}
		
		public static function resume (): void {
			// donne le focus au stage pour capter les evenements de clavier
			Config.stage.focus = Config.stage;
            SoundManager.stopSounds();
			if (isPause) {
				isPause = false;
				Config.stage.addEventListener (Event.ENTER_FRAME, gameLoop);
				SoundManager.getNewSoundFX("levelLoop").loop();
			}
		}
		public static function destroyAll():void 
		{
			
				GameLayer.getInstance().destroy();
			Player.getInstance().destroy();
			foreground.destroy();
			background2.destroy();
			background1.destroy();
			
			
			for (var j:int = 0; j < EnemyNormal.list.length; j++) 
			{
				EnemyNormal.list[j].destroy();
			}
			
			
			for (var i:int = 0; i < ShotPlayer.shots.length; i++) 
			{
				ShotPlayer.shots[i].destroy();
			}
			for (var k:int = 0; k <ShotEnemy.shotsEnemy.length ; k++) 
			{
			ShotEnemy.shotsEnemy[k].destroy();
			}
			for (var n:int = 0; n < Bomb.list.length; n++) 
			{
				Bomb.list[n].destroy();
			}
			for (var l:int = 0; l < Obstacle.list.length; l++) 
			{
				Obstacle.list[l].destroy();
			}
			for (var m:int = 0; m < Boss.list.length; m++) 
			{
				Boss.list[m].destroy();
			}
			Player.getInstance().life = 2;
			SoundManager.stopSounds();
			Monitor.getInstance().clear();
			Player.getInstance().nbBomb = 4;
			Hud.getInstance().scores = 0;
			Hud.getInstance().mcTopLeft.mcSpecialBar.mcBar.x = -300;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public static function destroy (): void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
		}

	}
}