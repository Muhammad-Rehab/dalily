
import 'package:flutter/material.dart';

class ImagesView extends StatefulWidget {

  const ImagesView({Key? key, required this.images,this.fromNetwork = true}) : super(key: key);
  final List<String> images ;
  final bool fromNetwork ;

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  bool showAppBar = true ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ?AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ):null,
      backgroundColor: Colors.black.withOpacity(.8),
      body: PageView.builder(
        itemCount: widget.images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=> Center(
          child: SizedBox(
            width: 250,
            height: 250,
            child: InteractiveViewer(
              onInteractionStart: (details){
                setState(() {
                  showAppBar = false ;
                });
              },
              onInteractionEnd: (details){
                setState(() {
                  showAppBar = true ;
                });
              },

              maxScale: 5,
              minScale: .3,
              clipBehavior: Clip.none,
              child: widget.fromNetwork
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.images[index],fit: BoxFit.fill,))
                  : Image.asset(widget.images[index],fit: BoxFit.fill,),
            ),
          ),
        ),
      ),
    );
  }
}
