%
% Création d'une WAITBAR, avec la possibilité de la positionner
% relativement à une figure. Si aucune figure n'existe alors se
% sera relativement à la position du curseur.
%
% Fonction laWaitbar
% Créateur: MEK, septembre 2011
%
% VARARGIN
% 1- Valeur à afficher
% 2- texte à afficher
% 3- position horizontale(G,gauche,L,left,C,centre,center,D,droit,R,right)
% 4- position verticale(T,top,H,haut,B,bas,bottom,C,centre,center)
% 5- Handle de la référence
%
function varargout =laWaitbar(varargin)

  %On commence par initialiser les variables au cas ou
  % elles ne seraient pas dans "varargin"
  Val =0;
  texto ='Test de waitbar';
  pHor ='C';
  pVer ='C';

  %Si aucune figure n'existe
  if isempty(findobj('Type', 'figure'))
    hdl =[];
  else
    hdl =gcf;
  end

  if nargin == 5
  	hdl =varargin{5};
  end
  if nargin >= 4
  	pVer =lower(varargin{4});
  end
  if nargin >= 3
  	pHor =lower(varargin{3});
  end
  if nargin >= 2
  	texto =varargin{2};
  end
  if nargin >= 1
  	Val =varargin{1};
  end
  Wb =waitbar(Val, texto, 'visible','off');
  set(Wb, 'Units','pixels');
  lapos =get(Wb, 'position');
  if isempty(hdl)
    lapos(:) =round(positioncur(pHor, pVer, lapos(3), lapos(4)));
  else
    lapos(:) =round(positionfen(pHor, pVer, lapos(3), lapos(4), hdl));
  end
  set(Wb, 'position',lapos, 'visible','on');
  figure(Wb);
  if nargout
    varargout{1} =Wb;
  end
end
