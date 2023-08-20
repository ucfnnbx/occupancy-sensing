//import 'dart:html';

import 'package:flutter/material.dart';
import 'data.dart';
//import 'dart:io';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'globals.dart' as globals;
//import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      home: const MyHomePage(title: 'Occupancy Monitor'),
      //   routes: {
      //     'add': (context) {
      //       return AddPage();
      //     },
//"saved": (context){return Saved();},
      //   },
    );
  }
}

class AddPage extends StatefulWidget {
  final int index;
  AddPage(this.index);
  @override
  State<AddPage> createState() => AddPageState(index);
}

class AddPageState extends State<AddPage> {
  late int index;
  AddPageState(this.index);
  List<double> stringList1 = (globals.liveData1.cast<double>());
  List<double> stringList2 = (globals.liveData2.cast<double>());
  List<double> stringList3 = (globals.liveData3.cast<double>());
  @override
  void initState() {
    super.initState();
//print(index);
    // for (var j = 0; j < 10; j++) {
    //   print(stringList[j]);
    // }
    globals.features1 = [
      Feature(
        // title: "Occupancy",
        color: Colors.green,
        data: stringList1,
      ),
    ];
    globals.features2 = [
      Feature(
        // title: "Occupancy",
        color: Colors.yellow,
        data: stringList2,
      ),
    ];
    globals.features3 = [
      Feature(
        // title: "Occupancy",
        color: Colors.blue,
        data: stringList3,
      ),
    ];
  }

  List<Feature> a = (globals.features1.cast<Feature>());
  List<Feature> b = (globals.features2.cast<Feature>());
  List<Feature> c = (globals.features3.cast<Feature>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail Page"),
          actions: <Widget>[
            // Add 3 lines from here...
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                setState(() {
                  stringList1 = (globals.liveData1.cast<double>());
                  stringList2 = (globals.liveData2.cast<double>());
                  stringList3 = (globals.liveData3.cast<double>());
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("Last minute data"),
                          content: Text(
                              "Click refresh button to refresh.\n\nHigh 'Human Presence' gives an occupied status in the place.\n\nHigh 'mmWave' or 'PIR' gives a triggered sensor."),
                          actions: [
                            TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ]);
                    });
              },
            ),
            //onPressed: addNew), //list icon to push next page
          ], //
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Human Presence',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            LineGraph(
              features: a,
              size: Size(350, 100),
              labelX: (globals.labelx.cast<String>()),
              labelY: ['Yes'],
              //  showDescription: true,
              graphColor: Colors.white30,
              graphOpacity: 0.2,
              // verticalFeatureDirection: false,
              //   descriptionHeight: 40, //130,
            ),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'mmWave',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            LineGraph(
              features: b,
              size: Size(350, 100),
              labelX: (globals.labelx.cast<String>()),
              labelY: [''],
              //   showDescription: true,
              graphColor: Colors.white30,
              graphOpacity: 0.2,
              //  verticalFeatureDirection: true,
              //  descriptionHeight: 40, //130,
            ),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'PIR',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            LineGraph(
              features: c,
              size: Size(350, 100),
              labelX: (globals.labelx.cast<String>()),
              labelY: [''],
              //   showDescription: true,
              graphColor: Colors.white30,
              graphOpacity: 0.2,
              //  verticalFeatureDirection: true,
              //  descriptionHeight: 40, //130,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(index)));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 56, 93, 123),
                      ),
                      icon: Icon(
                        Icons.search,
                        size: 25.0,
                      ),
                      label: Text(
                        "Locate sensor",
                        style: TextStyle(fontSize: 18.0),
                      ), // <-- Text
                    ))),
            SizedBox(
              height: 30, // <-- SEE HERE
            ),
          ],
        )));
  }
}

class DetailPage extends StatefulWidget {
  final int index;
  DetailPage(this.index);
  @override
  State<DetailPage> createState() => DetailPageState(index);
}

class DetailPageState extends State<DetailPage> {
  late int index;

  DetailPageState(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Add 6 lines from here...
        appBar: AppBar(
          title: const Text('Locate sensor'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              globals.detail[index]['title'],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          //SizedBox(height: 15),
          Image.asset(globals.detail[index]['image1'], height: 250),
          SizedBox(height: 15),
          Image.asset(globals.detail[index]['image2'], height: 250),
        ])));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var status = 0;
  late double feeds;
  late String desc;
  //final Set<int> saved = Set<int>();
  // List<double> stringList1 = (globals.liveData1.cast<double>());

  @override
  void initState() {
    super.initState();
    feeds = 0;
    desc = 'b';
    startMQTT();
  }

  void _pushsaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = globals.saved.map(
            (int index) {
              //    return ListView.builder(
              //    itemBuilder: (context, index) {
              //  final bool alreadySaved = _saved.contains(index);
              return ListTile(
                leading: Image.asset(data[index]['image']),
                //   Image.network(data[index]['image']),
                title: Text(data[index]['title']),
                subtitle: Text(desc),
                /*trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(index);
                          } else {
                            _saved.add(index);
                          }
                        });
                      },
                      icon: Icon(
                        alreadySaved ? Icons.bookmark : Icons.bookmark_border,
                        color: alreadySaved ? Colors.blue : null,
                      ),
                    ),*/

                onTap: () {
                  //   Navigator.pushNamed(context, 'add');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPage(index)));
                },
              );
              //   },
              //   itemCount: data.length,
              //   );
            },
          );
          final List<Widget> divided = tiles.toList();

          return Scaffold(
              // Add 6 lines from here...
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: ListView(children: divided)
              /* ListView.builder(
                itemBuilder: (context, index) {
                  divided;
                },
                itemCount: data.length,
              )*/
              ); // ... to here.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          leading: IconButton(
            onPressed: _pushsaved,
            icon: Icon(Icons.bookmark),
          ),
          actions: [
            IconButton(
              //if 0 then display icon list if other than zero display icon grid
              icon: status == 0 ? Icon(Icons.list) : Icon(Icons.grid_view),
              tooltip: 'Open shopping cart',
              onPressed: () {
                //required to add state,
                //setstate is used to change the state,
                //when the status variable is changed, the whole page will be re-rendered automatically
                setState(() {
                  if (status == 0) {
                    status = 1;
                  } else {
                    status = 0;
                  }
                });
              },
            ),
          ],
        ),
        body: /*Center (child:Column(children: <Widget>[
        const Text('Align Button to the Bottom in Flutter'),
        Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Bottom Button!'))))
      ]),),*/
