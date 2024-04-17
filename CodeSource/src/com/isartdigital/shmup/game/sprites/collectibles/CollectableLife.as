package com.isartdigital.shmup.game.sprites.collectibles 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class CollectableLife extends Collectable 
	{
		
		public function CollectableLife(pAsset:String) 
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
			
			SoundManager.getNewSoundFX("powerupLife").start();
			if (Player.getInstance().life == 4) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = true;
				Hud.getInstance().mcTopRight.mcGuide3.visible = true;
				
			}
			if (Player.getInstance().life == 3) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = true;
				Hud.getInstance().mcTopRight.mcGuide3.visible = false;
				Player.getInstance().life++;
			}
			if (Player.getInstance().life == 2) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = true;
				Hud.getInstance().mcTopRight.mcGuide2.visible = false;
				Hud.getInstance().mcTopRight.mcGuide3.visible = false;
				Player.getInstance().life++;
			}
			if (Player.getInstance().life == 1) 
			{
				Hud.getInstance().mcTopRight.mcGuide0.visible = true;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;
				Hud.getInstance().mcTopRight.mcGuide0.visible = false;
				Hud.getInstance().mcTopRight.mcGuide1.visible = false;
				Player.getInstance().life++;
			}
			
			destroy();
		}
	}

}