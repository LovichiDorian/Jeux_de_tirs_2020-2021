package com.isartdigital.utils.maths 
{
	/**
	 * ...
	 * @author Chadi Husser
	 */
	public class MathTools 
	{	
		public static const DEG2RAD:Number = Math.PI / 180; 
		public static const RAD2DEG:Number = 180 / Math.PI;
		
		public static function lerp(pStart:Number, pEnd:Number, pRatio:Number) : Number 
		{
			return pStart + (pEnd - pStart) * pRatio;
		}
	}

}