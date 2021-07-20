import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/shared/shared_styles.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';
import 'package:plant_it_forward/widgets/provider_widget.dart';

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
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(Provider.of(context)!.auth.currentUser.id)
        .child("avatar")
        .child(fileName);
    await firebaseStorageRef.putFile(_imageFile!);
    String? downloadUrl;
    // await taskSnapshot.ref
    //     .getDownloadURL()
    //     .then((value) => downloadUrl = value);
    String? resImg = fileName.substring(0, fileName.indexOf("."));
    Reference resizeImg = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(Provider.of(context)!.auth.currentUser.id)
        .child("avatar")
        .child(resImg + "_200x200.webp");
    await Future.delayed(const Duration(seconds: 5), () {});
    await resizeImg.getDownloadURL().then((value) => downloadUrl = value);
    Provider.of(context)!.auth.currentUser.photoUrl = downloadUrl;
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
        },
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
                    child: widget.profile.photoUrl != null
                        ? CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.teal.shade100,
                            child: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    NetworkImage(widget.profile.photoUrl!)),
                          )
                        : Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: _imageFile == null
                                        ? AssetImage("assets/PIF-Logo_3_5.webp")
                                        : Image.file(_imageFile!).image,
                                    fit: BoxFit.cover)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: _imageFile == null
                                  ? IconButton(
                                      icon: Icon(Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.black.withAlpha(100)),
                                      onPressed: pickImage,
                                    )
                                  : null,
                            ),
                          ),
                  ),
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
}
