import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:tuple/tuple.dart';

String menuPattern = r'[ㄱ-ㅎ|가-힣]+.*[0-9]{1,2}(,[0-9]*)원$';
String pricePattern = r'[0-9]{0,2}(,?[0-9]*)원$';

RegExp menuRegex = RegExp(menuPattern);
RegExp priceRegex = RegExp(pricePattern);

class MenuInfo {
  String restaurant;
  String meal;
  String menuName;
  String price;
  String date;

  MenuInfo(String restaurant, String meal, String menuName, String price, String date):
        this.restaurant = restaurant,
        this.meal = meal,
        this.menuName = menuName,
        this.price = price,
        this.date = date;
}

Tuple2<String, String> menuAndPrice(String menuData) {
  final match = priceRegex.firstMatch(menuData);
  String tempMenuPrice = match!.group(0).toString();
  String tempMenuName = menuData.substring(0, menuData.length - tempMenuPrice.length - 1);
  return new Tuple2(tempMenuName, tempMenuPrice);
}


Future<List<MenuInfo>> getMenuInfo() async {
  List<MenuInfo> menuData = [];
  List<String> rawMenuData = [];

  var unescape = HtmlUnescape();

  String snuMenuUrl = 'https://snuco.snu.ac.kr/ko/foodmenu?field_menu_date_value_1%5Bvalue%5D%5Bdate%5D=&field_menu_date_value%5Bvalue%5D%5Bdate%5D=03%2F11%2F2022';
  final http.Response response = await http.get(Uri.parse(snuMenuUrl));
  dom.Document document = parser.parse(response.body);

  document.getElementsByTagName("tr").skip(1)
          .forEach((dom.Element element) { // 1 element : 1 restaurant
            String restaurant = '';
            String meal = '';

            var elements = element.getElementsByTagName('td'); // elements : rest, breakfast, lunch, dinner
            
            elements.forEach((elem) {
              var className = elem.className;

              if (className == 'views-field views-field-field-restaurant') {
                restaurant = elem.innerHtml;
                print(restaurant);
              } else if (className == 'views-field views-field-field-breakfast') {
                meal = '아침';
                print(meal);

                if (restaurant.contains('소담마루') || restaurant.contains('라운지오') || restaurant.contains('공대간이식당')) {
                  return;
                }

                var rows = elem.getElementsByTagName('p');
                rows.forEach((e) {
                  String menuData = unescape.convert(e.innerHtml.toString());
                  
                  if (menuData.contains('운영시간') || menuData.contains('혼잡시간')) {
                    return;
                  }

                  if (menuData.length > 1) {
                    print(menuData);
                    final menuData2 = menuAndPrice(menuData);
                    String menuName = menuData2.item1;
                    String menuPrice = menuData2.item2;
                    print('메뉴: ' + menuName);
                    print('가격: ' + menuPrice);
                  }
                });
              } else if (className == 'views-field views-field-field-lunch') {
                meal = '점심';
                print(meal);

                if (restaurant.contains('소담마루') || restaurant.contains('라운지오') || restaurant.contains('공대간이식당')) {
                  return;
                }

                var rows = elem.getElementsByTagName('p');

                if (restaurant.contains('두레미담') || restaurant.contains('감골식당')){
                  List menuList = [];

                  String menuData = unescape.convert(rows[0].innerHtml.toString());
                  final menuData2 = menuAndPrice(menuData);
                  String menuName = menuData2.item1;
                  String menuPrice = menuData2.item2;

                  rows.skip(1).forEach((e) {
                    String menuNames = unescape.convert(e.innerHtml.toString());
                    if (menuNames.contains('운영시간') || menuNames.contains('혼잡시간')) {
                      return;
                    } else {
                      menuList.add(menuNames);
                    }
                  });

                  print('메뉴: ' + menuName);
                  print(menuList);
                  print('가격: ' + menuPrice);
                } else if (restaurant.contains('301동식당')) {
                  rows.length -= 2;
                  rows.forEach((e) {
                    String menuData = unescape.convert(e.innerHtml.toString());
                    List _menuData = menuData.split('<br>\n');
                    List menuList = _menuData[_menuData.length-1].split(',');

                    final menuData2 = menuAndPrice(_menuData[_menuData.length-2]);
                    String menuName = menuData2.item1;
                    String menuPrice = menuData2.item2;

                    print('메뉴: ' + menuName);
                    print(menuList);
                    print('가격: ' + menuPrice);
                  });
                } else {
                  rows.forEach((e) {
                    String menuData = unescape.convert(e.innerHtml.toString());
                    if (menuData.contains('운영시간') || menuData.contains('혼잡시간')) {
                      return;
                    }

                    if (menuData.length > 1){
                      if (menuData.contains('교직원')) {
                        final menuData2 = menuAndPrice(menuData);
                        String menuName = menuData2.item1;
                        String menuPrice = menuData2.item2;
                        print('메뉴: ' + menuName);
                        print('가격: ' + menuPrice);
                        return;
                      } else if (menuData.contains('교직메뉴')) {
                        String menuType = '교직메뉴';
                        print(menuType);
                        return;
                      }
                      List _menuData = menuData.split('<br>\n');
                      print(_menuData);
                      _menuData.forEach((elem) {
                        if (elem.length <= 1) {
                          return;
                        }
                        final menuData2 = menuAndPrice(elem);
                        String menuName = menuData2.item1;
                        String menuPrice = menuData2.item2;
                        print('메뉴: ' + menuName);
                        print('가격: ' + menuPrice);
                      });
                    }
                  });
                }

              } else if (className == 'views-field views-field-field-dinner') {
                meal = '저녁';
                print(meal);

                if (restaurant.contains('소담마루') || restaurant.contains('라운지오') || restaurant.contains('공대간이식당')) {
                  return;
                }

                var rows = elem.getElementsByTagName('p');

                if (restaurant.contains('두레미담')){
                  List menuList = [];

                  String menuData = unescape.convert(rows[0].innerHtml.toString());
                  final menuData2 = menuAndPrice(menuData);
                  String menuName = menuData2.item1;
                  String menuPrice = menuData2.item2;

                  rows.skip(1).forEach((e) {
                    String menuNames = unescape.convert(e.innerHtml.toString());
                    if (menuNames.contains('운영시간') || menuNames.contains('혼잡시간')) {
                      return;
                    } else {
                      menuList.add(menuNames);
                    }
                  });

                  print('메뉴: ' + menuName);
                  print(menuList);
                  print('가격: ' + menuPrice);
                } else {
                  rows.forEach((e) {
                    String menuData = unescape.convert(e.innerHtml.toString());
                    if (menuData.contains('운영시간') || menuData.contains('혼잡시간')) {
                      return;
                    }
                    if (menuData.length > 1){
                      if (menuData.contains('교직메뉴')) {
                        String menuType = '교직메뉴';
                        print(menuType);
                        return;
                      }
                      List _menuData = menuData.split('<br>\n');
                      print(_menuData);
                      _menuData.forEach((elem) {
                        if (elem.length <= 1) {
                          return;
                        }
                        final menuData2 = menuAndPrice(elem);
                        String menuName = menuData2.item1;
                        String menuPrice = menuData2.item2;
                        print('메뉴: ' + menuName);
                        print('가격: ' + menuPrice);
                      });
                    }
                  });
                }
              }
            });

  });
  return menuData;
}