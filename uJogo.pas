unit uJogo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    imgAvt: TImageList;
    imgObst: TImageList;
    imgBg: TImageList;
    imgOutros: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

end.