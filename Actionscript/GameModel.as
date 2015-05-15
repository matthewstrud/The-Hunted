package  {
	import flash.geom.Utils3D;
	import flash.media.SoundChannel;
	
	public class GameModel 
	{
		
		private var p = null;
		private var players : Array = new Array();
		private var projectiles : Array = new Array();
		private var thisPlayer : Player;
		private var playerName : String;
		private var playerSet : Boolean = false; //has the current player been set?
		var destroyed = new Laser3(); //New instance of the destroyed sound
		private var laser = new Laser(); //New instance of the laser sound
		var channel:SoundChannel = new SoundChannel(); //New soundchannel to hold the track
		public var gameover:endScreen;
		private var gameStarted:Boolean = false;

		public function GameModel(par : multiplayerManager) 
		{
			p = par;
		}
		
		public function update()
		{
			if(playerSet)
			{
				thisPlayer.update();
			}
			
			updateProjectiles();
		}
		
				
		public function setName(name : String)
		{
			playerName = name;
		}

		/*
		 * This has purpose of adding a new player to the model. 
		 * params m:String - Where m is expected to contain a message "!addPlayer [xPos] [yPos] [playerNum]"
		 */
		public function addPlayer(m : String) : Boolean
		{	
			trace("Add player message: " + m);
			//!addPlayer xPos yPos playerName
			var split:Array = m.split(" ");
			if(split.length > 0)
			{
				if(split[0] == "!addPlayer")
				{
					var found = false;
					
					//if (thisPlayer != null) {
					//	found = thisPlayer.getPlayerId == split[3] ? true:false;
					//	trace("Player is this player (" + thisPlayer.getPlayerId() + ")" + found);
					//}
					//check if the player exists allready
					for(var i = 0; i < players.length; i++)
					{
						if(split[3] == players[i].getPlayerId())
						{
							found = true;
							trace("Player is this player (" + players[i].getPlayerId() + ")" + found);
						}
					}
					if (this.players.length > 1) 
					{
						this.gameStarted = true;
					}
					if(found == false)
					{
						var tmpX:int = parseInt(split[1]);
						var tmpY:int = parseInt(split[2]);
						var tmpPlayer:Player = new Player(split[3]);
						var shipNum:int = parseInt(split[4]);
						tmpPlayer.setPosition(tmpX,tmpY); //0 rotation
						tmpPlayer.gotoAndStop(shipNum);
						trace("ship num is " + shipNum);
						
						//players.push(new Player(split[3],tmpX,tmpY,0));
						if (split[5] == "false" || tmpPlayer.getPlayerId() == playerName) 
						{
							players.push(tmpPlayer);
							p.addChild(tmpPlayer);
						}
						trace("new player id is: " + tmpPlayer.getPlayerId() + " Current Id is: " + playerName);
						if(tmpPlayer.getPlayerId() == playerName)
						{
							trace("adding this player");
							thisPlayer = tmpPlayer;
							thisPlayer.setCurrent();
							var tspecate:Boolean = true;
							if (split[5] == "false") tspecate = false;
							trace("Split is equal to " + tspecate);
							thisPlayer.setSpecate(tspecate);
							playerSet = true;
							found = true;
							trace("addPlayer, number in array: " + players.length);
							p.thehealth.x = tmpX-540;
							p.thehealth.y = tmpY-360; 
							p.setPosition(-tmpX+540, -tmpY+360);
							//p.addChild(tmpPlayer);
						}
						p.appendToChatArea("User Joined " + split[3]);
					}
				}
			}
			return found;
		}
		
		/*
		 * This has purpose of removing a player from the known model. 
		 * params mes:String - Where mes is expected to contain a message "!removePlayer [playerNum]"
		 * return Boolean - If success, retrun true. Else return false
		 */
		public function removePlayer(mes : String) : Boolean
		{
			var removed:Boolean = false;
			var split:Array = mes.split(" ");
			if(split.length > 0)
			{
				//Loop through the player the model knows about
				trace("Message is : " + mes);
				if (split[0] != "!di") 
				{
					p.appendToChatArea("User Left " + split[1]);
				}
				else if(thisPlayer.getPlayerId() == split[2])
				{
					trace("Incrementing kills");
					thisPlayer.incrementKills();
				}
				if (split[1] != playerName)
				{
					for(var i:int = 0; i < players.length; i++)
					{
						//If the player currently selected is the same as the player
						//being removed. Remove that player.
						if(players[i].getPlayerId() == split[1])
						{
							
							var tmp:Player = players[i];
							//projectiles.indexOf(miss)
							//trace("Player id's " + ", " + tmp.getPlayerId() + ", " + split[1]);
							//trace(players.indexOf(tmp));
							//players.splice(players.indexOf(tmp), 1);
							if(p.contains(players[i]))
							p.removeChild(players[i]);
							players.splice(i, 1);
							removed = true;
						}
					}
				}
				trace("The game started status " + gameStarted);
				if (players.length <= 1)
				{
					//thisPlayer.setSpecate(true);
					
					gameIsOver(true);
					gameStarted = false;
					p.broadcast("ov");
				}
			}
			return removed;
		}
		
		public function updatePlayer(m : String)
		{
			var split:Array = m.split(" ");
			if(split.length > 0)
			{
				if(split[0] == "!up")
				{
					//Loop through the player the model knows about
					for(var i:int = 0; i < players.length; i++)
					{
						//If the player currently selected is the same as the player
						//being updated. Send new values
						if (split[5] == true)
						{
							trace("This player is specating: " + players[i].getPlayerId());
							players.splice(i, 1);
						}
						else if(players[i].getPlayerId() == split[4] && split[4] != playerName)
						{
							players[i].setPosition(int(split[1]), int(split[2]));
							players[i].rotation = parseInt(split[3]);
						}
					}
				}
			}
		}
		
		public function createProjectile(m : String)
		{
			trace(m);
			
			var split:Array = m.split(" ");
			
			if(split[0] == "!f")
			{
				//create a new missle
				var tmpX:int = parseInt(split[1]);
				var tmpY:int = parseInt(split[2]);
				var tmpR:int = parseInt(split[3]);
				var user:String = split[4];
				var lasNum:int = parseInt(split[5]);
				
				//trace("x is: " + tmpX + "y is: " + tmpY + "rotation is: " + tmpR);
				
				var tmpMissile : Missile = new Missile(tmpX, tmpY, tmpR, thisPlayer,user);
				tmpMissile.gotoAndStop(lasNum);
				
				projectiles.push(tmpMissile);
				p.addChild(tmpMissile);
				
				
				laserSound();
			}
		}
		
		private function updateProjectiles() : void
		{
			//if a missile exists
			if(projectiles.length > 0)
			{
				for(var i = 0; i < projectiles.length; i++)
				{
					projectiles[i].update();
				}
			}
		}
		
		public function createBomb(mes:String):void
		{
			trace(mes);
			
			var split:Array = mes.split(" ");
			
			if(split[0] == "!b")
			{
				//create a new missle
				var tmpX:int = parseInt(split[1]);
				var tmpY:int = parseInt(split[2]);
				var user:String = split[3];
				var lasNum:int = parseInt(split[4]);
				
				var tmpBomb : Bomb = new Bomb(tmpX, tmpY, tmpR, thisPlayer,user);
				tmpBomb.gotoAndStop(lasNum);
				
				projectiles.push(tmpBomb);
				p.addChild(tmpBomb);
				
				laserSound();
		}
		
		public function getPlayer() : Player
		{
			return thisPlayer;
		}
		
		public function getName() : String
		{
			return playerName;
		}
		
		public function getXBounds() : int
		{
			return p.stage.stageWidth;
		}
		
		public function getYBounds() : int
		{
			return p.stage.stageHeight;
		}
		
		public function removeMissile(miss : Missile)
		{
			if(projectiles.indexOf(miss) != -1)
			{
				p.removeChild(miss);
				projectiles.splice(projectiles.indexOf(miss),1);
			}
		}
		
		public function destroy(m : String)
		{
			var split:Array = m.split(" ");
			
			var us = split[1];
			
			
			removeMissileIndex(parseInt(split[3]));
			
			if(us == playerName)
			{
				if (this.thisPlayer.changeHealth(parseInt(split[5])))
				{
					p.sendNotificatoon(" " +thisPlayer.getPlayerId() + " was destoryed by " + split[6]);
					p.broadcast("!di " + this.thisPlayer.getPlayerId() + " " + split[6]);
					gameIsOver(false);
				}
				if(!thisPlayer.getSpecate())
					Health.changehealth(thisPlayer.getHealth());
			}
			else
			{
				for(var i:int = 0; i < players.length; i++)
				{
					if(players[i].getPlayerId() == us)
					{
						if (this.players[i].changeHealth(parseInt(split[5]))) 
						{						
							p.removeChild(players[i]);
						}
					}
				}
				destroysound();
			}

		}
		/*Function which will plays destroyed sound*/
		public function destroysound():void 
		{
			channel = destroyed.play(0,1);
		}
		
		public function laserSound():void 
		{
			channel = laser.play(0,1);
		}
		
		public function getThisSpecate():Boolean
		{
			if(this.thisPlayer != null)
			return this.thisPlayer.getSpecate();
			return false;
		}
		
		// This is flawed.
		public function getMissileIndex(miss:Missile) : int
		{
			return projectiles.indexOf(miss);
		}
		
		public function removeMissileIndex(integer : int) : void
		{
			p.removeChild(projectiles[integer]);
			projectiles.splice(integer, 1);
		}
		
		public function numOfPlayersLeft():int
		{
			return this.players.length;
		}
		
		public function getGameStarted():Boolean
		{
			return this.gameStarted;
		}
		
		public function appendOverScreen():void
		{
			if (!this.p.contains(endScreen))
			{
				p.addChild(endScreen);
			}
		}
		
		private function gameIsOver(val:Boolean):void
		{
			thisPlayer.setSpecate(true);
			gameover = new endScreen(p, val);
			gameover.x = -p.x;
			gameover.y = -p.y;
			gameover.visible = true;
			p.addChild(gameover);
			p.setMovement(false);	
		}
	}
	
}
