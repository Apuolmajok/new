import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/controllers/tab_index_controller.dart';
   
import 'package:sharecare/views/cart/cart_page.dart';
import 'package:sharecare/views/home/home_page.dart';

import 'package:sharecare/views/Donate/donate_page.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sharecare/views/profile/drawer.dart';
// import 'package:community_material_icon/community_material_icon.dart';


// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList =  const [
    HomePage(),
    DonatePage(),
    CartPage(),
    AppPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());

    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            pageList[controller.tabIndex],
            Align(
              alignment: Alignment.bottomCenter,
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: kPrimary),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.black38),
                  selectedIconTheme: const IconThemeData(color: kSecondary),
                  onTap: (value) {
                    controller.setTabIndex = value;
                  },
                  currentIndex: controller.tabIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: controller.tabIndex == 0
                          ? const Icon(AntDesign.appstore1)
                          : const Icon(AntDesign.appstore_o),
                      label: 'Home',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(MaterialCommunityIcons.hand_heart_outline),
                      label: 'Donate',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(MaterialIcons.history_edu),
                      label: 'History',
                      ),
                      
                 
                    BottomNavigationBarItem(
                      icon: controller.tabIndex == 3
                          ? const Icon(Ionicons.chatbubble_outline)
                          : const Icon(Ionicons.chatbubble_ellipses_outline),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
