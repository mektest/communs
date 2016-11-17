%
% classdef (Sealed) CParamGlobal < handle
%
% gestion des paramètres pour toutes les applications
% rien de spécifique à une seule application.
%
%
classdef (Sealed) CParamGlobal < handle
  properties (Access =private)
    dispError =1; % (0: non) (1: tout) (2: identifier+message) (3: message seulement)
  end  %properties
  %------
  methods (Access =private)
    function tO =CParamGlobal     % CONSTRUCTOR
      % à voir
    end
  end  %methods
  %------
  methods (Static)
    function sObj =getInstance
      persistent localObj;
      if isempty(localObj) || ~isvalid(localObj)
        localObj =CParamGlobal;
      end
      sObj =localObj;
    end  %function
  end  %methods
  %------
  methods
    %-------
    function val =getDispError(tO)
      val =tO.dispError;
    end
    %-------
    function setDispError(tO, val)
      tO.dispError =val;
    end
  end
end