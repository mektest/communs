%
% Classe CDefautFen
%
% Classe de base pour gérer une Fenêtre
% tO --> thisObj
%
% methods
%   disparait(tO, src, event)
%   fenVisible(tO, etat)
%   togglevoir(tO, src, event)
%
classdef CDefautFen < handle
  properties
    fig;                   % handle de la figure
  end  %properties
  %------
  methods
    %___________________________________
    % rend la fenêtre invisible
    % sans la détruire
    %-------
    function disparait(tO, src, event)
      set(tO.fig, 'visible','off');
    end
    %___________________________________
    % En fonction du paramètre "etat"
    % affiche ou non la fenêtre
    %-------
    function fenVisible(tO, etat)
      set(tO.fig, 'visible',etat);
    end
    %___________________________________
    % Peut être utilisé avec un bouton
    % pour toggler la visibilité de la fenêtre
    %-------
    function togglevoir(tO, src, event)
      ss =CEOnOff.(get(tO.fig,'visible'));
      set(tO.fig, 'visible',char(CEOnOff(~ss)));
    end
  end  % methods
end