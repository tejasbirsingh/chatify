import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


 class CachedImage extends StatelessWidget {
   final String imageUrl;
   final bool isRound;
   final double radius;
   final double height;
   final double width;
   final BoxFit fit;
  final String noImage = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn2.vectorstock.com%2Fi%2F1000x1000%2F20%2F76%2Fman-avatar-profile-vector-21372076.jpg&imgrefurl=https%3A%2F%2Fwww.vectorstock.com%2Froyalty-free-vector%2Fman-avatar-profile-vector-21372076&tbnid=gRmIHR3owD_V0M&vet=12ahUKEwiTjoOomdHoAhWJTCsKHWD7AnoQMygGegUIARCiAg..i&docid=pmE0x0RqkiBF7M&w=1000&h=1080&q=profile%20image&ved=2ahUKEwiTjoOomdHoAhWJTCsKHWD7AnoQMygGegUIARCiAg";

   CachedImage(
     this.imageUrl,{
       this.isRound = false,
         this.radius = 0,
         this.height,
         this.width,
         this.fit = BoxFit.cover,

 });

   @override
   Widget build(BuildContext context) {
    try{
    return SizedBox(
      height: isRound ? radius : height,
      width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 :radius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) =>
            Center(child: CircularProgressIndicator(),),
            errorWidget: (context , url , error) =>
          Image.network(noImage, fit :BoxFit.cover),
          ),)
        );
        } catch (e){
      print(e);
      return Image.network(noImage , fit: BoxFit.cover,);
    }

   }
 }