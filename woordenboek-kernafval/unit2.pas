unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButtonAccept: TButton;
    ButtonCancel: TButton;
    EditEN: TEdit;
    EditFL: TEdit;
    EditNotes: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure ButtonAcceptClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.ButtonCancelClick(Sender: TObject);
begin
     //if mrOK=MessageDlg('Bent u seker, dat u wilt canceleren ?',mtConfirmation,[mbOK,mbCancel],0) then
     //begin
          Close;
     //end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
     EditEN.Text := '';
     EditFL.Text := '';
     EditNotes.Text := '';
end;

procedure TForm2.ButtonAcceptClick(Sender: TObject);
var
   query : String;
begin
     //if mrOK=MessageDlg('Are you sure you want to add a new record?',mtConfirmation,[mbOK,mbCancel],0) then
     //begin
          query := 'INSERT INTO woord (woord_en, woord_fl, beschrijving) VALUES ';
          query := query + '(''' + EditEN.Text + ''',''' + EditFL.Text + ''',''' + EditNotes.Text + ''')';
          Form1.SQLQuery1.Close;
          Form1.SQLQuery1.SQL.Text := query;
          Form1.DBConnection.Connected := True;
          Form1.SQLTransaction1.Active := True;
          Form1.SQLQuery1.ExecSQL;
          Form1.SQLTransaction1.Commit;
          Form1.SQLQuery1.Close;
          showmessage('Toegevoegd!');

          Form1.SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
          Form1.DBConnection.Connected := True;
          Form1.SQLTransaction1.Active := True;
          Form1.SQLQuery1.Open;
          Close;
     //end;
end;

end.

