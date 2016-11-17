%
% Cette énumération sert pour lire les fichiers AVI lorsque les readers normaux ont de la "misère"
%
% voir la description du contenu d'un fichier AVI
%
classdef CChunkEnum < uint32
  enumeration
    RIFF      (1179011410)
    AVI       ( 541677121)
    LIST      (1414744396)
    hdrl      (1819436136)
    avih      (1751742049)
    movi      (1769369453)
    strl      (1819440243)
    strf      (1718776947)
    ix00      ( 808482921)
    Y800      ( 808466521)
  end
end
