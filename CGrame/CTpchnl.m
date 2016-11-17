%
% Classe CTpchnl
%
%
classdef CTpchnl < handle
  properties
    Dato ={};
  end %properties
  %---------
  properties (SetAccess = protected)
    hFich;
    nbech =0;
  end %properties (SetAccess = protected)
  %------
  methods
    function thisObj =CTpchnl(hF)     %  CONSTRUCTOR
      thisObj.hFich =hF;
    end
    %-------
    function delete(thisObj)          %  DESTRUCTOR
      if thisObj.nbech
        for U =thisObj.nbech:-1:1
          delete(thisObj.Dato{U});
        end
        thisObj.nbech =0;
      end
    end
    %-------
    function ss =getDato(thisObj)
      ss =[];
      for U =1:thisObj.nbech
        hEch =thisObj.Dato{U};
        ss(U).nom =hEch.nom;
        ss(U).canal =hEch.canal;
        ss(U).point =hEch.point;
      end
    end
    %-------
    function tp =isValidStruc(thisObj, tp)
      % tp est une structure lu d'un fichier
      if ~isempty(tp) & sum(isfield(tp(1), {'nom', 'canal', 'point'})) == 3
      	test =[];
      	for U =1:length(tp)
      	  if (thisObj.hFich.Vg.nad < tp(U).canal) | (tp(U).canal == 0)
      		test(end+1) =U;
      	  elseif (tp(U).point > min(thisObj.hFich.Hdchnl.npoints(tp(U).canal,:))) | (tp(U).point == 0)
      		test(end+1) =U;
      	  end
      	end
      	if ~isempty(test)
      		tp(test) =[];
      	end
      else
      	tp =[];
      end
    end
    %-------
    function s =QuiSuisje(thisObj, hchild)
      s =0;
      for U =1:thisObj.nbech
        if find(thisObj.Dato{U}, hchild)
          s =U;
          break;
        end
      end
    end
    %-------
    function s =FaireListEchel(thisObj)
      s{1} ='Aucune';
      for U =1:thisObj.nbech
        hEch =thisObj.Dato{U};
        s{U} =hEch.nom;
      end
    end
    %-------
    function [laliste, B] =getpoint(thisObj, can)
      hdchnl =thisObj.hFich.Hdchnl;
      laliste={'...'};
      B =min(hdchnl.npoints(can,:));
      if B
        for i=1:B
          laliste{i} =num2str(i);
        end
      end
    end
    %-------
    function EnleveEchel(obj, echel)
      delete(obj.Dato{echel});
      obj.Dato(echel) =[];
      obj.nbech =length(obj.Dato);
    end
    %-------
    function DelPoint(tO, varargin)
      % utile pour "équilibrer la librairie"
    end  
    %-------
    function ValidEchelles(obj)
      nad =obj.hFich.Vg.nad;
      for U =obj.nbech:-1:1
        if nad < obj.Dato{U}.canal
    	  obj.EnleveEchel(U);
  	    elseif obj.Dato{U}.point > min(obj.hFich.Hdchnl.npoints(obj.Dato{U}.canal,:))
    	  obj.EnleveEchel(U);
        end
      end
    end
  end  %methods
end  %classdef
