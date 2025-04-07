unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  KeyPreview:=True;
//  BorderStyle:=bsDialog;
  ShowMessage('FormCreate')
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #27) then Close;
end;

end.
