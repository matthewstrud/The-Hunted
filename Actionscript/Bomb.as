package  {
	import flash.events.Event;
	public class Bomb extends Entity{

		private var playerArray : Array;
		private var player : Player = null;
		private var owner : Player = null;
		private var isset : Boolean = false;
		private var immune : Boolean = false;
		private var speed : int = 5;
		private var radius : int = 100;
		private var hasHit : Boolean = false;
		private var p = null;
		
		public function Bomb(tmpX : int, tmpY : int, p : Array, plyr : Player, thisPlayer:Player)
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			x = tmpX;
			y = tmpY;
			playerArray = p;
			owner = plyr;
		
			
			if(thisPlayer.getPlayerId() == owner.getPlayerId())
			{
				setImmune();
			}
		}
		
		override public function update()
		{
			//if no player is found
			if(!isset)
			{
				searchForPlayer();
			}
			else //the player is set
			{
				move();
				checkCollisions();
			}
			
		}
		
		//ignore this player
		public function setImmune()
		{
			immune = true;
		}
		
		public function move()
		{
			if(x < player.x)
			{
				x += speed;
			}
			else if(x > player.x)
			{
				x -= speed;
			}
			
			if(y < player.y)
			{
				y += speed;
			}
			else if(y > player.y)
			{
				y -= speed;
			}
		}
		
		public function addPlayer(p : Player)
		{
			trace("player found");
			player = p;
			isset = true;
		}
		
		/*
			Search for nearby players to lock on to a player
		*/
		private function searchForPlayer()
		{
			trace("checking players");
			for(var i : int = 0; i < playerArray.length; i++)
			{
				//check if this player is within a certain radius
				if(playerArray[i].x - this.x < radius && playerArray[i].x - this.x > -radius
					&& playerArray[i].y - this.y < radius && playerArray[i].y - this.y > - radius
				&& playerArray[i] != owner)
				{
					trace("player found, calling add player");
					addPlayer(playerArray[i]);
				}
			}
		}
		
		private function checkCollisions()
		{
			if(immune == false && !player.getSpecate())
			{
				if(this.hitTestObject(player) && !hasHit)
				{
					hasHit = true;
					p.destroyb(this);
				}
			}
		}
		
		public function getPlayerName():String
		{
			return owner.getPlayerId();
		}
		
		public function addedHandler(e:Event)
		{
			p = this.parent;
		}
		

	}
	
}
