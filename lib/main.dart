import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

void main() => runApp(BookImage());

class BookImage extends StatefulWidget {
  BookImage({Key? key}) : super(key: key);

  @override
  _BookImageState createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  final Controller = TextEditingController();

  String sbin = '';
  Map mapResponse = {};
  bool fetch = false;

  Future fetchPost() async {
    http.Response response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$sbin'));
    setState(() {
      mapResponse = json.decode(response.body);
      // print(mapResponse.toString());
    });
  }

  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 100, bottom: 100, left: 50, right: 50),
                  child: TextField(
                    controller: Controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter SBIN',
                      hintText: 'SBIN',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              fetch = true;
                              sbin = Controller.text;
                            });
                            fetchPost();
                          },
                          icon: Icon(Icons.send)),
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Image.network(
                      'https://covers.openlibrary.org/b/isbn/$sbin-L.jpg'),
                ),
                fetch == true
                    ? Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              mapResponse['items'][0]['volumeInfo']['title']
                                  .toString(),
                              style: GoogleFonts.poppins(fontSize: 30),
                            ),
                          ),
                          Container(
                            child: Text(
                              mapResponse['items'][0]['volumeInfo']
                                      ['description']
                                  .toString(),
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                            margin: EdgeInsets.only(left: 50, right: 50),
                          ),
                        ],
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
