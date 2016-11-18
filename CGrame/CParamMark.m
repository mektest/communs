%
% classdef CParamMark < handle
%
% Classe utilisé pour travailler avec le GUI du marquage automatisé
%
% METHODS
%

classdef CParamMark < handle

  properties (SetAccess =protected)
    canSrc =1;                  % canal source
    canDst =1;                  % canal destination
    canExtra =1;                % canal pour la copie des points à marquer
    parEss =false;              % on choisi les Ess ou Cat
    allTri =[];                 % essai sélectionné pour le marquage
    multiaff =[];
    affniv =[];
    tri =[];                    % essai pour l'affichage
  end

  methods

    %_____________________________________________________
    %                        SETTER
    %------------------------
    function setCanSrc(tO, v)
      tO.canSrc =v;
    end
    %_________________________
    function setCanDst(tO, v)
      tO.canDst =v;
    end
    %__________________________
    function setCanExtra(tO, v)
      tO.canExtra =v;
    end
    %________________________
    function setParEss(tO, v)
      tO.parEss =v;
    end
    %________________________
    function setAllTri(tO, v)
      tO.allTri =v;
    end
    %________________________
    function setAffniv(tO, v)
      tO.affniv =v;
    end
    %_____________________
    function setTri(tO, v)
      tO.tri =v;
    end

    %___________________________________
    % retourne une structure dont les
    % champs sont les propriétés de la classe
    %-----------------------
    function v =databrut(tO)
      v =CDefautFncBase.databrut(tO, class(tO));
    end

    %___________________________________
    % initialise la classe à partir d'une structure
    %______________________
    function initial(tO, v)
      % Comme nos propriétés sont "protected", on ne peut utiliser:
      % CDefautFncBase.initial(tO, class(tO), v);
      %
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

    %__________________________________________
    % retourne un objet de la classe CParamMark
    %---------------------
    function v =savePM(tO)
      v =CDefautFncBase.copie(tO);
    end

    %__________________________________________
    % initialise à partir d'un objet CParamMark
    % ne devrait plus être utilisé
    %------------------------
    function restorePM(tO, v)
      if isa(v, class(tO))
        tO.initial(v.databrut());
      end
    end

  end % method
end % classdef
