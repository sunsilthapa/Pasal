import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/Item_model.dart';

class FAQsScreen extends StatefulWidget {
  @override
  _FAQsScreenState createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text('FAQs'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: itemData.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionPanelList(
              animationDuration: Duration(milliseconds: 1000),
              dividerColor: Colors.red,
              elevation: 1,
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  body: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          itemData[index].discription,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              letterSpacing: 0.3,
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        itemData[index].headerItem,
                        style: TextStyle(
                          color: itemData[index].colorsItem,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  isExpanded: itemData[index].expanded,
                )
              ],
              expansionCallback: (item, status) {
                setState(() {
                  itemData[index].expanded = !itemData[index].expanded;
                });
              },
            );
          },
        ),
      ),
    );
  }

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      headerItem: 'What is HamroPasal',
      discription:
          "HamroPasal is a online platform to sell clothes of different categories.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: 'What are the services provided by HamroPasal',
      discription:
          "1. Buy clothes online.  2. Categoreis of clothers.  3. Password reset",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: 'How can I register Hamropasal?',
      discription:
          "HamroPasal is a online platform to sell clothes of different categories.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' How to order/ buy?',
      discription:
          "1.This was probably the most popular question asked by people.2.Although we put a how to buy/ order tutorial button on. 3.every single product page with detailed step by step. 4.walk-through as well as video, yet that didn’t stop. 5.the customers from asking the question. As I have said earlier, Malaysian people were not used to the concept of e-shopping. They just simply hand over the money and get their choice of product. So, putting a lot of details and completing a set of steps for e-shopping seemed a bit hassling to them.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' Can orders be placed using Hamropasal App?',
      discription:
          "Yes, Orders can be place with Hamropasal app.D-Force has to educate the customer first on how to use the app then provide them with a link and ask them to make purchase/download app from the given link.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' Order procedure?',
      discription:
          "Download Hamropsaal app in your phone or log in from website.  1. Select any category you want to shop from. 2. Open the product that you want to purchase 3. Add to cart 4. Click checkout 5.Add your details (name, contact number, address etc.)Select the payment optionClick submitYour order has been placed and will be delivered to your doorstep within 3-10 days.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem:
          'Is it important for me to educate the customer before placing order? ',
      discription:
          " Yes, it is essential that you first educate your customer and tell them how to place the order, how to change the order, and how to return it as well. You have to guide them properly because the better you guide and convince them, the greater is the chance of them making purchase from Daraz.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' Why my orders get canceled?',
      discription:
          "Orders get canceled because of following reasons:Cancelation from customer side.Product is out of stock.System recognizes it as a fraud order.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' Why my orders get canceled?',
      discription:
          "Orders get canceled because of following reasons:Cancelation from customer side.Product is out of stock.System recognizes it as a fraud order.",
      colorsItem: Colors.black,
    ),
    ItemModel(
      headerItem: ' Why my orders get canceled?',
      discription:
          "Orders get canceled because of following reasons:Cancelation from customer side.Product is out of stock.System recognizes it as a fraud order.",
      colorsItem: Colors.black,
    ),
  ];
}
