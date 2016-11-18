%
% classdef CPtchnl < handle
%
% METHODS
%  obj = CPtchnl(src)
%        EnlevePoint(obj, ess, canal, pt)
%        EnlevePointetLien(obj, ess, canal, pt)
%        EnleveLien(obj, canal, pt)
%   ss = get.Dato(obj)
%        initial(obj, Pt)
%        inserepoint(obj,canal,essai,point,temps,type)
%        marqettyp(obj,canal,essai,point,temps,type)
%        marquage(obj,canal,essai,point,temps)
%   pt = Onmark(obj,canal,essai,pt,temps)
%   lp = Onmarktyp(obj,canal,essai,point,temps,type)
%        OnTrie(obj,canal,essai)
%        PointBidon(obj, ess, canal, pt)
%    s = valeurDePoint(obj,texte,can,ess)
%    s = ValeurDeTemps(obj, texte, can, ess)
%   ss = verifPt3(obj, v, can, ess)
%
% METHODS STATIC
% [v, u] = retretted3(Texto, u)
%
% On pourrait faire une fonction DUPLIC: un canal vers plusieurs ou
%    N canal vers N canal... ptchnl.duplic(Vcan,Ncan) ...
%

classdef CPtchnl < handle

  properties
    Ofich =[];     % handle du fichier en cause
    Dato =[];      % contiendra la matrice des indices de point marqué
                   %   Dato(a, b, c) est de dimension 3
                   %   Dato(a, b, 1) contient les valeurs/index des points marqués
                   %                 (On garde l'indice et non le temps en sec.)
                   %   Dato(a, b, 2) contient le type de point marqué
                   %                -1 --> bidon
                   %                 0 --> régulier (par défaut)
                   %                 1 --> Fméd
                   %                 2 --> Fmoy
                   %                 3 --> Fmax
                   %
                   % hdchnl.point(can,tri) contient le numéro de la colonne (le b dans Dato)
                   % 
  end

  methods

    %____________
    % CONSTRUCTOR
    %-------------------------
    function obj =CPtchnl(src)
      obj.Ofich =src;
    end

    %-----------------------------------------------
    % Ici on ne fait pas de vérification sur le type
    % ou le contenu, mis à part isempty()
    %------------------------
    function initial(obj, Pt)
      if ~isempty(Pt)
        obj.Dato =int32(Pt);
      end
    end

    %_______
    % GETTER
    %-------------------------
    function ss =get.Dato(obj)
      ss =obj.Dato;
    end

    %-------
    function marqettyp(obj,canal,essai,point,temps,type)
      cnull =obj.Onmarktyp(canal,essai,point,temps,type);
    end
    % 
    % Tous les pts marqués sont gardés dans ptchnl. On garde l'indice et non le temps en sec.
    % hdchnl.point(can,tri) contient le # de la colonne dans ptchnl
    %-------
    function marquage(obj,canal,essai,point,temps)
      cnull =obj.Onmark(canal,essai,point,temps);
    end
    %-------
    function lp =Onmarktyp(obj,canal,essai,point,temps,type)
      lp =obj.Onmark(canal,essai,point,temps);
      obj.Dato(lp,obj.Ofich.Hdchnl.point(canal,essai),2) =type;
    end
    %-------
    function pt =Onmark(obj,canal,essai,pt,temps)
      hdchnl =obj.Ofich.Hdchnl;
      if pt   % on écrit sur le point "point"
        if hdchnl.npoints(canal,essai) == 0
          hdchnl.point(canal,essai) =size(obj.Dato,2)+1;
          obj.Dato(1:pt,hdchnl.point(canal,essai),2) =-1;
          hdchnl.npoints(canal,essai) =pt;
        elseif hdchnl.npoints(canal,essai) < pt
          obj.Dato(hdchnl.npoints(canal,essai)+1:pt,hdchnl.point(canal,essai),2) =-1;
          hdchnl.npoints(canal,essai) =pt;
        end
        obj.Dato(pt,hdchnl.point(canal,essai),2) =0;
        obj.Dato(pt,hdchnl.point(canal,essai),1) =temps;
      else       % on cré un nouveau point
        hdchnl.npoints(canal,essai) =hdchnl.npoints(canal,essai) +1;
        pt =hdchnl.npoints(canal,essai);
        if pt == 1
          hdchnl.point(canal,essai) =size(obj.Dato,2)+1;
        end
        obj.Dato(pt,hdchnl.point(canal,essai),2) =0;
        obj.Dato(pt,hdchnl.point(canal,essai),1) =temps;
      end
      if temps > hdchnl.nsmpls(canal,essai)
        obj.Dato(pt,hdchnl.point(canal,essai),2) =-1;
      end
    end
    %-------
    function OnTrie(obj,canal,essai)
      hdchnl =obj.Ofich.Hdchnl;
      N =hdchnl.npoints(canal,essai);
      if N > 1
        V =obj.Dato(1:N, hdchnl.point(canal,essai),1);
        [a, b] =sort(V);
        obj.Dato(1:N, hdchnl.point(canal,essai),1) =V(b);
      end
    end
    %-------
    function inserepoint(obj,canal,essai,point,temps,type)
      hdchnl =obj.Ofich.Hdchnl;
      dernier =hdchnl.npoints(canal,essai);
      if dernier == 0
        hdchnl.npoints(canal,essai) =point;
        hdchnl.point(canal,essai) =size(obj.Dato,2)+1;
        obj.Dato(1:point,hdchnl.point(canal,essai),2) =-1;
      elseif point > hdchnl.npoints(canal,essai)
        hdchnl.npoints(canal,essai) =point;
        obj.Dato(dernier+1:point,hdchnl.point(canal,essai),2) =-1;
      else
        hdchnl.npoints(canal,essai) =dernier+1;
        obj.Dato(point+1:dernier+1,hdchnl.point(canal,essai),:) =obj.Dato(point:dernier,hdchnl.point(canal,essai),:);
      end
      obj.Dato(point,hdchnl.point(canal,essai),1) =temps;
      if temps > hdchnl.nsmpls(canal,essai)
        obj.Dato(point,hdchnl.point(canal,essai),2) =-1;
      else
        obj.Dato(point,hdchnl.point(canal,essai),2) =type;
      end
    end
    %-------
    function EnlevePointetLien(obj, ess, canal, pt)
      obj.EnlevePoint(ess, canal, pt);
      obj.EnleveLien(canal, pt);
    end
    %-------
    function EnlevePoint(obj, ess, canal, pt)
      hdchnl =obj.Ofich.Hdchnl;
      if hdchnl.npoints(canal,ess) > 1
        obj.Dato(pt:end-1,hdchnl.point(canal,ess),1) =obj.Dato(pt+1:end,hdchnl.point(canal,ess),1);
        obj.Dato(pt:end-1,hdchnl.point(canal,ess),2) =obj.Dato(pt+1:end,hdchnl.point(canal,ess),2);
      end
      obj.Dato(hdchnl.npoints(canal,ess),hdchnl.point(canal,ess),1) =0;
      hdchnl.npoints(canal,ess) =hdchnl.npoints(canal,ess) - 1;
    end
    %-------
    function EnleveLien(obj, canal, pt)
      obj.Ofich.Tpchnl.DelPoint(canal, pt);
    end
    %-------
    function PointBidon(obj, ess, canal, pt)
      % (Est appelé de l'extérieur)
      hdchnl =obj.Ofich.Hdchnl;
      obj.Dato(pt,hdchnl.point(canal, ess),2) =-1;
      obj.EnleveLien(canal, pt);
    end
    %-------
    function s =valeurDePoint(obj,texte,can,ess)
      % (Est appelé de l'extérieur)
      % On décortique la valeur d'un point
      % ON VÉRIFIE texte et retourne la valeur en échantillon
      % évolution nov-2012
      % On peut maintenant donné comme valeur de point: P1+(Pf-Pi)/10
      try
        m =obj.valeurDeTemps(texte,can,ess);
        % On retourne le résultat en nb d'échantillon
        s =obj.temps2Echantillon(m,can,ess);
      catch e
        lesMots =sprintf('Erreur dans la fonction: %s\n%s (Canal: %d)|(Essai: %d)', ...
                          e.identifier, e.message, can, ess);
        disp(lesMots);
        s =[];
      end
    end
    %-------
    function s =valeurDeTemps(obj, texte, can, ess)
      % (Est appelé de l'extérieur)
      % On décortique une valeur d'interval temporel
      % ON VÉRIFIE texte et retourne la valeur en temps (sec)
      % On peut maintenant donné comme valeur de point: (Pf-Pi)/10
      try
        % On retourne le résultat en secondes
        s =obj.tretted3(texte,can,ess);
      catch e
        lesMots =sprintf('Erreur dans la fonction: %s\n%s (Canal: %d)|(Essai: %d)', ...
                          e.identifier, e.message, can, ess);
        disp(lesMots);
        s =[];
      end
    end
    %-------
    function v =temps2Echantillon(obj, tiempo, can, ess)
      hdchnl =obj.Ofich.Hdchnl;
      fcut =hdchnl.frontcut(can,ess);
      rate =hdchnl.rate(can,ess);
      v =round((tiempo-fcut)*rate);
      if v < 0
        me =MException('COMMUNS:CPtchnl:temps2Echantillon', 'Échantillon inférieure à Zéro, attention au frontcut');
        throw(me);
      elseif v == 0
        v =1;
      end
    end
    %-------
    function tt =tretted3(tO, TT, can, ess)
      % gestion des string lu lorsque l'on a un temps ou un point
      % la string devrait avoir été soumis à: isSyntaxBornesValid
      if ~isSyntaxBorneValid(TT)
        me =MException('COMMUNS:CPtchnl:tretted3', 'Syntaxe (%s) non valide', TT);
        throw(me);
      end
      % ON ENLÈVE LES BLANK
      pat ='\s+';
      TT =regexprep(TT, pat, '');
      if isempty(regexpi(TT, 'p')) && isempty(str2num(TT))  % pas de "p" mais d'autres caractères
        me =MException('COMMUNS:CPtchnl:tretted3', ['L''expression: %s n''est pas valide'], TT);
        throw(me);
      else
        u =java.lang.StringBuffer;
        leTop =length(TT);
        i =1;
        while (i <= leTop)
          if strncmpi(TT(i), 'p', 1)       % on a un "point"
            [val, i] =tO.retretted3(TT, i);
            i =i-1;
            if isempty(val)
              me =MException('COMMUNS:CPtchnl:tretted3', ...
                            ['L''expression: %s n''est pas valide'], TT);
              throw(me);
            end
            v =tO.verifPt3(val, can, ess);
            if isempty(v)
              me =MException('COMMUNS:CPtchnl:tretted3', ...
                            ['L''expression: %s n''est pas valide'], TT);
              throw(me);
            end
            u.append(num2str(v, 28));
          else
            u.append(TT(i));
          end
          i =i+1;
        end
      end
      tt =str2num(u.toString());
      if isempty(tt)
        me =MException('COMMUNS:CPtchnl:tretted3', ...
                      ['L''expression: %s n''est pas valide'], TT);
        throw(me);
      end
    end
    %-------
    function ss =verifPt3(obj, v, can, ess)
      % On retourne la réponse en sec
      hdchnl =obj.Ofich.Hdchnl;
      fcut =hdchnl.frontcut(can,ess);
      rate =hdchnl.rate(can,ess);
      ss =[];
      if strncmpi(v, 'i', 1)
        ss =1;
      elseif strncmpi(v, 'f', 1)
        ss =hdchnl.nsmpls(can,ess);
      else
        lePt =str2num(v);
        if ~isempty(lePt) && lePt <= hdchnl.npoints(can,ess) && ...
           lePt > 0 && obj.Dato(lePt,hdchnl.point(can,ess),2) ~= -1
          ss =double(obj.Dato(lePt,hdchnl.point(can,ess),1));
        end
      end
      if ~isempty(ss)
        ss =ss/rate+fcut;
      end
    end
  end  %methods
  %------------------------------------------------------------
  % ATTENTION: le "thisObject" devra être fourni par l'appelant
  % car la classe ne le fourni pas aux méthodes Static
  %---------------
  methods (Static)
    %---------------------------------------------
    % L'indicateur "u" pointe sur un caractère "p"
    % en arrivant dans cette fonction
    %-------
    function [v, u] =retretted3(Texto, u)
      u =u+1;
      v ='';
      if u > length(Texto)     % le "p" était le dernier char
        return;
      end
      if strcmpi(Texto(u), 'i') || strcmp(Texto(u), '0')
        v ='i';
        u =u+1;
      elseif strcmpi(Texto(u), 'f')
        v ='f';
        u =u+1;
      else
        pat ='^\d';
        while u <= length(Texto) && ~isempty(regexp(Texto(u:end), pat))
          v(end+1) =Texto(u);
          u =u+1;
        end
      end
    end
  end  %methods (Static)
end  %classdef
