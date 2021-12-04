import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'constants.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'data.dart';

class Discoverpage extends StatefulWidget {
  const Discoverpage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Discoverpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: discovergradientEndColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
        backgroundColor: primarymapbuttoncolor,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [discovergradientStartColor, discovergradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.3, 0.7])),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                // Menü Titel:
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: const <Widget>[
                    Text(
                      'Entdecken',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 44,

                        color: primaryTextColor,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),

              // Swiper:
              Container(
                height: 500,
                padding: const EdgeInsets.only(left: 32),
                child: Swiper(
                  itemCount: stationen.length,
                  itemWidth: MediaQuery.of(context).size.width - 2 * 64,
                  layout: SwiperLayout.STACK,
                  pagination: const SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.white,
                        activeSize: 20,
                        space: 8),
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a, b) => DetailPage(
                              stationInfo: stationen[index],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 100),

                              // Grundkarte
                              Card(
                                elevation: 11,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 100),

                                      // StationsName
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          stationen[index].name,
                                          style: const TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: 40,
                                            color: Color(0xff47455f),
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      // Untertitel
                                      Text(
                                        'Knechtsteden',
                                        style: TextStyle(
                                          fontFamily: 'Avenir',
                                          fontSize: 23,
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 32),

                                      // Mehr erfahren Link
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Mehr erfahren',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              fontSize: 18,
                                              color: secondaryTextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: secondaryTextColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Bild / Icon
                          Align(
                            alignment: Alignment.topCenter,
                            child: Hero(
                                tag: stationen[index].position,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(110),
                                  child: Image.asset(stationen[index].iconImage,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.55,
                                      fit: BoxFit.fitWidth),
                                )),
                          ),

                          // Nummer

                          Positioned(
                            right: 24,
                            bottom: 60,
                            child: Text(
                              stationen[index].position.toString(),
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 200,
                                color: primaryTextColor.withOpacity(0.08),
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
