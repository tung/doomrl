{$INCLUDE doomrl.inc}
unit doomconfig;
interface

uses Classes, SysUtils, vluaconfig;

type

{ TDoomConfig }

TDoomConfig = class(TLuaConfig)
  constructor Create( const FileName : Ansistring; Reload : Boolean );
end;


implementation

uses vsystems, dfdata, vluastate, vlualibrary, doomlua, doomhelp, dfitem, doomio, doomviews;


{ TDoomConfig }

constructor TDoomConfig.Create( const FileName : Ansistring; Reload : Boolean );
begin
  inherited Create;

  SetConstant('VERSION_STRING', VERSION_STRING);
  SetConstant('VERSION_BETA',   VERSION_BETA);

  LoadMain( FileName );

  Option_Graphics         := Configure('Graphics',Option_Graphics);
  Option_Blending         := Configure('Blending',Option_Blending);
  Option_SaveOnCrash      := Configure('SaveOnCrash',Option_SaveOnCrash);
  Option_SoundEngine      := Configure('SoundEngine',Option_SoundEngine);

  Option_HighASCII        := Configure(
    'AllowHighAscii', Option_HighASCII or ForceSDLConsole or (Option_Graphics = 'SDLCONSOLE'));
  Option_AlwaysName       := Configure('AlwaysName',Option_AlwaysName);
  Option_Music            := Configure('GameMusic',Option_Music);
  Option_Sound            := Configure('GameSound',Option_Sound);
  Option_BlindMode        := Configure('BlindMode',Option_BlindMode);
  Option_ClearMessages    := Configure('ClearMessages',Option_ClearMessages);// TODO : Reimplement
  Option_MorePrompt       := Configure('MorePrompt',Option_MorePrompt);
  Option_MessageColoring  := Configure('MessageColoring',Option_MessageColoring);
  Option_InvFullDrop      := Configure('InvFullDrop',Option_InvFullDrop);
  Option_MortemArchive    := Configure('MortemArchive',Option_MortemArchive);
  Option_MenuReturn       := Configure('MenuReturn',Option_MenuReturn);
  Option_SoundEquipPickup := Configure('SoundEquipPickup',Option_SoundEquipPickup);
  Option_ColoredInventory := Configure('ColoredInventory',Option_ColoredInventory);
  Option_LockBreak        := Configure('LockBreak',Option_LockBreak);
  Option_LockClose        := Configure('LockClose',Option_LockClose);
  Option_TimeStamp        := Configure('TimeStamp',Option_TimeStamp);

  Option_PlayerBackups    := Configure('PlayerBackups',Option_PlayerBackups);
  Option_ScoreBackups     := Configure('ScoreBackups',Option_ScoreBackups);

  Option_RunDelay         := Configure('RunDelay',Option_RunDelay);
  Option_MessageBuffer    := Configure('MessageBuffer',Option_MessageBuffer);

  Option_IntuitionColor   := Configure('IntuitionColor',Option_IntuitionColor);
  Option_IntuitionChar    := AnsiString(Configure('IntuitionChar',Option_IntuitionChar))[1];

  Option_MaxRun           := Configure('MaxRun',Option_MaxRun);
  Option_MaxWait          := Configure('MaxWait',Option_MaxWait);

  if ForceNoAudio then
  begin
    Option_Sound := False;
    Option_Music := False;
    Option_SoundEngine := 'NONE';
  end;

  if (not Option_Music) and (not Option_Sound) then Option_SoundEngine := 'NONE';
  if Option_SoundEngine = 'DEFAULT' then
     Option_SoundEngine := {$IFDEF WINDOWS}'FMOD'{$ELSE}'SDL'{$ENDIF};
  if (Option_SoundEngine <> 'FMOD') and (Option_SoundEngine <> 'SDL') then
     Option_SoundEngine := 'NONE';
  if Option_SoundEngine = 'NONE' then
  begin
    Option_Music     := False;
    Option_Sound     := False;
    SoundVersion     := False;
  end
  else
    SoundVersion     := True;

  // synchro
  if ForceConsole then Option_Graphics := 'CONSOLE'
  else if ForceSDLConsole then Option_Graphics := 'SDLCONSOLE'
  else if ForceGraphics then Option_Graphics := 'TILES'
  else
  begin
    case Option_Graphics of
      'TILES', 'CONSOLE', 'SDLCONSOLE': ;
      else Option_Graphics := 'TILES';
    end;
  end;
  GraphicsVersion := Option_Graphics = 'TILES';

  TDoomIO.RegisterLuaAPI( State );
end;

end.

