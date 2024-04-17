package com.isartdigital.shmup.game.sprites.collectibles 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class CollectableFireUpgrade extends Collectable 
	{
		private var nbUpgrade:int = 0;
		
		public function CollectableFireUpgrade(pAsset:String) 
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
			nbUpgrade++;
			SoundManager.getNewSoundFX("powerupFireUpgrade").start();
			Player.getInstance().weaponLevel = nbUpgrade;
			destroy();
		}
	}

}