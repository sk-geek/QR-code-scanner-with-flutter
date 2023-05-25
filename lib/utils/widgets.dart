import 'package:flutter/material.dart';

import '../main.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your password',
            labelText: 'Password',
            icon: Icon(Icons.lock_open_outlined),
            errorText: isEmpty ? "This field is required" : null,
          ),
          obscureText: true,
          onChanged: (String value) {
            if (value == '') {
              setState(() {
                isEmpty = true;
              });
            } else {
              setState(() {
                isEmpty = false;
              });
            }
            password = value;
          }),
    );
  }
}

class EmailInput extends StatefulWidget {
  const EmailInput({
    super.key,
  });

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: "email@provider.domain",
          label: Text('Email'),
          errorText: isEmpty ? "This field is required" : null,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          if (value == '') {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              isEmpty = false;
            });
          }
          email = value;
        },
      ),
    );
  }
}

class PasswordConfirmInput extends StatefulWidget {
  const PasswordConfirmInput({
    super.key,
  });

  @override
  State<PasswordConfirmInput> createState() => _PasswordConfirmInputState();
}

class _PasswordConfirmInputState extends State<PasswordConfirmInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Confirm Password",
          hintText: "Enter Password Again",
          icon: Icon(Icons.lock_outline),
          errorText: isEmpty ? "This field is required" : null,
        ),
        obscureText: true,
        onChanged: (value) {
          if (value == '') {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              isEmpty = false;
            });
            confirmedPassword = value;
          }
        },
      ),
    );
  }
}
