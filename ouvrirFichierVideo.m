%
% FUCNTION v =ouvrirFichierVideo('nom_Du_Fichier_Video')
%
% devra être appelé dans une structure "try-catch"
%
% try
%   v =ouvrirFichierVideo('nom_Du_Fichier_Video');
% catch e
%   faireQuelqueChose(e);
% end
%
% si tout va bien, v contiendra le handle de l'objet
% qui va nous retourner les frames voulus.
%
function v =ouvrirFichierVideo(nomFichier)
  % Est-ce que le fichier est valide
  if isempty(dir(nomFichier))
    me =MException('COMMUN:ouvrirFichierVideo',['Verifiez le nom du fichier(' nomFichier ')']);
    throw(me);
  end
  % rendu ici, le fichier existe.
  % il faut déterminer le type de fichier
  %_________
  % RAW(gel)

  fid =fopen(nomFichier, 'r');
  if fid == -1
    me =MException('COMMUN:ouvrirFichierAVI',['Accès en lecture refusé']);
    throw(me);
  else
    test ='    ';
    test(:) =fread(fid,4,'char')';  % on teste si l'entête est conforme
    fclose(fid);
    if strcmpi(test, 'lvsn')
      v ='LVSN';
    elseif strcmpi(test, 'riff')
      %_______________________
      % AVI(Y800) et autre AVI
      Y800 = 808466521;
      try
        ss =getAviInfo(nomFichier);
      catch e
        me =MException('COMMUN:ouvrirFichierAVI', e.message);
        throw(me);
      end
      if ss.VideoStreamHeader.CompressionHandler == Y800
        v ='Y800';
      else
        % faudrait voir avec le reader de matlab, peut être vidéo ~= AVI
        v ='AVI ';
      end
    else
      v =[];
    end
  end
end
%
%  voir CChunkEnum.m
%
function autre
  RIFF =1179011410;
  AVI =541677121;
  LIST =1414744396;
  hdrl =1819436136;
  avih =1751742049;
  movi =1769369453;
  strl =1819440243;
  strf =1718776947;
  ix00 =808482921;
  Y800 = 808466521;
end
