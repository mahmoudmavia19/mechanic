import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechanic/screens/onboarding.dart';
import 'package:mechanic/widgets/custombtn.dart';

class DeactivateAccountPage extends StatefulWidget {
  const DeactivateAccountPage({super.key});

  @override
  _DeactivateAccountPageState createState() => _DeactivateAccountPageState();
}

class _DeactivateAccountPageState extends State<DeactivateAccountPage> {
  bool risk1Checked = false;
  bool risk2Checked = false;
  bool risk3Checked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to show a dialog to get the user's current password
  Future<String?> _showPasswordInputDialog() async {
    String? currentPassword;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Current Password'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password.';
                }
                return null;
              },
              onSaved: (value) {
                currentPassword = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            CustomBTN(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context, currentPassword);
                }
              },
              text:'Submit',
            ),
          ],
        );
      },
    );
    return currentPassword;
  }

  // Function to reauthenticate the user with their current password
  Future<void> _reauthenticateUser(String currentPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Reauthenticate the user
        await user.reauthenticateWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Show an error message for incorrect current password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect current password.'),
          ),
        );
      } else {
        // Handle other authentication errors
        print('Re-authentication failed: $e');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  // Function to deactivate the user's account
  Future<void> _deactivateAccount(context) async {
    // Check if all risks are confirmed
    if (!risk1Checked || !risk2Checked || !risk3Checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm all risks before deactivating your account.'),
        ),
      );
      return;
    }

    // Show the password input dialog and get the current password
    String? currentPassword = await _showPasswordInputDialog();

    if (currentPassword != null) {
      // Reauthenticate the user before deactivating the account
      await _reauthenticateUser(currentPassword);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Disable the user's account (this will sign the user out)
          await user.delete();

           await FirebaseAuth.instance.signOut();



          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account has been deactivated.'),
            ),
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OnBoarding(),), (route) => false);

         } on FirebaseAuthException catch (e) {
           print('Error deactivating account: $e');
        } catch (e) {
          // Handle other errors
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deactivate Account'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you sure you want to deactivate your account?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Risks of Deactivation:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: risk1Checked,
                    onChanged: (value) {
                      setState(() {
                        risk1Checked = value!;
                      });
                    },
                  ),
                  const Expanded(child: Text('- You will lose access to your account.')),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: risk2Checked,
                    onChanged: (value) {
                      setState(() {
                        risk2Checked = value!;
                      });
                    },
                  ),
                  const Expanded(child: Text('- You may lose any data associated with your account.')),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: risk3Checked,
                    onChanged: (value) {
                      setState(() {
                        risk3Checked = value!;
                      });
                    },
                  ),
                  const Expanded(child: Text('- You won\'t be able to recover your account.')),
                ],
              ),
              const SizedBox(height: 20),
              CustomBTN(
                onPressed: () {
                  _deactivateAccount(context);
                },
                text: 'Confirm Deactivation',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
