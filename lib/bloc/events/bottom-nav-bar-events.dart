
abstract class BottomNavBarEvents {
  BottomNavBarEvents();
}

class ChangeBottomNavBarIndex extends BottomNavBarEvents {
  int index;

  ChangeBottomNavBarIndex(this.index) : super();
}
