import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/home/home-screen.dart';

class CustomerDetailsPage extends StatelessWidget {
  final String mobileNumber;
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MMMM-dd");

  final TextEditingController dobTextEditingController =
      new TextEditingController();
  final Customer customer = new Customer();

  CustomerDetailsPage({this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is CustomerRegistrationSuccess) {
            ///update customer profile bloc state
            BlocProvider.of<CustomerProfileBloc>(context)
                .add(FetchCustomerProfile());

            BlocProvider.of<BottomNavBarBloc>(context)
                .add(ChangeBottomNavBarIndex(0));
            BlocProvider.of<LoginBloc>(context)..add(CheckLoginStatus());
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar:
              BlocBuilder<LoginBloc, LoginStates>(builder: (context, state) {
            if (state is LoginInProgress)
              return LinearProgressIndicator();
            else
              return Container(
                height: 0,
              );
          }),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 38,
                left: 32,
                right: 32,
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      "Please help us with few basic details",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Full Name",
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Enter Your Name";
                          else {
                            customer.fullName = value;
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: mobileNumber,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Enter Your Name";
                          else {
                            customer.phoneNumber = value;
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: DateTimeField(
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1960),
                              initialDate:
                                  currentValue ?? DateTime.parse('2010-12-31'),
                              lastDate: DateTime.parse('2010-12-31'));
                        },
                        validator: (value) {
                          customer.dob = value;

                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ButtonTheme(
                        height: 48,
                        minWidth: MediaQuery.of(context).size.width - 48,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(05)),
                        child: RaisedButton(
                          onPressed: () {
                            handleNext(context);
                          },
                          child: Text("NEXT"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

//  void _showDatePicker(context) {
//    DatePicker.showDatePicker(
//      context,
//      onMonthChangeStartWithFirstDate: true,
//      pickerTheme: DateTimePickerTheme(
//        //   showTitle: _showTitle,
//        confirm: Text('Done', style: TextStyle(color: Colors.amber)),
//      ),
//      minDateTime: DateTime.parse('1960-01-01'),
//      maxDateTime: DateTime.parse('2010-12-31'),
//      initialDateTime: DateTime.parse('2010-12-31'),
//      dateFormat: 'yyyy-MMMM-dd',
//      locale: DateTimePickerLocale.en_us,
//      onClose: () => print("----- onClose -----"),
//      onCancel: () => print('onCancel'),
//      onChange: (dateTime, List<int> index) {
//        dobTextEditingController.text =
//            new DateFormat('yyyy-MM-dd').format(dateTime);
//      },
//      onConfirm: (dateTime, List<int> index) {
//        dobTextEditingController.text =
//            new DateFormat('yyyy-MM-dd').format(dateTime);
//        customer.dob = dateTime.toString();
//      },
//    );
//  }

  void handleNext(context) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context)
          .add(RegisterCustomer(customer: customer));
    }
  }
}
