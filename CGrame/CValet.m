%
% Classe qui donne les services à la "Communauté"
%
classdef CValet
  % Définition des Méthodes Statics
  methods (Static)
    function valdefaut()
      %**************************************
      % DÉFINITION DU CURSEUR EN FLEUR DE LYS
      fleur=ones(16,16);
      fleur([1:9 12:16],[1 16])=nan;
      fleur([1:8 11:16],[2 15])=nan;
      fleur([1:7 11 13:16],[3 14])=nan;
      fleur([1:7 11 13:16],[4 13])=nan;
      fleur([1:7 13:16],[5 12])=nan;
      fleur([1:4 6:8 13 14 16],[6 11])=nan;
      fleur([1 2 8:11 13 15 16],[7 10])=nan;
      %*********************************************
      % DÉFINITION DES VARIABLES GLOBALES PAR DÉFAUT
      set(0,'DefaultFigurePointer','cross',...
            'DefaultFigurePointerShapeCData',fleur,...
            'DefaultFigurePointerShapeHotSpot',[1 8],...
            'DefaultFigureUnits','pixels',...
            'DefaultFigureMenuBar','none', ...
            'DefaultFigureNumberTitle','off', ...
            'DefaultFigureWindowStyle','normal', ...
            'DefaultFigureBackingStore','off',...
            'DefaultFigureDockControls','off',...
            'DefaultFigureRenderermode','auto',...
            'DefaultFigureDoubleBuffer','on',...
            'DefaultFigureColor',[0.8 0.8 0.8],...
            'DefaultUIControlStyle','pushbutton',...
            'defaultUIControlFontSize',9,...
            'defaultAxesColor',[1 1 1],...
            'defaultAxesunits','Normalized',...
            'defaultAxesButtonDownFcn',[]);
    end
    %------------------
    % GARBAGE COLLECTOR
    % fonction pour nettoyer les Objets qui ont
    % fini leur travail et sont désormais inutiles
    %-------
    function GarbageCollector(src, event, thatObj)
      set(src, 'WindowButtonMotionFcn','');
      pause(0.25);
      delete(thatObj);
    end
    %-------
    function [fname,pname,cual] =quelfich(lenom,letit,multi)
      % Créateur: MEK, février 2009
      %
      % lenom ={'*.ext','extension à ouvrir'}
      % letit =Titre de la fenêtre
      % multi =true Si multiselect, autrement false
      cual =0;
      if multi
      	[fname,pname,cual] = uigetfile(lenom,letit,'MultiSelect','on');
        if iscell(fname) || (ischar(fname) && ischar(pname))
          cd(pname);
          if iscell(fname)
            fname = sort(fname);
          else
            fname = {fname};
          end
        end
      else
      	[fname,pname] = uigetfile(lenom,letit);
        if ischar(fname) && ischar(pname)
          cd(pname);
          cual =1;
        end
      end
    end
    %-------
    function Pf =Reposition(Pi)
      % On s'assure que les coordonnées de position seront
      % visible dans le ou les moniteurs accessibles.
      %
      Pf =Pi;
      S =get(0, 'MonitorPosition');
      M =0;
      for U =1:size(S,1)
        if Pi(1) < S(U, 3)
          M =U;
          break;
        end
      end
      if ~M
        M =1;
        Pf(1) =S(M, 3)-Pi(3);
      end
      Pf(2) =min(Pi(2),max(S(:,4))-Pi(4)-20);
    end
    %-------
    function Val =fen3bton(letitre,question,bout1,bout2,hndl)
      % varargin{1}  le titre de la fenêtre
      % varargin{2}  le texte à afficher {cellule}
      % varargin{3}  le label du premier bouton
      % varargin{4}  le label du deuxième bouton
      % varargin{5}  le handle de la fenêtre repère
      %
      % retournera [] si on cancel on ferme la fenêtre
      %             1 si on choisi le premier bouton
      %             0 si on choisi le deuxième bouton
      ligne =length(question);
      marge =20; mx =5; large =700+2*marge; haut =80+ligne*17; lbout =70;
      postext =[marge 70 large ligne*17];
      fig =figure( 'units','pixels','position', [10 10 large haut], 'visible','off', ...
           'CloseRequestFcn','set(findobj(''tag'',''Tagzz''),''string'',''cancelez'');', ...
           'name',letitre, 'NumberTitle','off', 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
           'defaultUIControlunits','pixels',...
           'defaultUIControlFontSize',9, 'Resize','off');
      letx =uicontrol('parent',fig, 'position',postext, 'style','text',...
                      'FontName','FixedWidth','FontSize',10);
      [question,pos] =textwrap(letx,question);
      postext(3) =pos(3);
      large =postext(3)+2*marge;
      lapos =positionfen('C','C',large,haut,hndl);
      set(fig, 'position',lapos);
      set(letx, 'position',postext, 'string',question);
      posx =round((large-2*mx-3*lbout)/2);
      leBt =uicontrol('parent',fig,'position',[posx 25 lbout 20], 'string',bout1, ...
                'callback','set(findobj(''tag'',''Tagzz''),''string'',''cancelo'');');
      posx =posx+lbout+mx;
      uicontrol('parent',fig,'position',[posx 25 lbout 20], 'string',bout2, ...
                'callback','set(findobj(''tag'',''Tagzz''),''string'',''canceln'');');
      posx =posx+lbout+mx;
      uicontrol('parent',fig,'position',[posx 25 lbout 20], 'string','Canceler', 'tag','Tagzz', ...
                'callback','set(findobj(''tag'',''Tagzz''),''string'',''cancelez'');');
      set(fig,'visible','on', 'WindowStyle','modal');
      uicontrol(leBt);
      waitfor(findobj('tag','Tagzz'),'string');
      ccc =get(findobj('tag','Tagzz'),'string');
      delete(fig);
      if strncmp(ccc,'cancele',7)         % on quitte
      	Val =[];
      elseif strncmp(ccc,'cancelo',7)     % Oui
      	Val =true;
      elseif strncmp(ccc,'canceln',7)     % Non
      	Val =false;
      end
    end
    %-------
    function Val =fen2bton(letitre,question,bout1,bout2,hndl,actif)
      % varargin{1}  le titre de la fenêtre
      % varargin{2}  le texte à afficher {cellule}
      % varargin{3}  le label du premier bouton
      % varargin{4}  le label du deuxième bouton
      % varargin{5}  le handle de la fenêtre repère
      % varargin{6}  1 on delete après usage, 0 on delete pas
      %
      % retournera [] si on ferme la fenêtre
      %             1 si on choisi le premier bouton
      %             0 si on choisi le deuxième bouton
      ligne =length(question);
      marge =20; mx =5; large =700+2*marge; haut =80+ligne*17; lbout =70;
      postext =[marge 70 large ligne*17];
      fig =figure( 'units','pixels', 'position',[10 10 large haut], 'visible','off', 'tag','Tagg', ...
           'CloseRequestFcn','set(gcf,''tag'',''Tag0'');', 'NumberTitle','off',...
           'name',letitre, 'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
           'defaultUIControlunits','pixels',...
           'defaultUIControlFontSize',9, 'Resize','off');
      letx =uicontrol('parent',fig, 'position',postext, 'style','text',...
                      'FontName','FixedWidth','FontSize',10);
      [question,pos] =textwrap(letx,question);
      postext(3) =pos(3);
      large =postext(3)+2*marge;
      lapos =positionfen('C','C',large,haut,hndl);
      set(fig, 'position',lapos);
      set(letx, 'position',postext, 'string',question);
      posx =round((large-mx-2*lbout)/2); haut =20; posy =25;
      leBt =uicontrol('parent',fig,'position',[posx posy lbout haut], 'string',bout1, ...
                'callback','set(gcf,''tag'',''Tag1'');');
      posx =posx+lbout+mx;
      uicontrol('parent',fig,'position',[posx posy lbout haut], 'string',bout2, ...
                'callback','set(gcf,''tag'',''Tag2'');');
      set(fig,'visible','on', 'WindowStyle','modal');
      uicontrol(leBt);
      waitfor(gcf,'tag');
      ccc =get(gcf,'tag');
      if actif
      	delete(fig);
      end
      if strncmp(ccc, 'Tag0', 4)            % on quitte
      	Val =[];
      elseif strncmp(ccc, 'Tag1', 4)        % bouton 1
      	Val =true;
      elseif strncmp(ccc, 'Tag2', 4)        % bouton 2
      	Val =false;
      end
    end
    %
    % Pour les prochaînse fonctions, voilà la Struc A-->CDatoImport()
    % A.debcan  donne la concordance du premier canal importé
    % A.fincan  donne ...           ... dernier ...
    % A.modcan  Nb de canaux ajouté, sinon < 0
    % A.debess  donne la concordance du premier essai importé
    % A.finess  donne ...           ... dernier ...
    % A.modess  Nb d'essai ajouté, sinon < 0
    % A.f0nad   donne le nombre de canal du fichier actif avant modif
    % A.f1nad   donne ...                       ... importé ...
    % A.f0ess   donne le nombre d'essai du fichier actif avant modif
    % A.f1ess   donne ...                      ... importé ...
    %-------
    function ImportDtchnl(hF0, hF1, A)
      % Sert à importer les datas (CDtchnl) du fichier hF1 dans hF0
      lemess ='Transfert des données (Dtchnl), canal ';
      hwb = waitbar(0,lemess);
      vg =hF0.Vg;
      hdchnl =hF0.Hdchnl;
      Nvg =hF1.Vg;
      Nhdchnl =hF1.Hdchnl;
      Dt0 =CDtchnl();
      Dt1 =CDtchnl();
      totcan =A.f0nad+A.modcan;
      if A.modcan < 0
        totcan =A.f0nad;
      end
      totess =A.f0ess+A.modess;
      if A.modess < 0
        totess =A.f0ess;
      end
      G0 =1/totcan;
      G1 =0;
      G2 =G0/4;
      for U =1:totcan
      	G1 =G1+G0;
        waitbar(G1, hwb, [lemess num2str(U)]);
        hF0.getcanal(Dt0, U);
        waitbar(G1+G2, hwb);
        if U <= A.f0nad        % canaux existant
          if totess > size(Dt0.Dato.(Dt0.Nom), 2)  % on comble les essais manquant
            Dt0.Dato.(Dt0.Nom)(1, totess) =0;
          end
          waitbar(G1+G2*2, hwb);
        else
          Dt0.Dato.(Dt0.Nom) =zeros(1,totess);
          waitbar(G1+G2*2, hwb);
        end
        V =U-A.debcan+1;
        if (U >= A.debcan) & (U <= A.fincan)
        	hF1.getcanal(Dt1, V);
        	ss =size(Dt1.Dato.(Dt1.Nom));
        	Dt0.Dato.(Dt0.Nom)(1:ss(1), A.debess:A.debess-1+ss(2)) =Dt1.Dato.(Dt1.Nom);
        end
        waitbar(G1+G2*3, hwb);
       	hF0.setcanal(Dt0);
      end
      delete(hwb);
    end
    %-------
    function ImportHdchnl(hF0, hF1, A)
      % Sert à importer les headers (CHtchnl) du fichier hF1 dans hF0
      hwb = waitbar(0,'Transfert des entêtes (Hdchnl), veuillez patienter');
      vg =hF0.Vg;
      hdchnl =hF0.Hdchnl;
      fname =hF1.autre.lenom;
      Nvg =hF1.Vg;
      Nhdchnl =hF1.Hdchnl;
      Dt0 =CDtchnl();
      Dt1 =CDtchnl();
      waitbar(0.1, hwb);
      % On ajoute des essais
      if A.debcan == 1
        % il y a plus de canaux dans l'importation
      	if A.f1nad > A.f0nad
      		hdchnl.ajoutcan(A.f1nad-A.f0nad);
      		for U =A.f0nad+1:A.f1nad
      			hdchnl.adname{U} =Nhdchnl.adname{U};
      		end
      	end
      	waitbar(0.25, hwb);
      	ess =A.debess:A.finess;
        U =1:A.f1nad;
        hdchnl.sweeptime(U,ess) =Nhdchnl.sweeptime;
        hdchnl.rate(U,ess) =Nhdchnl.rate;
        hdchnl.nsmpls(U,ess) =Nhdchnl.nsmpls;
        hdchnl.max(U,ess) =Nhdchnl.max;
        hdchnl.min(U,ess) =Nhdchnl.min;
        hdchnl.npoints(U,ess) =0;
        hdchnl.point(U,ess) =0;
        hdchnl.frontcut(U,ess) =Nhdchnl.frontcut;
        test =size(hdchnl.numstim);
        if test(1) > 1 & test(2) > 1
        	hdchnl.numstim =hdchnl.numstim(1, :);
        end
        hdchnl.numstim(ess) =0;
        hdchnl.comment(U, ess) ={fname};
        waitbar(0.65, hwb);
        % il y a moins de canaux dans l'importation
      	if A.f1nad < A.f0nad
          U =A.f1nad+1:A.f0nad;
          hdchnl.sweeptime(U,ess) =1;
          hdchnl.rate(U,ess) =1;
          hdchnl.nsmpls(U,ess) =1;
          hdchnl.max(U,ess) =0;
          hdchnl.min(U,ess) =0;
          hdchnl.npoints(U,ess) =0;
          hdchnl.point(U,ess) =0;
          hdchnl.frontcut(U,ess) =0;
          hdchnl.numstim(ess) =0;
          hdchnl.comment(U, ess) ={fname};
        end
      else
      % On ajoute des canaux
    		hdchnl.ajoutcan(A.f1nad);
    		waitbar(0.35, hwb);
    		ZZ =A.f0nad+1:A.f0nad+A.f1nad;
    		for U =ZZ
    			hdchnl.adname{U} =Nhdchnl.adname{U-A.f0nad};
    		end
      	ess =A.debess:A.finess;
        U =ZZ;
        waitbar(0.45, hwb);
        hdchnl.sweeptime(U,ess) =Nhdchnl.sweeptime;
        hdchnl.rate(U,ess) =Nhdchnl.rate;
        hdchnl.nsmpls(U,ess) =Nhdchnl.nsmpls;
        hdchnl.max(U,ess) =Nhdchnl.max;
        hdchnl.min(U,ess) =Nhdchnl.min;
        hdchnl.npoints(U,ess) =0;
        hdchnl.point(U,ess) =0;
        hdchnl.frontcut(U,ess) =Nhdchnl.frontcut;
        hdchnl.comment(U, ess) ={fname};
        % il y a plus d'essai dans l'importation
        waitbar(0.55, hwb);
      	if A.f1ess > A.f0ess
          U =1:A.f0nad;
          ess =A.f0ess+1:A.f1ess;
          hdchnl.sweeptime(U,ess) =1;
          hdchnl.rate(U,ess) =1;
          hdchnl.nsmpls(U,ess) =1;
          hdchnl.max(U,ess) =0;
          hdchnl.min(U,ess) =0;
          hdchnl.npoints(U,ess) =0;
          hdchnl.point(U,ess) =0;
          hdchnl.frontcut(U,ess) =0;
          test =size(hdchnl.numstim);
          if test(1) > 1 & test(2) > 1
          	hdchnl.numstim =hdchnl.numstim(1, :);
          end
          hdchnl.numstim(ess) =0;
          hdchnl.comment(U, ess) ={fname};
        end
      end
      waitbar(0.85, hwb);
    	vg.nad =length(hdchnl.adname);
      vg.ess =length(hdchnl.numstim);
      delete(hwb);
    end
    %-------
    function ImportStim(hF0, hF1, A)
      % Sert à importer les stimulus du fichier hF1 dans hF0
      hwb = waitbar(0,'Transfert des Stimulus, veuillez patienter');
      vg =hF0.Vg;
      hdchnl =hF0.Hdchnl;
      Nvg =hF1.Vg;
      Nhdchnl =hF1.Hdchnl;
      % On s'assure des stimulus existants
      waitbar(0.15, hwb);
      vg.nst =length(vg.nomstim)+1;
      vg.nomstim{vg.nst} ='Bidon';
      cc =zeros(vg.nst, 1);
      qui =1;
      oter =[];
      for U =1:vg.nst
      	if isempty(strtrim(vg.nomstim{U})) | strcmpi(strtrim(vg.nomstim{U}), 'bidon')
      		cc(U) =0;
      		oter =[oter U];
      	else
      		cc(U) =qui;
      		qui =qui+1;
      	end
      end
      waitbar(0.25, hwb);
      test =size(hdchnl.numstim);
      if test(1) > 1 & test(2)> 1
        hdchnl.numstim =hdchnl.numstim(1, :);
      end
      test =find(hdchnl.numstim > vg.nst-1 | hdchnl.numstim == 0);
      if ~isempty(test)
      	hdchnl.numstim(test) =vg.nst;
      end
      % on ramène à 0 les bidons et autres acabits
      for U =1:length(hdchnl.numstim)
      	hdchnl.numstim(U) =cc(hdchnl.numstim(U));
      end
      waitbar(0.45, hwb);
      if ~isempty(oter)
      	vg.nomstim(oter) =[];
      	vg.nst =length(vg.nomstim);
      end
      % On s'assure de la même chose des stimulus à importer
      waitbar(0.35, hwb);
      Nvg.nst =length(Nvg.nomstim)+1;
      Nvg.nomstim{Nvg.nst} ='Bidon';
      cc =zeros(Nvg.nst,1);
      qui =1;
      oter =[];
      for U =1:Nvg.nst
      	if isempty(strtrim(Nvg.nomstim{U})) | strcmpi(strtrim(Nvg.nomstim{U}), 'bidon')
      		cc(U) =0;
      		oter =[oter U];
      	else
      		cc(U) =qui;
      		qui =qui+1;
      	end
      end
      test =size(Nhdchnl.numstim);
      if test(1) > 1 & test(2)> 1
        Nhdchnl.numstim =Nhdchnl.numstim(1, :);
      end
      test =find(Nhdchnl.numstim > Nvg.nst-1 | Nhdchnl.numstim == 0);
      if ~isempty(test)
      	Nhdchnl.numstim(test) =Nvg.nst;
      end
      for U =1:A.f1ess
      	Nhdchnl.numstim(U) =cc(Nhdchnl.numstim(U));
      end
      if ~isempty(oter)
      	Nvg.nomstim(oter) =[];
      	Nvg.nst =length(Nvg.nomstim);
      end
      % Maintenant on peut importer
      waitbar(0.5, hwb);
      if Nvg.nst
      	cc =zeros(Nvg.nst, 1);
    	  for nS =1:Nvg.nst
    	    etpuis =find(strcmpi(vg.nomstim, Nvg.nomstim{nS}));
      	  if isempty(etpuis)
    	      vg.nst =vg.nst+1;
    	      vg.nomstim{vg.nst} =Nvg.nomstim{nS};
    	      cc(nS) =vg.nst;
      	  else
      	    cc(nS) =etpuis(1);
    		  end
    	  end
      	for U =A.debess:A.finess
    	    if (hdchnl.numstim(U) == 0) & (Nhdchnl.numstim(U-A.debess+1) > 0)
      	    hdchnl.numstim(U) =cc(Nhdchnl.numstim(U-A.debess+1));
    	    end
    	  end
      end
      waitbar(0.8, hwb);
      hF0.StimEssVideBidon();
      delete(hwb);
    end
    %-------
    function ImportCatego(hF0, hF1, A)
      %
      % On effectue ici la récupération des catégories du fichiers à ajouter (hF1)
      % vers le fichier actif (hF0)
      %
      hwb = waitbar(0,'Transfert des catégories (Catego), veuillez patienter');
      cat =hF0.Catego;
      fcat =hF1.Catego;
      vg =hF0.Vg;
      fvg =hF1.Vg;
      %
      % on discrémine à savoir si on a ajouter des essais
      % et si oui, on ajoute ses essais comme disponibles
      %
      totess =A.f0ess+A.modess;
      if A.modess < 0
        totess =A.f0ess;
      end
      waitbar(0.1, hwb);
      if A.modess > 0
        tot =A.f0ess+1:totess;
        % on fait le tour des niveaux
        for i =1:vg.niveau
          cat.Dato(1,i,1).ness =cat.Dato(1,i,1).ness+A.modess;
          cat.Dato(1,i,1).ess(tot) =1;
          % on fait le tour des catégories
          for j =1:cat.Dato(1,i,1).ncat
            cat.Dato(2,i,j).ess(tot) =0;
          end
        end
      end
      waitbar(0.2, hwb);
      %
      if vg.niveau & fvg.niveau
        % On avait des niveaux et on en a dans l'ajout
        for i =1:fvg.niveau         % On compare les niveaux importés
          waitbar(0.8*(i/fvg.niveau)+0.2, hwb);
          npareil =1;               % avec les locaux
          for j =1:vg.niveau
            if strcmpi(deblank(fcat.Dato(1,i,1).nom),deblank(cat.Dato(1,j,1).nom))
            % LE NIVEAU EXISTAIT
              for e =1:fcat.Dato(1,i,1).ncat      % on compare les catégories importés
                cpareil =1;                       % avec les locaux
                for k =1:cat.Dato(1,j,1).ncat
                  if strcmpi(deblank(fcat.Dato(2,i,e).nom),deblank(cat.Dato(2,j,k).nom))
                    % LA CATÉGORIE EXISTAIT
                    for m =A.debess:A.finess
                      if cat.Dato(1,j,1).ess(m) & fcat.Dato(2,i,e).ess(m-A.debess+1)
                        cat.Dato(1,j,1).ess(m) =0;
                        cat.Dato(2,j,k).ess(m) =1;
                      end
                    end
                    cat.Dato(1,j,1).ness =sum(cat.Dato(1,j,1).ess(:));
                    cat.Dato(2,j,k).ncat =sum(cat.Dato(2,j,k).ess(:));
                    cpareil =0;
                    break;
                  end
                end  %for k =1:cat.Dato(1,j,1).ncat
                if cpareil
                  % LA CATÉGORIE N'EXISTAIT PAS
                  cat.Dato(1,j,1).ncat =cat.Dato(1,j,1).ncat+1;
                  ratte =cat.Dato(1,j,1).ncat;
                  cat.Dato(2,j,ratte).nom =fcat.Dato(2,i,e).nom;
                  cat.Dato(2,j,ratte).ess =zeros(totess, 1);
                  for m =A.debess:A.finess
                    if cat.Dato(1,j,1).ess(m) & fcat.Dato(2,i,e).ess(m-A.debess+1)
                      cat.Dato(1,j,1).ess(m) =0;
                      cat.Dato(2,j,ratte).ess(m) =1;
                    end
                  end
                  cat.Dato(1,j,1).ness =sum(cat.Dato(1,j,1).ess(:));
                  cat.Dato(2,j,ratte).ncat =sum(cat.Dato(2,j,ratte).ess(:));
                end  %if cpareil
              end  %for e =1:fcat.Dato(1,i,1).ncat
              npareil =0;
              break;
            end
          end  %for j =1:vg.niveau
          %
          if npareil
          % LE NIVEAU N'EXISTAIT PAS
            vg.niveau =vg.niveau+1;
            cat.Dato(1,vg.niveau,1).nom =fcat.Dato(1,i,1).nom;
            cat.Dato(1,vg.niveau,1).ncat =fcat.Dato(1,i,1).ncat;
            cat.Dato(1,vg.niveau,1).ess =ones(totess, 1);
            cat.Dato(1,vg.niveau,1).ess(A.debess:A.finess) =fcat.Dato(1,i,1).ess
            cat.Dato(1,vg.niveau,1).ness =sum(cat.Dato(1,vg.niveau,1).ess(:));
            %
            for k =1:cat.Dato(1,vg.niveau,1).ncat
              cat.Dato(2,vg.niveau,k).nom =fcat.Dato(2,i,k).nom;
              cat.Dato(2,vg.niveau,k).ess =zeros(totess, 1);
              cat.Dato(2,vg.niveau,k).ess(A.debess:A.finess) =fcat.Dato(2,i,k).ess;
              cat.Dato(2,vg.niveau,k).ncat =sum(cat.Dato(2,vg.niveau,k).ess(:));
            end
          end  %if npareil
        end  %for i =1:fvg.niveau
      elseif fvg.niveau
        % On avait pas de niveaux, mais on en a dans l'ajout
                  % I=1:FVG.NIVEAU
                  % J=1:VG.NIVEAU
                  % E=1:FCATEGO(1,I,1).NCAT
                  % K=1:CATEGO(1,J,1).NCAT
                  % M=1:FVG.ESS
                  % W=M+AJ.DEBESS-1
        for i =1:fvg.niveau
          waitbar(0.8*(i/fvg.niveau)+0.2, hwb);
          vg.niveau =vg.niveau+1;
          cat.Dato(1,vg.niveau,1).nom =fcat.Dato(1,i,1).nom;
          cat.Dato(1,vg.niveau,1).ncat =fcat.Dato(1,i,1).ncat;
          cat.Dato(1,vg.niveau,1).ess([1:totess]) =1;
          cat.Dato(1,vg.niveau,1).ness =totess;
          %
          for k =1:cat.Dato(1,vg.niveau,1).ncat
            cat.Dato(2,vg.niveau,k).nom =fcat.Dato(2,i,k).nom;
            cat.Dato(2,vg.niveau,k).ess([1:totess]) =0;
            cat.Dato(2,vg.niveau,k).ncat =0;
            %
            for s =A.debess:A.finess
              if fcat.Dato(2,i,k).ess(s-A.debess+1)
                cat.Dato(2,vg.niveau,k).ess(s) =1;
                cat.Dato(1,vg.niveau,1).ess(s) =0;
              end
            end
            cat.Dato(2,vg.niveau,k).ncat =sum(cat.Dato(2,vg.niveau,k).ess(:));
            cat.Dato(1,vg.niveau,1).ness =sum(cat.Dato(1,vg.niveau,1).ess(:));
          end
        end  %for i =1:fvg.niveau
      end  %if vg.niveau & fvg.niveau
      delete(hwb);
    end
    %-------
    function ImportPtchnl(hF0, hF1, A)
      % On conserve les points marqués
      hwb = waitbar(0,'Transfert des points marqués (Catego), veuillez patienter');
      hdchnl =hF0.Hdchnl;
      Nhdchnl =hF1.Hdchnl;
      ptchnl =hF0.Ptchnl;
      Nptchnl =hF1.Ptchnl;
      Nbcan =A.fincan-A.debcan;
      for U =A.debcan:A.fincan
        waitbar(U/(Nbcan), hwb);
        for V =A.debess:A.finess
          NU =U-A.debcan+1;
          NV =V-A.debess+1;
      	  for T =1:Nhdchnl.npoints(NU,NV)
            ptchnl.marqettyp(U, V, 0, Nptchnl.Dato(T, Nhdchnl.point(NU, NV),1), Nptchnl.Dato(T, Nhdchnl.point(NU, NV),2));
      	  end
      	end
      end
      delete(hwb);
    end
    %-------
    function ImportTpchnl(hF0, hF1, A)
      tp1 =hF1.Tpchnl;
      for U =1:tp1.nbech
        tp1.Dato{U}.ModCanal(tp1.Dato{U}.canal+A.debcan-1);
      end
      hF0.Tpchnl.AssimilerNouveau(tp1);
    end
  end  %methods (Static)
end %classdef
