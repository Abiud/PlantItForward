import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';

class EditUser extends StatefulWidget {
  final UserData user;
  EditUser({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing User"),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: FloatingActionButton.extended(
            backgroundColor: primaryGreen,
            elevation: 2,
            label: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            icon: !loading
                ? Icon(
                    Icons.save,
                    color: Colors.white,
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
            onPressed: () {
              if (!loading) {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    loading = true;
                  });
                  editProfile(context).then((val) {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Successfully updated!"),
                        duration: Duration(
                          seconds: 2,
                        )));
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "We couldn't update the data, please try again later."),
                        duration: Duration(
                          seconds: 3,
                        )));
                  });
                }
              }
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Image(
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/pattern.png"),
                ),
                Positioned(
                  bottom: -60.0,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                      child: displayProfilePic()),
                ),
              ],
            ),
            verticalSpaceLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Information",
                    style: TextStyle(
                        color: LightColors.kDarkBlue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2),
                  ),
                  verticalSpaceSmall,
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding: fieldContentPadding,
                              enabledBorder: fieldEnabledBorder,
                              focusedBorder: fieldFocusedBorder,
                              errorBorder: fieldErrorBorder,
                              labelText: 'Name',
                              hintText: "Name..."),
                          initialValue: widget.user.name,
                          validator: (val) {
                            if (widget.user.name.length > 0) {
                              return null;
                            }
                            return "Title cannot be empty";
                          },
                          onChanged: (val) {
                            widget.user.name = val;
                          },
                        ),
                        verticalSpaceMedium,
                        if (widget.user.isAdmin())
                          Row(
                            children: [
                              Text(
                                "Role: ",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 16),
                              ),
                              Text(
                                "admin",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        else
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                  contentPadding: fieldContentPadding,
                                  enabledBorder: fieldEnabledBorder,
                                  focusedBorder: fieldFocusedBorder,
                                  errorBorder: fieldErrorBorder,
                                  labelText: 'Role',
                                  hintText: "Farmer/Volunteer"),
                              value: widget.user.role,
                              onChanged: (val) {
                                widget.user.role = val.toString();
                              },
                              items: <String>[
                                'farmer',
                                'volunteer',
                              ].map<DropdownMenuItem<String>>((String e) {
                                return DropdownMenuItem<String>(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future editProfile(context) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.user.id);

    return await userDoc.update(widget.user.toMap());
  }

  Widget displayProfilePic() {
    if (widget.user.photoUrl != null) {
      return CircleAvatar(
        radius: 85,
        backgroundColor: Colors.teal.shade100,
        child: CircleAvatar(
            radius: 80, backgroundImage: NetworkImage(widget.user.photoUrl!)),
      );
    }
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage("assets/PIF-icon.png"), fit: BoxFit.cover)),
    );
  }
}
