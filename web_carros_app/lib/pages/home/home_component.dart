import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:web_carros_app/models/ad_helper.dart';
import 'package:web_carros_app/models/auto.dart';
import 'package:web_carros_app/pages/overview/overview_component.dart';
import 'package:web_carros_app/pages/shared/app_bar_widget.dart';
import 'package:web_carros_app/pages/shared/loading_widget.dart';
import 'package:web_carros_app/services/auto_service.dart';
import 'package:web_carros_app/services/local_storage_service.dart';
import 'package:web_carros_app/utils/styles.dart';

class HomeComponent extends StatefulWidget {
  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  LocalStorageService _localStorageService;
  AutoService _autoService;
  List<Auto> favorites;
  List<Auto> news;
  bool loadingFavorites;
  bool loadingNewsAndTrend;

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  _HomeComponentState() {
    this._localStorageService = LocalStorageService();
    this._autoService = AutoService();
  }

  @override
  void initState() {
    super.initState();
    this._loadBannerAd();
    this._getFavoriteAutos();
    this._getNews();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  _getNews() {
    setState(() {
      this.loadingNewsAndTrend = true;
    });

    this.news = [];

    this._autoService.getNews().then((value) {
      if (value == null) {
        // tratar server erro
      } else {
        if (value.success) {
          this.news = value.data;
        } else {
          // tratar erro
        }
      }

      setState(() {
        this.loadingNewsAndTrend = false;
      });
    });
  }

  _getFavoriteAutos() {
    setState(() {
      this.loadingFavorites = true;
    });

    this.favorites = [];

    this._localStorageService.getFavoriteAutos().then((value) {
      if (value == null) {
        // tratar server erro
      } else {
        if (value.success) {
          this.favorites = value.data;
        } else {
          // tratar erro
        }
      }

      setState(() {
        this.loadingFavorites = false;
      });
    });
  }

  _getSectionTitle(String title) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        title,
        style: Styles.montTextTitle,
      ),
    );
  }

  Widget _createHorizontalCard(Auto item) {
    String autoImage = (item.autoImagePathList.length >= 3)
        ? item.autoImagePathList[2]
        : item.autoImagePathList[0];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: OpenContainer(
        openColor: Styles.cardColor,
        closedColor: Styles.cardColor,
        closedElevation: 2,
        closedShape: RoundedRectangleBorder(
            borderRadius: Styles.defaultCardBorderRadius),
        onClosed: (val) {
          this._getFavoriteAutos();
        },
        openBuilder: (context, action) {
          return OverviewComponent(item);
        },
        closedBuilder: (context, action) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: 150,
            height: 160,
            child: Stack(
              children: [
                Container(
                  child: Image.network(
                    autoImage,
                    fit: BoxFit.cover,
                    width: 150,
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.brand,
                        style: Styles.tileTitleTextStyle,
                      ),
                      Text(
                        item.model,
                        style: Styles.montText,
                      ),
                      Text(
                        item.version,
                        style: Styles.montTextGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _createCard(Auto item) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
      width: double.infinity,
      child: OpenContainer(
        openColor: Styles.cardColor,
        closedColor: Styles.cardColor,
        closedElevation: 2,
        closedShape: RoundedRectangleBorder(
            borderRadius: Styles.defaultCardBorderRadius),
        onClosed: (val) {
          this._getFavoriteAutos();
        },
        openBuilder: (context, action) {
          return OverviewComponent(item);
        },
        closedBuilder: (context, action) {
          return Container(
            child: ListTile(
              title: Text(
                item.brand,
                style: Styles.tileTitleTextStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.model,
                    style: Styles.montText,
                  ),
                  Text(
                    item.version,
                    style: Styles.montTextGrey,
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Container(
                child: Image.network(
                  item.autoImagePathList[0],
                  fit: BoxFit.cover,
                  width: 150,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_isBannerAdReady)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ),
                  AppBarWidget(),
                  // News
                  loadingNewsAndTrend
                      ? Container(
                          height: 227,
                          child: LoadingWidget(),
                        )
                      : Container(
                          child: Column(
                            children: [
                              _getSectionTitle('Novidades'),
                              Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: news
                                        .map((item) =>
                                            _createHorizontalCard(item))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  // Favorites
                  _getSectionTitle('Favoritos'),
                  loadingFavorites
                      ? LoadingWidget()
                      : this.favorites.isEmpty
                          ? Container(
                              margin: EdgeInsets.all(20),
                              child: Text(
                                'Nenhum favorito',
                                style: Styles.montTextGrey,
                              ),
                            )
                          : Column(
                              children: favorites
                                  .map((item) => _createCard(item))
                                  .toList(),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
