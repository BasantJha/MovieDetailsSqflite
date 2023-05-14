
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../Constant/Button_TextfieldConstant.dart';
import '../DatabaseController/DatabasaeHelper.dart';
import '../DatabaseController/MovieDetails.dart';
import 'SavedMovieListUI.dart';
import 'package:showcaseview/showcaseview.dart';






class FilmDetailsForm extends StatefulWidget {
  const FilmDetailsForm({Key? key,}) : super(key: key);

  @override
  State<FilmDetailsForm> createState() => _FilmDetailsFormState();
}

class _FilmDetailsFormState extends State<FilmDetailsForm> {

  static Set<String>? prefKeys;
  TextEditingController movieNameController = TextEditingController();
  TextEditingController directorNameController = TextEditingController();
  TextEditingController posterController = TextEditingController();
  int? contact;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _image = File("");
  String base64Image = "";
  List movie = [];
  List movieByName = [];

  final keyone = GlobalKey();


  bool isvisible = false;
  final dbMovieHelper = DatabaseMovieHelperData.instance;
  final movieDetails_FormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      return ShowCaseWidget.of(context).startShowCase([
        keyone
      ]);
    });

  }


  SingleChildScrollView MainfunctionUi(){
    return SingleChildScrollView(
        child: Form(
          key: movieDetails_FormKey,
          child: Card(
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
                            child: TextFormField(
                                validator: validateToEmptyText,
                                controller: movieNameController,
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
                          child: TextFormField(
                              controller: directorNameController,
                              validator: validateToEmptyText,
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
                            child: TextFormField(
                              controller: posterController,
                              validator: validateToEmptyText,
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
                          "Insert Data",
                          elevatedButtonBlock: ElevatedButtonBlock(
                              elevatedButtonAction: (){
                                print("Action perform on Insert Data");
                                if(movieDetails_FormKey.currentState!.validate())
                                  {
                                    _insert(movieNameController.text,
                                        directorNameController.text,
                                        base64Image);
                                  }
                              }
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movie Details Form"),
          actions: [
             Padding(
               padding: EdgeInsets.only(right: 10),
               child: Showcase(
                 key: keyone,
                 description: "Use This Button to See Saved Movie Details",
                 child: InkWell(
                   onTap: (){
                     //_queryAll();
                     print("Go to SaveMovie List Page");
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedMovieList()));
                   },
                   child: Image.asset("assets/listViewIcon.png",
                     height: 30,width: 30,color: Colors.white,),
                 ),
               )
             )
          ],
        ),
        body: MainfunctionUi(),
    );
  }



  void _insert(movieName,DirectorName,Poster) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseMovieHelperData.columnMovieName:movieName,
      DatabaseMovieHelperData.columnDirectorName: DirectorName,
      DatabaseMovieHelperData.columnPoster: Poster,
    };
    print("Raw Data $row");
    MovieDetails car = MovieDetails.fromMap(row);
    print("Movie Data to Pass ${car.MovieName} ${car.Poster} ${car.Poster}");
    dbMovieHelper.insert(car,
        ResponseBlock(
            SuccessBlock: <T>(success)
            {
          _showMessageInScaffold('inserted row id: $success');
        },
            FailureBlock: <T>(failure){
             _showMessageInScaffold("Error in Inserting Data $failure");
            }
        )
    );

  }



  void _showMessageInScaffold(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
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
        posterController.text = imageName;
      });
      print("Image List $imageName");
    } on PlatformException catch(e) {
      _showMessageInScaffold("Failed To load Image $e");
    }
  }

  String? validateToEmptyText(String? value)
  {
    if(value!.isEmpty || value == null)
      {
        return "This Field is Required";
      }
    else
      {
        return null;
      }
  }

}


