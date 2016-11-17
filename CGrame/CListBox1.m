%
% Classe CListBox1
%
%  Gestion d'une listebox avec choix multiple
%
classdef CListBox1 < handle
  properties
    hnd;
  end
  methods
    function obj =CListBox1(texte)  % CONSTRUCTOR
      obj.hnd =uicontrol(texte{:});
    end
    %-------
    function delete(obj)    % DESTRUCTOR
      if ishandle(obj.hnd)
        delete(obj.hnd);
      end
    end
    %-------
    function V =getString(obj)
      V =get(obj.hnd, 'String');
    end
    %-------
    function setString(obj, texte)
      letop =length(texte)+(length(texte) == 2);
      set(obj.hnd, 'String',texte, 'max',letop);
    end
    %-------
    function updateprop(obj, texte)
      set(obj.hnd, texte{:});
    end
    %-------
    function V =getValue(obj)
      V =sort(get(obj.hnd, 'Value'));
    end
    %-------
    function setValue(obj, V)
      set(obj.hnd, 'Value', V);
    end
    %-------
    function suivant(obj)
  		ligne =obj.getValue();
  		nbligne =length(obj.getString());
      if ligne(end) == nbligne
        ligne(end) =0;
      end
      obj.setValue(ligne+1);
    end
    %-------
    function precedent(obj)
      ligne =obj.getValue()-1;
      nbligne =length(obj.getString());
      if ligne(1) == 0
        ligne(1) =nbligne;
      end
      obj.setValue(ligne);
    end
  end
end