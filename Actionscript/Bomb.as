package  {
	
	public class Bomb extends Entity{

		private playerArray : Array = null;
		private player : Player = null;
		private owner : Player = null;
		private isset : Boolean = false;
		private immune : Boolean = false;
		private speed : int = 10;
		private radius : int = 100;
		
		public function Bomb(tmpX : int, tmpY : int, p : Array, plyr : Player, user : String)
		{
			x = tmpX;
			y = tmpY;
			playerArray = p;
			owner = plyr;
		
			
			if(user == owner.getPlayerId())
			{
				setImmune();
			}
		}
		
		override public function update()
		{
			//if no player is found
			if(!isset)
			{
				
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
			player = p;
			isset = true;
		}
		
		/*
			Search for nearby players to lock on to a player
		*/
		private function searchForPlayer()
		{
			for(var i : int = 0; i < playerArray.length; i++)
			{
				//check if this player is within a certain radius
				if(playerArray[i].x - this.x < radius && playerArray[i].x - this.x > -radius
					&& playerArray[i].y - this.y < radius && playerArray[i].y - this.y > - radius
				&& playerArray[i] != owner)
				{
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
					p.destroy(this);
				}
			}
		}

	}
	
}
