
abstract class BottomNavBarEvents {
  BottomNavBarEvents();
}

class ChangeBottomNavBarState extends BottomNavBarEvents {
  int newIndex;
  bool hide;
  

  ChangeBottomNavBarState(this.newIndex,this.hide) : super();
}
