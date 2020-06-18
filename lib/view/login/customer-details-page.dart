import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/login-controller.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/home/main-page.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String mobileNumber;

  CustomerDetailsPage({this.mobileNumber});

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dobTextEditingController = new TextEditingController();
  Customer customer = new Customer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is CustomerRegistrationSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }

          /*    else if (state is CustomerRegistrationError) {
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }*/
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
                            customer.name = value;
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: widget.mobileNumber,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Enter Your Name";
                          else {
                            customer.mobileNumber = value;
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new TextFormField(
                        showCursor: true,
                        readOnly: true,
                        controller: dobTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "DOB",
                        ),
                        onTap: () {
                          _showDatePicker();
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return "Choose Your DOB";
                          else {
                            return null;
                          }
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
                          color: Color(0xFF2A2E43),
                          onPressed: () {
                            handleNext();
                          },
                          child: Text("NEXT",
                              style: TextStyle(color: Color(0xFFF4E600))),
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

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        //   showTitle: _showTitle,
        confirm: Text('Done', style: TextStyle(color: Colors.amber)),
      ),
      minDateTime: DateTime.parse('1960-01-01'),
      maxDateTime: DateTime.parse('2010-12-31'),
      initialDateTime: DateTime.parse('2010-12-31'),
      dateFormat: 'yyyy-MMMM-dd',
      locale: DateTimePickerLocale.en_us,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        dobTextEditingController.text =
            new DateFormat('yyyy-MM-dd').format(dateTime);
      },
      onConfirm: (dateTime, List<int> index) {
        dobTextEditingController.text =
            new DateFormat('yyyy-MM-dd').format(dateTime);
        customer.dob = dateTime.toString();
      },
    );
  }

  void handleNext() {
    if (_formKey.currentState.validate()) {
       BlocProvider.of<LoginBloc>(context).add(RegisterCustomer(
       customer: customer));
    }
  }
}
