%
% Classe CCatego
%
% Pour travailler avec des classements de niveaux et catégories
%
% STRUCTURE CATEGO
% catego(1,niveau,1)
%                   .nom     -> nom du niveau
%                   .ess(n)  -> 1 si l'essai  n  est encore disponible dans ce niveau
%                   .ncat    -> Nb de catégorie pour ce niveau
%                   .ness    -> Nb d'essai encore disponible pour ce niveau
% catego(2,niveau,catégorie)
%                   .nom     -> nom de la catégorie
%                   .ess(n)  -> 1 si l'essai  n  appartient à cette catégorie
%                   .ncat    -> Nb d'essai dans cette catégorie
%

classdef CCatego < handle
  properties
    Dato =[];           % Conteneur de la structure Catego
    hF =[];             % handle du fichier analyse
  end %properties
  %------
  methods

    %------------------------------
    % Getter pour la propriété Dato
    %-------------------------
    function ss =get.Dato(obj)
      ss =obj.Dato;
    end

    %------------------------------------
    % Cato doit être une Structure CATEGO
    %--------------------------
    function initial(obj, Cato)
      if isa(Cato, 'struct')
        obj.Dato =Cato;
      end
    end

    %--------------------------------
    % Retourne le nom de la catégorie
    % à partir du niveau demandé pour l'essai ess
    %----------------------------------------
    function v =getNomCatego(obj, leniv, ess)
      n =obj.getNumeroCatego(leniv, ess);
      v =[];
      if ~isempty(n)
        v =strtrim(obj.Dato(2, leniv, n).nom);
      end
    end

    %-----------------------------------
    % Retourne le numéro de la catégorie
    % à partir du niveau demandé pour l'essai ess
    %-------------------------------------------
    function v =getNumeroCatego(obj, leniv, ess)
      v =[];
      if ~isempty(leniv) && ~isempty(ess) && leniv > 0 && ess > 0
        ncat =obj.Dato(1, leniv, 1).ncat;
        for u =1:ncat
          s =find(obj.Dato(2, leniv, u).ess);
          if ~isempty(find(s == ess))
            v =u;
            break;
          end
        end
      end
    end

    %-----------------------------
    function EnleveEssai(obj, ess)
      vg =obj.hF.Vg;
      for U =1:vg.niveau
        obj.Dato(1,U,1).ess(ess) =[];
        obj.Dato(1,U,1).ness =sum(obj.Dato(1,U,1).ess);
        for V =1:obj.Dato(1,U,1).ncat
          obj.Dato(2,U,V).ess(ess) =[];
          obj.Dato(2,U,V).ncat =sum(obj.Dato(2,U,V).ess);
        end
      end
    end

    %-----------------------------
    function RebatirCategorie(obj)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
      obj.hF.StimulusVide();
      catego.Dato =[];
      vg.niveau =0;
      vg.affniv =0;
      vg.defniv =1;
      obj.Dato(1,1,1).nom ='Stimulus';
      % On s'assure que les stimulus sont uniques
      obj.hF.StimulusUnique();
      % les essais non-assignés seront classés "bidon"
      obj.hF.StimEssVideBidon();
   	  % on transforme les Stimulus en CATÉGORIES
      if vg.nst
        vg.niveau = 1;
        vg.affniv =0;
        vg.defniv =1;
        obj.Dato(1,1,1).ness =0;
        obj.Dato(1,1,1).ncat =vg.nst;
        obj.Dato(1,1,1).ess =zeros(1, vg.ess);
        for i =1:vg.nst
          obj.Dato(2,1,i).nom =vg.nomstim{i};
          ss =find(hdchnl.numstim == i);
          obj.Dato(2,1,i).ncat=0;
          obj.Dato(2,1,i).ess =zeros(1, vg.ess);
          if ~isempty(ss)
            obj.Dato(2,1,i).ncat =length(ss);
            obj.Dato(2,1,i).ess(ss) =1;
          end
        end
      end % if vg.nst
      vg.sauve =true;
    end

    %------------------------------------------------
    function lessai =BatirListeEssaiLibre(obj, leniv)
      % Sert à bâtir la liste des essais à associer à une catégorie
      % pour le niveau "leniv"
      %
      lessai ='0 -  -';
      vg =obj.hF.Vg;
      if vg.niveau && obj.Dato(1,leniv,1).ness
        % On cherche les essais disponibles dans ce niveau
        hdchnl =obj.hF.Hdchnl;
        edispo =find(obj.Dato(1,leniv,1).ess);
        lessai ={};
        for i =1:length(edispo)
          nono =1;
          for j =1:obj.Dato(1,vg.defniv,1).ncat
            if obj.Dato(2,vg.defniv,j).ess(edispo(i))
              lessai{end+1} =[num2str(edispo(i)) '-' obj.Dato(2,vg.defniv,j).nom];
              nono =0;
              break;
            end
          end
          if nono
          	lestim =hdchnl.numstim(edispo(i));
            if vg.nst && lestim && lestim <= vg.nst
              lessai{end+1} =[num2str(edispo(i)) '-' vg.nomstim{lestim}];
            else
              lessai{end+1} =[num2str(edispo(i)) '- - -'];
            end
          end
        end  %for i=1:size(edispo)
      end
    end

    %----------------------------------------------------------
    function lessaib =BatirListeEssaiAssocie(obj, leniv, lacat)
      % Sert à bâtir la liste des essais associer à la catégorie
      % "lacat" du niveau "leniv"
      lessaib ='0';
      % On vérifie que l'on a bien des essais dans cet CAT
      vg =obj.hF.Vg;
      if vg.niveau && lacat <= obj.Dato(1,leniv,1).ncat  && obj.Dato(2,leniv,lacat).ncat
        hdchnl =obj.hF.Hdchnl;
        easso =find(obj.Dato(2,leniv,lacat).ess);
        lessaib ={};
        for i =1:length(easso)
          nono =1;
          for j =1:obj.Dato(1,vg.defniv,1).ncat
            if obj.Dato(2,vg.defniv,j).ess(easso(i))
              lessaib{end+1} =[num2str(easso(i)) '-' obj.Dato(2,vg.defniv,j).nom];
              nono =0;
              break;
            end
          end
          if nono
          	lestim =hdchnl.numstim(easso(i));
            if vg.nst && lestim && lestim <= vg.nst
              lessaib{end+1} =[num2str(easso(i)) '-' vg.nomstim{lestim}];
            else
              lessaib{end+1} =[num2str(easso(i)) '- - -'];
            end
          end
        end  %for j =1:size(easso)
      end
    end

    %--------------------
    function Majstim(obj)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
    	tlet =0;
    	for U =1:vg.niveau
    		if strcmpi(strtrim(obj.Dato(1,U,1).nom),'stimulus')
    			tlet =U;
    			break;
    		end
    	end
      if tlet
      	vg.nst =obj.Dato(1,tlet,1).ncat;
      	vg.nomstim =cell(1, vg.nst);
        hdchnl.numstim =zeros(1, vg.ess);
        for U =1:vg.nst
          vg.nomstim{U} =strtrim(obj.Dato(2,tlet,U).nom);
          test =find(obj.Dato(2,tlet,U).ess);
          if ~isempty(test)
            hdchnl.numstim(test) =U;
          end
        end
      end
    end
  end  %methods
end  %classdef
