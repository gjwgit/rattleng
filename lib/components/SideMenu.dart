import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Text("SIDE MENU"),
            SizedBox(
              width: 180,
              child:
                SvgPicture.asset(
                  'assets/images/pod_indi.svg',
                  semanticsLabel: 'Rattle Logo'
                ),
            ),
          ],
        ),
      ),
    );
  }
}
