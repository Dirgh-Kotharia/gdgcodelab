import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './detail.dart';
import './model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<PhotoResponse>> photos;

  Future<List<PhotoResponse>> fetchPhotos() async {
    String photosUrl = "https://api.unsplash.com/photos/";

    List<PhotoResponse> list = [];
    final response = await http.get(
      photosUrl,
      headers: {
        'Authorization': "Client-ID " +
            "Your Api Access Key Here",
      },
    );

    if (response.statusCode == 200) {
      List decodedJson = json.decode(response.body);
      print(json.decode(response.body));
      print(decodedJson.length);
      for (int i = 0; i < decodedJson.length; i++) {
        list.add(PhotoResponse.fromJson(decodedJson[i]));
      }
      return list;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    super.initState();
    photos = fetchPhotos();
  }

  buildPhotosListView(AsyncSnapshot<List<PhotoResponse>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageItemWidget(snapshot.data[index]),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      //title: ,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.image,size: 40.0,),
          title: Text("Photos"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<PhotoResponse>>(
          future: photos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildPhotosListView(snapshot);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class ImageItemWidget extends StatelessWidget {
  final PhotoResponse data;

  const ImageItemWidget(this.data);

  buildBottomText() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black38,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "By ${data.user.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Detail(data),
          ),
        );
      },
      child: Container(
        height: 200.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.network(
                data.urls.full,
                fit: BoxFit.cover,
              ),
            ),
            buildBottomText(),
          ],
        ),
      ),
    );
  }
}
