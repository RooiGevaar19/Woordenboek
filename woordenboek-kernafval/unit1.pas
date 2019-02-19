unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, sqlite3conn, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, Menus, DbCtrls, ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonSelectAll: TButton;
    ButtonAddEntry: TButton;
    ButtonEditEntry: TButton;
    ButtonRemoveEntry: TButton;
    ButtonFindEN: TButton;
    ButtonFindEN1: TButton;
    ButtonFindFL: TButton;
    ButtonFindFL1: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DBConnection: TSQLite3Connection;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    ItemClear: TMenuItem;
    ItemExit: TMenuItem;
    ItemEnter: TMenuItem;
    MenuImportCSV: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuExportCSV: TMenuItem;
    MenuExportXML: TMenuItem;
    MenuExport: TMenuItem;
    MenuImport: TMenuItem;
    MenuImportXML: TMenuItem;
    MenuExportCSV1: TMenuItem;
    MenuImportCSV1: TMenuItem;
    MenuItemView: TMenuItem;
    MenuSortID: TMenuItem;
    MenuSortEN: TMenuItem;
    MenuSortFL: TMenuItem;
    MenuReboot: TMenuItem;
    ImportCSVDialog: TOpenDialog;
    ImportXMLDialog: TOpenDialog;
    PopupMenu1: TPopupMenu;
    ExportCSVDialog: TSaveDialog;
    ExportXMLDialog: TSaveDialog;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    //procedure Button1Click(Sender: TObject);
    procedure ButtonSelectAllClick(Sender: TObject);
    procedure ButtonAddEntryClick(Sender: TObject);
    procedure ButtonEditEntryClick(Sender: TObject);
    procedure ButtonFindEN1Click(Sender: TObject);
    procedure ButtonFindENClick(Sender: TObject);
    procedure ButtonFindFL1Click(Sender: TObject);
    procedure ButtonFindFLClick(Sender: TObject);
    procedure ButtonRemoveEntryClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ItemClearClick(Sender: TObject);
    procedure ItemEnterClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure MenuExportCSV1Click(Sender: TObject);
    procedure MenuImportCSV1Click(Sender: TObject);
    procedure MenuImportCSVClick(Sender: TObject);
    procedure MenuExportCSVClick(Sender: TObject);
    procedure MenuExportXMLClick(Sender: TObject);
    procedure MenuImportXMLClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure ItemExitClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuRebootClick(Sender: TObject);
    procedure MenuSortENClick(Sender: TObject);
    procedure MenuSortFLClick(Sender: TObject);
    procedure MenuSortIDClick(Sender: TObject);
  private
    function OrderBySorttype() : String;
    procedure DeleteByID(id : String);
    procedure ShowDatabase();
  public
    arax       : LongInt;
    sorttype   : ShortInt;
  end;

var
  Form1      : TForm1;

implementation

uses Unit2, Unit3,
  XMLRead, XMLWrite, DOM;

{$R *.lfm}

{ TForm1 }

function TForm1.OrderBySorttype() : String;
begin
     if (sorttype = 1) then OrderBySorttype := 'ORDER BY woord_en'
     else if (sorttype = 2) then OrderBySorttype := 'ORDER BY woord_fl'
     else if (sorttype = 3) then OrderBySorttype := 'ORDER BY beschrijving'
     else OrderBySorttype := 'ORDER BY id_woord';
end;

procedure TForm1.DeleteByID(id : String);
var
   query : String;
begin
     query := 'DELETE FROM woord WHERE id_woord='+id+';';
     SQLQuery1.Close;
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.ExecSQL;
     SQLTransaction1.Commit;
     SQLQuery1.Close;
end;

procedure TForm1.ShowDatabase();
begin
     SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord '+OrderBySorttype();
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   query : String;
begin
     Edit1.Text := '';

     query := 'CREATE TABLE IF NOT EXISTS woord (id_woord INTEGER PRIMARY KEY AUTOINCREMENT, woord_en VARCHAR (50), woord_fl VARCHAR (50), beschrijving VARCHAR (100))';
     SQLQuery1.Close;
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.ExecSQL;
     SQLTransaction1.Commit;
     SQLQuery1.Close;

     sorttype := 0;
     ShowDatabase();
