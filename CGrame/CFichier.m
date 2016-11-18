%
% Classe CFichier
%
% Classe de Base pour la gestion des fichiers au format d'Analyse,
% indépendante des applications. Elle sera héritée par d'autres classes 
% du genre CFichierAnalyse.
%
% MEK - mai 2009
%

classdef CFichier < handle

  properties
    Info =[];
    Vg =[];
    Hdchnl =[];
    Ptchnl =[];
%   Tpchnl;     % voir CFichierAnalyse
    Catego =[];
    autre =[];
  end

  properties (SetAccess = private)
    NouvelVersion =7.08;
  end

  methods

    % CONSTRUCTOR
    function thisObj =CFichier(letype)
      thisObj.Info =CFinfo();
      thisObj.Vg =CVgFichier();
      thisObj.Vg.itype =letype;
      thisObj.Hdchnl =CHdchnl();
      thisObj.Ptchnl =CPtchnl(thisObj);
      thisObj.Catego =CCatego();
      thisObj.Catego.hF =thisObj;
    end

    % DESTRUCTOR
    function delete(thisObj)
      delete(thisObj.Info);
      delete(thisObj.Vg);
      delete(thisObj.Hdchnl);
      delete(thisObj.Ptchnl);
      delete(thisObj.Catego);
    end

    %----------------------------------------
    % GETTER-SETTER
    % pour la propriété: NouvelleVersion
    %----------------------------------------
    function val = get.NouvelVersion(thisObj)
      val =thisObj.NouvelVersion;
    end

    function thisObj = set.NouvelVersion(thisObj,value)
      % rien à faire, on ne touche pas à cette propriété
    end

    %------------------------------------
    % FIND  (overload)
    % Si on a plusieurs fichiers ouverts,
    % on peut vouloir les comparer
    %------------------------------
    function Cok =find(thisObj,OFi)
      Cok =(thisObj == OFi);
    end

    %---------------------------------
    % Copie data du canal source (src)
    % vers le canal destination (dst)
    %-------------------------------------
    function CopieCanal(thisObj, src, dst)
      hDt =CDtchnl();
      thisObj.getcanal(hDt, src);
      thisObj.setcanal(hDt, dst);
    end

    %-----------------------------------
    % Récupère 1 canal (tous les essais)
    % HDt --> handle sur un objet CDtchnl()
    % can --> numéro du canal
    %-----------------------------------
    function getcanal(thisObj, HDt, can)
      if nargin == 3
        HDt.Nom =thisObj.Hdchnl.cindx{can};
      end
      if isempty(whos('-file', thisObj.Info.fitmp, HDt.Nom))
      	a.(HDt.Nom) =[];
      	HDt.Dato =a;
      else
        HDt.Dato =load(thisObj.Info.fitmp, HDt.Nom);
      end
    end

    %-------------------------------------
    % Récupère 1 canal pour les essais ess
    % HDt --> handle sur un objet CDtchnl()
    % ess --> numéro des essais à lire
    % can --> numéro du canal
    %-----------------------------------------
    function getcaness(thisObj, HDt, ess, can)
      if nargin == 4
        HDt.Nom =thisObj.Hdchnl.cindx{can};
      end
      if isempty(whos('-file', thisObj.Info.fitmp, HDt.Nom))
      	a.(HDt.Nom) =[];
      	HDt.Dato =a;
      else
        s =load(thisObj.Info.fitmp, HDt.Nom);
        HDt.Dato.(HDt.Nom) =s.(HDt.Nom)(:,ess);
      end
    end

    %-----------------------------------------
    % sauvegarde le canal avec tous ses essais
    % HDt --> handle sur un objet CDtchnl()
    % can --> numéro du canal
    %-----------------------------------
    function setcanal(thisObj, HDt, can)
      if nargin == 3
        thisObj.rename(HDt, can);
      end
      p =HDt.Dato;
      save(thisObj.Info.fitmp, '-Struct', 'p', HDt.Nom, '-Append');
    end

    %----------------------------------------
    % sauvegarde le canal pour les essais ess
    % HDt --> handle sur un objet CDtchnl()
    % ess --> numéro des essais à lire
    % can --> numéro du canal
    function setcaness(thisObj, HDt, ess, can)
      if nargin == 4
        thisObj.rename(HDt, can);
      end
      p =load(thisObj.Info.fitmp, HDt.Nom);
      if isempty(HDt.Dato.(HDt.Nom))
   	    p.(HDt.Nom)(:,ess) =[];
      elseif ~isfield(p, HDt.Nom)
  	    p.(HDt.Nom)(:,ess) =HDt.Dato.(HDt.Nom);
  	  else
  	  	a =size(HDt.Dato.(HDt.Nom), 1);
  	  	p.(HDt.Nom)(1:a,ess) =HDt.Dato.(HDt.Nom);
      end
      save(thisObj.Info.fitmp, '-Struct', 'p', HDt.Nom,'-Append');
    end

    %----------------------------
    % Delete les datas d'un canal
    %   can --> numéro du canal
    %----------------------------
    function delcan(thisObj, can)
      HDt =CDtchnl();
      for U =1:length(can)
        % lire le nom de la variable du canal
      	HDt.Nom =thisObj.Hdchnl.cindx{can(U)};
        % on vide les datas
      	HDt.Dato.(HDt.Nom) =[];
        % on sauvegarde
      	thisObj.setcanal(HDt);
      end
      delete(HDt);
    end

    %----------------------
    % delete les essais ess
    %  ess --> numéro des essais
    %----------------------------
    function deless(thisObj, ess)
      HDt =CDtchnl();
      hwb =waitbar(0, 'canal: ');
      %________________________________________________________________________
      % comme chaque canal est conservé dans une variable séparément,
      % il faudra faire le tour de tout les canaux pour effacer les essais ess
      %------------------------------------------------------------------------
      for U =1:thisObj.Vg.nad
      	waitbar(U/thisObj.Vg.nad, hwb, ['canal: ' num2str(U)]);
        % lecture du nom du canal
      	HDt.Nom =thisObj.Hdchnl.cindx{U};
        % mise à zéro des essais
      	HDt.Dato.(HDt.Nom) =[];
        % sauvegarde du canal pour les essais ess
      	thisObj.setcaness(HDt, ess);
      end
      delete(HDt);
      delete(hwb);
    end

    %----------------------------------
    % On fait une revision des stimulus
    % pour s'assurer qu'ils ne sont pas vides
    %-----------------------------
    function StimulusVide(thisObj)
      % On commence par enlever les cellules vides
      for V =length(thisObj.Vg.nomstim):-1:1
        if isempty(strtrim(thisObj.Vg.nomstim{V}))
          thisObj.Vg.nomstim(V) =[];
        end
      end
      if isempty(thisObj.Vg.nomstim)
        % On a pas de stimulu, on en cré un bidon
        thisObj.Vg.nst =1;
        thisObj.Vg.nomstim ={'Bidon'};
        thisObj.Hdchnl.numstim =ones(1, thisObj.Vg.ess);
      else
      	% on ajuste les paramètres
      	thisObj.Vg.nst =length(thisObj.Vg.nomstim);
      	test =zeros(1, thisObj.Vg.ess);
      	N =min(length(test), length(thisObj.Hdchnl.numstim));
      	test(1:N) =thisObj.Hdchnl.numstim(1:N);
      	thisObj.Hdchnl.numstim =test;
      end
    end

    %------------------------------------------
    % On s'assure que les stimulus sont uniques
    % ------------------------------
    function StimulusUnique(thisObj)
      vg =thisObj.Vg;
      hdchnl =thisObj.Hdchnl;
      ref =vg.nomstim;
      U =1;
      while(U < vg.nst)
        test =strcmpi(vg.nomstim{U}, vg.nomstim);
      	if sum(test) > 1
      		tt =find(test);
      	  vg.nomstim(tt(2:end)) =[];
      	  vg.nst =length(vg.nomstim);
      	end
      	U =U+1;
      end
      letest =find(hdchnl.numstim > length(ref));
      if ~isempty(letest)
      	hdchnl.numstim(letest) =0;
      end
      lesess =find(hdchnl.numstim > 0);
      for U =lesess
      	test =strcmpi(ref{hdchnl.numstim(U)}, vg.nomstim);
      	ss =find(test);
      	if isempty(ss)
      	  ss =0;
      	end
      	hdchnl.numstim(U) =ss;
      end
    end

    %-----------------------------------------------
    % les essais non-assignés seront classés "bidon"
    %---------------------------------
    function StimEssVideBidon(thisObj)
      vg =thisObj.Vg;
      hdchnl =thisObj.Hdchnl;
      % recherche de la position des bidons
   	  ss =find(hdchnl.numstim == 0 | hdchnl.numstim > vg.nst);
   	  if ~isempty(ss)
        test =strcmpi('bidon', vg.nomstim);
        if sum(test) == 0
      	  vg.nst =vg.nst+1;
      	  vg.nomstim{vg.nst} ='bidon';
      	  bidon =vg.nst;
        else
        	bidon =find(test);
        end
    	  hdchnl.numstim(ss) =bidon;
   	  end
    end

    %-------------------------------------------
    % Renommer la variable qui contient le canal
    % HDt --> handle sur un objet CDtchnl()
    % can --> numéro du canal
    %---------------------------------
    function rename(thisObj, HDt, can)
      lenom =thisObj.Hdchnl.cindx{can};
      HDt.rename(lenom);
    end

    %------------------------------
    % Retourne le size du canal can
    % can --> numéro du canal
    %--------------------------------
    function Dt =sizecan(thisObj,can)
      ss =whos('-file', thisObj.Info.fitmp, thisObj.Hdchnl.cindx{can});
      Dt =ss.size;
    end

    %-------------------------------------
    % [Ok] = ASSEZPT(LesCan, NbPt, LesEss)
    %
    % Cette fonction va vérifier si on a le bon nombre de point demandé.
    % En entrée: les canaux à vérifier, le nombre de point nécessaire
    %            (1 par défaut), les essais (1:vg.ess par défaut).
    % En sortie: si il y a erreur, [1],  autrement [0]
    %-------------------------------------------
    function lasortie =assezpt(thisObj,varargin)
      if nargin <= 1
        lasortie =true;
        return;
      end
      lasortie =false;
      % variable des infos sur les canaux/essais
      hdchnl =thisObj.Hdchnl;
      % variable des infos des points marqués
      ptchnl =thisObj.Ptchnl;
      % variable des infos globales
      vg =thisObj.Vg;
      lescan =varargin{1};
      nbpt =1;
      lesess =[1:vg.ess];
      if nargin == 3
        nbpt =varargin{2};
      elseif nargin > 3
        nbpt =varargin{2};
        lesess =varargin{3};
      end
      %**********************************************************
      % L'affichage d'erreur se fait dans la fenêtre de commande.
      % Comme on utilise des caractères ASCII > 128, ça demande
      % une pirouette supplémentaire (retour au bon vieux "DOS" d'autrefois).
      %**********************************************************************
      sdl =[char(13) char(10)];
      ctok =1;
      legros =max(nbpt);
      for ii =1:length(lescan)
        ss =find(hdchnl.npoints(lescan(ii),lesess) < legros);
        if length(ss)
          if ctok
            disp([num2str(legros) ' point(s) sont requis pour cette fonction.']);
          end
          lastr =[sdl 'Pour le canal ' num2str(lescan(ii)) ', les essais suivants sont a corriger:'];
          disp([lastr sdl num2str(lesess(ss))]);
          ctok =0;
          lasortie =true;
        end
        ctiok =[];
        for jj =lesess
          for uu =1:length(nbpt)
            if (hdchnl.npoints(lescan(ii),jj)>=nbpt(uu)) & (ptchnl.Dato(nbpt(uu),hdchnl.point(lescan(ii),jj),2) == -1)
              ctiok =[ctiok ' ' num2str(jj)];
            end
          end
        end
        if length(ctiok)
          lasortie =true;
          disp([sdl 'point bidon: essai #' ctiok]);
        end
      end
    end

    %-------------------------------------------------
    % Procède au marquage d'un point, voir "CPtchnl.m"
    %-------------------------------------------------------
    function marqettyp(thisObj,canal,essai,point,temps,type)
      thisObj.Ptchnl.marqettyp(canal,essai,point,temps,type);
    end

    %---------------------------------
    % initialise Ptchnl et met à jour:
    %   -  la matrice des points marqués
    %   -  thisObj.Hdchnl
    %--------------------------
    function initpoint(thisObj)
      % variable des infos sur les canaux/essais
      Hd =thisObj.Hdchnl;
      % variable des infos des points marqués
      Pt =thisObj.Ptchnl;
      % nombre maximum de point marqué dans ce fichier
      tmp =max(Hd.npoints(:));
      if tmp > 0 && ~isempty(Pt.Dato)
        % on a des points marqués
        % quel canal/essai en a
        ptmp =find(Hd.npoints(:) > 0);
        % on se fait un backup de la matrice des infos des points marqués
        Dato =Pt.Dato;
        % mise à zéro de la matrice des infos des points marqués
        Pt.Dato =zeros(tmp,length(ptmp),2);
        % Il reste à rebâtir la matrice des points marqués à partir
        % des infos canal/essais (Hdchnl) et du backup (Dato)
        for U =1:length(ptmp)
          Pt.Dato(1:Hd.npoints(ptmp(U)),U,:) =Dato(1:Hd.npoints(ptmp(U)),Hd.point(ptmp(U)),1:2);
          ttest =find(Pt.Dato(1:Hd.npoints(ptmp(U)),U,1) > Hd.nsmpls(ptmp(U)));
          if ~isempty(ttest)
            Pt.Dato(ttest,U,2) =-1;
          end
          Hd.point(ptmp(U)) =U;
        end
      end
    end

    %-----------------------------
    % rebâti la variable vg.lesess
    % qui est uitlisé pour afficher les essais avec
    % un nom de catégorie ou de stimulus...
    %-----------------------
    function lesess(thisObj)
    % vg.defniv sert à afficher les catégories du niveau désiré plutôt que d'indiquer le stimulus.
      vg =thisObj.Vg;
      cc =thisObj.Catego.Dato;
      L =cell(1,vg.ess);
      % On vérifie si on a des stimulus
   	  tlet =0;
      for U =1:vg.niveau
        if strcmpi(strtrim(cc(1,U,1).nom),'stimulus')
          tlet =U;
          break;
        end
      end
      if tlet
        S =zeros(vg.ess, 1);     % Ici S contient la catégorie pour un essai donné
        for U =1:cc(1,tlet,1).ncat
          S(:) =cc(2, tlet, U).ess(:)*U+S;
        end
      end
      for V =1:vg.ess
      	lestim ='-';
      	if vg.niveau
          lecat =0;
          for U =1:cc(1,vg.defniv,1).ncat
            if cc(2,vg.defniv,U).ess(V)
              lecat =U;
              break;
            end
          end
          if tlet
            if tlet == vg.defniv
              lestim ='';
            else
              lestim =[cc(2,tlet,S(V)).nom '-'];
            end
            if lecat
              lestim =[lestim cc(2,vg.defniv,lecat).nom];
            end
          else
            if vg.nst & thisObj.Hdchnl.numstim(V) & thisObj.Hdchnl.numstim(V) <= vg.nst
          	  lestim =[strtrim(vg.nomstim{thisObj.Hdchnl.numstim(V)}) '-'];
            end
            if lecat
              lestim =[lestim cc(2,vg.defniv,lecat).nom];
            end
          end
        else
          % Pas de niveaux, on vérifie si on a des stimulus (avec vg.nst)
       	  if vg.nst & thisObj.Hdchnl.numstim(V) & thisObj.Hdchnl.numstim(V) <= vg.nst
        	lestim =[strtrim(vg.nomstim{thisObj.Hdchnl.numstim(V)}) ' -'];
          end
      	end
        if V >99
          L{V} =[num2str(V) '- ' lestim];
        elseif V >9
          L{V} =[num2str(V) ' - ' lestim];
        else
          L{V} =[num2str(V) '  - ' lestim];
        end
      end
      vg.lesess =L;
    end

    %------------------------------
    % Rebâti la variable vg.lescats
    % pour l'affichage des noms de catégorie
    %------------------------
    function lescats(thisObj)
      vg =thisObj.Vg;
      cc =thisObj.Catego;
      vg.lescats ={};
      for N =1:vg.niveau
        for C =1:cc.Dato(1,N,1).ncat
          vg.lescats{end+1} =[strtrim(cc.Dato(1,N,1).nom) '--' strtrim(cc.Dato(2,N,C).nom)];
        end
      end
    end

    %---------------------------------------------------------------
    % Suite au nouveau format de fichier Analyse, il était important
    % de faire attention de ne pas écraser par défaut un fichier qui
    % était dans l'ancien format.
    %    entrada  -->  nom du fichier à vérifier
    % Au Retour
    %    []       -->  mauvais format de fichier
    %    false    -->  ancien format d'Analyse
    %    true     -->  nouveau format
    %-------------------------------------------
    function COk =SondeFichier(thisObj, entrada)
      COk =[];
      % on vérifie si on a au moins une variable vg
      chk00 =whos('-file', entrada, 'vg');
      % on vérifie si il y a une variable hdchnl
      chk01 =whos('-file', entrada, 'hdchnl');
      % on vérifie si il y a une variable dtchnl
      chk02 =whos('-file', entrada, 'dtchnl');
      if isempty(chk00) | isempty(chk01)
        % il manque au moins une des variables de base dans les deux formats
        return;
      elseif isempty(chk02)
        % il y a apparence du nouveau format
       	ss =load(entrada, 'hdchnl');
       	if ~isfield(ss.hdchnl, 'cindx')
          % fausse alerte, ce n'est pas le nouveau format non plus.
          return;
        end
        % il s'agit bien du nouveau format
      	COk =true;
      else
        % apparence d'un fichier analyse
       	ss =load(entrada, 'hdchnl');
       	if isfield(ss.hdchnl, 'cindx')
        	COk =true;
          return;
        end
        COk =false;
      end
    end

    %----------------------------------------------------
    % Lorsque l'on a un fichier à l'ancien format on doit
    % le transformer dans la nouvelle version pour pouvoir
    % l'utiliser.
    %   fI  -->  nom du fichier d'entrée
    %   fO  -->  nom du fichier de sortie
    %   hwb -->  handle d'un waitbar
    %---------------------------------------------
    function TransformCanaux(thisObj, fI, fO, hwb)
      dtchnl2can(thisObj, fI, fO, hwb);
    end

    %----------------------------------------------------------
    % Fonction pour passer de l'ancienne version à la nouvelle.
    %   entrada   -->  est le nom du fichier
    %   hwb       -->  est un handle sur le waitbar actif
    %   hF        -->  est un handle sur une fonction, utilisé dans analyse
    %-----------------------------------------------------
    function salida =correction(thisObj, entrada, hwb, hF)
      palabras ={'**************************************';...
                 '*  Votre fichier Analyse doit être   *';...
                 '*  converti. Vous DEVRIEZ Donner un  *';...
                 '*  nouveau nom afin de conserver     *';...
                 '*  intacte l''ancien fichier.         *';...
                 '*                                    *';...
                 '**************************************'};
      lafig =gcf;
      etalors =CValet.fen3bton('Conseil avant conversion',palabras,'Renommer','Écraser',lafig);
      if isempty(etalors)       % on quitte
      	salida =[];
        return;
      elseif etalors            % on renomme
        [fnom,pnom] =uiputfile('*.mat','','nouveau.mat');
        if ((length(fnom) == 1) & (fnom == 0)) | (~isempty(hF) & hF(fullfile(pnom,fnom)))
          salida =[];
          return;
        end
        salida =fullfile(pnom,fnom);
        guardar =0;
      else                      % on écrase
        agarder =[tempname() '.mat'];
        movefile(entrada,agarder);
        salida =entrada;
        entrada =agarder;
        guardar =1;
      end
      thisObj.TransformCanaux(entrada, salida, hwb);
      if guardar
      	delete(entrada);
      end
    end

    %----------------------------------------
    % Convertir un fichier de l'ancien format
    %   entrada   -->  est le nom du fichier
    %   hwb       -->  est un handle sur le waitbar actif
    %---------------------------------------
    function converti(thisObj, entrada, hwb)
      salida =[tempname(pwd) '.mat'];
      movefile(entrada, salida, 'f');
      thisObj.TransformCanaux(salida, entrada, hwb);
      delete(salida);
    end

  end  %methods (Access =protected)
end  %classdef
