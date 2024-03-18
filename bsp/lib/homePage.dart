
import 'dart:isolate';
import 'dart:ui';

import 'package:bsp/noti.dart';
import 'package:bsp/user_holder.dart';
import 'package:bsp/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

// new with chnages 
  void startBackgroundTask() {
    final SendPort? send = IsolateNameServer.lookupPortByName('isolate');
    send!.send(null);
  }
}


class _HomePageState extends State<HomePage> {

  late StreamController<int> _streamController;
  late Stream<int> _stream;
  late Timer _timer;
  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {

    _tooltipBehavior =  TooltipBehavior(enable: true);

    super.initState();
    _streamController = StreamController<int>();
    _stream = _streamController.stream;
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      // Emit a unique value (timestamp) every 5 seconds
      _streamController.add(DateTime.now().millisecondsSinceEpoch);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    //_startBackgroundTask();
    UserHolder holder = UserHolder();
    holder.addUser("Atakan Kaya", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
    /* holder.addUser("A2", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
    holder.addUser("A3", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
    holder.addUser("A4", "https://drive.google.com/uc?export=view&id=1Js0UDC3WrYu2tX5wIvhMXIQ0GJJFTW0Q", 'https://drive.google.com/uc?export=view&id=1P8MgKlcdH-2b0pRByNWVHE9cMY1ynI-N');
 */    
    List<UserModel> models = holder.giveEm();
    
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Blood Sugar Predictor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        centerTitle: true,
      ),

      backgroundColor: Colors.white,    
 
        body: SingleChildScrollView(
        // Set height to cover the entire vertical space
        //height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "BSP",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
        
            SizedBox(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height-130,
              color:  Color.fromARGB(255, 174, 225, 249),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    models.forEach((model) async {
                      
                      await model.updateImage();
                    });
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 40,),
                    itemCount: models.length,
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    itemBuilder: (context, index){
                      return Container(
                        //height: models[index].image?.height,
                        height: MediaQuery.of(context).size.height-130,
                        // ignore: sort_child_properties_last
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              models[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14
                              ),
                            ),
                            /* PyPlotLib depiction code
                            Container(
                              height: models[index].image?.height,
                              child: models[index].getUpdatedImage(),
                            ),
                            Container(
                              height: models[index].image?.height, // Set the height as needed
                              child: () {
                                models[index].updateImage(); 
                                if (models[index].image == null) {
                                  // If the image is not loaded, show CircularProgressIndicator
                                  models[index].updateImage(); // initiate the function call
                                  return CircularProgressIndicator();
                                } else {
                                  // If the image is loaded, display the image
                                  return models[index].image!;
                                }
                              }()
                            ), */
                            FutureBuilder<List<double>>(
                              future: models[index].fetchData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  
                                  if (snapshot.data![0] == 0){
                                    models[index].bgColor = Colors.red;
                                    Noti().showNotification(body: "Emergency!", title: "BSP");
                                  }
                                  else{
                                    models[index].bgColor = Colors.green;
                                    //startBackgroundTask();
                                    Noti().showNotification(body: "You are fine!", title: "BSP");
                                  }

                                  String shower = "";
                                  if (snapshot.data![1] == 0){
                                    shower += "L";
                                  }
                                  else if (snapshot.data![1] == 1){
                                    shower += "\\";
                                  }
                                  else if (snapshot.data![1] == 2){
                                    shower += "--";
                                  }
                                  else if (snapshot.data![1] == 3){
                                    shower += "/";
                                  }
                                  else if (snapshot.data![1] == 4){
                                    shower += "T";
                                  }
                                  else{
                                    shower += "!";
                                  }
                                  
                                  shower += "  ";

                                  if (snapshot.data![2] == 0){
                                    shower += "L";
                                  }
                                  else if (snapshot.data![2] == 1){
                                    shower += "\\";
                                  }
                                  else if (snapshot.data![2] == 2){
                                    shower += "--";
                                  }
                                  else if (snapshot.data![2] == 3){
                                    shower += "/";
                                  }
                                  else if (snapshot.data![2] == 4){
                                    shower += "T";
                                  }
                                  else{
                                    shower += "!";
                                  }

                                  // Display the elements in a Text widget
                                  return Column(
                                    children: [
                                      Text(shower),
                                      Container(
                                        height: MediaQuery.of(context).size.height-250,
                                        color: Colors.white,
                                        child: SfCartesianChart(
                                          trackballBehavior: TrackballBehavior(
                                            shouldAlwaysShow: true,
                                            enable: true,

                                            /* tooltipSettings: InteractiveTooltip(
                                              enable: true,
                                            ), */
                                          ),
                                          primaryYAxis: const NumericAxis(
                                            minimum: 40,
                                            //rangePadding: ChartRangePadding.round,
                                            // Other axis properties...
                                          ),
                                          // Enables the legend
                                          //legend: Legend(isVisible: true), 
                                          // Enables the tooltip for all the series in chart
                                          tooltipBehavior: _tooltipBehavior,
                                          // Initialize category axis
                                          primaryXAxis: CategoryAxis(),
                                          
                                          series: <CartesianSeries>[
                                              // Initialize line series
                                              LineSeries<ChartData, String>(
                                                  // Enables the tooltip for individual series
                                                  enableTooltip: true, 
                                                  width: 5,
                                                  dataSource: [
                                                      // Bind data source
                                                      ChartData('-55', snapshot.data![3]),
                                                      ChartData('-50', snapshot.data![4]),
                                                      ChartData('-45', snapshot.data![5]),
                                                      ChartData('-40', snapshot.data![6]),
                                                      ChartData('-35', snapshot.data![7]),
                                                      ChartData('-30', snapshot.data![8]),
                                                      ChartData('-25', snapshot.data![9]),
                                                      ChartData('-20', snapshot.data![10]),
                                                      ChartData('-15', snapshot.data![11]),
                                                      ChartData('-10', snapshot.data![12]),
                                                      ChartData('-5', snapshot.data![13]),
                                                      ChartData('0', snapshot.data![14]),
                                                      ChartData('5', snapshot.data![15]),
                                                      ChartData('10', snapshot.data![16]),
                                                      ChartData('15', snapshot.data![17]),
                                                  ],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                  /* markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                  ), */
                                                  /* dataLabelSettings: DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(color: Colors.black),
                                                  ), */
                                                  pointColorMapper: (ChartData data, index) {
                                                    if (data.x == '0'){
                                                      return Colors.red;
                                                    } else if (data.x == '5') {
                                                      return Colors.red; // Change the color of "5" to red
                                                    } else if (data.x == '10') {
                                                      return Colors.red; // Change the color of "10" to blue
                                                    } else if (data.x == '15') {
                                                      return Colors.red; // Change the color of "15" to green
                                                    }
                                                    return null; // Return null for other data points to use the default color
                                                  },
                                                  
                                              )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle errors
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Display a loading indicator while waiting for the data
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ]),
                          decoration: BoxDecoration(
                          color: models[index].bgColor,
                        ),
                      );
                    }
                  );
                },
              ),
            )
          ],
        ),
      ),
      
    );
  }
}


class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}