unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.TabControl;

type
  TfrmMain = class(TForm)
    pnlMain: TPanel;
    imgListAvt: TImageList;
    imgListObst: TImageList;
    imgListBg: TImageList;
    imgListOutros: TImageList;
    TabControl1: TTabControl;
    tabInicio: TTabItem;
    tabJogo: TTabItem;
    imgChao: TImage;
    imgBg: TImage;
    Button1: TButton;

    procedure carregarImagem(img: TImage; imgNome: String; imgList: TimageList; x, y, altura, largura: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

{ TForm1 }

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  TabControl1.ActiveTab := tabJogo;
end;

procedure TfrmMain.carregarImagem(img: TImage; imgNome: String;
  imgList: TimageList; x, y, altura, largura: Integer);
var
  i: Integer;
  s: TSizeF;
begin
  i := imgList.Source.IndexOf(imgNome);
  s.Create(largura, altura);

  with img do
  begin
    Bitmap     := imgList.Bitmap(s, i);
    Position.X := x;
    Position.Y := y;
    height     := altura;
    width      := largura;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ClientHeight := trunc(pnlMain.Height);
  ClientWidth  := trunc(pnlMain.Width -30);
  TabControl1.ActiveTab := tabInicio;

  carregarImagem(imgBg,'bg',imgListBg,0,0,321,700);
  carregarImagem(imgChao,'chao',imgListBg,0,321,49,700);

end;

end.
