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
% 6- tag du bouton
%
function varargout =laWaitbarBouton(varargin)
  Val =0;
  texto ='Test de waitbar';
  pHor ='C';
  pVer ='C';
  hdl =gcf;
  letag ='TagLaWaitbarBouton';
  if nargin == 6
    letag =varargin{6};
  elseif nargin >= 5
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
  step =50;
  lapos(:) =round(positionfen(pHor, pVer, lapos(3), lapos(4)+step, hdl));
  set(Wb, 'position',lapos);
  foo =get(Wb, 'Children');
  set(foo, 'Units','pixels');
  posfoo =get(foo, 'Position');
  posfoo(2) =lapos(4)-posfoo(4)-45;
  set(foo, 'Position', posfoo);
  large =50; haut =22; posy =20; posx =round((lapos(3)-large)/2);
  uicontrol('Parent',Wb, 'Tag',letag, 'String','Arrêt', 'Position',[posx posy large haut]);
  set(Wb, 'visible','on', 'WindowStyle','modal');
  figure(Wb);
  if nargout
    varargout{1} =Wb;
  end
end
