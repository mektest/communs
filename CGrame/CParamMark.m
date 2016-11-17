%
% classdef CParamMark < handle
%
% METHODS
%
classdef CParamMark < handle
 %__________
  properties (SetAccess =protected)
    canSrc =1;                  % canal source
    canDst =1;                  % canal destination
    canExtra =1;                % canal pour la copie des points à marquer
    parEss =false;              % on choisi les Ess ou Cat
    allTri =[];                 % essai pour le marquage
    multiaff;
    affniv;
    tri;                        % essai pour l'affichage
  end
 %_______
  methods
   %________
    function setCanSrc(tO, v)
      tO.canSrc =v;
    end
   %________
    function setCanDst(tO, v)
      tO.canDst =v;
    end
   %________
    function setCanExtra(tO, v)
      tO.canExtra =v;
    end
   %________
    function setParEss(tO, v)
      tO.parEss =v;
    end
   %________
    function setAllTri(tO, v)
      tO.allTri =v;
    end
   %________
    function setAffniv(tO, v)
      tO.affniv =v;
    end
   %________
    function setTri(tO, v)
      tO.tri =v;
    end
   %___________________________________
   % retourne une structure dont les
   % champs sont les propriétés de la classe
   %________
    function v =databrut(tO)
      v =CDefautFncBase.databrut(tO, class(tO));
    end
   %___________________________________
   % initialise la classe à partir d'une structure
   %________
    function initial(tO, v)
      % On s'assure que v est une STRUCT
      if ~isempty(v) & isa(v, 'struct')
        % Création d'un objet "tO"
        S =str2func(class(tO));
        hType =S();
        % Lecture de ses properties
        a =properties(hType);
        delete(hType);
        for U =1:length(a)
          if isfield(v, a{U})
            tO.(a{U}) =v.(a{U});
          end
        end
      end
    end
   %___________________________________
   % retourne un objet de la classe CParamMark
   %________
    function v =savePM(tO)
      v =CDefautFcnBase.copie(tO);
    end
   %___________________________________
   % initialise à partir d'un objet CParamMark
   % ne devrait plus être utilisé
   %________
    function restorePM(tO, v)
      if isa(v, class(tO))
        tO.initial(v.databrut());
      end
    end
  end
end
