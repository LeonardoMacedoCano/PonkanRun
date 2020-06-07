unit uAvatar;

interface

uses FMX.Dialogs, FMX.Objects, System.Types;

type TAvatar = class
    x: Integer;
    y: Integer;
    altura: Integer;
    largura: Integer;
    velocidade: Double;
    salto: Integer;
    score: Integer;
    frame: Integer;
    fr1: Integer;
    gravidade: Double;
    forcaSalto: Double;
    agachar: boolean;

    procedure atualizar;
    procedure mudarSprite(width, height: Integer; img: String);

    procedure Rolar;
    procedure Pular;

    constructor Create;
    destructor Destroy; override;
end;

implementation
{ TAvt }

uses uMain;

procedure TAvatar.atualizar;
var
  s: TSizeF;
begin
  s.Create(frmMain.player.Width, frmMain.player.Height);

// Loop dos frames
  // rolando
  if agachar = true then
  begin
    if frame <= 20 then
    begin
      frame := frame +1;
    end
    else
    begin
      frame := 1;
    end;
  end;
  // pulando
  if salto = 1 then
  begin
    if frame <= 30 then
    begin
      frame := frame +1;
    end
    else
    begin
      frame := 1;
    end;
  end
  else if salto = 0 then
  begin
    if frame <= 20 then
    begin
      frame := frame +1;
    end
    else
    begin
      frame := 1;
    end;
  end;
  // andando
  if frame <= 90 then
  begin
    frame := frame +1;
  end
  else
  begin
    frame := 1;
  end;

// Loop das images por frames
  // pulando
  if (frmMain.player.Position.Y + frmMain.player.Height) < frmMain.imgChao.Position.Y then
  begin
    if salto = 1 then
    begin
      if frame <= 15 then
      begin
        mudarSprite(80, 78, 'avtsalto1');
      end
      else if (frame > 15) and (frame <= 30) then
      begin
        mudarSprite(79, 78, 'avtsalto2');
      end;
    end;
    if salto = 0 then
    begin
      if frame <= 10 then
      begin
        mudarSprite(66, 59, 'avtrolar1');
      end
      else if (frame > 10) and (frame <= 20) then
      begin
        mudarSprite(58, 60, 'avtrolar2');
      end;
    end;
  end
  // rolando
  else if agachar = true then
  begin
    if frame <= 10 then
    begin
       mudarSprite(79, 60, 'avtrolar3');
    end
    else if (frame > 10) and (frame <= 20) then
    begin
       mudarSprite(77, 60, 'avtrolar4');
    end;
  end
  // andando
  else if frame <= 10 then
  begin
    mudarSprite(69, 78, 'avt1');
  end
  else if (frame > 10) and (frame <= 15) then
  begin
    mudarSprite(70, 78, 'avt2');
  end
  else if (frame > 15) and (frame <= 25) then
  begin
    mudarSprite(83, 78, 'avt3');
  end
  else if (frame > 25) and (frame <= 35) then
  begin
    mudarSprite(72, 78, 'avt4');
  end
  else if (frame > 35) and (frame <= 45) then
  begin
    mudarSprite(69, 78, 'avt5');
  end
  else if (frame > 45) and (frame <= 55) then
  begin
    mudarSprite(69, 78, 'avt6');
  end
  else if (frame > 55) and (frame <= 60) then
  begin
    mudarSprite(70, 78, 'avt7');
  end
  else if (frame > 60) and (frame <= 70) then
  begin
    mudarSprite(83, 78, 'avt8');
  end
  else if (frame > 70) and (frame <= 80) then
  begin
    mudarSprite(72, 78, 'avt9');
  end
  else if (frame > 80) and (frame <= 90) then
  begin
    mudarSprite(69, 78, 'avt10');
  end;
end;

constructor TAvatar.Create;
begin
  gravidade := 1.5;
  velocidade := 0;
  forcaSalto := 23.6;
  salto := 0;
  agachar := false;
  score := 0;
  Frame := 0;
  Fr1 := 15;
end;

destructor TAvatar.Destroy;
begin

  inherited;
end;

procedure TAvatar.mudarSprite(width, height: Integer; img: String);
var
  s: TSizeF;
  i: integer;
begin
  s.Create(width, height);
  i                     := frmMain.imgListAvt.Source.IndexOf(img);
  frmMain.player.Width  := width;
  frmMain.player.Height := height;
  frmMain.player.Bitmap := frmMain.imgListAvt.Bitmap(s, i);
end;

procedure TAvatar.Pular;
begin
  if frmMain.estadoAtual = 1 then
  begin
    if salto > 0 then
    begin
      agachar := false;
      frmMain.player.Position.Y := frmMain.player.Position.Y -1;
      velocidade := - forcaSalto;
      salto := salto - 1;
      frame := 0;
    end;
  end;
end;

procedure TAvatar.Rolar;
begin
  if frmMain.estadoAtual = 1 then
  begin
    velocidade := forcaSalto;
    agachar    := true;
  end;
end;

end.
