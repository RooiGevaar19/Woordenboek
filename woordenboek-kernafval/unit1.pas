unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, sqlite3conn, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
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
    ItemFile: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuReboot: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure ButtonFindEN1Click(Sender: TObject);
    procedure ButtonFindENClick(Sender: TObject);
    procedure ButtonFindFL1Click(Sender: TObject);
    procedure ButtonFindFLClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure ItemClearClick(Sender: TObject);
    procedure ItemEnterClick(Sender: TObject);
    procedure ItemFileClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure ItemExitClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuRebootClick(Sender: TObject);
  private
    { private declarations }
  public
    arax       : LongInt;
  end;

var
  Form1      : TForm1;

implementation

uses Unit2, Unit3;

{$R *.lfm}

{ TForm1 }

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

     SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
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

          SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
          DBConnection.Connected := True;
          SQLTransaction1.Active := True;
          SQLQuery1.Open;
     end;
end;

procedure TForm1.ItemEnterClick(Sender: TObject);
begin
     Form2.ShowModal;
end;

procedure TForm1.ItemFileClick(Sender: TObject);
var
   fp               : text;
   en, fl, notes    : String;
   query, fn        : String;
   L                : TStrings;
   S, E             : string;
begin
     if OpenDialog1.Execute then
     begin
          fn := OpenDialog1.Filename;
          //ShowMessage(fn);
          assignfile(fp, fn);
          reset(fp);
          while not eof(fp) do
          begin
               //readln(fp, en); readln(fp, fl); readln(fp, notes);
               readln(fp, S);
               if (S = '') then continue;
               //https://forum.lazarus.freepascal.org/index.php?topic=33644.0
               L:=TStringlist.Create;
               try
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
                  query := query + '(''' + en + ''',''' + fl + ''','''+notes+''')';
                  //query := 'INSERT INTO woord (woord_en, woord_fl, bescheijving) VALUES (''a'',''b'',''c'')';
                  SQLQuery1.Close;
                  SQLQuery1.SQL.Text := query;
                  DBConnection.Connected := True;
                  SQLTransaction1.Active := True;
                  SQLQuery1.ExecSQL;
                  SQLTransaction1.Commit;
                  SQLQuery1.Close;
                  //ShowMessage(concat('',en,' - ',fl,''));
               finally
                      L.Free;
               end;
          end;
          closefile(fp);
          SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
          DBConnection.Connected := True;
          SQLTransaction1.Active := True;
          SQLQuery1.Open;
          ShowMessage('Added successfully!');
     end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.ItemExitClick(Sender: TObject);
begin
     //if mrOK=MessageDlg('Bent u zeker dat u wilt afsluiten ?',mtConfirmation,[mbOK,mbCancel],0) then
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
begin
     FormEdit.id := arax;
     FormEdit.ShowModal;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
   query : String;
begin
     if mrOK=MessageDlg('Are you sure you want to delete this record?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
            query := 'DELETE FROM woord WHERE id_woord='+IntToStr(arax)+';';
            SQLQuery1.Close;
            SQLQuery1.SQL.Text := query;
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.ExecSQL;
            SQLTransaction1.Commit;
            SQLQuery1.Close;

            SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.Open;
     end;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

procedure TForm1.MenuRebootClick(Sender: TObject);
var
   query : String;
begin
    if mrOK=MessageDlg('Are you sure ou want to destroy all base and load it again?'+#13#10+'The database will become empty afterwards.',mtConfirmation,[mbOK,mbCancel],0) then
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

            SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.Open;
     end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   query : String;
begin
     if mrOK=MessageDlg('Are ou sure you want to clear the database?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
            query := 'DELETE FROM woord';
            SQLQuery1.Close;
            SQLQuery1.SQL.Text := query;
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.ExecSQL;
            SQLTransaction1.Commit;
            SQLQuery1.Close;

            SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
            DBConnection.Connected := True;
            SQLTransaction1.Active := True;
            SQLQuery1.Open;
     end;
end;

procedure TForm1.ButtonFindEN1Click(Sender: TObject);
begin
     SQLQuery1.Close;
     SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
end;

procedure TForm1.ButtonFindENClick(Sender: TObject);
var query : String;
begin
     SQLQuery1.Close;
     query := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord ';
     query := query + 'WHERE woord_en LIKE ''%' +  Edit1.Text + '%''';
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
     query := query + 'WHERE beschrijving LIKE ''%' +  Edit1.Text + '%''';
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
     query := query + 'WHERE woord_fl LIKE ''%' +  Edit1.Text + '%''';
     SQLQuery1.SQL.Text := query;
     DBConnection.Connected := True;
     SQLTransaction1.Active := True;
     SQLQuery1.Open;
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

end.

