unit uChao;

interface

uses FMX.Dialogs, FMX.Objects, System.Types, FMX.ImgList;

type TChao = class
    x: Integer;
    y: Integer;
    altura: Integer;
    largura: Integer;
    img: TImage;
    imgNome: String;
    imgList: TimageList;

    procedure atualizar;
    constructor Create;
    destructor Destroy; override;
end;
implementation
{ TChao }

uses uMain;

procedure TChao.atualizar;
begin
  frmMain.imgChao.Position.X := frmMain.imgChao.Position.X - frmMain.velocidade;
  if frmMain.imgChao.Position.X <= -30 then
  begin
    frmMain.imgChao.Position.X := 0;
  end;
end;

constructor TChao.Create;
begin
  x       := 0;
  y       := 321;
  altura  := 49;
  largura := 700;
  img     := frmMain.imgChao;
  imgNome := 'chao';
  imgList := frmMain.imgListBg;

  frmMain.carregarImagem(img,imgNome,imgList,x,y,altura,largura);
end;

destructor TChao.Destroy;
begin
  //
  inherited;
end;

end.
