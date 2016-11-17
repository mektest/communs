%
% Classe CUneListe circulaire
%
%  Gestion d'une liste
%
% À REVOIR SÉRIEUSEMENT AVANT D'UTILISER
%
classdef CUneListe < handle
  properties
    premier =[];      % handle du premier noeud créer
    cur =[];          % handle du noeud actif (pour la lecture dans AV)
  end
  methods
    function thisObj =CUneListe()  % CONSTRUCTOR
      % rien pour l'instant
    end
    %-------
    function delete(thisObj)       % DESTRUCTOR
      if ~isempty(thisObj.premier)
        thisObj.cur =thisObj.premier;
        S =thisObj.cur.next;
        thisObj.cur.next =[];
        thisObj.cur =S;
        while ~isempty(thisObj.cur.next)
          S =thisObj.cur.next;
          delete(thisObj.cur);
          thisObj.cur =S;
        end
        delete(thisObj.premier);
      end
    end
    %---------------------------
    %% À revoir avant d'utiliser
    function Nouveau(thisObj, hData)
      hnd =CUnNoeud();
      if isempty(thisObj.premier)
        thisObj.premier =hnd;
        thisObj.cur =hnd;
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
    end
  end %methods
end
