/*
 * This has purpose of recording the relvant keypresses
 * so it can send the request to multiplayer manager using a 
 * method called "move" which takes in a string.
 */
package { 
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class gameController extends EventDispatcher{
		 
		private var manager:multiplayerManager;
		private var keysArray:Array = [];
		private var canFire:Boolean = true;
		
		private var movement:Boolean = true;
		private var isChatMode:Boolean;
		
		public function gameController(m:multiplayerManager) 
		{
			this.manager = m;
			
			//Timer for missiles
			var fireTimer:Timer = new Timer(50);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerListener);
			fireTimer.start();
			isChatMode = false;
		}

		/*
		 * Has a purpose of sending the movmement request to the multipler manager
		 */
		public function update():void
		{
			//Switch statements are as inefficent in AS
			//So I decided to use poor pratice of "if's
			
			/*I have imrpoved this by seperating verticle
			and horizontal movements, before it was not
			possible to move diagonally
			*/
			if(keysArray[Keyboard.LEFT])
			{
				if(!isChatMode && movement)
				manager.move(1);
			}
			else if(keysArray[Keyboard.RIGHT])
			{
				if(!isChatMode && movement)
				manager.move(3);
			}
			
			if(keysArray[Keyboard.DOWN])
			{
				if(!isChatMode && movement)
				manager.move(2);
			}
			else if(keysArray[Keyboard.UP])
			{
				if(!isChatMode && movement)
				manager.move(4);
			}
			
			if(keysArray[Keyboard.SPACE])
			{
				//ever half second
				if(canFire == true && !isChatMode && movement)
				{
					canFire = false;
					manager.fire();
					keysArray[Keyboard.SPACE] = false;
				}
			}
			if (keysArray[Keyboard.ENTER])
			{
				//Send text in chat room.
				if (isChatMode && movement)
				{
					manager.sendMessage();
					manager.setChatBox("");
				}
				isChatMode = false;
				manager.setChatType(0);
			}
			if (keysArray[Keyboard.ESCAPE])
			{
				isChatMode = false;
				manager.setChatType(0);
			}
			if (keysArray[Keyboard.T])
			{
				isChatMode = true;
				manager.setChatType(1);
			}
		}
		
		public function setMovement(val:Boolean):void
		{
			this.movement = val;
		}
		

		public function event(e:KeyboardEvent) : void
		{
			if(e.type == "keyDown")
			{
				keysArray[e.keyCode] = true;
			}
			else if(e.type == "keyUp")
			{
				keysArray[e.keyCode] = false;
			}
		}
		
		function fireTimerListener (e:TimerEvent):void
		{
			canFire = true;
		}
	}
}
	