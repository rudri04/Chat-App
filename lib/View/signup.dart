import 'package:chat_app/Widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final firebase = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey =GlobalKey<FormState>();
    var _isLogin =true;
    var _enteredEmail = '';
    var _enteredPassword ='';
    void _submit() async{

      final isValid = formKey.currentState!.validate();

      if(!isValid){
        return;
      }

      formKey.currentState!.save();

      try{
        if(_isLogin) {
          final userCredential = await firebase.signInWithEmailAndPassword
            (email: _enteredEmail, password: _enteredPassword);
        }
        else {
          final userCredential = await firebase
              .createUserWithEmailAndPassword
            (email: _enteredEmail, password: _enteredPassword);
        }
      } on FirebaseAuthException
      catch(e){
        Get.snackbar('Alert','${e.message}' ?? 'Authentication Failed');
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset('Assets/Images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          if(!_isLogin)
                            const UserImagePicker(),

                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value){
                                _enteredEmail = value!;
                              },
                              validator: (value){
                                if(value == null ||
                                    value.trim().isEmpty||
                                    !value.contains('@')){
                                  return 'Please Enter valid E-Mail Address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'E-Mail Address'
                              ),
                            ),


                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onSaved: (value){
                              _enteredPassword = value!;
                            },
                            validator: (value){
                              if(value == null ||
                                  value.trim().length < 6){
                                return 'Password must be 6 character long';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Password'
                            ),
                          ),

                          const SizedBox(height: 10,),

                          ElevatedButton(onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer
                              ),
                              child: Text( _isLogin ? 'Log In' : 'Sign Up')),


                          TextButton(onPressed: (){
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                          }, child: Text(_isLogin ? 'Create an account' : 'I already have an account!! LogIn',style: const TextStyle(fontSize: 17),))

                        ],
                      ),

                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
