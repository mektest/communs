% 
% Classe CSecur
% mai 2009
%
%  CSecur
%  vérification d'utilisation
%
classdef CSecur < handle
  %---------
  properties (Hidden, SetAccess =protected, GetAccess =protected)
    lok =false;    % true si on bloque
    chance =true;
    Bonus =13.777;
    flush =[];
  end  %properties
  %---------
  properties (Hidden, Constant, SetAccess =protected, GetAccess =protected)
    camino ={'', 'k:\jj\', 'g:\jjanalyse\'};
    a ='\security\';
    B =getenv('windir');
    c ='.regard';
  end
  %------
  methods
    %-------
    function val =Ctiunbandit(thisObj)
      val =thisObj.lok;
    end
    %-------
    function val =get.flush(thisObj)
      val =thisObj.flush;
    end
    %-------
    function val =get.lok(thisObj)
      val =thisObj.lok;
    end
    %-------
    function COk =recuperer(thisObj)
      thisObj.GrandTest();
      COk =thisObj.lok;
    end
    %-------
    function set.lok(thisObj, val)
      thisObj.lok =val;;
    end
  end  %methods
  %------
  methods (Access =protected)
    %-------
    function GrandTest(thisObj)
      thisObj.Regard();
    end
  end  %methods (Access =protected)
  %------
  methods (Access =private)
    %-------
    function Regard(thisObj)
      elpath =thisObj.camino;
      % est-ce que le prg validation.exe a déjà été installé
      elpath{1} =[thisObj.B thisObj.a];
      thisObj.lok =isempty(dir([elpath{1} thisObj.c]));
      % les validation réseau sont-elles visibles
      if thisObj.lok
       	for U =2:length(elpath)
          thisObj.lok =isempty(dir([elpath{U} thisObj.c]));
          if ~thisObj.lok
            break;
          end
        end
      end
      % dernier recours
      if thisObj.lok
        thisObj.benificeDuDoute();
      else
        thisObj.laisseEmpreinte();
      end
    end
    %-------
    function benificeDuDoute(thisObj);
      fich =fullfile(tempdir(), 'c@mino.mat');
      if ~isempty(dir(fich))
        thisObj.lok =false;
        vitvit =[thisObj.B thisObj.a thisObj.c];
        copyfile(fich, vivit);
      end
    end
    %-------
    function laisseEmpreinte(thisObj)
      fich =fullfile(tempdir(), 'c@mino.mat');
      vitvit =[thisObj.B thisObj.a thisObj.c];
      if isempty(dir(fich)) & ~isempty(dir(vitvit))
        copyfile(vitvit, fich);
      end
    end
  end  %methods (Access =private)
end  %classdef