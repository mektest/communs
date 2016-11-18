%
% Classe CListBox2
%
%  Gestion d'une listebox avec choix simple/unique ou même les popupmenu
% ici on hérite de la classe CListBox1
%
classdef CListBox2 < CListBox1

  methods

    %------------
    % CONSTRUCTOR
    %-----------------------------
    function obj =CListBox2(texte)
      obj@CListBox1(texte);
    end

    %-------------------------------
    % overload la fonction getString
    % en sélection simple, on a pas à définir un "max"
    %-----------------------------
    function setString(obj, texte)
      set(obj.hnd, 'String',texte);
    end

  end  % methods
end % classdef
