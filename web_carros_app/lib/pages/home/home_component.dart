import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_carros_app/models/auto.dart';
import 'package:web_carros_app/pages/shared/loading_widget.dart';
import 'package:web_carros_app/services/local_storage_service.dart';
import 'package:web_carros_app/utils/styles.dart';

class HomeComponent extends StatefulWidget {
  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  LocalStorageService _localStorageService;
  List<Auto> favorites;
  bool loadingFavorites;
  bool loadingNewsAndTrend;

  _HomeComponentState() {
    this._localStorageService = LocalStorageService();
  }

  @override
  void initState() {
    super.initState();
    this._getFavoriteAutos();
    this._getNews();
  }

  _getNews() {
    setState(() {
      this.loadingNewsAndTrend = true;
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
        this.loadingNewsAndTrend = false;
      });
    });
  }

  _goToSettings() {
    print('settings');
  }

  _getAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Styles.appTitle,
        ),
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.all(10),
          child: InkWell(
            borderRadius: Styles.circularBorderRadius,
            onTap: () {
              this._goToSettings();
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: FaIcon(
                FontAwesomeIcons.bars,
                size: 22,
                color: Styles.mainTextColor,
              ),
            ),
          ),
        ),
      ],
    );
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Text(
        item.model,
        style: Styles.montText,
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
          // if (refresh) {
          //   this.updatePageContent();
          //   this.refresh = false;
          // }
          // updateAppBar();
        },
        openBuilder: (context, action) {
          return Container();
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
                  item.autoImagePath,
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
                  _getAppBar(),
                  // News
                  loadingNewsAndTrend
                      ? Container(
                          child: LoadingWidget(),
                        )
                      : Container(
                          child: Column(
                            children: [
                              _getSectionTitle('Novidades'),
                              Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: favorites
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