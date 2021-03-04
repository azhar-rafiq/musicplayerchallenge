import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:musicplayerchallenge/widget/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Music Player App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //
  //
  // VARIABLE
  //
  //

  //1.
  //Current search string, initiated with empty string
  String textSearchInput = "";

  //2.
  //Search TextField Controller
  TextEditingController textSearchController = new TextEditingController();

  //3.
  //Total song listed, initiated with 20 song will be fetched from iTunes API
  int totalSong = 20;

  //4.
  //Current number/index of a song being played.
  //value -1 = no song is selected/played.
  //playingIndex will become -1 if there is a new search string submitted.
  int playingIndex = -1;

  //5.
  //Current status whether it is playing or not.
  //It change the icon of play/pause button to the state:
  //
  // true = play icon
  // flase = pause icon
  //
  //A song may be already selected but the playingStatus is false when the play/pause button is clicked-
  //in this case the playing bar
  bool playingStatus = false;


  @override
  void dispose() {

    //dispose the search controller
    textSearchController.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:

      //Contain of all the body of the app
      Container(
        child:

          //Column to order the search bar and the music list
          Column(
            children: <Widget>[

                //Search BAR:
                Container(
                  height: 55,
                  color: Colors.white,
                  padding: EdgeInsets.only(left:25,right:25,top:10,bottom:5),
                  child:

                      //TextField bar, user can click this TextField,
                      // and then there will be a keyboard show up to enter the search string.
                        TextField(
                          controller: textSearchController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20,),
                          decoration: InputDecoration(
      //
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black12, width: 1.0),
                          ),
                          filled: false,

                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'search artist ...'),
                          onSubmitted: (String str) {
                            setState((){
                              playingIndex = -1;
                              textSearchInput = str;
                            });
                          },
                        ),
                ),

                //Music LIST:
                Container(
                  child:

                      textSearchController.text==""?
                      Container(
                        padding: EdgeInsets.all(15),
                        child:
                        Text("Enter the name of music artist above ..."),
                      ):
                      FutureBuilder(
                        //Set the iTunes API URL to fetch the musics data
                        future: http.post("https://itunes.apple.com/search",
                        body: {"term":  textSearchInput, "limit": totalSong.toString(), "country": "us"}),
                        builder: (context, snapshot) {

                          //check if the iTunes API return the music list/not null
                          if (snapshot.hasData) {

                            //check if the result of iTunes API music data is not 0 song
                            if(json.decode(snapshot.data.body)["resultCount"]=="0"){

                              return Container(
                                child:
                                  //show the information that the search string result in 0 song
                                  Text("Not found :("),);

                            //if there is 1 or more song in the music data from API, show the result/list
                            }else{

                              return Expanded(
                                child:

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Expanded(
                                    child:

                                    //Create a ListView to show the music(s) data
                                    ListView.builder(

                                      //Make each of the list is clickable


                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,

                                      //put the resultCount data from API to set the total index available in the list
                                      itemCount: json.decode(snapshot.data.body)["resultCount"],

                                      itemBuilder: (context, index) {

                                        return GestureDetector(

                                          //Give each song view a listener onTapUp to change the playingIndex to the selected song,
                                          //and also play the selected song (playingStatus = true)
                                          onTapUp: (TapUpDetails details){
                                            if(playingIndex!=index){
                                              setState(() {
                                                playingStatus = true;
                                                playingIndex = index;
                                              });
                                            }},
                                          child:
                                            Container(

                                          //change background color into grey or white every one song in the list displayed
                                          color: index % 2 == 0 ? Colors.white : Colors.grey[200],

                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[

                                                  Expanded(
                                                    flex:6,

                                                    //displaying song's artwork
                                                    child: Image.network(json.decode(snapshot.data.body)['results'][index]['artworkUrl60'].toString()),
                                                  ),

                                                  Expanded(
                                                    flex: 20,
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 8,
                                                          bottom: 12,
                                                          left: 6,
                                                          right: 6),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: <Widget>[

                                                          Text(
                                                            json.decode(snapshot.data.body)['results'][index]['trackName'].toString(),
                                                            textAlign: TextAlign.left,
                                                            style: new TextStyle(
                                                              color: playingIndex==index?colorTheme.primary(context):Colors.black,
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                FontWeight.normal),
                                                          ),

                                                          Text(
                                                            json
                                                                .decode(snapshot.data.body)['results'][index]['artistName']
                                                                .toString(),
                                                            textAlign: TextAlign.left,
                                                            style: new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors.grey[600],
                                                                fontWeight:
                                                                FontWeight.normal),
                                                          ),
                                                          Text(
                                                            json
                                                                .decode(snapshot.data.body)['results'][index]['collectionName']
                                                                .toString(),
                                                            textAlign: TextAlign.left,
                                                            style: new TextStyle(
                                                                fontSize: 11.0,
                                                                color: Colors.grey,
                                                                fontWeight:
                                                                FontWeight.normal),
                                                          ),

                                                        ],),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    flex: 5,
                                                    child:
                                                        Column(children:<Widget>[

                                                          Visibility(
                                                            //if the current index song is playing, show the indicator,
                                                            //if not, hide them
                                                            visible:playingIndex==index?true:false,
                                                            child:
                                                            Container(
                                                              margin: EdgeInsets.all(4),
                                                              child:Icon(Icons.music_note,
                                                                color: colorTheme.lightTeal(context),
                                                                textDirection: TextDirection
                                                                    .ltr,
                                                                size: 30,),
                                                            ),
                                                          ),

                                                        ],),
                                                  ),


                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        );
                                      },
                                    ),
                                  ),
                                ],),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text(
                              "Error:" + snapshot.error,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.normal),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),

                ),

            ],),
          ),

        //building the music play bar
        bottomNavigationBar:

        //if the app has no search input (playingIndex==-1) OR there is a new search is submitted (playingIndex==-1)-
        //the music play bar will be hide/switched with 0 height of Container,
        //if the playingIndex NOT EQUAL -1, then the song already selected, and then switched with the real container-
        //of music play bar
        playingIndex == -1 ? Container(height:0,) : Container(
          height: 70,
          color: Colors.grey[200],
          child:
          Column(
            children:<Widget>[
          Row(
            children: <Widget>[

              Expanded(
              flex:2,
                child:Container(),
              ),
              Expanded(
                flex:6,

                child: FlatButton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    children: <Widget>[
                      Icon(Icons.skip_previous,
                        color: Colors.black,
                        textDirection: TextDirection
                            .ltr,
                        size: 30,),
                    ],),

                  onPressed: () {
                    setState(() {
                      if(playingIndex!=0) {
                        playingIndex = playingIndex - 1;
                      }
                    });
                  },
                ),
              ),

              Expanded(
                flex:6,
                child: FlatButton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    children: <Widget>[
                      Icon(
                        playingStatus==true?Icons.pause:Icons.play_arrow,
                        color: Colors.black,
                        textDirection: TextDirection
                            .ltr,
                        size: 40,),
                    ],),

                  onPressed: () {
                    if(playingIndex!=-1){
                      setState(() {
                        if(playingStatus==true){playingStatus=false;
                        }else{
                          playingStatus=true;}
                      });
                    }else{
                      setState(() {
                        playingStatus=false;
                      });
                    }
                  },

                ),
              ),

              Expanded(
                flex:6,
                child: FlatButton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    children: <Widget>[
                      Icon(Icons.skip_next,
                        color: Colors.black,
                        textDirection: TextDirection
                            .ltr,
                        size: 30,),
                    ],),

                  onPressed: () {
                    setState(() {
                      //totalSong-1 = the number of index of the last music listed/fetch
                      //(the first index of the music is 0)
                      if(playingIndex!=totalSong-1) {
                        playingIndex = playingIndex + 1;
                      }
                    });
                  },
                ),
              ),

              Expanded(
                flex:2,
                child:Container(),
              ),

            ],
          ),
              Container(
                padding: EdgeInsets.only(top:5),
              child:
              Row(

                children: <Widget>[
                  Expanded(
                    flex:2,
                    child: Container(),
                  ),
                  Expanded(
                    flex:10,
                    child:Container(
                      height: 5,
                      color: Colors.black,
                        padding: EdgeInsets.all(10)
                    ),
                  ),
                  Expanded(
                    flex:2,
                    child: Container(),
                  ),
                ],),
              ),


            ],),
        ),
    );
  }

}
