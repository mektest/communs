%
% Classe CDtchnl
%
classdef CDtchnl < handle
  properties
    Dato =struct();
    Nom ='';
  end  %properties
  %------
  methods
    function V =Databrut(thisObj)
      V =thisObj.Dato.(thisObj.Nom);
    end
    %-------
    function HDt =clone(obj)
      HDt =CDtchnl();
	   obj.cloneThis(HDt);
    end
    %-------
    % ici on clone Thisobj dans Thatobj
    function cloneThis(Thisobj, Thatobj)
      Thatobj.Nom =Thisobj.Nom;
      Thatobj.MaZdato();
      Thatobj.Dato.(Thatobj.Nom) =Thisobj.Dato.(Thisobj.Nom);
    end
    %-------
    % ici on clone Thatobj dans Thisobj
    function cloneThat(Thisobj, Thatobj)
      Thatobj.cloneThis(Thisobj);
    end
    %-------
    function MaZtotal(obj)
      obj.MaZdato();
      obj.MaZnom();
    end
    %-------
    function MaZdato(obj)
      obj.Dato =struct();
    end
    %-------
    function MaZnom(obj)
      obj.Nom ='';
    end
    %-------------------------
    % si obj.Nom  est vide = 0
    % si obj.Nom  non vide = 1
    % si obj.Dato est vide = 0
    % si obj.Dato non vide = 2
    %-------
    function rename(tO, lenom)
      test =(~isempty(tO.Dato)*2)+(~isempty(tO.Nom));
      if test < 2
      	tO.Dato.(lenom) =[];
      	tO.Nom =lenom;
      elseif length(fields(tO.Dato)) > 1
      	disp('Erreur dans la fonction rename de l''objet CDtchnl');
      else
      	tO.Nom =lenom;
      	vieux =fields(tO.Dato);
      	a.(lenom) =tO.Dato.(vieux{1});
      	tO.Dato =a;
      end
    end
  end  %methods
end