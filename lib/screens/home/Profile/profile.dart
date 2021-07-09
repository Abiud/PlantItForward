import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

class Profile extends StatefulWidget {
  final UserData profile;

  const Profile({Key? key, required this.profile}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  File? _imageFile;

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("setting file");
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToFirebase(BuildContext context) async {
    if (_imageFile == null) return null;
    String fileName = basename(_imageFile!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(Provider.of(context)!.auth.currentUser.id)
        .child(fileName);
    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(_imageFile!);
    String? downloadUrl;
    taskSnapshot.ref.getDownloadURL().then((value) => downloadUrl = value);
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'profile', // a different string for each navigationBar
        transitionBetweenRoutes: false,
        leading: CupertinoNavigationBarBackButton(),
        middle: Text("Profile"),
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          child: !loading
              ? Icon(Icons.save)
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
                editProfile(context).then((val) async {
                  setState(() {
                    loading = false;
                  });
                });
              }
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 300,
                                width: 300,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: _imageFile != null
                                      ? Image.file(_imageFile!)
                                      : IconButton(
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            size: 50,
                                          ),
                                          onPressed: pickImage,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: fieldContentPadding,
                          enabledBorder: fieldEnabledBorder,
                          focusedBorder: fieldFocusedBorder,
                          errorBorder: fieldErrorBorder,
                          labelText: 'Name',
                          hintText: "Name..."),
                      initialValue: widget.profile.name,
                      validator: (val) {
                        if (widget.profile.name!.length > 0) {
                          return null;
                        }
                        return "Title cannot be empty";
                      },
                      onChanged: (val) {
                        widget.profile.name = val;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future editProfile(context) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.profile.id);

    String? url = await uploadImageToFirebase(context);

    return await userDoc.update({"name": widget.profile.name, "photoUrl": url});
  }
}
