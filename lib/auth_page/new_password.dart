import 'package:eyu_data_collection/auth_page/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eyu_data_collection/model/UserModel.dart';
import 'package:eyu_data_collection/DatabaseHandler/AuthDbHelper.dart';


class NewPassword extends StatefulWidget {
  const NewPassword({Key key}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final formKey = GlobalKey<FormState>();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  TextEditingController controlPassword = TextEditingController();
  TextEditingController controlConfPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Center(
                    child: Column(
                        children: [
                          Image.asset(
                            MediaQuery.of(context).platformBrightness ==
                                Brightness.light ? "assets/images/1.jpeg"
                                : 'assets/images/4.jpg',
                            height: 300,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10.0, right: 50.0,
                                left: 50.0, bottom: 10.0),
                            child: Column(
                                children: <Widget>[
                                  Text(
                                    "Updating Password",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Merriweather"
                                    ),),
                                  const SizedBox(height: 21.0,),
                                  buildTextFieldPassword(
                                      title: "Password",
                                      controller: controlPassword,
                                      autoHint: "*******",
                                      size: MediaQuery.of(context).size.width/1.4),
                                  SizedBox(height: 10.0,),
                                  buildTextFieldConfPassword(
                                      title: "Conform password",
                                      controller: controlConfPassword,
                                      autoHint: "*******",
                                      size: MediaQuery.of(context).size.width/1.4),

                                  SizedBox(height: 20.0,),

                                  Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      //SizedBox(width: 140,),
                                      FlatButton(
                                          color: Colors.lightBlue,
                                          onPressed: (){
                                            final isValid = formKey.currentState.validate();

                                            if (isValid) {
                                              update();
                                            }
                                          },
                                          child: Text("Update Password",
                                            style: TextStyle(color: Colors.white),)),
                                      SizedBox(height: 12.0,),
                                      FlatButton(
                                          color: Colors.grey[200],
                                          onPressed: (){
                                            Navigator.pop(context);
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AdminPage()))
                                          },
                                          child: Text("Cancel")),
                                    ],
                                  ),
                                ]),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }
  bool isHiddenPassword = true;

  Widget buildTextFieldPassword({
    @required title,
    @required TextEditingController controller,
    int maxLines =1,
    @required String autoHint,
    @required size,
    @required match
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size, child: TextFormField(
              obscureText: isHiddenPassword,
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: autoHint,
                prefixIcon: Icon(Icons.security),
                suffixIcon: InkWell(
                  onTap: _togglePassword,
                  child:isHiddenPassword ? Icon(
                    Icons.visibility,
                  ): Icon(Icons.visibility_off),
                ),),
              validator: (value) {
                if (value.length <= 7)
                  return "Your password must be >= 7 digit";
                else
                  return null;
              }
          ),
          )

        ],
      );

  bool isHiddenPassword1 = true;
  Widget buildTextFieldConfPassword({
    @required title,
    @required TextEditingController controller,
    int maxLines =1,
    @required String autoHint,
    @required size,
    @required match
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size, child: TextFormField(
              obscureText: isHiddenPassword1,
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: autoHint,
                prefixIcon: Icon(Icons.security),
                suffixIcon: InkWell(
                  onTap: _togglePasswordconf,
                  child:isHiddenPassword1 ? Icon(
                    Icons.visibility,
                  ): Icon(Icons.visibility_off),
                ),),
              validator: (value) {
                if (value.length <= 7 && value == controlPassword.text)
                  return "Your password didn't match together";
                else
                  return null;
              }
          ),
          )

        ],
      );

  void _togglePassword(){
    if(isHiddenPassword == true){
      isHiddenPassword = false;
    }
    else isHiddenPassword = true;
    setState(() {
      isHiddenPassword = isHiddenPassword;
    });
  }
  void _togglePasswordconf(){
    if(isHiddenPassword1 == true){
      isHiddenPassword1 = false;
    }
    else isHiddenPassword1 = true;
    setState(() {
      isHiddenPassword1 = isHiddenPassword1;
    });
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        actions: <Widget>[
          new FlatButton(
            child: Text('Exit'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LogInPage())
              );
            },
          ),
        ]
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog);
  }

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String user_id;
  String first_name;
  String Last_name;
  String password;

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      user_id = sp.getString("user_id");
      first_name = sp.getString("user_name");
      Last_name = sp.getString("email");
      password = sp.getString("password");
    });
  }

  update() async {
    String uid = user_id;
    String uname = first_name;
    String email = Last_name;
    String passwd = controlPassword.text;


    UserModel user = UserModel(uid, uname, email, passwd);
    await dbHelper.updateUser(user).then((value) {
      if (value == 1) {
        _showAlertDialog("Image Data Collection for AI",
            "Successfully Updated");

        updateSP(user, true).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LogInPage()),
                  (Route<dynamic> route) => false);
        });
      } else {
        _showAlertDialog("Image Data Collection for AI",
            "Error Update");
      }
    }).catchError((error) {
      print(error);
      _showAlertDialog("Image Data Collection for AI",
          "Error");
    });
  }

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name);
      sp.setString("email", user.email);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
    }
  }
}