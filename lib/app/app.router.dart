// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/auth/auth_view.dart';
import '../ui/navbar/navbar_view.dart';
import '../ui/produce/price/price_create/price_create_view.dart';
import '../ui/produce/price/price_history/price_history_view.dart';
import '../ui/produce/price/price_list/price_list_view.dart';
import '../ui/produce/produce_view.dart';
import '../ui/startup/startup_view.dart';
import '../ui/statistics/statistics_view.dart';

class Routes {
  static const String startupView = '/';
  static const String navbarView = '/navbar-view';
  static const String statisticsView = '/statistics-view';
  static const String authView = '/auth-view';
  static const String produceView = '/produce-view';
  static const all = <String>{
    startupView,
    navbarView,
    statisticsView,
    authView,
    produceView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.navbarView, page: NavbarView),
    RouteDef(Routes.statisticsView, page: StatisticsView),
    RouteDef(Routes.authView, page: AuthView),
    RouteDef(
      Routes.produceView,
      page: ProduceView,
      generator: ProduceViewRouter(),
    ),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartupView(),
        settings: data,
      );
    },
    NavbarView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NavbarView(),
        settings: data,
      );
    },
    StatisticsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StatisticsView(),
        settings: data,
      );
    },
    AuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AuthView(),
        settings: data,
      );
    },
    ProduceView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProduceView(),
        settings: data,
      );
    },
  };
}

class ProduceViewRoutes {
  static const String priceListView = '/price-list-view';
  static const all = <String>{
    priceListView,
  };
}

class ProduceViewRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(
      ProduceViewRoutes.priceListView,
      page: PriceListView,
      generator: PriceListViewRouter(),
    ),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    PriceListView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PriceListView(),
        settings: data,
      );
    },
  };
}

class PriceListViewRoutes {
  static const String priceCreateView = '/price-create-view';
  static const String priceHistoryView = '/price-history-view';
  static const all = <String>{
    priceCreateView,
    priceHistoryView,
  };
}

class PriceListViewRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(PriceListViewRoutes.priceCreateView, page: PriceCreateView),
    RouteDef(PriceListViewRoutes.priceHistoryView, page: PriceHistoryView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    PriceCreateView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PriceCreateView(),
        settings: data,
      );
    },
    PriceHistoryView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PriceHistoryView(),
        settings: data,
      );
    },
  };
}
