%
% Fonction quelfich
% Créateur: MEK, février 2009
%
% VARARGIN{1} ={'*.ext','extension à ouvrir'}
% VARARGIN{2} =Titre de la fenêtre
% VARARGIN{3} =1 Si multiselect, autrement 0
%
% VARARGOUT{1} =Nom du fichier choisi (En ordre alphabétique si MULTI)
% VARARGOUT{2} =Path du fichier choisi
% VARARGOUT{3} =1 réussit, 0 échec
%
function varargout =quelfich(varargin)
  lenom =varargin{1};
  letit =varargin{2};
  multi =varargin{3};
  cual =0;
  if multi
  	[fname,pname,cual] =uigetfile(lenom,letit,'MultiSelect','on');
    if cual & isdir(pname)
      cd(pname);
      if iscell(fname)
        fname =sort(fname);
      else
        fname ={fname};
      end
    end
  else
  	[fname,pname] =uigetfile(lenom,letit);
    if pname & isdir(pname)
      cd(pname);
      cual =1;
    end
  end
  varargout{1} =fname;
  varargout{2} =pname;
  varargout{3} =cual;
end
