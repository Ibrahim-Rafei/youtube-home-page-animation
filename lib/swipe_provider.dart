import 'package:flutter/material.dart';

class SwipeProvider extends ChangeNotifier {
 bool isupdating = false ;
 double mainheight  = 0 ;
 double afterheight  = 120 ;
 double afterwidth = 1/3 ;
  var position= Offset.zero;
  var imagewidth = 0.0 ;
  var imageheight = 0.0 ;
  int firsttime = 1 ;
 int second = 1 ;
String status = '' ;
 var x = Offset.zero;

 //when using finger
  updateposition (DragUpdateDetails details,  context ,imgheight, realheight, fixedimageheight){
    if(second==1 && firsttime==1) {
      isupdating = true;
      position += details.delta;
      imageheight -= details.delta.dy * fixedimageheight / mainheight;
      if (mainheight - position.dy  <= afterheight) {
        imagewidth = MediaQuery
            .of(context).size.width *   (1+(0.5-(1-(-(((afterheight-(afterwidth*100))-(mainheight - position.dy ))/(afterwidth*100))*(afterwidth)))));   /*(1 + (0.5 - (1 - (((afterheight -50 - (200 - (mainheight - position.dy ))) * (1 / (50 * 2)))))));*/
        if (mainheight - position.dy  <= afterheight -50) {
          imagewidth = MediaQuery
              .of(context)
              .size
              .width * afterwidth;
        }
      } else {
        imagewidth = MediaQuery
            .of(context)
            .size
            .width;
      }
      if (imageheight <= afterheight -50) {
        imageheight = afterheight -50;
      } else if (imageheight >= fixedimageheight) {
        imageheight = fixedimageheight;
      }
      if (position.dy >=mainheight - imageheight ) {
        position = Offset(0.0, (mainheight - imageheight ));
      } else if (position.dy <= 0.0) {
        position = Offset.zero;
        imageheight = fixedimageheight;
      }


      notifyListeners();
    }
  }


// when removing finger
  endposition(context, imgheight, realheight, fixedimageheight)async{



    isupdating = false ;
    if(position.dy <= mainheight/3){
      position = Offset.zero;
      imageheight = fixedimageheight ;
      imagewidth = MediaQuery.of(context).size.width;
    }else{

      if(mainheight - position.dy  <= afterheight ){
        imagewidth = MediaQuery.of(context).size.width*afterwidth;
        imageheight = afterheight -50 ;
        position =Offset(0.0, (mainheight - imageheight ) );
      }else {
        imageheight = afterheight;
        position = Offset(0.0, (mainheight - imageheight ));
        notifyListeners();
      }
    }
    firsttime= 1;
    second= 1 ;
    notifyListeners();
  }




  //when removing finger and the velocity is not null and swiping down
 downspeed(context, imgheight,  fixedimageheight)async{

   isupdating = false ;

     if(mainheight - position.dy  <= afterheight ){
       imagewidth = MediaQuery.of(context).size.width*afterwidth;
       imageheight = afterheight -50 ;
       position =Offset(0.0, (mainheight - imageheight ) );
     }else {
       imageheight = afterheight;
       position = Offset(0.0, (mainheight - imageheight ));


     }

   firsttime= 1 ;
   notifyListeners();
 }



  //when removing finger and the velocity is null and swiping up
upspeed(context, imgheight, fixedimageheight)async{

   isupdating = false ;
     if(mainheight - position.dy  >= afterheight ){
       imagewidth = MediaQuery.of(context).size.width;
       imageheight = fixedimageheight ;
       position = Offset.zero;
     }else {
       imageheight = afterheight;
       position = Offset(0.0, (mainheight - imageheight ));


       imagewidth = MediaQuery
           .of(context)
           .size
           .width ;


   }

   second= 1 ;
   notifyListeners();
 }





}

