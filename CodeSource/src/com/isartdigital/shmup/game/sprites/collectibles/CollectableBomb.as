package com.isartdigital.shmup.game.sprites.collectibles 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class CollectableBomb extends Collectable 
	{
		
		
		public function CollectableBomb(pAsset:String) 
		{
			assetName = pAsset;
			super();
			
		}
		override protected function doActionNormal():void 
		{
			comport();
		}
		private function comport():void 
		{
			
			Player.getInstance().nbBomb++;
			Hud.getInstance().mcTopLeft.mcGuide1.visible = true;
			SoundManager.getNewSoundFX("powerupBomb").start();
			destroy();
		}
		
	}

}