package com.isartdigital.utils.game 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import flash.display.Sprite;
	/**
	 * Classe de base des objets interactifs dans le jeu
	 * Par convention le changement de référence de doAction se fait via des méthodes setMode (setModeVoid, setModeAction) qui peuvent aussi contenir des paramètres d'initialisation
	 * expose de façon publique sa méthode doAction qui peut faire référence à différentes méthodes prévues (doActionVoid, doActionNormal) ou spécifiques définies par ses classes filles
	 * @author Mathieu ANTHOINE
	 */
	public class GameObject extends Sprite
	{
		public const RAD2DEG:Number = 180 / Math.PI; // radian * RAD2DEG => opération pour passer d'un angle en radian en degré
		public const DEG2RAD:Number = Math.PI / 180; // degree * DEG2RAD => opération pour passer d'un angle en degré en radian
		/**
		 * méthode appelée à chaque gameLoop. Elle peut faire référence à différentes méthodes au cours du temps
		 */
		public var doAction:Function;
		
		public function GameObject() 
		{
			super();
			setModeVoid();	
			
		}
			
		/**
		 * applique le mode "ne fait rien"
		 */
		protected function setModeVoid (): void {
			doAction = doActionVoid;
		}
		
		/**
		 * fonction vidé destinée à maintenir la référence de doAction sans rien faire
		 */
		protected function doActionVoid (): void {}

		
		/**
		 * applique le mode normal (mode par defaut)
		 */
		protected function setModeNormal(): void {
			doAction = doActionNormal;
		}
		
		/**
		 * fonction destinée à appliquer un comportement par defaut
		 */
		protected function doActionNormal (): void {}
		
		/**
		 * Activation
		 */
		public function start (): void {
			setModeNormal();
		}
		
		/**
		 * nettoie et détruit l'instance
		 */
		public function destroy (): void {
			setModeVoid();
            
			if (parent != null) parent.removeChild (this);
		}

		
	}

}