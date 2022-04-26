import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ViewQrCode extends StatelessWidget {
  const ViewQrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Constants.qrCodeLink);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
        title: Text('QR Code', style: TextStyle(color: Colors.black, fontSize: 24),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 50, top: 100, bottom: 20),
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(115, 156, 214, 1),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image:DecorationImage(
                                image: CachedNetworkImageProvider(Constants.qrCodeLink) ,
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                          'The customer can directly connect with you by using this QR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(151, 151, 151, 1),
                          fontSize: 17
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Supplier ID: ' + Constants.myCode,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        letterSpacing: 0.5
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/personIcon.jpeg',
                              ),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle)),
                  Text(
                    Constants.myStoreName,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
