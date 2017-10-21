unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormEdit }

  TFormEdit = class(TForm)
    ButtonAccept: TButton;
    ButtonCancel: TButton;
    EditEN: TEdit;
    EditFL: TEdit;
    EditNotes: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelXD: TLabel;
    procedure ButtonAcceptClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    id  : LongInt;
  end;

var
  FormEdit: TFormEdit;

implementation

Uses Unit1;

{$R *.lfm}

{ TFormEdit }

procedure TFormEdit.FormCreate(Sender: TObject);
begin

end;

procedure TFormEdit.ButtonCancelClick(Sender: TObject);
begin
     Close;
end;

procedure TFormEdit.ButtonAcceptClick(Sender: TObject);
var
   query : String;
begin
     if mrOK=MessageDlg('Are you sure you want to edit this record?',mtConfirmation,[mbOK,mbCancel],0) then
     begin
          Form1.SQLTransaction1.Active := False;
          Form1.SQLTransaction1.Active := True;
          query := 'UPDATE woord SET woord_en = '+QuotedStr(EditEN.Caption)+', woord_fl = '+QuotedStr(EditFL.Caption)+', beschrijving = '+QuotedStr(EditNotes.Caption)+' WHERE id_woord='+IntToStr(id)+';';
          Form1.SQLQuery2.Close;
          Form1.SQLQuery2.SQL.Text := query;
          Form1.DBConnection.Connected := True;
          Form1.SQLTransaction1.Active := True;
          Form1.SQLQuery2.ExecSQL;
          Form1.SQLTransaction1.Commit;
          Form1.SQLQuery2.Close;
          showmessage('Gewijzigd!');

          Form1.SQLQuery1.Close;
          Form1.SQLQuery1.SQL.Text := 'SELECT id_woord AS ''ID'', woord_en AS ''English Translation'', woord_fl AS ''Conlang Translation'', beschrijving AS ''Notes'' FROM woord';
          Form1.DBConnection.Connected := True;
          Form1.SQLTransaction1.Active := True;
          Form1.SQLQuery1.Open;
          Close;
     end;
end;

procedure TFormEdit.FormActivate(Sender: TObject);
begin
     LabelXD.Caption := IntToStr(id);
     EditEN.Text := '';
     EditFL.Text := '';
     EditNotes.Text := '';

      Form1.SQLQuery3.Close;
      Form1.SQLQuery3.SQL.Text := 'SELECT woord_en FROM woord WHERE id_woord='+IntToStr(id)+';';
      Form1.DBConnection.Connected := True;
      Form1.SQLTransaction1.Active := True;
      Form1.SQLQuery3.Open;
      EditEN.Text := Form1.SQLQuery3.Fields[0].AsString;

      Form1.SQLQuery3.Close;
      Form1.SQLQuery3.SQL.Text := 'SELECT woord_fl FROM woord WHERE id_woord='+IntToStr(id)+';';
      Form1.DBConnection.Connected := True;
      Form1.SQLTransaction1.Active := True;
      Form1.SQLQuery3.Open;
      EditFL.Text := Form1.SQLQuery3.Fields[0].AsString;

      Form1.SQLQuery3.Close;
      Form1.SQLQuery3.SQL.Text := 'SELECT beschrijving FROM woord WHERE id_woord='+IntToStr(id)+';';
      Form1.DBConnection.Connected := True;
      Form1.SQLTransaction1.Active := True;
      Form1.SQLQuery3.Open;
      EditNotes.Text := Form1.SQLQuery3.Fields[0].AsString;
end;

end.

