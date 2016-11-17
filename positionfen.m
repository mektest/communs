%
% Fonction positionfen
% Créateur: MEK, janvier 2009
%
% VARARGIN
% 1- position horizontale(G,gauche,L,left,C,centre,center,D,droit,R,right)
% 2- position verticale(T,top,H,haut,B,bas,bottom,C,centre,center)
% 3- largeur de la fenêtre
% 4- Hauteur de la fenêtre
% 5- Handle de la référence
%
function varargout =positionfen(varargin)
	hndl =gcf;
  if nargin == 5
  	hndl =varargin{5};
  end
  pp =get(hndl,'units');           % avant de déplacer les bas...
  set(hndl,'Units','pixels');
  fenpos =get(hndl,'position');
  set(hndl,'Units',pp);            % on remet les bas à leur place...
	horiz ='centre';
	verti ='centre';
	large =fenpos(3)/2;
	haute =fenpos(4)/2;
  if nargin >= 4
  	haute =varargin{4};
  end
  if nargin >= 3
  	large =varargin{3};
  end
  if nargin >= 2
  	verti =lower(varargin{2});
  end
  if nargin >= 1
  	horiz =lower(varargin{1});
  end
  final =[0 0 large haute];
%  monpos =get(0,'MonitorPositions');
%  elmonit =length(monpos(:))/length(monpos);
  switch horiz
  %------------
  case {'left+','gauche+','g+','l+'}
  	final(1) =fenpos(1)-large;
  %------------
  case {'left','gauche','g','l'}
  	final(1) =fenpos(1);
  %------------
  case {'right+','droit+','r+','d+'}
  	final(1) =fenpos(1)+fenpos(3);
  %------------
  case {'right','droit','r','d'}
  	final(1) =fenpos(1)+fenpos(3)-large;
  %------------
  case {'center+','centre+','c+'}
  	final(1) =fenpos(1)+(fenpos(3)/2);
  %------------
  case {'center-','centre-','c-'}
  	final(1) =fenpos(1)+((fenpos(3)/2)-large);
  %------------
  case {'center','centre','c'}
  	final(1) =fenpos(1)+((fenpos(3)-large)/2);
  end
  switch verti
  %------------
  case {'top+','haut+','t+','h+'}
  	final(2) =fenpos(2)+fenpos(4);
  %------------
  case {'top','haut','t','h'}
  	final(2) =fenpos(2)+fenpos(4)-haute;
  %------------
  case {'bottom+','bas+','b+'}
  	final(2) =fenpos(2)-haute;
  %------------
  case {'bottom','bas','b'}
  	final(2) =fenpos(2);
  %------------
  case {'center+','centre+','c+'}
  	final(2) =fenpos(2)+(fenpos(4)/2);
  %------------
  case {'center-','centre-','c-'}
  	final(2) =fenpos(2)+((fenpos(4)/2)-haute);
  %------------
  case {'center','centre','c'}
  	final(2) =fenpos(2)+((fenpos(4)-haute)/2);
  end
  final(1) =max(final(1),20);
  final(2) =max(final(2),20);
  varargout{1} =floor(CaFitTi(fenpos, final));
end
  