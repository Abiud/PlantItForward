import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';

class EditUser extends StatefulWidget {
  final UserData? user;
  final String? userId;
  EditUser({Key? key, this.user, this.userId}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<UserData> user;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  Future<UserData> getUser() async {
    if (widget.user != null) return Future.value(widget.user);
    if (widget.userId != null) {
      late UserData data;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get()
          .then((value) => data = UserData.fromSnapshot(value))
          .onError((e, stackTrace) => Future.error(e.toString()));
      return data;
    }
    return Future.error("No user or Id provided");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              UserData item = snapshot.data!;
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
                            editProfile(context, item).then((val) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text("Successfully updated!"),
                                      duration: Duration(
                                        seconds: 2,
                                      )));
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
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
                                child: displayProfilePic(item)),
                          ),
                        ],
                      ),
                      verticalSpaceLarge,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
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
                                    initialValue: item.name,
                                    validator: (val) {
                                      if (item.name.length > 0) {
                                        return null;
                                      }
                                      return "Title cannot be empty";
                                    },
                                    onChanged: (val) {
                                      item.name = val;
                                    },
                                  ),
                                  verticalSpaceMedium,
                                  if (item.isAdmin())
                                    Row(
                                      children: [
                                        Text(
                                          "Role: ",
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16),
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
                                        value: item.role,
                                        onChanged: (val) {
                                          item.role = val.toString();
                                        },
                                        items: <String>[
                                          'farmer',
                                          'volunteer',
                                        ].map<DropdownMenuItem<String>>(
                                            (String e) {
                                          return DropdownMenuItem<String>(
                                            child: Text(e),
                                            value: e,
                                          );
                                        }).toList()),
                                  verticalSpaceMedium,
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        item.email!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
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
          }
        });
  }

  Future editProfile(BuildContext context, UserData item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(item.id);

    return await userDoc.update(item.toMap());
  }

  Widget displayProfilePic(UserData item) {
    if (item.photoUrl != null) {
      return CircleAvatar(
        radius: 85,
        backgroundColor: Colors.teal.shade100,
        child: CircleAvatar(
            radius: 80, backgroundImage: NetworkImage(item.photoUrl!)),
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
