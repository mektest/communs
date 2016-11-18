%
% Classe CFinfo
%
% Informations sur le fichier lui même
%

classdef CFinfo < handle
  properties
    prenom ='';   % dossier de travail (path)
    finame ='';   % nom du fichier en entrée
    foname ='';   % nom du fichier en sortie...appelé à disparaître
    fich =[];     % est appelé à disparaître
    fitmp =[];    % nom du fichier temporaire de travail
  end

  methods

    function delete(obj)              % DESTRUCTOR
      if ~isempty(obj.fitmp) && ~isempty(dir(obj.fitmp))
    	  delete(obj.fitmp);
      end
    end

  end % method
end % classdef
