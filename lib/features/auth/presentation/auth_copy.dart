class AuthCopy {
  const AuthCopy(this.languageName);

  final String languageName;

  bool get isKannada => languageName.toLowerCase() == 'kannada';

  String get loginTitle => isKannada ? 'ಮತ್ತೆ ಸ್ವಾಗತ' : 'Welcome back';
  String get loginSubtitle => isKannada
      ? 'ನಿಮ್ಮ ಆರೋಗ್ಯ ಪ್ರಯಾಣವನ್ನು ಮುಂದುವರಿಸಿ.'
      : 'Continue your preventive wellness journey.';
  String get signupTitle => isKannada ? 'ಖಾತೆ ರಚಿಸಿ' : 'Create your account';
  String get signupSubtitle => isKannada
      ? 'HealWise AI ನಲ್ಲಿ ನಿಮ್ಮ ವೈಯಕ್ತಿಕ ಆರೋಗ್ಯ ಸ್ಥಳವನ್ನು ಪ್ರಾರಂಭಿಸಿ.'
      : 'Start your personal wellness space in HealWise AI.';
  String get profileTitle =>
      isKannada ? 'ಆರೋಗ್ಯ ಪ್ರೊಫೈಲ್' : 'Health profile setup';
  String get profileSubtitle => isKannada
      ? 'ನಿಮ್ಮ ಸಲಹೆಗಳನ್ನು ವೈಯಕ್ತಿಕಗೊಳಿಸಲು ಮೂಲ ಮಾಹಿತಿ ಸೇರಿಸಿ.'
      : 'Add basic details so guidance can feel more personal.';
  String get email => isKannada ? 'ಇಮೇಲ್' : 'Email';
  String get password => isKannada ? 'ಪಾಸ್ವರ್ಡ್' : 'Password';
  String get fullName => isKannada ? 'ಪೂರ್ಣ ಹೆಸರು' : 'Full name';
  String get age => isKannada ? 'ವಯಸ್ಸು' : 'Age';
  String get gender => isKannada ? 'ಲಿಂಗ' : 'Gender';
  String get height => isKannada ? 'ಎತ್ತರ (ಸೆಂ.ಮೀ)' : 'Height (cm)';
  String get weight => isKannada ? 'ತೂಕ (ಕೆಜಿ)' : 'Weight (kg)';
  String get healthHistory => isKannada ? 'ಆರೋಗ್ಯ ಇತಿಹಾಸ' : 'Health history';
  String get lifestyleHabits =>
      isKannada ? 'ಜೀವನಶೈಲಿ ಅಭ್ಯಾಸಗಳು' : 'Lifestyle habits';
  String get loginButton => isKannada ? 'ಲಾಗಿನ್' : 'Login';
  String get signupButton => isKannada ? 'ಸೈನ್ ಅಪ್' : 'Sign up';
  String get saveProfile => isKannada ? 'ಪ್ರೊಫೈಲ್ ಉಳಿಸಿ' : 'Save profile';
  String get createAccount =>
      isKannada ? 'ಹೊಸ ಖಾತೆ ರಚಿಸಿ' : 'Create new account';
  String get alreadyAccount =>
      isKannada ? 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?' : 'Already have an account?';
  String get noAccount =>
      isKannada ? 'ಖಾತೆ ಇಲ್ಲವೇ?' : 'Do not have an account?';
  String get continueAsGuest =>
      isKannada ? 'ಡೆಮೋ ಆಗಿ ಮುಂದುವರಿಸಿ' : 'Continue demo';
  String get requiredField =>
      isKannada ? 'ಈ ಕ್ಷೇತ್ರ ಅಗತ್ಯವಿದೆ' : 'This field is required';
  String get invalidEmail =>
      isKannada ? 'ಸರಿಯಾದ ಇಮೇಲ್ ನಮೂದಿಸಿ' : 'Enter a valid email';
  String get shortPassword => isKannada
      ? 'ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳ ಪಾಸ್ವರ್ಡ್ ಬಳಸಿ'
      : 'Use at least 6 characters';
  String get medicalNote => isKannada
      ? 'HealWise AI ವೈದ್ಯಕೀಯ ಸಲಹೆಗೆ ಪರ್ಯಾಯವಲ್ಲ.'
      : 'HealWise AI supports wellness education and does not replace medical advice.';
}
