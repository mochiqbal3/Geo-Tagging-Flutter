import 'package:flutter/material.dart';
import 'package:geotagging/util/shared_pref.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool _passwordVisible = true;
  bool isLoading = false;
  bool isValidUsername = false;
  bool isValidPassword = false;
  @override
  void initState() {
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              color: Theme.of(context).accentColor,
              height: MediaQuery.of(context).size.height - 300,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(12.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                      ),
                      controller: _controllerUsername,
                      onChanged: (value)=>{
                        if(value.isNotEmpty){
                          this.setState((){
                            isValidUsername = true;
                          })
                        }else{
                          this.setState((){
                            isValidUsername = false;
                          })
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    child: TextFormField(
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        controller: _controllerPassword,
                        onChanged: (value){
                          if(value.isNotEmpty){
                            this.setState((){
                              isValidPassword = true;
                            });
                          }else{
                            this.setState((){
                              isValidPassword = false;
                            });
                          }
                        },
                        ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        onPressed: () {
                          if (!isLoading) {
                            if(isValid()){
                              setState(() {
                                isLoading = true;
                              });
                              SharedPrefs.storePref("username", 
                              _controllerUsername.text.toString());
                              SharedPrefs.storeBool("isLogin", true);
                              Navigator.pushReplacementNamed(context, "/home");
                            }                            
                          }else{
                            print("else");
                          }
                        },
                        textColor: switchTextColor(),
                        color: switchColorButton(),
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(validateText(),
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
  isValid(){
    if(_controllerUsername.text.toString() == ""){
      return false;
    }else if(_controllerPassword.text.toString() == ""){
      return false;
    }else{
      return true;
    }
  }
  validateText(){
    if(!isValidUsername){
      return "Blank Username";
    }else if(!isValidPassword){
      return "Blank Password";
    }else if(isLoading){
      return "Loading";
    }else {
      return "Login";
    }
  }
  switchColorButton(){
    if(isValidPassword && isValidUsername && !isLoading){
      return Theme.of(context).primaryColorDark;
    }else{
      return Theme.of(context).accentColor;
    }
  }
  switchTextColor(){
    if(isValidPassword && isValidUsername && !isLoading){
      return Theme.of(context).accentColor;
    }else{
      return Theme.of(context).primaryColorDark;
    }
  }
}
