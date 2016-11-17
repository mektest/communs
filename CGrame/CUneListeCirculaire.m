%
% Classe CUneListeCirculaire
%
%  Gestion d'une liste circulaire
%
classdef CUneListeCirculaire < CUneListe
  properties
    ecrit =[];        % handle du noeud pour l'écriture
  end
  %______
  methods
    function thisObj =CUneListe()  % CONSTRUCTOR
      % rien pour l'instant
    end
    %---------------------------
    %% À revoir avant d'utiliser
    function Nouveau(thisObj, hData)
      hnd =CUnNoeud();
      if isempty(thisObj.premier)
        thisObj.premier =hnd;
        thisObj.cur =hnd;
        thisObj.ecrit =hnd;
        hnd.next =hnd;
      else
        hnd.next =thisObj.cur.next;
      end
      thisObj.cur.next =hnd;
      hnd.hbuf =hData;
    end
    %-------
    function MiseAZero(thisObj)
      S =thisObj.premier;
      S.status =2;
      while ~isempty(S.next) & ~(S.next.status == 2)
        S =S.next;
        S.status =0;
      end
      thisObj.premier.status =0;
      thisObj.ecrit =thisObj.cur;
    end
  end
end