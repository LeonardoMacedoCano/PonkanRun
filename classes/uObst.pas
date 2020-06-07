unit uObst;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani, System.ImageList,
  FMX.ImgList;

type TObstaculos = class
  public
  x: Integer;
  y: Integer;
  altura: Integer;
  largura: Integer;

  procedure atualizar(velocidade: Integer);
  procedure posicao(velocidade: Integer);

  constructor Create;
  destructor Destroy; override;
end;

var
  tempoInsere: Integer;
  distancia: Integer;

implementation
{ TObstaculos }

uses uMain;

procedure TObstaculos.atualizar(velocidade: Integer);
var
  modelo, i: Integer;
  s: TSizeF;
begin
  if tempoInsere > 0 then
  begin
    tempoInsere := tempoInsere -1;
  end
  else
  if tempoInsere = 0 then
  begin
    tempoInsere := distancia + Random(21);
    modelo := 0 + Random(3);
  
    if modelo = 0 then
    begin
      altura := 55;
      largura  := 89;
      y := trunc(frmMain.imgBg.Height - altura);
      x := trunc(frmMain.imgBg.Width - largura);
    end
    else if modelo = 1 then
    begin
      altura := 98;
      largura  := 71;
      y := trunc(frmMain.imgBg.Height - altura);
      x := trunc(frmMain.imgBg.Width - largura);
    end
    else if modelo = 2 then
    begin
      altura := 171;
      largura  := 49;
      y := trunc((frmMain.imgBg.Height - 61) - altura);
      x := trunc(frmMain.imgBg.Width - largura);
    end;

    s.Create(largura, altura);

    for i:= 0 to frmMain.ComponentCount - 1 do
    begin
      if (frmMain.Components[i].Name = 'obst1') or
         (frmMain.Components[i].Name = 'obst2') or
         (frmMain.Components[i].Name = 'obst3') or
         (frmMain.Components[i].Name = 'obst4') or
         (frmMain.Components[i].Name = 'obst5') then
      begin
        if (TImage(frmMain.Components[i]).tag < 0) then
        begin
          with TImage(frmMain.Components[i]) do
          begin
            Bitmap     := frmMain.imgListObst.Bitmap(s, modelo);
            Position.X := x;
            Position.Y := y;
            height     := altura;
            width      := largura;
            tag        := modelo;
            break
          end;
        end;
      end;
    end;
  end;
  posicao(velocidade);
end;

constructor TObstaculos.Create;
begin
  distancia := 40;
  tempoInsere := distancia + Random(21);

end;

destructor TObstaculos.Destroy;
begin
  inherited;
  //
end;

procedure TObstaculos.posicao(velocidade: Integer);
var
  i: Integer;
begin
  for i:= 0 to frmMain.ComponentCount - 1 do
  begin
    if (frmMain.Components[i].Name = 'obst1') or
       (frmMain.Components[i].Name = 'obst2') or
       (frmMain.Components[i].Name = 'obst3') or
       (frmMain.Components[i].Name = 'obst4') or
       (frmMain.Components[i].Name = 'obst5') then
    begin
      if (TImage(frmMain.Components[i]).tag <> -1) then
      begin
        if (TImage(frmMain.Components[i]).tag = 0) or (TImage(frmMain.Components[i]).tag = 1) then
        begin
          if (TImage(frmMain.Components[i]).Position.X <= frmMain.player.position.x + frmMain.player.Width) and
             (TImage(frmMain.Components[i]).Position.Y <= frmMain.player.Position.Y + frmMain.player.height) then
          begin
            frmMain.estadoAtual := 3;
          end
          else
          begin
            TImage(frmMain.Components[i]).Position.X := TImage(frmMain.Components[i]).Position.X - velocidade;
          end;
        end
        else if TImage(frmMain.Components[i]).tag = 2 then
        begin
          if (TImage(frmMain.Components[i]).Position.X <= frmMain.player.position.x + frmMain.player.Width) and
             (TImage(frmMain.Components[i]).Position.Y + TImage(frmMain.Components[i]).Height >= frmMain.player.Position.Y) and
             (TImage(frmMain.Components[i]).Position.Y <= frmMain.player.Position.Y + frmMain.player.Height) then
          begin
            frmMain.estadoAtual := 3;
          end
          else
          begin
            TImage(frmMain.Components[i]).Position.X := TImage(frmMain.Components[i]).Position.X - velocidade;
          end;
        end;
        if (TImage(frmMain.Components[i]).Position.X + TImage(frmMain.Components[i]).Width < frmMain.player.Position.X) then
        begin
          frmMain.score := frmMain.score +1;
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
end;

end.
