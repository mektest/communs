%
% classdef CVgFichier < handle
%
% Variables globales des fichiers Analyse
%
% METHODS
%          initial(tO, vg)
%       V =databrut(tO)
%          majVgWmh(tO)
%          majWmhVg(tO)
%   clone =copie(tO)
%
classdef CVgFichier < handle
 %______________________________
  properties (Access =protected)
    wmh =CParamMark();  % Utilisé par le Gui du marquage automatique
  end
 %__________
  properties
    laver =1.0;
    itype =[];        % 1-analyse, 2-texte, 3-a21xml
    otype =8;         % contient la version matlab à sauvegarder V6 ou V7 ou V7.3
    sauve =false;
    valeur =0;
    nad =1;           % nombre de canaux
    ess =1;           % nombre d'essai
    lesess ={};
    lescats ={};
    nst =0;
    nomstim ={};
    niveau =0;
    affniv =0;
    pt =1;                     % 1- afficher les points marqués avec texte, 2- sans texte
    can =1;                    % canal à afficher
    toucan =false;             % afficher tous les canaux
    tri =1;                    % essai à afficher
    toutri =false;             % afficher tous les essais
    cat =1;                    % catégorie à afficher
    xy =0;
    x =[];
    y =[];
    zoom =1;
    zoomonoff =1;
    affcoord =CEOnOff(false);  % afficher le DataCursor
    ligne =0;
    colcan =true;
    coless =false;
    colcat =true;
    legende =false;
    letemps =0;
    defniv =1;
    permute =0;
    choixy =[];
    filtp =0;
    filtpmin =0.0;
    filtpmax =0.1;
    xymarkx =1;
    xymarkxecart =10;
    xymarkyecart =10;
    loq =1;
    xlim =0;
    ylim =0;
    trich =0;
    deroul =[0.0100 0.0500];
    multiaff =[];
    xval =[0 1];
    yval =[0 1];
  end  %properties
  %------
  methods
    %-------
    function initial(tO, vg)
      CDefautFncBase.initial(tO, class(tO), vg);
      tO.majWmhVg();
    end
    %-------
    function majWmhVg(tO)
      vg =tO.databrut();
      tO.wmh.initial(vg);
      if isempty(tO.wmh.allTri)
        tO.wmh.setAllTri(1:tO.ess);
      end
    end
    %-------
    function majVgWmh(tO)
      v =CParamMark();
      p =properties(v);
      delete(v);
      vg =tO.databrut();
      for u =1:length(p)
        if isfield(vg, p{u})
          tO.(p{u}) =tO.wmh.(p{u});
        end
      end
      tO.can =tO.wmh.canSrc;
    end
    %-------
    function V =databrut(tO)
      V =CDefautFncBase.databrut(tO, 'CVgFichier');
    end
    %-------
    function clone =copie(tO)
      clone =CDefautFncBase.copie(tO, 'CVgFichier');
    end
    %---------------------------------------
    % On retourne un objet wmh =CParamMark()
    function v =getWmh(tO)
      v =tO.wmh;
    end
    %-------------------
    % ou v =CParamMark()
    function setWmh(tO, v)
      tO.wmh =v;
    end
  end  %methods
end