import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController usernameController;

  const UsernameField({Key? key, required this.usernameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
      children: [
        Text(
          'Username',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.07),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter username',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailField({Key? key, required this.emailController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
      children: [
        Text(
          'Email',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.07),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter email',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
final TextEditingController passwordController;

const PasswordField({Key? key, required this.passwordController})
    : super(key: key);

@override
_PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
bool _isPasswordVisible = false;

@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Password',
style: TextStyle(
color: Theme.of(context).colorScheme.onBackground,
fontWeight: FontWeight.normal,
fontSize: 16,
),
),
const SizedBox(height: 10),
TextField(
obscureText: !_isPasswordVisible,
controller: widget.passwordController,
decoration: InputDecoration(
hintText: '******',
hintStyle: TextStyle(
color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
fontSize: 14,
),
filled: true,
fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.07),
contentPadding:
const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(8.0),
borderSide: BorderSide.none,
),
suffixIcon: IconButton(
icon: Icon(
_isPasswordVisible ? Icons.visibility : Icons.visibility_off,
color: Theme.of(context).iconTheme.color,
),
onPressed: () {
setState(() {
_isPasswordVisible = !_isPasswordVisible;
});
},
),
),
),
],
);
}
}