//final bool alreadySaved = _saved.contains(index);
            status == 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      //globals.index = index;
                      //  print(index);
                      final bool alreadySaved = globals.saved.contains(index);
                      print(alreadySaved);
                      return ListTile(
                        leading: Image.asset(data[index]['image']),
                        //   Image.network(data[index]['image']),
                        title: Text(data[index]['title']),
                        subtitle: Text(desc),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              // print(globals.alreadySaved);
                              //  print(globals.saved);
                              if (alreadySaved) {
                                globals.saved.remove(index);
                              } else {
                                globals.saved.add(index);
                              }
                            });
                          },
                          icon: Icon(
                            alreadySaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: alreadySaved ? Colors.blue : null,
                          ),
                        ),

                        onTap: () {
                          //   Navigator.pushNamed(context, 'add');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage(index)));
                        },
                      );
                    },
                    itemCount: data.length,
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (_, index) {
                      final bool alreadySaved = globals.saved.contains(index);
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          //add shadow
                          elevation: 5,
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(data[index]['image']),
                                        fit: BoxFit.cover)),
                              ),
                              ListTile(
                                title: Text(data[index]['title']),
                                subtitle: Text(desc),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (alreadySaved) {
                                        globals.saved.remove(index);
                                      } else {
                                        globals.saved.add(index);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    alreadySaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: alreadySaved ? Colors.blue : null,
                                  ),
                                ),
                                onTap: () {
                                  //   Navigator.pushNamed(context, 'add');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddPage(index)));
                                },
                                // Icon(Icons.bookmark),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length));
  }

  updateFeed1(double s) {
    setState(() {
      double feeds = s;

      // stringList = (globals.liveData.cast<double>());
      //  print(feeds);
      if (feeds == 0.0) {
        desc = 'Available';
      } else {
        desc = 'Occupied';
      }
      //  print(globals.liveData[1]);
      for (var i = 0; i < 60; i++) {
        if (i < 59) {
          globals.liveData1[i] = globals.liveData1[i + 1];
        }
        if (i == 59) {
          globals.liveData1[i] = feeds;
        }
      }
      //  stringList1 = (globals.liveData1.cast<double>());
    });
  }

  updateFeed2(double s) {
    setState(() {
      double feeds = s;
      for (var i = 0; i < 60; i++) {
        if (i < 59) {
          globals.liveData2[i] = globals.liveData2[i + 1];
        }
        if (i == 59) {
          globals.liveData2[i] = feeds;
        }
      }
    });
  }

  updateFeed3(double s) {
    setState(() {
      double feeds = s;
      for (var i = 0; i < 60; i++) {
        if (i < 59) {
          globals.liveData3[i] = globals.liveData3[i + 1];
        }
        if (i == 59) {
          globals.liveData3[i] = feeds;
        }
      }
    });
  }

  Future<void> startMQTT() async {
    final client = MqttServerClient('mqtt.cetools.org', '');
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 30;
    final String username = 'student';
    final String password = 'ce2021-mqtt-forget-whale';
    try {
      await client.connect(username, password);
    } catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    const topicc = 'student/ucfnnbx/human/ifhuman';
    const topic1 = 'student/ucfnnbx/human/mmwave';
    const topic2 = 'student/ucfnnbx/human/pir';
    client.subscribe(topicc, MqttQos.atMostOnce);
    client.subscribe(topic1, MqttQos.atMostOnce);
    client.subscribe(topic2, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      if (c[0].topic == topicc) {
        final messageString = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        double MS = double.parse(messageString);
        updateFeed1(
          MS,
        );
        //  print(
        //      'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      }
      if (c[0].topic == topic1) {
        final messageString = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        double MS1 = double.parse(messageString);
        updateFeed2(
          MS1,
        );
      }
      if (c[0].topic == topic2) {
        final messageString = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        double MS2 = double.parse(messageString);
        updateFeed3(
          MS2,
        );
      }
      /*    if (c[0].topic == topic1){
final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      double MS1 = double.parse(messageString);
        updateFeed2(
        MS1,
      );
      }*/
      /*   final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      double MS = double.parse(messageString);
      //List<double> stringList = (globals.liveData.cast<double>());
      // feeds = messageString;
      //  print(
      //     'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      updateFeed1(
        MS,
      );*/
    });
  }
}
