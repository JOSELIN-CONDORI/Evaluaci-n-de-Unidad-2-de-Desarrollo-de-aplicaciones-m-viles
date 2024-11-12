import 'package:googleapis/sheets/v4.dart';

class SheetStyle {
  final List<String> item;
  SheetStyle(this.item);
  List<String> get headerRow => item;

  BatchUpdateSpreadsheetRequest getColumnFormatRequest(int sheetId) {
    return BatchUpdateSpreadsheetRequest.fromJson({
      'requests': [
        {
          'repeatCell': {
            'range': {
              'sheetId': sheetId,
              'startRowIndex': 0,
              'endRowIndex': 1,
              'startColumnIndex': 0,
              'endColumnIndex': item.length,
            },
            'cell': {
              'userEnteredFormat': {
                'backgroundColor': {
                  'red': 0.3,
                  'green': 0.5,
                  'blue': 0.8,
                },
                'textFormat': {
                  'fontSize': 14,
                  'bold': true,
                  'foregroundColor': {
                    'red': 1.0,
                    'green': 1.0,
                    'blue': 1.0,
                  },
                },
              },
            },
            'fields': 'userEnteredFormat(backgroundColor,textFormat)',
          },
        },
        {
          'repeatCell': {
            'range': {
              'sheetId': sheetId,
              'startRowIndex': 1,
              'startColumnIndex': 0,
              'endColumnIndex': item.length,
            },
            'cell': {
              'userEnteredFormat': {
                'backgroundColor': {
                  'red': 0.95,
                  'green': 0.95,
                  'blue': 1.0,
                },
                'textFormat': {
                  'fontSize': 12,
                  'foregroundColor': {
                    'red': 0.1,
                    'green': 0.1,
                    'blue': 0.0,
                  },
                },
              },
            },
            'fields': 'userEnteredFormat(backgroundColor,textFormat)',
          },
        },
      ],
    });
  }
}
