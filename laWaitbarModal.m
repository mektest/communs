%
% Création d'une WAITBAR, avec la possibilité de la positionner
% relativement à une figure. Si aucune figure n'existe alors se
% sera relativement à la position du curseur. De plus, sa propriété
% 'WindowStyle' sera 'modal'.
%
% Fonction laWaitbarModal
% Créateur: MEK, avril 2015
%
% VARARGIN
% 1- Valeur à afficher
% 2- texte à afficher
% 3- position horizontale(G,gauche,L,left,C,centre,center,D,droit,R,right)
% 4- position verticale(T,top,H,haut,B,bas,bottom,C,centre,center)
% 5- Handle de la référence
%
function varargout =laWaitbarModal(varargin)

  %On va créer un objet "laWaitbar"
  foo =laWaitbar(varargin{:});

  %on va le rendre "modal"
  set(foo, 'WindowStyle','modal');

  if nargout
    varargout{1} =foo;
  end
end
