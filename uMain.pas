unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.TabControl, Winapi.Windows, uAvatar, uObst, uChao,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

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
    player: TImage;
    obst1: TImage;
    obst2: TImage;
    obst3: TImage;
    obst4: TImage;
    obst5: TImage;
    Timer1: TTimer;
    Timer2: TTimer;
    imgCenter: TImage;
    lblCenter: TLabel;
    FDTable: TFDTable;
    imgScore: TImage;
    lblScore: TLabel;

    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure verificarAgachar;

    procedure carregarImgCenter(img: String);
    procedure carregarImagem(img: TImage; imgNome: String; imgList: TimageList; x, y, altura, largura: Integer);

    procedure Enter;
    procedure Pausar;
    procedure FormShow(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    FestadoAtual: Integer; // 0 - Jogar | 1 - Jogando | 2 - Pausado | 3 - Perdeu
    Fvelocidade: Integer;
    Fscore: Integer;
  public
    property velocidade: Integer read Fvelocidade write Fvelocidade;
    property estadoAtual: Integer read FestadoAtual write FestadoAtual;
    property score: Integer read Fscore write Fscore;
  end;

var
  frmMain: TfrmMain;
  avt: TAvatar;
  obst: TObstaculos;
  chao: TChao;

implementation

{$R *.fmx}
{$R *.iPhone47in.fmx IOS}

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

procedure TfrmMain.carregarImgCenter(img: String);
var
  i, altura, largura: Integer;
  s: TSizeF;
begin
  altura  := 0;
  largura := 0;

  if img = 'jogar' then
  begin
    altura            := 174;
    largura           := 206;
    lblCenter.Visible := False;
  end
  else if img = 'perdeu' then
  begin
    altura            := 265;
    largura           := 253;
    lblCenter.Visible := True;
  end;

  if img <> '' then
  begin
    i := imgListOutros.Source.IndexOf(img);
    s.Create(largura, altura);

    with imgCenter do
    begin
      Bitmap     := imgListOutros.Bitmap(s, i);
      Position.X := ((pnlMain.Width - 30) - largura) /2;
      Position.Y := (pnlMain.Height - altura) /2;
      Height     := altura;
      Width      := largura;
      Visible    := True;
    end;
  end
  else
  begin
    imgCenter.Visible := False;
  end;
end;

procedure TfrmMain.Enter;
var
  i: Integer;
begin
  if estadoAtual = 0 then
  begin
    estadoAtual := 1;
  end
  else if estadoAtual = 3 then
  begin
    estadoAtual := 0;
    for i:= 0 to frmMain.ComponentCount - 1 do
    begin
      if (frmMain.Components[i].Name = 'obst1') or
         (frmMain.Components[i].Name = 'obst2') or
         (frmMain.Components[i].Name = 'obst3') or
         (frmMain.Components[i].Name = 'obst4') or
         (frmMain.Components[i].Name = 'obst5') then
      begin
        with TImage(frmMain.Components[i]) do
        begin
          Bitmap     := nil;
          Position.X := 616;
          Position.Y := 146;
          height     := 55;
          width      := 89;
          tag        := -1;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case key of
    vkreturn: // tecla enter
    begin
      Enter;
    end;
    vkup:     // tecla seta para cima
    begin
      avt.Pular;
    end;
  end;

  if CharInSet(KeyChar, ['p','P']) then
  begin
    pausar;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  avt  := TAvatar.Create;
  obst := TObstaculos.Create;
  chao := Tchao.Create;

  ClientHeight := trunc(pnlMain.Height);
  ClientWidth  := trunc(pnlMain.Width -30);
  TabControl1.ActiveTab := tabInicio;

  carregarImagem(imgBg,'bg',imgListBg,0,0,321,700);

  estadoAtual := 0; // 0 = Jogar
  velocidade  :=  8;
  obst1.Tag   := -1;
  obst2.Tag   := -1;
  obst3.Tag   := -1;
  obst4.Tag   := -1;
  obst5.Tag   := -1;

  FDTable.Active := True;
  lblScore.Position.X := 35;
  lblScore.Position.Y := 18;
end;

procedure TfrmMain.Pausar;
begin
  if estadoAtual = 1 then
  begin
    estadoAtual := 2;
  end
  else if estadoAtual = 2 then
  begin
    estadoAtual := 1;
  end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  lblScore.Text := 'Score: ' + score.ToString;
  lblCenter.Text := score.ToString;

  if estadoAtual = 0 then // 0 = Jogar
  begin
    carregarImgCenter('jogar');
    imgScore.Visible  := False;
    lblScore.Visible  := False;
    lblCenter.Visible := False;
    score := 0;
  end
  else if estadoAtual = 1 then // 1 = Jogando
  begin
    carregarImgCenter('');
    carregarImagem(imgScore,'folha',imgListOutros,0,10,46,140);
    imgScore.Visible  := True;
    lblScore.Visible  := True;
    lblCenter.Visible := False;
  end
  else if estadoAtual = 3 then // 3 = Perdeu
  begin
    carregarImgCenter('perdeu');
    lblCenter.Position.X := imgCenter.Position.X + ((imgCenter.Width - 20) /2);
    imgScore.Visible  := False;
    lblScore.Visible  := False;
    lblCenter.Visible := True;
  end;

  if estadoAtual <> 2 then // 2 = Pausado
  begin
    avt.atualizar;
    chao.atualizar;
    avt.velocidade:= avt.velocidade + avt.gravidade;
    if (player.Position.Y + player.Height) < imgChao.Position.Y then
    begin
      player.Position.Y:= player.Position.Y + avt.velocidade;
    end
    else if (player.Position.Y + player.Height) = imgChao.Position.Y then
    begin
       avt.salto:= 2;
       avt.velocidade:= 0;
    end
    else
    begin
      player.Position.Y:= imgChao.Position.Y - player.Height;
    end;
  end;
end;

procedure TfrmMain.Timer2Timer(Sender: TObject);
begin
  if estadoAtual = 1 then
  begin
    obst.atualizar(velocidade);
    verificarAgachar;
  end;
end;

procedure TfrmMain.verificarAgachar;
begin
  if GetKeyState(vkdown) and 128 > 0 then
  begin
    avt.Rolar;
  end
  else
  begin
    avt.agachar := false;
  end;
end;

end.
