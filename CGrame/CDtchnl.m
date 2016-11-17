%
% Comme le nom le suggère, dtchnl --> Data Channel
%
% Classe CDtchnl < handle
%

classdef CDtchnl < handle

  properties
    Dato =struct();     % struc qui contiendra la matrice de data
    Nom ='';            % nom du champ de la tructure ci-haut
  end

  methods

    %---------------------------------------------------------------
    % fonction pour retourner les datas du canal associé à cet objet
    %-----------------------
    function V =Databrut(tO)
      V =tO.Dato.(tO.Nom);
    end

    %----------------------------------------------------
    % fonction pour fabriquer un clone de l'objet courant
    %-----------------------
    function HDt =clone(tO)
      HDt =CDtchnl();
      tO.cloneThis(HDt);
    end

    %----------------------------------
    % ici on clone Thisobj dans Thatobj
    %-----------------------------------
    function cloneThis(Thisobj, Thatobj)
      Thatobj.Nom =Thisobj.Nom;
      % on fait une misazour :-)
      Thatobj.MaZdato();
      Thatobj.Dato.(Thatobj.Nom) =Thisobj.Dato.(Thisobj.Nom);
    end

    %----------------------------------
    % ici on clone Thatobj dans Thisobj
    %-----------------------------------
    function cloneThat(Thisobj, Thatobj)
      Thatobj.cloneThis(Thisobj);
    end

    %---------------------
    % Mise à zéro complète
    %---------------------
    function MaZtotal(obj)
      obj.MaZdato();
      obj.MaZnom();
    end

    %----------------------
    % mise à zéro des datas
    %--------------------
    function MaZdato(obj)
      obj.Dato =struct();
    end

    %----------------------------
    % mise à zéro du nom du champ
    %-------------------
    function MaZnom(obj)
      obj.Nom ='';
    end

    %-----------------------------------
    % Si on change de canal de référence
    % en conservant le même objet CDtchnl
    % on a besoin de renommer le champ des datas
    %-------------------------
    function rename(tO, lenom)
      %-------------------------
      % si obj.Nom  est vide = 0
      % si obj.Nom  non vide = 1
      % si obj.Dato est vide = 0
      % si obj.Dato non vide = 2
      %-------------------------
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
