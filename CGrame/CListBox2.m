%
% Classe CListBox2
%
%  Gestion d'une listebox avec choix simple ou même les popupmenu
%
classdef CListBox2 < CListBox1
  methods
    function obj =CListBox2(texte)  % CONSTRUCTOR
      obj@CListBox1(texte);
    end
    %-------
    function setString(obj, texte)
      set(obj.hnd, 'String',texte);
    end
  end  %methods
end