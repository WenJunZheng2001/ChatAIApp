import 'package:bloc_test/data/auth/auth_exceptions.dart';
import 'package:bloc_test/data/sqlite_database/database_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final firebaseAuth = AuthService.firebase();
  bool isDoingSomething = false;

  AuthBloc() : super(AuthInitialState()) {
    on<AuthRequestLoginEvent>((event, emit) async {
      if (isDoingSomething) {
        return;
      }
      isDoingSomething = true;
      emit(AuthLoadingState());

      try {
        final email = event.email;
        final password = event.password;
        final bool isValid = EmailValidator.validate(email);
        if (email == "" || password == "") {
          emit(AuthErrorState("Campo/i mancante/i"));
          isDoingSomething = false;
          return;
        }
        if (!isValid) {
          emit(AuthEmailInvalidState());
          isDoingSomething = false;
          return;
        }
        if (password.length < 7) {
          emit(AuthErrorState("Credenziali invalidi."));
          isDoingSomething = false;
          return;
        }

        final userOld = firebaseAuth.currentUser;
        if (userOld != null) {
          await firebaseAuth.logOut();
        }

        final user = await firebaseAuth.login(email: email, password: password);
        if (!user.isEmailVerified) {
          await firebaseAuth.sendEmailVerification();
          emit(AuthErrorState("Ti abbiamo inviato un email di verifica"));
          return;
        }
        emit(AuthLoginSuccessState());
        isDoingSomething = false;
      } on InvalidEmailAuthException {
        emit(AuthGenericFailState("Invalid email."));
        isDoingSomething = false;
      } on WrongPasswordAuthException {
        emit(AuthGenericFailState("Invalid password."));
        isDoingSomething = false;
      } on GenericAuthException {
        emit(AuthGenericFailState("Invalid credentials."));
        isDoingSomething = false;
      } catch (e) {
        emit(AuthGenericFailState("Qualcosa è andato storto."));
        isDoingSomething = false;
      }
    });

    on<AuthRequestRegistrationEvent>((event, emit) async {
      if (isDoingSomething) {
        return;
      }
      isDoingSomething = true;
      emit(AuthLoadingState());

      try {
        final email = event.email;
        final password = event.password;
        final confirmPassword = event.confirmPassword;
        final bool isValid = EmailValidator.validate(email);

        if (email == "" || password == "" || confirmPassword == "") {
          emit(AuthErrorState("Campo/i mancante/i"));
          isDoingSomething = false;
          return;
        } else if (!isValid) {
          emit(AuthEmailInvalidState());
          isDoingSomething = false;
          return;
        } else if (password.length < 7) {
          emit(AuthErrorState("Password troppo corta"));
          isDoingSomething = false;
          return;
        } else if (password != confirmPassword) {
          emit(AuthErrorState("Le password non coincidono"));
          isDoingSomething = false;
          return;
        }
        await firebaseAuth.createUser(email: email, password: password);
        await firebaseAuth.sendEmailVerification();
        emit(AuthRegistrationSuccessState());
        isDoingSomething = false;
      } on InvalidEmailAuthException {
        emit(AuthGenericFailState("Invalid email."));
        isDoingSomething = false;
      } on WrongPasswordAuthException {
        emit(AuthGenericFailState("Invalid password."));
        isDoingSomething = false;
      } on EmailAlreadyInUseAuthException {
        emit(AuthGenericFailState("Email già in uso."));
        isDoingSomething = false;
      } on GenericAuthException {
        emit(AuthGenericFailState("Invalid credentials."));
        isDoingSomething = false;
      } catch (e) {
        emit(AuthGenericFailState("Qualcosa è andato storto."));
        isDoingSomething = false;
      }
    });

    on<AuthResetPasswordEvent>((event, emit) async {
      try {
        if (state is AuthLoadingState) {
          return;
        }
        isDoingSomething = true;
        final email = event.email;
        if (email == "") {
          emit(AuthFailedSendResetPasswordState("Inserisci la tua email."));
          isDoingSomething = false;
          return;
        }
        await firebaseAuth.resetPassword(email: email);
        emit(AuthSentPasswordResetSuccessState());
        isDoingSomething = false;
      } on InvalidEmailAuthException {
        emit(AuthFailedSendResetPasswordState("Email invalida."));
        isDoingSomething = false;
      } on MissingEmailAuthException {
        emit(AuthFailedSendResetPasswordState("Email mancante."));
        isDoingSomething = false;
      } on UserNotFoundAuthException {
        emit(AuthFailedSendResetPasswordState("Utente non trovato."));
        isDoingSomething = false;
      } catch (e) {
        emit(AuthFailedSendResetPasswordState("C'è stato un problema."));
        isDoingSomething = false;
      }
    });

    on<AuthGoogleLoginEvent>((event, emit) async {
      try {
        if (isDoingSomething) {
          return;
        }
        isDoingSomething = true;
        emit(AuthLoadingState());
        final userOld = firebaseAuth.currentUser;
        if (userOld != null) {
          await firebaseAuth.logOut();
        }

        await firebaseAuth.googleLogin();
        emit(AuthLoginSuccessState());
        isDoingSomething = false;
      } catch (e) {
        emit(AuthGenericFailState("Login google interrotta."));
        isDoingSomething = false;
      }
    });

    on<AuthSignOutEvent>((event, emit) async {
      if (isDoingSomething) {
        return;
      }
      try {
        await firebaseAuth.logOut();
        await DatabaseProvider.deleteLocalDatabase();
        emit(AuthLogoutSuccessState());
      } catch (e) {
        emit(AuthGenericFailState(e.toString()));
      }
    });

    on<AuthAnonymousLoginEvent>((event, emit) async {
      try {
        if (isDoingSomething) {
          return;
        }
        isDoingSomething = true;
        emit(AuthLoadingState());
        await firebaseAuth.anonymousLogin();
        emit(AuthLoginSuccessState());
        isDoingSomething = false;
      } catch (e) {
        emit(AuthGenericFailState("Login anonima fail"));
        isDoingSomething = false;
      }
    });

    on<AuthDeleteAccountEvent>((event, emit) async {
      await firebaseAuth.deleteAccount();
      emit(AuthSuccessDeletedAccountState());
    });
  }
}
