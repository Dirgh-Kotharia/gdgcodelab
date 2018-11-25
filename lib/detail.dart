import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './model.dart';

class Detail extends StatelessWidget {

final PhotoResponse photoList;
Detail(this.photoList);

buildBackIcon(BuildContext context) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: CircleAvatar(
        backgroundColor: Colors.black12,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

    buildImage() {
      return Align(
        alignment: Alignment.center,
        child: Image.network(
          photoList.urls.regular,
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.contain,
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black38,
        body: Stack(
          children: <Widget>[
            buildImage(),
            BottomAlignedText(photoList.user),
            buildBackIcon(context),
          ],
        ),
      );
    }
}

class BottomAlignedText extends StatelessWidget {
  final User user;

  BottomAlignedText(this.user);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black38,
        width: double.infinity,
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "By ${user.username}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ),
            user.bio != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${user.bio}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : Text(''),
          ],
        ),
      ),
    );
  }
}