package com.isartdigital.utils.effects 
{
	import com.isartdigital.utils.game.StateObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe permettant d'ajouter des trainées derrière les objets
	 * @author Mathieu ANTHOINE
	 */
	public class Trail extends Sprite 
	{
		
		private var points:Vector.<Point> = new Vector.<Point>();
		private var lastX:Number;
		private var lastY:Number;
		private var size:Number;
		private var time:int = 1;
		
		/**
		 * Cible du trail
		 */
		private var target:DisplayObject;
		
		/**
		 * Longueur maximum du trail en pixels
		 */
		public var length:int = 0;
		
		/**
		 * distance entre chaque point composant le trail
		 */
		public var distance:Number;
		
		/**
		 * couleur du trail
		 */
		public var color:int = 0x0;
		
		/**
		 * persistence (vitesse de disparition du trail)
		 */
		public var persistence:Number = 1;
		
		/**
		 * ferme l'arc sur la cible
		 */
		public var closed:Boolean = true;
		
		public function Trail() 
		{
			super();
			
		}
		
		/**
		 * Initialisation du trail
		 * @param	pTarget définition de la cible
		 * @param	pSize largeur
		 * @param	pDistance distance entre chaque point du trail
		 * @param	pLength longueur maximum en pixels
		 */
		public function init(pTarget:DisplayObject,pSize:Number=5,pDistance:Number=10,pLength:int=0):void {
			target = pTarget;
			size = pSize;
			lastX = target.x;
			lastY = target.y;
			distance = pDistance;
			length = pLength == 0 ? distance * 20:pLength;

		}
		
		/**
		 * dessine le trail (à executer chaque frame)
		 */
		public function draw():void 
		{
			
			var lParent:DisplayObjectContainer = target.parent;
			if (lParent == null) return;
			
			lParent.addChildAt(this, Math.max(0,lParent.getChildIndex(target)-1));
			
			if (Point.distance(new Point(lastX,lastY),new Point(target.x,target.y))>distance ) {
				points.push(new Point(target.x, target.y));
				lastX = target.x;
				lastY = target.y;
			}
			
			graphics.clear();
			
			if (points.length>0) graphics.moveTo(points[0].x, points[0].y);
			
			for (var i:int = 1; i < points.length;i++ ) {
				graphics.lineStyle((i / points.length)*size, color);
				
				graphics.lineTo(points[i].x, points[i].y);
			}
			
			if (points.length>0 && closed) graphics.lineTo(target.x, target.y);
			
			graphics.endFill();
			
			if (points.length>1 && (points.length * distance > length || time++> Math.ceil(persistence))) {
				points.shift();
				var lTime:int = Math.round(1 / persistence)-1;
				if (persistence < 1 && points.length>5) {
					while (points.length > 1 && lTime-->0) {
						points.shift();
					}
				}
				time = 1;
			}
			
		}
		
		/**
		 * Efface le trail
		 */
		public function clear ():void {
			points.length = 0;
		}
		
		public function destroy ():void {
			clear();
			parent.removeChild(this);
		}
		
	}

}