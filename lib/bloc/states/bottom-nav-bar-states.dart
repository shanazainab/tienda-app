abstract class BottomNavBarStates {
  BottomNavBarStates();
}

class ChangeBottomNavBarStatusSuccess extends BottomNavBarStates {
  int index;
  bool hide;

  ChangeBottomNavBarStatusSuccess(this.index, this.hide) : super();
}

class Initialize extends BottomNavBarStates {
  Initialize() : super();
}
