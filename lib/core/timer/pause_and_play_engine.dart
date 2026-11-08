class PlayButtonController {
  PlayButtonController();
  
  String playOrPause (bool mode){
    if (mode){
      return 'lib/assets/images/pause_btn.png';
    } 

    return 'lib/assets/images/play_btn.png';
  }
  
}