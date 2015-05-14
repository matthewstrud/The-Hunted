package 
{
	import flash.events.Event;
	public class Missile extends Entity 
	{

		private var speed = 20;
		private var immune = false;
		private var player : Player = null;
		private var p = null;
		private var hasHit:Boolean = false;
		private var user:String;

		public function Missile(tmpX : int, tmpY : int, tmpR : int, plyr : Player, tuser:String) 
		{
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			x = tmpX;
			y = tmpY;
			rotation = tmpR;
			player = plyr;
			user = tuser;
			
			if(user == player.getPlayerId())
			{
				setImmune();
			}
			
		}
		
		override public function update()
		{
			var angle :Number = rotation * Math.PI / 180;
			x += speed * Math.sin(angle);
			y += speed * -Math.cos(angle);
			
			checkBounds();
			checkCollisions();
		}
		
		//ignore this player
		public function setImmune()
		{
			immune = true;
		}
		
		//check for collisions ignoring this player
		private function checkCollisions()
		{
			if(immune == false && !player.getSpecate())
			{
				if(this.hitTestObject(player) && !hasHit)
				{
					hasHit = true;
					p.destroy(this);
				}
			}
		}
		
		private function checkBounds()
		{
			if(x < 0 || x > p.getXBounds() || y < 0 || y > p.getYBounds()) 
			{
				p.removeMissile(this);
			}
		}
		
		public function getPlayerName():String
		{
			return user;
		}
		
		public function addedHandler(e:Event)
		{
			p = this.parent;
		}

	}
	
}
