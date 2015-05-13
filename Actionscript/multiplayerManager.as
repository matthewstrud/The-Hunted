package  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.display.FocusDirection;
	
	
	public class multiplayerManager extends Screen 
	{
		
		private var cm : ConnectionManager;
		private var m : GameModel;
		private var gc : gameController;
		private var userName : String = "";
		private var roomName : String = "room";
		private var changed : Boolean = true;
		private var shipNum : int = 0;
		private var lasNum : int = 0;
		public static var frame :String = "darkness";
		
		//private var healthField:TextField;
		private var chatarea:TextField;
		private var chatbox:TextField;
		
		private var speed : int = 1;
		//private static 
		public function multiplayerManager(sn:int , ls:int) 
		{
			trace("sent variable is: " + sn);
			shipNum = sn;
			lasNum = ls;
			
			trace("shipNum mm is: " + shipNum);
			
			/*create a random name to be used as the user name
			this is the primary place where this needs to be changed
			however a method will be made later in order to change
			this based upon the users choice in the log in screen
			*/
			userName = Math.ceil((Math.random() * 100)).toString();
			
			m = new GameModel(this);
			cm = new ConnectionManager(this);
			
			cm.connect(userName, roomName);
			m.setName(userName);
			gc  = new gameController(this);
			addChat();
			//this.healthField = new TextField();
			//var tmp:Player = m.getPlayer();
			//this.healthField.text = "hello";
			//this.healthField.text = toString(tmp.getHealth());
			//this.healthField.textColor = 0xFFFFFF;
			//addChild(this.healthField);
			//cm.broadcast("!addPlayer 100 100 " + m.getName() + " " + shipNum);
			
			var updateTimer:Timer = new Timer(10);
			updateTimer.addEventListener(TimerEvent.TIMER, updateTimerListener);
			updateTimer.start();
		}
		
		override public function update()
		{
			gotoAndStop(frame);
			thehealth.update();
			gc.update();
			m.update();
			
			moveTextField();
			
			//trace("Current spectate: " +  m.getPlayer().getSpecate());
			
			//var temp : Player = m.getPlayer();
			//var tempX = temp.x;
			//var tempY = temp.y;
			//var rot = temp.rotation;
			
		}
		
		private function moveTextField()
		{
			//this.healthField.x = -x+10;
			//this.healthField.y = -y + 10;
			
			this.chatbox.x = -x;
			this.chatbox.y = -y + ((getYBounds()/4) -30);
			
			this.chatarea.x = -x;
			this.chatarea.y = -y + ((getYBounds()/4) -100);
		}
		
		public function message(message : String) : void
		{
			//trace("DEBUG - Message received: " + message);
			
			//contains either...
			if(message.indexOf("!addPlayer") >= 0)
			{
				//prevents the player responding to something that already exists
				if(!m.addPlayer(message))//returns true if its its own message or the player was already found
				{
					//make this shorter or multiple lines
					cm.broadcast("!addPlayer " + m.getPlayer().x.toString() + " " + m.getPlayer().y.toString() + " " + m.getPlayer().getPlayerId().toString() + " " + shipNum + " " + m.getThisSpecate()); //add this player to the new client
				}
				
			}
			else if(message.indexOf("!up") >=0)
			{
				//trace("update");
				m.updatePlayer(message);
				
			}
			else if(message.indexOf("!removePlayer") >=0)
			{
				m.removePlayer(message);
			}
			
			if(message.indexOf("!f") >=0)
			{
				m.createProjectile(message);
			}
			
			if(message.indexOf("!des") >=0)
			{
				m.destroy(message);
			}
			else if (message.indexOf("!m") >= 0)
			{
				appendToChatArea(message);
			}
			if (message.indexOf("!di") >= 0)
			{
				m.removePlayer(message);
			}
		}
		
		/*
		 * 1 - left, 2 - down, 3 - right, 4 - up
		 */
		public function move(move : int) : void 
		{
				
			trace("entered move");
			var temp : Player = m.getPlayer();
			var tempX = temp.x;
			var tempY = temp.y;
			
			//move based upon rotation
			
			//trace("BEUG - Movement request recieve: " + move);
			if(move == 1) //left
			{
				//tempX = tempX - speed;
				//temp.x -= speed;
				//temp.addXSpeed(-speed);
				temp.rotate(-1);
			}
			else if(move == 2) //down
			{
				//tempY = tempY + speed;
				//temp.y += speed;
				temp.moveDir(-1);
			}
			else if(move == 3) //right
			{
				//tempX = tempX + speed;
				//temp.x += speed;
				//temp.addXSpeed(speed);
				temp.rotate(1);
			}
			else if(move == 4) //up
			{
				//tempY = tempY - speed;
				//temp.y -= speed;
				//temp.addYSpeed(-speed);
				temp.moveDir(1);
			}
			
			//broadcast the players positon to the other players
			//cm.broadcast("!updatePlayer " + tempX + " " + tempY + " " + userName);
		}
		
		//message passed on from the controller to fire weapon
		public function fire()
		{
			if (!m.getPlayer().getSpecate()) 
			{				
				var temp : Player = m.getPlayer();
				//get the players rotation (players rotation is equal to the missiles rotation)
				var rot = temp.rotation;
				//get the position (position is equal to the players original position)
				var xPos = temp.x;
				var yPos = temp.y;
				
				trace(rot);
				
				cm.broadcast("!f " + xPos + " " + yPos + " " + rot + " " + userName + " " + lasNum);
			}
		}
		
		//send position updates to the other players
		public function updateTimerListener(e:TimerEvent) : void
		{
				
			var temp : Player = m.getPlayer();
			if (temp != null) 
			{
				//get the players rotation (players rotation is equal to the missiles rotation)
				var rot = temp.rotation;
				//get the position (position is equal to the players original position)
				var tempX = temp.x;
				var tempY = temp.y;
				var specate = temp.getSpecate();
				//trace("Player: " + userName + " is " + specate);
			}
			
			//optomisation, dont need to update if not moved
			if(changed == true)
			{
				cm.broadcast("!up " + tempX + " " + tempY + " " + rot + " " + userName + " " + specate);
				changed = false;
			}
		}
		
		public function setPosition(tmpX:int, tmpY:int):void
		{
			this.x = tmpX;
			this.y = tmpY;
		}

		public function event(e : KeyboardEvent) : void
		{
			gc.event(e);
		}
		
		public function getXBounds() : int
		{
			return stage.stageWidth * 4;
		}
		
		public function getYBounds() : int
		{
			return stage.stageHeight * 4;
		}
		
		public function setChanged(b : Boolean)
		{
			changed = b;
		}
		
		public function destroy(miss : Missile)
		{
			cm.broadcast("!des " + userName + " " + m.getMissileIndex + " " + "-1" + " " + miss.getPlayerName()); 
			// the last value "-1" is temperory and denotes damage.
		}
		
		public function getShipNum() : String
		{
			return shipNum.toString();
		}
		
		public function removeMissile( miss : Missile)
		{
			m.removeMissile(miss);
		}
		
		private function addChat():void
		{
			chatarea = new TextField();
			chatarea.name = "chatarea"; //get child by name
			chatarea.width = this.width;
			//chatarea.height = 10;
			chatarea.height = 60;
			chatarea.wordWrap = true;
			chatarea.selectable = false;
			
			var chatFormat:TextFormat = new TextFormat();
			chatFormat.size = 14;
			//var chatFont:Font = new Font();
			//chatFormat.font = chatFont;
			chatFormat.color = 0xffff00;
			
			chatarea.defaultTextFormat = chatFormat;
			
			chatbox = new TextField();
			chatbox.name = "chatbox";
			this.chatbox.width = this.width;
			//this.chatbox.height = 10
			this.chatbox.wordWrap = false;
			this.chatbox.selectable = true;
			this.chatbox.type = TextFieldType.DYNAMIC;
			this.chatbox.alwaysShowSelection = true;
			
			this.chatbox.defaultTextFormat = chatFormat;
			
			this.chatarea.text = "";
			this.chatbox.text = "";
			
			addChild(chatarea);
			addChild(chatbox);
			//this.stage.focus = this.chatbox;//stage.focus = this.chatbox;
		}
		
		public function setChatType(type:int):void
		{
			if (type == 1) 
			{
				this.chatbox.type = TextFieldType.INPUT;
				this.focusRect = this.chatbox;
			}
			else 
				this.chatbox.type = TextFieldType.DYNAMIC;
		}
		
		public function appendToChatArea(m:String):void
		{
			var split:Array = m.split(" ");
			var toAppend:String = "";
			for (var k = 0; k < split.length; k++)
				trace(split[k]);
			toAppend += split[1] + ": ";
			for (var i:int = 2; i < split.length; i++)
			{
				toAppend += split[i] + " ";
			}
			toAppend += "\n";
			this.chatarea.appendText(toAppend);
			this.chatarea.scrollV = this.chatarea.maxScrollV;
		}
		
		public function setChatBox(mes:String):void
		{
			this.chatbox.text = mes;
		}
		
		public function sendMessage():void
		{
			cm.broadcast("!m " + m.getName() + " " + this.chatbox.text);
		}
		
		public function broadcast(mes:String):void
		{
			cm.broadcast(mes);
		}
		
		public function sendNotificatoon(mes:String):void
		{
			cm.broadcast("!m " + mes);
		}
		
		public function getSpecate():Boolean
		{
			return m.getThisSpecate();
		}
		
		public static function battlearena(type:Boolean):void {
			if (type == true) {
				frame = "lightness";
			}
			else if (type == false) {
				frame = "darkness";
			}
		}
	
}
}