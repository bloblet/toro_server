import 'package:aqueduct/aqueduct.dart';

void info(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.info(message, error, stackTrace);
void warning(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.warning(message, error, stackTrace);
void shout(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.shout(message, error, stackTrace);
void severe(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.severe(message, error, stackTrace);
void config(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.config(message, error, stackTrace);
void fine(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.fine(message, error, stackTrace);
void finer(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.finer(message, error, stackTrace);
void finest(dynamic message, [Object error, StackTrace stackTrace]) => Logger.root.finest(message, error, stackTrace);

const black = '\u001b[30m';
const red = '\u001b[31m';
const green = '\u001b[32m';
const yellow = '\u001b[33m';
const blue = '\u001b[34m';
const magenta = '\u001b[35m';
const cyan = '\u001b[36m';
const white = '\u001b[37m';

const brightBlack = '\u001b[30;1m';
const brightRed = '\u001b[31;1m';
const brightGreen = '\u001b[32;1m';
const brightYellow = '\u001b[33;1m';
const brightBlue = '\u001b[34;1m';
const brightMagenta = '\u001b[35;1m';
const brightCyan = '\u001b[36;1m';
const brightWhite = '\u001b[37;1m';
const bold = '\u001b[1m';
const underline = '\u001b[4m';
const reversed = '\u001b[7m';
const reset = '\u001b[0m';

const infoColor = cyan;
const warningColor = yellow;
const shoutColor = magenta;
const severeColor = red;
const configColor = blue;
const fineColor = underline;
const finerColor = underline;
const finestColor = underline;
