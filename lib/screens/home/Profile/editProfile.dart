import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/config.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final UserData profile;

  const EditProfile({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
    FirebaseStorage storage = FirebaseStorage.instance;
    String uid = widget.profile.id;
    Reference firebaseStorageRef =
        storage.ref().child("users").child(uid).child("avatar").child(fileName);
    await firebaseStorageRef.putFile(_imageFile!);
    String? downloadUrl;
    String? resImg = fileName.substring(0, fileName.indexOf("."));
    Reference resizeImg = storage
        .ref()
        .child("users")
        .child(uid)
        .child("avatar")
        .child(resImg + "_200x200.webp");
    await Future.delayed(const Duration(seconds: 5), () {});
    await resizeImg.getDownloadURL().then((value) {
      downloadUrl = value;
      if (widget.profile.photoUrl != null)
        storage.refFromURL(widget.profile.photoUrl!).delete();
    });
    widget.profile.photoUrl = downloadUrl;
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/pattern.png"),
                ),
                Positioned(
                  bottom: -60.0,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                      child: Stack(
                        children: [
                          displayProfilePic(),
                          Positioned(
                              right: 0.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: pickImage,
                              )),
                        ],
                      )),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                            if (widget.profile.name.length > 0) {
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
        FirebaseFirestore.instance.collection('users').doc(widget.profile.id);

    String? url = await uploadImageToFirebase(context);

    if (url != null) {
      return await userDoc
          .update({"name": widget.profile.name, "photoUrl": url});
    }

    return await userDoc.update({"name": widget.profile.name});
  }

  Widget displayProfilePic() {
    if (widget.profile.photoUrl != null) {
      if (_imageFile == null)
        return CircleAvatar(
          radius: 85,
          backgroundColor: Colors.teal.shade100,
          child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(widget.profile.photoUrl!)),
        );
    }
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: _imageFile == null
                  ? AssetImage("assets/PIF-icon.png")
                  : Image.file(_imageFile!).image,
              fit: BoxFit.cover)),
    );
  }
}
