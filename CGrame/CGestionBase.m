%
% classdef CGestionBase < handle
%
% METHODS
%   clone =copie(tO)
%       V =databrut(tO)
%          initial(tO, V)
%          ResetProp(tO)
%
%  Contient toutes les méthodes de bases pour les classes
%  qui ont des propriétés qui doivent être sauvegarder.
%  **** la propriété "monnom" doit être initialisé ****
%

classdef CGestionBase < handle

  properties
    monnom ='';     % nom de la classe parent
  end

  methods

    %-------------------------------
    % initial, change les properties
    % à partir d'une structure
    %----------------------
    function initial(tO, V)
      CDefautFncBase.initial(tO, tO.monnom, V);
    end

    %--------------------------------
    % databrut retourne une structure
    % à partir des properties de tO.monnom
    %-----------------------
    function V =databrut(tO)
      V =CDefautFncBase.databrut(tO, tO.monnom);
    end

    %-------------------------------
    % ResetProp remet les properties
    % aux valeurs par défauts
    %---------------------
    function ResetProp(tO)
      CDefautFncBase.ResetProp(tO, tO.monnom);
    end

    %---------------------------------------------------
    % copie retourne un objet avec les properties actuel
    %------------------------
    function clone =copie(tO)
      clone =CDefautFncBase.copie(tO, tO.monnom);
    end

  end  %methods
end
