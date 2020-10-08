abstract class BottomNavBarStates {
  BottomNavBarStates();
}

class ChangeBottomNavBarIndexSuccess extends BottomNavBarStates {
  int index;

  ChangeBottomNavBarIndexSuccess(this.index) : super();
}
