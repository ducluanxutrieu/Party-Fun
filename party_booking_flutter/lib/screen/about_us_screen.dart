import 'package:flutter/material.dart';
import 'package:party_booking/src/constant.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AboutUsScreen> {
  // AccountModel _accountModel;
  String avatarUrl;
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    // _updateUserProfile();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
      ),

      //backgroundColor: Colors.green,
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "List of members",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SymptomCard(
                          image: "assets/images/avatar_dong.png",
                          title: "Trần Ngọc Quang Đông",
                          text: "17520561",
                          isActive: true,
                        ),
                        SymptomCard(
                          image: "assets/images/avatar_trung.png",
                          title: "Trần Đức Trung",
                          text: "17520561",
                        ),
                        SymptomCard(
                          image: "assets/images/avatar_luan.png",
                          title: "Trần Đức Luân",
                          text: "17520561",
                        ),
                        SymptomCard(
                          image: "assets/images/check.png",
                          title: "Phan Thị Thanh Hương",
                          text: "17520561",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Description", style: kTitleTextstyle),

                  PreventCard(
                    text: "Mr. Thai Huy Tan",
                    title: "School Master",
                  ),
                  PreventCard(
                    text: "NT114.K21",
                    //      image: "assets/images/wear_mask.png",
                    title: "Subject ID",
                  ),
                  PreventCard(
                    text: "PartyBooking là trang web giúp đặt tiệc online, giúp cho khách hàng có thể đơn giản hóa việc đặt một bữa tiệc "
                        "cho gia đình và bạn bè, mang lại sự dễ dàng nhất cho khách hàng muốn có những buổi tiệc thân mật bên người thân và gia đình.",
                    title: "Description",
                  ),
                  SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
//  final String image;
  final String title;
  final String text;

  const PreventCard({
    Key key,
    // this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green, //                   <--- border color
          width: 1.0,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 24,
            color: kShadowColor,
          ),
        ],
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: kTitleTextstyle.copyWith(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            maxLines: 100,
            //   overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ) ,
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final bool isActive;

  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, height: 2.5, letterSpacing: 1.0),
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
