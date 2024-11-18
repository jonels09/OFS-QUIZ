class TranslationService {
  static Map<String, Map<String, String>> translations = {
    'fr': {
      'app_title': 'Quiz Franciscain',
      'welcome': 'Bienvenue au Quiz Franciscain',
      'start_quiz': 'Commencer le Quiz',
      'view_scores': 'Voir les scores',
      'quiz': 'Quiz',
      'score': 'Score',
      'percentage': 'Pourcentage',
      'back_home': 'Retour à l\'accueil',
      'restart': 'Recommencer',
      'score_history': 'Historique des scores',
      'no_scores': 'Aucun score enregistré',
      'no_scores_category': 'Aucun score pour cette catégorie',
      'category': 'Catégorie',
      'date': 'Date',
      'loading': 'Chargement...',
      'quiz_finished': 'Quiz terminé !',
      'final_score': 'Score final',
      'select_category': 'Choisissez une catégorie',
      'category_vie_saint_francois': 'Vie de Saint François',
      'category_bible': 'Bible',
      'choose_theme_color': 'Choisir la couleur du thème',
      'cancel': 'Annuler',
    },
    'mg': {
      'app_title': 'Kilalao Fanontaniana Fransiskana',
      'welcome': 'Tongasoa eto amin\'ny Kilalao Fanontaniana Fransiskana',
      'start_quiz': 'Atombohy ny Kilalao',
      'view_scores': 'Hijery ny isa azo',
      'quiz': 'Fanontaniana',
      'score': 'Isa azo',
      'percentage': 'Isan-jato',
      'back_home': 'Hiverina any am-piandohana',
      'restart': 'Averina indray',
      'score_history': 'Tantaran\'ny isa azo',
      'no_scores': 'Tsy misy isa voarakitra',
      'no_scores_category': 'Tsy misy isa ho an\'ity sokajy ity',
      'category': 'Sokajy',
      'date': 'Daty',
      'loading': 'Andrasana kely...',
      'quiz_finished': 'Vita ny kilalao !',
      'final_score': 'Isa farany',
      'select_category': 'Misafidiana sokajy',
      'category_vie_saint_francois': 'Fiainan\'i Masindahy François',
      'category_bible': 'Baiboly',
      'choose_theme_color': 'Misafidiana loko',
      'cancel': 'Aoka ihany',
    },
  };

  static String translate(String key, String languageCode) {
    return translations[languageCode]?[key] ?? translations['fr']![key]!;
  }
}
