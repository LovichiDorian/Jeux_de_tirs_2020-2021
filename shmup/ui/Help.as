package com.isartdigital.shmup.ui 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.ui.help.HelpSpecial;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.GameInput;
	
	/**
	 * Ecran d'aide
	 * @author Mathieu ANTHOINE
	 */
	public class Help extends Screen 
	{
		
		/**
		 * instance unique de la classe Help
		 */
		protected static var instance: Help;

		public var btnNext:SimpleButton;
		
		public var mcPad:Sprite;
		public var mcKeyboard:Sprite;
		public var mcTouch:Sprite;
		
		protected var pad:GameInput;
		
		public function Help() 
		{
			super();			
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Help {
			if (instance == null) instance = new Help();
			return instance;
		}
		
		override protected function init (pEvent:Event): void {
			super.init(pEvent);
			btnNext.addEventListener(MouseEvent.CLICK, onClick);
			
			switch (Controller.type) {
				case Controller.KEYBOARD:
					mcPad.visible = false;
					mcTouch.visible = false;
					break;
				case Controller.PAD:
					mcKeyboard.visible = false;
					mcTouch.visible = false;
					break;
				case Controller.TOUCH:
					mcPad.visible = false;
					mcKeyboard.visible = false;
			}
			//TweenLite.from(this, 2, {scaleX: 2, scaleY: 2, ease:Back.easeIn})
			TweenLite.from(btnNext, 2, {scaleX:1.8, scaleY:1.8, ease:Elastic.easeIn})
		}
		
		protected function onClick (pEvent:MouseEvent) : void {
			SoundManager.getNewSoundFX("click").start();
			UIManager.addScreen(HelpSpecial.getInstance());
			//GameManager.start();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			btnNext.removeEventListener(MouseEvent.CLICK, onClick);
			instance = null;
			super.destroy();
		}

	}
}