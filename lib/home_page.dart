//import 'dart:html';

import 'package:apiproject/constants.dart';
import 'package:apiproject/webpage.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle kstyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
  );

  String k;
  int searched = 0;
  var decodedData;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  void getData(String q) async {
    //print(q);
    String nurl;

    nurl =
        'https://developers.zomato.com/api/v2.1/search?q=$q&lat=17.3850&lon=78.4867&sort=rating&order=desc';

    var response = await http.get(
      Uri.encodeFull(nurl),
      headers: {
        'user-key': '2d780119ab27fe83895d47260cdd6367',
        "Accept": "application/json",
      },
    );
    //print()
    this.setState(() {
      var result = convert.jsonDecode(response.body);

      decodedData = result;
      searched = 1;
      loading = false;
      //print(decodedData);
    });
    // print(decodedData);
  }

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Center(
              child: Text(
            'Flutter Restaurants',
            style: TextStyle(
              color: errorStateLightRed,
            ),
          )),
        ),
        body: loading == true
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Text(
                        'Welcome Harsha !',
                        style: kstyle,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('Search your favourite food in Hyderabad !'),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: 400.0,
                      //margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Enter your favourite food'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text('| '),
                          ),
                          IconButton(
                              color: errorStateBrightRed,
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                getData(controller.text);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    searched == 0
                        ? Flexible(
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 100.0, left: 30.0),
                              child: Center(
                                child: Image.network(
                                    'https://images.news18.com/ibnkhabar/uploads/2019/12/food-1.jpg?impolicy=website&width=459&height=306'),
                              ),
                            ),
                          )
                        : Restaurant(
                            decodedData: decodedData,
                          )
                  ],
                ),
              ),
      ),
    );
  }
}

class Restaurant extends StatelessWidget {
  var decodedData;
  Restaurant({@required this.decodedData});
  @override
  Widget build(BuildContext context) {
    return decodedData.length == null
        ? Container()
        : Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    decodedData == null ? 0 : decodedData['results_shown'],
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 410.0,
                      height: 222.0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return WebPage(
                                  url: decodedData['restaurants'][index]
                                      ['restaurant']['url'],
                                );
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 20.0,
                                  left: 30.0,
                                  right: 20.0,
                                  bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 15),
                                      blurRadius: 27,
                                      color: Colors.black12,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(35.0)),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200.0,
                                        child: Text(
                                          decodedData['restaurants'][index]
                                              ['restaurant']['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        width: 150.0,
                                        child: Text(decodedData['restaurants']
                                                [index]['restaurant']
                                            ['location']['locality']),
                                      ),
                                      SizedBox(
                                        height: 23.0,
                                      ),
                                      Container(
                                        width: 150,
                                        child: Text(
                                          'Cost for two : ' +
                                              ' ' +
                                              decodedData['restaurants'][index]
                                                          ['restaurant']
                                                      ['average_cost_for_two']
                                                  .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        child: decodedData['restaurants'][index]
                                                    ['restaurant']['thumb']
                                                .isNotEmpty
                                            ? Image.network(
                                                decodedData['restaurants']
                                                        [index]['restaurant']
                                                    ['thumb'],
                                                height: 100.0,
                                                width: 100.0,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                'https://pro-comm-online.com/wp-content/uploads/2019/11/not-available.jpg',
                                                height: 100.0,
                                                width: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      SizedBox(
                                        height: 9.0,
                                      ),
                                      Text(
                                        'Rating :' +
                                            ' ' +
                                            decodedData['restaurants'][index]
                                                        ['restaurant']
                                                    ['user_rating']
                                                ['aggregate_rating'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
