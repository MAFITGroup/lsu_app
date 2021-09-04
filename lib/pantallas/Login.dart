import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/ui/input_decorations.dart';
import 'package:lsu_app/widgets/widgets.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 200),

              CardContainer(
                child: Column(
                  children: [
                    SizedBox( height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 30),

                    _LoginForm(),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text('Olvidaste la contrasena?', style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 50),
            ],
          ),
        )
      ),
    );
  }

}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context ){
    return Container(
      child: Form(

        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                labelText: 'e-mail',
                prefixIcon: Icons.alternate_email_rounded
              ),
              validator: (value){

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Formato de correo electronico valido';
              },
            ),

            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'contraseña',
                  prefixIcon: Icons.lock_outline
              ),
              validator: (value){

                return (value != null && value.length >= 8 )
                  ?null
                  : 'Formato de la contraseña no es valida';


              },
            ),

            SizedBox(height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Color.fromRGBO(0, 65, 116, 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text('Ingresar', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
              ),
              onPressed: (){})
          ],
        ),
      ),
    );
  }
}



