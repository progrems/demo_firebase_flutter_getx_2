// Routes contient les noms utilisés dans le code avec GetX.
// On écrit Routes.home au lieu de répéter directement "/home" partout.
class Routes {
  static const root = _Paths.root;
  static const accueil = _Paths.accueil;
  static const home = _Paths.home;
  static const login = _Paths.login;
  static const forgot = _Paths.forgot;
  static const register = _Paths.register;
  static const notFound = _Paths.notFound;
}

// _Paths garde les vraies chaînes de chemins.
// Cette séparation rend les redirections plus propres et plus faciles à changer.
class _Paths {
  static const root = '/';
  static const accueil = '/accueil';
  static const home = '/home';
  static const login = '/login';
  static const forgot = '/forgot';
  static const register = '/register';
  static const notFound = '/not-found';
}
