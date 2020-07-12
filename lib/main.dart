import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/models/notificationModel.dart';
import 'package:lolipop_book_store/models/searchBookModel.dart';
import 'package:lolipop_book_store/screens/book_detail/book_detail.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/screens/news_book/newsBook.dart';
import 'package:lolipop_book_store/screens/notifications/promotion.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:lolipop_book_store/viewmodels/CRUDSearchBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiengviet/tiengviet.dart';
import 'screens/home/home.dart';
import 'screens/profile/profile.dart';
import 'screens/carts/cart.dart';
import 'screens/categories/categories.dart';
import 'screens/spash_screen/splash_screen.dart';
import 'widgets/drawer.dart';

void main() => runApp(MaterialApp(home: SplashScreen()));
final Map<String, NotificationModel> _noti = <String, NotificationModel>{};
final Map<String, Route<void>> routes = <String, Route<void>>{};

NotificationModel _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final NotificationModel noti = _noti.putIfAbsent(
      data['notiID'],
      () => NotificationModel(
          notiID: data['notiID'],
          imageURL: data['imageURL'],
          content: data['content'],
          title: data['title'],
          date: data['date']));
  return noti;
}

class MyApp extends StatelessWidget {
  static const String _title = 'Lolipop Book Store';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _topicButtonsDisabled = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
      TextEditingController(text: 'topic');

  Widget _buildDialog(BuildContext context, NotificationModel noti) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: Container(
        height: 180,
        child: Column(children: [
          CachedNetworkImage(
              imageUrl: noti.imageURL,
              width: 300,
              height: 100,
              fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(
            noti.title,
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.blueAccent[800],
                fontWeight: FontWeight.bold,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            noti.content,
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              color: Colors.grey[700],
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ]),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final NotificationModel noti = _itemForMessage(message);

    String routeName = '/detail/$noti.notiID';
    Route route = routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => Promotion(noti),
      ),
    );
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!route.isCurrent) {
      Navigator.push(context, route);
    }
  }

  Route<void> get getNewsBookRoute {
    final String routeName = '/newsBook';

    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => NewsBook(),
      ),
    );
  }

  void _navigateHome() {
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!getNewsBookRoute.isCurrent) {
      Navigator.push(context, getNewsBookRoute);
    }
  }

  _SearchAppBarDelegate _searchDelegate;
  CRUDSearchBook crudSearchBook = new CRUDSearchBook();
  bool _isSearch = false;
  _getSearchBook() async {
    final List<String> kWords = [];
    List<SearchBook> searchBook = await crudSearchBook.fetchsearchBooks();
    // searchBook.forEach((searchBook) {
    //   kWords.add(searchBook.tenSach.trim());
    // });
    _searchDelegate = _SearchAppBarDelegate(searchBook);
    //print(kWords);
    _isSearch = true;
  }

  int _selectedIndex = 0;
  //Todo: Custom TextStyle
  static const TextStyle bottomItemStyle =
      TextStyle(fontFamily: 'RobotoSlab', fontSize: 13.0);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Category(),
    Cart(),
    NewsBook(),
    Profile(),
    LoginPage()
  ];
  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');

    if (_userEmail != null) {
      print('User email: ' + _userEmail);

      return _userEmail;
    } else
      return '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSearchBook();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data']['type'] == 'suggestbook') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetails(
                      idDM: message['data']['idDM'],
                      idBook: message['data']['idBook'])));
        } else if (message['data']['type'] == 'promotion') {
          _navigateToItemDetail(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data']['type'] == 'suggestbook') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetails(
                      idDM: message['data']['idDM'],
                      idBook: message['data']['idBook'])));
        } else if (message['data']['type'] == 'promotion') {
          print("onResume: $message");
          _navigateToItemDetail(message);
        }
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {});
    });
  }

  //Todo: Xử lý hành động tap của BottomNavigationBar
  void _onItemTapped(int index) async {
    if (index == 4) {
      String _userEmail = await _getUserEmail();
      if (_userEmail == '' || _userEmail == null) {
        _widgetOptions[4] = LoginPage();
      } else {
        _widgetOptions[4] = Profile();
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lollipop Store',
            style: TextStyle(fontFamily: 'RobotoSlab')),
        backgroundColor: Colors.amber[700],
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (_isSearch == true) {
                  showSearchPage(context, _searchDelegate);
                } else
                  print("wait");
              })
        ],
      ),
      drawer: new DrawerWidget(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: Text(
              'Trang Chủ',
              style: bottomItemStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text(
              'Danh Mục',
              style: bottomItemStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text(
              'Giỏ Hàng',
              style: bottomItemStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text(
              'Tiêu Điểm',
              style: bottomItemStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Cá Nhân',
              style: bottomItemStyle,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
      ),
    );
  }

  void showSearchPage(
      BuildContext context, _SearchAppBarDelegate searchDelegate) async {
    final SearchBook selected = await showSearch<SearchBook>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${selected.tenSach}'),
        ),
      );
    }
  }
}

class _SearchAppBarDelegate extends SearchDelegate<SearchBook> {
  final List<SearchBook> _searchBook;
  final List<SearchBook> _history;

  _SearchAppBarDelegate(List<SearchBook> searchBook)
      : _searchBook = searchBook,
        //pre-populated history of words
        _history = <SearchBook>[],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    _getOneSearchBook(String bookID) async {
      print(bookID);
      CRUDSearchBook crudSearchBook = CRUDSearchBook();
      BookModel book;
      SearchBook searchBook =
          await crudSearchBook.getSearchBookById(bookID.trim());
      print(searchBook.idDM + 'v');
      if (searchBook != null) {
        CRUDBook crudBook = new CRUDBook(searchBook.idDM.trim());
        book = await crudBook.getBookByTitleBook(bookID.trim());
      }
      return book;
    }

    return FutureBuilder(
        future: _getOneSearchBook(this.query),
        builder: (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
          if (snapshot.hasData == true && snapshot.data != null) {
            return BookDetails(
              bookModel: snapshot.data,
            );
          } else {
            return Center(
                child: Text('Không tìm thấy sách ☹',
                    style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 20)));
          }
        });
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    print(tiengviet(query.toLowerCase()));
    final Iterable<SearchBook> suggestions = this.query.isEmpty
        ? _history
        : _searchBook.where((book) => book.tenKhongDau
            .trim()
            .toLowerCase()
            .startsWith(tiengviet(query.toLowerCase())));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (SearchBook suggestion) {
        this.query = suggestion.tenSach;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : Container(
              height: 0,
              width: 0,
            ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<SearchBook> suggestions;
  final String query;
  final ValueChanged<SearchBook> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final SearchBook suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty
              ? Icon(Icons.history)
              : CachedNetworkImage(
                  imageUrl: suggestion.biaSach,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.tenSach.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.tenSach.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
