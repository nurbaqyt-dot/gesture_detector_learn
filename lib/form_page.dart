import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const FormPage());

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _hideText = true;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _life = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  final _mainKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _countries = [
    "Kazakhstan",
    "Uzbekistan",
    "Spain",
    "France",
    "USA",
  ];

  String? _selectedCountry;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _life.dispose();
    _password.dispose();
    _confirm.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _changeFocus(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Registration Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _mainKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration:  InputDecoration(
                labelText: "Full Name",
                hintText: "Enter your name",
                prefixIcon: Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _name.clear();
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'),
                ),
              ],
              validator: _validateName,
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _changeFocus(context, _nameFocus, _phoneFocus);
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                hintText: "Enter your phone number",
                helperText: "Phone Number Format 8(XXX)XXX-XXXX",
                prefixIcon: Icon(Icons.phone),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _phone.clear();
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9()\- ]'),
                ),
                LengthLimitingTextInputFormatter(15),
              ],
              validator: _validateNumber,
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _changeFocus(context, _phoneFocus, _passFocus);
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email Address",
                hintText: "forexample@gmail.com",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: _validateEmail,
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Country",
                icon: Icon(Icons.map),
                border: OutlineInputBorder(),
              ),
              value: _selectedCountry,
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (data) {
                setState(() {
                  _selectedCountry = data;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Please select a country";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _life,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Life Story",
                hintText: "Type something about you",
                helperText: "Keep it short",
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _password,
              obscureText: _hideText,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.security),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hideText = !_hideText;
                    });
                  },
                  icon: Icon(
                    _hideText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validatePassword,
              focusNode: _passFocus,
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _confirm,
              obscureText: _hideText,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                hintText: "Type your password again",
                prefixIcon: Icon(Icons.border_color_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validateConfirmPassword,
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: controll,
              child: const Text(
                "Submit Form",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void controll() {
    if (_mainKey.currentState!.validate()) {
      _showDialog(name: _name.text);
      print("Form is valid");
      print("Name: ${_name.text}");
      print("Phone: ${_phone.text}");
      print("Email: ${_email.text}");
      print("Country: $_selectedCountry");
      print("Life Story: ${_life.text}");
      print("Password: ${_password.text}");
      print("Confirm Password: ${_confirm.text}");
    } else {
      _showMessage(message: "Form is not valid!");
    }
  }

  String? _validateName(String? value) {
    final nameExp = RegExp(r'^[a-zA-Z ]+$');

    if (value == null || value.isEmpty) {
      return "Name is required";
    } else if (!nameExp.hasMatch(value)) {
      return "Please enter alphabetical characters";
    }

    return null;
  }

  String? _validateNumber(String? value) {
    final exp = RegExp(r'^[\d()\- ]{1,15}$');

    if (value == null || value.isEmpty) {
      return "Number is required";
    } else if (!exp.hasMatch(value)) {
      return "Type number correctly";
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final expEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
    );

    if (value == null || value.isEmpty) {
      return "Email must be typed!";
    } else if (!expEmail.hasMatch(value)) {
      return "Type a valid Gmail address";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length != 8) {
      return "Password must contain 8 characters";
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    } else if (value != _password.text) {
      return "Password does not match";
    }

    return null;
  }

  void _showMessage({required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDialog({String? name}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text(
            "Registration is succesful",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "$name you just registered",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
