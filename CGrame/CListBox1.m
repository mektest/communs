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

    %------------
    % CONSTRUCTOR
    % EN ENTRÉE: UNE CELLULE CONTENANT LES PAIRES DE "PROPRIÉTÉ, VALEUR"
    %            QUI DÉFINIRONT LA LISTBOX
    %-----------------------------
    function obj =CListBox1(texte)
      obj.hnd =uicontrol(texte{:});
    end

    %-----------
    % DESTRUCTOR
    %-------------------
    function delete(obj)
      if ishandle(obj.hnd)
        delete(obj.hnd);
      end
    end

    %------------------------------------
    % Update les properties de la listbox
    % EN ENTRÉE {UNE CELLULE CONTENANT LES PAIRES DE "PROPRIÉTÉ, VALEUR"}
    %------------------------------
    function updateprop(obj, texte)
      set(obj.hnd, texte{:});
    end

    %________________________________________________
    % GETTER/SETTER pour les propriétés de la listbox
    %------------------------------------------------

    function V =getString(obj)
      V =get(obj.hnd, 'String');
    end

    function setString(obj, texte)
      letop =length(texte)+(length(texte) == 2);
      set(obj.hnd, 'String',texte, 'max',letop);
    end

    function V =getValue(obj)
      V =sort(get(obj.hnd, 'Value'));
    end

    function setValue(obj, V)
      set(obj.hnd, 'Value', V);
    end

    %------------------------------------------------------
    % On incrémente la valeur de la sélection de la listbox
    % si on était rendu au dernier item, on replacera le
    % curseur au premier item.
    %--------------------
    function suivant(obj)
  		ligne =obj.getValue();
  		nbligne =length(obj.getString());
      if ligne(end) == nbligne
        ligne(end) =0;
      end
      obj.setValue(ligne+1);
    end

    %------------------------------------------------------
    % On décrémente la valeur de la sélection de la listbox
    % si on était rendu au premier item, on replacera le
    % curseur au dernier item.
    %----------------------
    function precedent(obj)
      ligne =obj.getValue()-1;
      nbligne =length(obj.getString());
      if ligne(1) == 0
        ligne(1) =nbligne;
      end
      obj.setValue(ligne);
    end

  end % method
end % classdef
