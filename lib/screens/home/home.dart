import 'package:flutter/material.dart';
import 'package:plant_it_forward/customWidgets/drawerScreen.dart';
import 'package:plant_it_forward/customWidgets/mainSection.dart';
import 'package:plant_it_forward/screens/home/homeScreen.dart';
import 'package:plant_it_forward/screens/home/price.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(
              selectedIndex: selectedIndex,
              onIndexChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              }),
          MainSection(
            selectedIndex: selectedIndex,
          )
          // Builder(builder: (context) {
          //   switch (selectedIndex) {
          //     case 0:
          //       return HomeScreen();
          //     case 1:
          //       return Price();
          //     default:
          //       return HomeScreen();
          //   }
          // })
        ],
      ),
    );
  }
}

// class Home extends StatelessWidget {
//   // final AuthService _auth = AuthService();
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           DrawerScreen(
//               selectedIndex: selectedIndex,
//               onIndexChanged: (int index) {
//                 setState(() {
//                   selectedIndex = index;
//                 });
//               }),
//           HomeScreen()
//         ],
//       ),
//       // appBar: AppBar(
//       //   title: Text('My app'),
//       //   elevation: 0.0,
//       //   actions: [
//       //     TextButton.icon(
//       //       onPressed: () async {
//       //         await _auth.signOut();
//       //       },
//       //       icon: Icon(Icons.person),
//       //       label: Text("logout"),
//       //       style: TextButton.styleFrom(primary: Colors.white),
//       //     )
//       //   ],
//       // ),
//     );
//   }
// }
