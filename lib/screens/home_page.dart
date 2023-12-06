import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:location/location.dart';
import 'package:stemm_cloudwoork_assignment/api/weather_api.dart';

import '../constants/decoration.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> myData = {};
  Map myLongLatData = {};
  bool isLoading = true;
  List myPlacelist = [];
  bool isCurrentLocation = true;
  final TextEditingController placeController = TextEditingController();

  getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    getWeatherDetails(
        latitude: locationData.latitude!, longtitude: locationData.longitude!);
  }

  getWeatherDetails({required double latitude, required double longtitude}) {
    DioRequestClass.getWeatherDetails(latitude: latitude, longitude: latitude)
        .then((weatherData) {
      if (weatherData["status"] == 200) {
        isLoading = false;
        myData = weatherData["body"];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: weatherData["message"]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weather Details"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                        title: const Text("Current Location"),
                        value: isCurrentLocation,
                        onChanged: (val) {
                          setState(() {
                            isCurrentLocation = val;
                          });
                          getCurrentLocation();
                        }),
                    Text(
                      "Location Name: ${(isCurrentLocation ? "Current Location" : myLongLatData["name"])}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Today Weather \n Min : ${myData["daily"]["temperature_2m_min"][0]} °C \n Max :${myData["daily"]["temperature_2m_max"][0]} °C",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    DataTable(
                        // datatable widget
                        columns: const [
                          // column to set the name
                          DataColumn(
                            label: Text('Date'),
                          ),
                          DataColumn(
                            label: Text('Temp(Min)'),
                          ),
                          DataColumn(
                            label: Text('Temp(Max)'),
                          ),
                        ],
                        rows: List.generate(
                            myData["daily"]["time"].length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(myData["daily"]["time"][index]
                                      .toString())),
                                  DataCell(Text(
                                      "${myData["daily"]["temperature_2m_min"][index]} °C")),
                                  DataCell(Text(
                                      "${myData["daily"]["temperature_2m_max"][index]} °C")),
                                ])).toList())
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Get Search By Name",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                              controller: placeController,
                              decoration: textFieldDecoration.copyWith(
                                  hintText: "Place", labelText: "Place")),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  DioRequestClass.getLatitudeLongitude(
                                          name: placeController.text)
                                      .then((value) {
                                    if (value["status"] == 200) {
                                      myPlacelist = value["body"]["results"];
                                      setState(() {});
                                      print(myPlacelist);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: value["message"]);
                                    }
                                  });
                                },
                                child: const Text("Get List of places")),
                          ),
                          ...myPlacelist.map((e) {
                            return Row(
                              children: [
                                Text(e["name"]),
                                const Gap(5),
                                ElevatedButton(
                                  child: const Text("Get Details"),
                                  onPressed: () {
                                    myLongLatData = e;
                                    isCurrentLocation = false;
                                    print(e);
                                    getWeatherDetails(
                                        latitude: e["latitude"],
                                        longtitude: e["longitude"]);
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          })
                        ],
                      ),
                    ),
                  );
                });
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return const CitySelectionScreen();
            // })).then((value) {
            //   myLongLatData = value;
            //   setState(() {});
            //   print(value);
            // });
          },
          tooltip: 'Increment',
          label: const Text("Search By Name"),
        ));
  }
}
