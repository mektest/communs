%
%                              Classe de base pour les figures
%
% classdef CBasePourFigure < handle
%
% METHODS
%       delete(tO)                 % DESTRUCTOR
%       figFocus(tO)
%       setFigModal(tO)
%       setFigNormal(tO)
%
classdef CBasePourFigure < handle
  %---------
  properties
    fig =[];          % handle de la figure
  end
  %------
  methods
    %-------
    function delete(tO)                 % DESTRUCTOR
      if ~isempty(tO.fig) && ishandle(tO.fig)
        delete(tO.fig);
      end
    end
    %_____________________________________________
    % On ramène le focus sur la figure principale
    %---------------------------------------------
    function figFocus(tO)
      figure(tO.fig);
    end
    %_____________________________________________
    % On garde le focus 'gelé' sur la fenêtre
    %---------------------------------------------
    function setFigModal(tO)
      set(tO.fig, 'WindowStyle','modal');
    end
    %_____________________________________________
    % On 'dégèle' le focus de la fenêtre
    %---------------------------------------------
    function setFigNormal(tO)
      set(tO.fig, 'WindowStyle','normal');
    end
  end
end
