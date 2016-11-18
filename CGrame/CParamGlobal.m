%
% classdef (Sealed) CParamGlobal < handle
%
% gestion des paramètres pour toutes les applications
% rien de spécifique à une seule application.
%
%

classdef (Sealed) CParamGlobal < handle

  properties (Access =private)
    %_______________________________________________
    % la propriété dispError devrait être consulté
    % avant d'afficher les message d'erreur.
    %
    %  valeur possible: est-ce que l'on affiche  --> qu'est-ce qu'on affiche
    %         0       :         non              --> on affiche pas
    %         1       :         oui              --> on affiche tout
    %         2       :         oui              --> on affiche identifier+message
    %         3       :         oui              --> on affiche message seulement
    %-----------------------------------------------
    dispError =1;
  end

  methods (Access =private)

    %------------
    % CONSTRUCTOR
    %------------------------
    function tO =CParamGlobal
      % à voir
    end

  end  % methods (Access =private)

  methods (Static)

    %-----------------------------------------------
    % Fonction static pour appeler l'instance/handle
    % de cette objet
    %-------------------------
    function sObj =getInstance
      persistent localObj;
      if isempty(localObj) || ~isvalid(localObj)
        localObj =CParamGlobal();
      end
      sObj =localObj;
    end

  end  %methods

  methods

    %--------------
    % GETTER/SETTER
    %-----------------------------
    function val =getDispError(tO)
      val =tO.dispError;
    end
    %-----------------------------
    function setDispError(tO, val)
      tO.dispError =val;
    end

  end % method
end % classdef
