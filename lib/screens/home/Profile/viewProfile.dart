import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/shared/loading.dart';
import 'package:plant_it_forward/shared/ui_helpers.dart';
import 'package:plant_it_forward/theme/colors.dart';

class ViewProfile extends StatefulWidget {
  final UserData? profile;
  final String? userId;
  const ViewProfile({Key? key, this.profile, this.userId}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late Future<UserData> user;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  Future<UserData> getUser() async {
    if (widget.profile != null) return Future.value(widget.profile);
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
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: item.photoUrl != null
                                ? CircleAvatar(
                                    radius: 85,
                                    backgroundColor: Colors.teal.shade100,
                                    child: CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            NetworkImage(item.photoUrl!)),
                                  )
                                : Container(
                                    height: 160,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/PIF-Logo_3_5.webp"),
                                            fit: BoxFit.cover)),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              item.name!,
                              style: TextStyle(
                                color: LightColors.kDarkBlue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          verticalSpaceMedium,
                          Text(
                            "Information",
                            style: TextStyle(
                                color: LightColors.kDarkBlue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2),
                          ),
                          verticalSpaceSmall,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text("More info....")],
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
      },
    );
  }
}
