﻿package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Player extends MovieClip
	{
		
		private var id : String;
		private var status : Boolean = true;
		private var isCurrent : Boolean = false;
		private var xSpeed : Number = 0;
		private var ySpeed : Number = 0;
		private var xBounds : int = 0;
		private var yBounds : int = 0;
		private var rotationSpeed : Number = 0;
		private var slowDownSpeed : Number = 0.01;
		private var maxSpeed : int = 10;
		private var p = null;
		
		private var specate:Boolean;
		private var health:int;
		private var kills:int = 0;

		public function Player(name : String)
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			trace("created new player: " + name);
			id = name;
			this.x = 0;
			this.y = 0;
			specate = false;
			health = 3;
		}
		/*
		public function Player(name : String, xPos: int, yPos : int, rot : int)
		{
			this.id = name;
			this.x = xPos;
			this.y = yPos;
			this.rotation = rot;
		}
		*/
		public function setPosition(xPos : int, yPos : int)
		{
			this.x = xPos;
			this.y = yPos;
			//this.rotation = rot;
		}
		

		
		public function addYSpeed( ys : Number)
		{
			ySpeed = ySpeed + ys;
			if(ySpeed > maxSpeed)
			{
				ySpeed = maxSpeed;
			}
			else if(ySpeed < -maxSpeed)
			{
				ySpeed = -maxSpeed;
			}
		}
		
		public function rotate(rot : int)
		{
			//add to rotation speed limit top speed
			
			rotation+= (rot * 5);
			
				
		}
		
		//Changed from getId to getPlayerId - to remove conflict in names.
		public function getPlayerId() : String
		{
			return id;
		}
				
		public function setStatus(stat : Boolean)
		{
			status = stat;
		}
		
		public function getStatus() : Boolean
		{
			return status;
		}
		public function getHealth() : int
		{
			return health;
		}
		
		//only called for the current player
		public function update() : void
		{
			bounds();
			move();
			//wrapAround(); //temporary code to wrap the player around
		}
		
		//sets the player to be this clients player
		public function setCurrent()
		{
			isCurrent = true;
		}
		
		//adds acceleration to the player
		private function move()
		{
			//first slow the player down in order to stop the player naturally
			
			if(xSpeed > 0)
			{
				xSpeed -= slowDownSpeed;
			}
			else if(xSpeed < 0)
			{
				xSpeed += slowDownSpeed;
			}
			
			if(ySpeed > 0)
			{
				ySpeed -= slowDownSpeed;
			}
			else if(ySpeed < 0)
			{
				ySpeed += slowDownSpeed;
			}
			
			if(xSpeed != 0 || ySpeed != 0)
			{
				p.setChanged(true);
			}
			
			//move the movie clip
			p.x -= xSpeed;
			p.y -= ySpeed;
			
			//then move the player and the health bar
			x += xSpeed;
			y += ySpeed;
			p.thehealth.x += xSpeed;
			p.thehealth.y += ySpeed;
			
			//rotation ease off
			
			
		}
		
		private function wrapAround()
		{
			/*
			if(x > xBounds)
			{
				x = 0;
			}
			else if(x < 0)
			{
				x = xBounds;
			}
			
			if(y > yBounds)
			{
				y = 0;
			}
			else if(y < 0)
			{
				y = yBounds;
			}
			*/
		}
		
		/*
			Prevent the player from going out of bounds by moving the player
			back to thier last position. As the background is moved in the opposite
			direction the background also has to be placed in the correct location.
		*/
		private function bounds() : void
		{
			if(x < 0)
			{
				x = 0;
				p.x = 0 + 540;
				p.thehealth.x = 0 - 540;
			}
			//4320
			else if(x > p.getXBounds())
			{
				x = p.getXBounds();
				p.x = -p.getXBounds() + 540;
				p.thehealth.x = p.getXBounds() - 540;
			}
			
			if(y < 0)
			{
				y = 0;
				p.y = 0 + 360;
				p.thehealth.y = 0-360;
			}
			//2880 - 360
			else if(y > p.getYBounds())
			{
				y = p.getYBounds();
				p.y = -p.getYBounds() + 360;
				p.thehealth.y = p.getYBounds() - 360;
			}
		}
		
		
		/*
			Move in a direction using sin for xSpeed and cosine for y speed
			multiplied by dir which will be either 1 or -1 for forwards or
			backwards respectivly.
		*/
		public function moveDir(dir : int)
		{
			var angle :Number = rotation * Math.PI / 180;
			xSpeed += dir * (Math.sin(angle));
			ySpeed += dir * -((Math.cos(angle)));
			
			//todo need to limit the max speed of x and y speed using the maxSpeed variable
			
			if(xSpeed > maxSpeed)
			{
				xSpeed = maxSpeed;
			}
			else if(xSpeed < -maxSpeed)
			{
				xSpeed = -maxSpeed;
			}
			
			if(ySpeed > maxSpeed)
			{
				ySpeed = maxSpeed;
			}
			else if(ySpeed < -maxSpeed)
			{
				ySpeed = -maxSpeed;
			}
		}
		
		public function getSpecate() : Boolean
		{
			return this.specate;
		}
		
		public function setSpecate(val:Boolean) : void
		{
			trace("Player.setSpecate new value: " + val);
			this.specate = val;
		}

		private function addedHandler(e:Event)
		{
			p = this.parent;
			xBounds = p.getXBounds();
			yBounds = p.getYBounds();
		}
		
		/**
		 * 
		 * @param	value to change
		 * @return TRUE if player health is below 0. else FASLE
		 */
		public function changeHealth(value:int) : Boolean
		{
			this.health += value;
			if (this.health > 0) return false;
			return true;
		}
		
		public function incrementKills():void
		{
			this.kills++;
		}
		
		public function getKills():int
		{
			return this.kills;
		}
		
		public function stopPlayer():void
		{
			trace("Stoppping the player");
			this.xSpeed = 0;
			this.ySpeed = 0;
		}
	
	}
	
}