end;

procedure TForm1.ItemClearClick(Sender: TObject);
var
   query : String;
begin
     if mrOK=MessageDlg('Are you sure you want to clear the database?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
          query := 'DELETE FROM woord';
          SQLQuery1.Close;
          SQLQuery1.SQL.Text := query;
          DBConnection.Connected := True;
          SQLTransaction1.Active := True;
          SQLQuery1.ExecSQL;
          SQLTransaction1.Commit;
          SQLQuery1.Close;

          ShowDatabase();
     end;
end;

procedure TForm1.ItemEnterClick(Sender: TObject);
begin
     Form2.ShowModal;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuExportCSV1Click(Sender: TObject);
var
   fn  : String;
   fp  : Text;
   str : String;
begin
     if ExportCSVDialog.Execute then
     begin
          fn := ExportCSVDialog.FileName;
          assignfile(fp, fn);
          rewrite(fp);
          SQLQuery1.Close;
          SQLQuery1.SQL.Text := 'SELECT woord_en, woord_fl, beschrijving FROM woord';
          DBConnection.Connected := True;
          SQLTransaction1.Active := True;
          SQLQuery1.Open;
          SQLQuery1.First;
          while not SQLQuery1.EOF do
          begin
               str := '"' + SQLQuery1.FieldByName('woord_en').AsString + '","' +
                      SQLQuery1.FieldByName('woord_fl').AsString + '","' +
                      SQLQuery1.FieldByName('beschrijving').AsString + '"' + #10#13;
          write(fp, str);
          SQLQuery1.Next;
          end;
          closefile(fp);
          SQLQuery1.Close;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;

function InsertRecord(S : String; delimiter : Char) : String;
var
   query, i      : String;
   en, fl, notes : String;
   L             : TStrings;
begin
     L := TStringlist.Create;
     L.Delimiter := delimiter;
     L.QuoteChar := '"';
     L.StrictDelimiter := true;
     L.DelimitedText := S;
     en := L.Strings[0];
     fl := L.Strings[1];
     notes := L.Strings[2];
     query := 'INSERT INTO woord (woord_en, woord_fl, beschrijving) VALUES ';
     query := query + '(' + QuotedStr(en) + ',' + QuotedStr(fl) + ','+ QuotedStr(notes) +')';
     L.Free;
     InsertRecord := query;
end;

procedure TForm1.MenuImportCSV1Click(Sender: TObject);
var
   fp        : text;
   query, fn : String;
   S, E      : string;
begin
     if ImportCSVDialog.Execute then
     begin
          for fn in ImportCSVDialog.Files do
          begin
               try
                  assignfile(fp, fn);
                  reset(fp);
                  SQLQuery1.Close;
                  while not eof(fp) do
                  begin
                       readln(fp, S);
                       if (S = '') then continue;
                       query := InsertRecord(S, ',');
                       SQLQuery1.Close;
                       SQLQuery1.SQL.Text := query;
                       DBConnection.Connected := True;
                       SQLTransaction1.Active := True;
                       SQLQuery1.ExecSQL;
                  end;
                  SQLTransaction1.Commit;
                  SQLQuery1.Close;
                  closefile(fp);
               except
                     on E : Exception do
                     begin
                          SQLTransaction1.Rollback;
                          ShowMessage('An error occurred on '+#13#10+S+#13#10+'in '+fn+'.');
                          SQLQuery1.Close;
                          closefile(fp);
                     end;
               end;
          end;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;

procedure TForm1.MenuImportCSVClick(Sender: TObject);
var
   fp               : text;
   en, fl, notes    : String;
   query, fn        : String;
   L                : TStrings;
   S, E             : string;
begin
     if ImportCSVDialog.Execute then
     begin
          //fn := ImportCSVDialog.Files[0];
          //ShowMessage(fn);

          for fn in ImportCSVDialog.Files do
          begin
               try
               assignfile(fp, fn);
               reset(fp);
               SQLQuery1.Close;
               while not eof(fp) do
               begin
                    readln(fp, S);
                    if (S = '') then continue;
                    //https://forum.lazarus.freepascal.org/index.php?topic=33644.0
                    {*L := TStringlist.Create;
                       L.Delimiter := #9;
                       L.QuoteChar := '"';
                       L.StrictDelimiter := true;  // set this to false and the second 'test me' will be separate items! Try it.
                       L.DelimitedText := S;
                       //showmessage(S);
                       en := L.Strings[0];
                       fl := L.Strings[1];
                       notes := L.Strings[2];
                       //showmessage(''+en+' - '+fl+' - '+notes+'');
                       query := 'INSERT INTO woord (woord_en, woord_fl, beschrijving) VALUES ';
                       query := query + '(' + QuotedStr(en) + ',' + QuotedStr(fl) + ','+ QuotedStr(notes) +')';
                    *}
                    query := InsertRecord(S, #9);
                       SQLQuery1.Close;
                       SQLQuery1.SQL.Text := query;
                       DBConnection.Connected := True;
                       SQLTransaction1.Active := True;
                       SQLQuery1.ExecSQL;
                       //ShowMessage(concat('',en,' - ',fl,''));
                    //L.Free;
               end;
               SQLTransaction1.Commit;
               SQLQuery1.Close;
               closefile(fp);
               except
                     on E : Exception do
                     begin
                          SQLTransaction1.Rollback;
                          ShowMessage('An error occurred on '+#13#10+S+#13#10+'in '+fn+'.');
                          SQLQuery1.Close;
                          closefile(fp);
                     end;
               end;
          end;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;

procedure TForm1.MenuExportCSVClick(Sender: TObject);
var
   fn  : String;
   fp  : Text;
   str : String;
begin
     if ExportCSVDialog.Execute then
     begin
          fn := ExportCSVDialog.FileName;
          //showMessage(fn);
          //try
             assignfile(fp, fn);
             rewrite(fp);
             SQLQuery1.Close;
             SQLQuery1.SQL.Text := 'SELECT woord_en, woord_fl, beschrijving FROM woord';
             DBConnection.Connected := True;
             SQLTransaction1.Active := True;
             SQLQuery1.Open;
             SQLQuery1.First;
             while not SQLQuery1.EOF do
             begin
                  str := SQLQuery1.FieldByName('woord_en').AsString + #9 +
                         SQLQuery1.FieldByName('woord_fl').AsString + #9 +
                         SQLQuery1.FieldByName('beschrijving').AsString + #10#13;
                  write(fp, str);
                  SQLQuery1.Next;
             end;
             closefile(fp);
          //finally
          //end;

          SQLQuery1.Close;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;

procedure TForm1.MenuExportXMLClick(Sender: TObject);
var
   fn  : String;
   fp  : Text;
   str : String;
begin
     if ExportXMLDialog.Execute then
     begin
          fn := ExportXMLDialog.FileName;
          assignfile(fp, fn);
          rewrite(fp);
          SQLQuery1.Close;
          SQLQuery1.SQL.Text := 'SELECT woord_en, woord_fl, beschrijving FROM woord';
          DBConnection.Connected := True;
          SQLTransaction1.Active := True;
          SQLQuery1.Open;
          SQLQuery1.First;
          writeln(fp, '<dictionary>');
          while not SQLQuery1.EOF do
          begin
               str := #9 + '<entry><original>'+SQLQuery1.FieldByName('woord_en').AsString + '</original>' +
                   '<translation>' + SQLQuery1.FieldByName('woord_fl').AsString + '</translation>' +
                   '<description>' + SQLQuery1.FieldByName('beschrijving').AsString + '</description></entry>'
                   + #10#13;
               write(fp, str);
               SQLQuery1.Next;
          end;
          writeln(fp, '</dictionary>');
          closefile(fp);

          SQLQuery1.Close;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;

procedure TForm1.MenuImportXMLClick(Sender: TObject);
var
   fp               : text;
   en, fl, notes    : String;
   query, fn        : String;
   L                : TStrings;
   S, E             : string;
   PassNode         : TDOMNode;
   Doc              : TXMLDocument;
   Child            : TDOMNode;
begin
     if ImportXMLDialog.Execute then
     begin
          for fn in ImportXMLDialog.Files do
          begin
               try
               SQLQuery1.Close;
               ReadXMLFile(Doc, fn);
               Child := Doc.DocumentElement.FirstChild;
               while Assigned(Child) do
               begin
                    with Child.ChildNodes do
                    try
                       en := Item[0].FirstChild.NodeValue;
                       fl := Item[1].FirstChild.NodeValue;
                       notes := Item[2].FirstChild.NodeValue;
                    finally
                           Free;
                    end;
                    query := 'INSERT INTO woord (woord_en, woord_fl, beschrijving) VALUES ';
                    query := query + '(''' + en + ''',''' + fl + ''','''+notes+''')';
                    SQLQuery1.Close;
                    SQLQuery1.SQL.Text := query;
                    DBConnection.Connected := True;
                    SQLTransaction1.Active := True;
                    SQLQuery1.ExecSQL;
                    Child := Child.NextSibling;
               end;
               SQLTransaction1.Commit;
               SQLQuery1.Close;
               Doc.Free;
               except
                     on E : Exception do
                     begin
                          SQLTransaction1.Rollback;
                          ShowMessage('An error occurred on '+#13#10+S+#13#10+'in '+fn+'.');
                          SQLQuery1.Close;
                          Doc.Free;
                     end;
               end;
          end;
          ShowDatabase();
          ShowMessage('Finished!');
     end;
end;


procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.ItemExitClick(Sender: TObject);
begin
     if mrOK=MessageDlg('Are you sure you want to exit?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
          Application.Terminate;
          Exit;
     end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var
   i     : Integer;
begin
     with SQLQuery1 do
     for i := 0 to DBGrid1.SelectedRows.Count - 1 do
     begin
          GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
          FormEdit.id := Fields[0].AsInteger;
          FormEdit.ShowModal;
          if i <> DBGrid1.SelectedRows.Count - 1 then Next;
     end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
   i     : Integer;
   j     : String;
   itemz : TStringList;
begin
     if mrOK=MessageDlg('Are you sure you want to delete these records?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
          itemz := TStringList.Create;
          with SQLQuery1 do
          begin
               for i := 0 to DBGrid1.SelectedRows.Count - 1 do
               begin
                    GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
                    itemz.Add(Fields[0].AsString);
                    Next;
               end;
               for j in itemz do
               begin
                    //ShowMessage(j);
                    DeleteByID(j);
               end;
              ShowDatabase();
          end;
          itemz.Free;
     end;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

procedure TForm1.MenuRebootClick(Sender: TObject);
var
   query : String;
begin
    if mrOK=MessageDlg('Are you sure you want to destroy all base and load it again?'+#13#10+'The database will become empty afterwards.',mtConfirmation,[mbOK,mbCancel],0) then
     begin
            query := 'DROP TABLE IF EXISTS woord;';
            SQLQuery1.Close;
            SQLQuery1.SQL.Text := query;
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.ExecSQL;
            SQLTransaction1.Commit;
            SQLQuery1.Close;

            query := 'CREATE TABLE IF NOT EXISTS woord (id_woord INTEGER PRIMARY KEY AUTOINCREMENT, woord_en VARCHAR (50), woord_fl VARCHAR (50), beschrijving VARCHAR (100))';
            SQLQuery1.Close;
            SQLQuery1.SQL.Text := query;
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.ExecSQL;
            SQLTransaction1.Commit;
            SQLQuery1.Close;

            ShowDatabase();
     end;
end;

procedure TForm1.MenuSortENClick(Sender: TObject);
begin
     sorttype := 1;
     SQLQuery1.Close;
     ShowDatabase();
end;

procedure TForm1.MenuSortFLClick(Sender: TObject);
begin
     sorttype := 2;
     SQLQuery1.Close;
     ShowDatabase();
end;

procedure TForm1.MenuSortIDClick(Sender: TObject);
begin
     sorttype := 0;
     SQLQuery1.Close;
     ShowDatabase();
end;

procedure TForm1.ButtonAddEntryClick(Sender: TObject);
begin
    Form2.ShowModal;
end;

procedure TForm1.ButtonSelectAllClick(Sender: TObject);
var
   i : Integer;
begin
     DBGrid1.SelectedRows.Clear;
     DataSource1.DataSet.First;
     for i := 0 to DataSource1.DataSet.RecordCount-1 do
     begin
          DBGrid1.SelectedRows.CurrentRowSelected := not DBGrid1.SelectedRows.CurrentRowSelected;
          DataSource1.DataSet.Next;
     end;
end;


procedure TForm1.ButtonEditEntryClick(Sender: TObject);
var
   i : Integer;
begin
     with SQLQuery1 do
     begin
     for i := 0 to DBGrid1.SelectedRows.Count - 1 do
     begin
          GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
          FormEdit.id := Fields[0].AsInteger;
          FormEdit.ShowModal;
          if i <> DBGrid1.SelectedRows.Count - 1 then Next;
     end;
end;
end;

procedure TForm1.ButtonFindEN1Click(Sender: TObject);
begin
     SQLQuery1.Close;
     SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord '+OrderBySorttype();
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.ButtonFindENClick(Sender: TObject);
var query : String;
begin
     SQLQuery1.Close;
     query := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord ';
     query := query + 'WHERE woord_en LIKE ''%' +  Edit1.Text + '%'' '+OrderBySorttype();
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.ButtonFindFL1Click(Sender: TObject);
var
   query : String;
begin
     SQLQuery1.Close;
     query := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord ';
     query := query + 'WHERE beschrijving LIKE ''%' +  Edit1.Text + '%'' '+OrderBySorttype();
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.ButtonFindFLClick(Sender: TObject);
var query : String;
begin
     SQLQuery1.Close;
     query := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord ';
     query := query + 'WHERE woord_fl LIKE ''%' +  Edit1.Text + '%'' '+OrderBySorttype();
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.ButtonRemoveEntryClick(Sender: TObject);
var
   i     : Integer;
   j     : String;
   itemz : TStringList;
begin
     if mrOK=MessageDlg('Are you sure you want to delete these records?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
          itemz := TStringList.Create;
          with SQLQuery1 do
          begin
               for i := 0 to DBGrid1.SelectedRows.Count - 1 do
               begin
                    GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
                    itemz.Add(Fields[0].AsString);
                    Next;
               end;
               for j in itemz do
               begin
                    //ShowMessage(j);
                    DeleteByID(j);
               end;
              ShowDatabase();
          end;
          itemz.Free;
     end;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
var
   query  : String;
begin
     arax := DBGrid1.DataSource.DataSet.RecNo;
     //ShowMessage(IntToStr(arax));


     arax := DBGrid1.DataSource.DataSet.Fields[0].AsInteger;
     SQLQuery3.Close;
     //SQLQuery2.Close;
     //SQLQuery1.Close;
     query := 'SELECT id_woord FROM woord WHERE rowid='+IntToStr(arax)+';';
     //showmessage(query);
     SQLQuery3.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery3.Open;
     //showmessage(IntToStr(SQLQuery1.Fields[0].AsInteger));
     arax := SQLQuery3.Fields[0].AsInteger;
     //showmessage(IntToStr(arax));
     if (arax >= 1) then PopupMenu1.PopUp;
     //FormTrackProperties.ShowModal;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
     PopupMenu1.PopUp;
end;

end.

