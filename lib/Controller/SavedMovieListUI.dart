


import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Constant/Button_TextfieldConstant.dart';
import '../DatabaseController/DatabasaeHelper.dart';
import '../DatabaseController/MovieDetails.dart';



class SavedMovieList extends StatefulWidget
{
  //late final List movieDetails;
 // SavedMovieList(this.movieDetails);
  @override
  State<StatefulWidget> createState() => _SavedMovieList();

}


class _SavedMovieList extends State<SavedMovieList>
{

  var fontsize1 = 12.0;
  var fontfamily1 = "Roboto";
  var fontweight1 = FontWeight.w500;

  var fontsize2 = 14.0;
  final dbMovieHelper = DatabaseMovieHelperData.instance;
  final editKey = GlobalKey();
  final deletekey = GlobalKey();

  List data= [];
  bool queryStatus = false;
  TextEditingController EditmovieNameController = TextEditingController();
  TextEditingController EditdirectorNameController = TextEditingController();
  TextEditingController EditposterController = TextEditingController();

  File _image = File("");
  String base64Image = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Before queery called");
    _queryAll();
    print("After queery called");
    //print("Movie Details length ${widget.movieDetails.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Movie List"),
      ),
      body: data.length == 0?
          Center(
            child: Text("No Data Found"),
          ):
      ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index){
            MovieDetails movie= data[index];
            print("Data $data in listview");
            return saveMovieUI(moviedetails: movie);
            },
      ),
    );
  }


  saveMovieUI({required MovieDetails moviedetails}){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4.0,
      child: Container(
        //height: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
            color: Colors.grey
        )
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                      child: Image.memory(
                       base64Decode( moviedetails.Poster.toString()),
                        fit: BoxFit.cover,
                      )
                    //Image.asset("assets/listViewIcon.png",width: 90,height: 90,),
                  )
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Movie:",
                               style: TextStyle(
                                 color: Colors.blue,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14
                               ),

                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(moviedetails.MovieName.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Director:",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(moviedetails.DirectorName.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Image.asset("assets/edit.png",
                    width: 20,height: 20,
                    color: Colors.grey,
                  ),
                  onTap: (){
                    customDailogBox(moviedetails);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: (){

                    _delete(moviedetails.id);
                    _queryAll();
                  },
                  child: Image.asset("assets/delete.png",
                    width: 20,height: 20,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }


  void _delete(id) async {
    await dbMovieHelper.delete(
      id,
        ResponseBlock(SuccessBlock: <T>(success){
          print("Deleted SuccessFully $success");
          _queryAll();
          setState(() {});
          _showMessageInScaffold('deleted $success row(s): row $id}');
        },
            FailureBlock: <T>(failure){
              _showMessageInScaffold('error in deleteing: row $id $failure }');
            }
        )
    );
  }

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
  }



  void   _queryAll() async {

    await dbMovieHelper.queryAllRows(
        ResponseBlock(SuccessBlock: <T>(success)
        {
          print("Sucess $success");
          List datafromQuerry = success as List;
          print(datafromQuerry);
          data.clear();
          for(var i = 0;i<datafromQuerry.length;i++)
            {
              data.add(MovieDetails.fromMap(datafromQuerry[i]));
            }
          setState(() {});
          print("Movie List $data");
        },
            FailureBlock: <T>(failure){
              setState(() {});
              data = [];
              _showMessageInScaffold('Error In loading Data $failure');
            }
        )
    );

  }

  void edit(MovieDetails movie) async
  {
    print("Movie Details in Edit ${movie.id} ${movie.MovieName} ${movie.DirectorName} ${movie.Poster}");
   await dbMovieHelper.update(movie,
        ResponseBlock(
            SuccessBlock: <T>(success){
              _showMessageInScaffold('data Edited SuccessFully $success');
          _queryAll();
          Navigator.of(context).pop();
          setState(() {});
        },
            FailureBlock: <T>(failure){
              _showMessageInScaffold('Error In Editing Data $failure');
            }
        )
    );
  }


  customDailogBox(MovieDetails movieDetails) async
  {
    EditmovieNameController.text = movieDetails.MovieName!;
    EditdirectorNameController.text = movieDetails.DirectorName!;
    EditposterController.text = movieDetails.Poster.toString();
    base64Image = movieDetails.Poster.toString();
    return  showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 500,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Movie Name"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children:  [
                        Expanded(
                            flex: 1,
                            child: TextField(
                                controller: EditmovieNameController,
                                decoration: getTextFieldDecoration()
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Director Name"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children:  [
                        Expanded(
                          flex: 1,
                          child: TextField(
                              controller: EditdirectorNameController,
                              decoration:  getTextFieldDecoration()
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Poster"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children:  [
                        Expanded(
                            flex: 1,
                            child: TextField(
                              controller: EditposterController,
                              decoration:  getTextFieldDecorationWithSuffixIcon(
                                  "assets/attachment_icon.jpg",
                                  elevatedButtonBlock: ElevatedButtonBlock(
                                      elevatedButtonAction: (){
                                        pickImage();
                                      }
                                  )
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CJElevatedBlueButton(
                          "Update Data",
                          elevatedButtonBlock: ElevatedButtonBlock(
                              elevatedButtonAction: (){
                                print("Action perform on Insert Data");
                                Map<String, dynamic> row = {
                                  DatabaseMovieHelperData.columnId:movieDetails.id,
                                  DatabaseMovieHelperData.columnMovieName:EditmovieNameController.text,
                                  DatabaseMovieHelperData.columnDirectorName: EditdirectorNameController.text,
                                  DatabaseMovieHelperData.columnPoster: base64Image,
                                };
                                MovieDetails detailsToEdit = MovieDetails.fromMap(row);
                                edit(detailsToEdit);
                              }
                          )
                      ),
                    )
                  ],
                ),
              )
            ),
          );
        });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this._image = imageTemp);
      print("Image ggsgsg $_image");
      Uint8List imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
      var imageName = _image.path.split('/').last;
      setState(() {
        EditposterController.text = imageName;
      });
      print("Image List $imageName");
    } on PlatformException catch(e) {
      _showMessageInScaffold("Failed To load Image $e");
    }
  }








}

