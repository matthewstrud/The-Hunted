package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.globalization.LastOperationStatus;
	import flash.events.KeyboardEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Main extends MovieClip 
	{
		
		private var currentScreen:Screen;
		private var menu:menuScreen;
		private var settings:settingsScreen;
		private var multiplayer:multiplayerManager;
		private var singlePlayer:gameInstance;
		public static var shipNum : int = 0;
		public static var lasNum : int = 0;
		var backingtrack = new Theme(); //New instance of the hit ground sound
		var channel:SoundChannel = new SoundChannel(); //New soundchannel to hold the track
		
		
		public function Main() 
		{
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			trace("creating menu screen");
			menu = new menuScreen();
			currentScreen = menu;
			addChild(currentScreen);
			this.playtheme();
			
		}
		
		private function update(e : Event) : void
		{
			currentScreen.update();
		}
		
		private function keyDown(e : KeyboardEvent) : void
		{
			if(currentScreen == multiplayer)				
			{
				multiplayer.event(e);
			}
		}
		
		private function keyUp(e : KeyboardEvent) : void
		{
			if(currentScreen == multiplayer)
			{
				multiplayer.event(e);
			}
		}
		
		public function mm() : void
		{
			multiplayer = new multiplayerManager(shipNum, lasNum);
			removeChild(currentScreen);
			currentScreen = multiplayer;
			addChild(currentScreen);
		}
		/*Function which will plays backing track*/
		public function playtheme():void {
				channel = backingtrack.play(0,9999);
				channel.soundTransform = new SoundTransform(0.75); // Sets the volume to 40%
		 }
	}
	
}
