import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserModel {
  String name;
  String graphLink;
  String jsonLink;
  Image? image;
  Color bgColor;

  UserModel({
    required this.name,
    required this.graphLink,
    required this.jsonLink,
    this.image,
    required this.bgColor,
  }) {
    // Initialize the image property using the provided response URL
    image = Image.network(graphLink);
  }

  /* Future<void> updateImage() async {
    try {
      image = null;

      var response = await http.get(Uri.parse(this.graphLink));

      // Update the image in your app
      image = Image.memory(response.bodyBytes);
    } catch (error) {
      print('Error updating image: $error');
      // Handle errors or show a message to the user
    }
  } */

  Future<void> updateImage() async {
    var response = await http.get(Uri.parse(this.graphLink));
    // Update the image in your app
    image = Image.memory(response.bodyBytes);
  }

  Future<List<double>> fetchData() async {
    final response = await http.get(Uri.parse(this.jsonLink));

    if (response.statusCode == 200) {
      // Parse JSON and convert it to List<double>
      List<dynamic> rawData = json.decode(response.body);
      List<double> doubleList = rawData.map((value) => value.toDouble()).toList().cast<double>();

      return doubleList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Image? getUpdatedImage() {
    return this.image;
  }
}