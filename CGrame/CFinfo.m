%
% Classe CFinfo
%
classdef CFinfo < handle
  properties
    prenom ='';   % dossier de travail
    finame ='';
    foname ='';
    fich;
    fitmp;
  end  %properties
  %
  methods
    function delete(obj)              % DESTRUCTOR
      if ~isempty(obj.fitmp) & ~isempty(dir(obj.fitmp))
    	  delete(obj.fitmp);
      end
    end
  end
end