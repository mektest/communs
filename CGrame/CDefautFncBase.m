%
% classdef CDefautFncBase
%
% METHODS (Static)           <------------ ATTENTION
%   initial(lobjet, Type, V)
%   V =databrut(lobjet, Type)
%   ResetProp(lobjet, Type)
%   hType =copie(lobjet, Type)
%

classdef CDefautFncBase

  methods (Static)

    %--------------------------------------------------
    % initial, change les properties de l'objet lobjet,
    % à partir des propriétés de la classe Type et
    % d'une structure V ou un objet de la classe Type
    %--------------------------------
    function initial(lobjet, Type, V)
      % On s'assure que V est une STRUCT ou un objet de la class "Type"
      if ~isempty(Type) && (isa(V, 'struct') || isa(V, Type))
        if isa(V, Type)
          V =CDefautFncBase.databrut(V, class(V));
        end
        % Création d'un objet Type
        S =str2func(Type);
        hType =S();
        % Lecture de ses properties
        a =properties(hType);
        delete(hType);
        for U =1:length(a)
          if isfield(V, a{U})
            lobjet.(a{U}) =V.(a{U});
          end
        end
      end
    end

    %--------------------------------
    % databrut retourne une structure
    % à partir des properties de la classe Type
    %---------------------------------
    function V =databrut(lobjet, Type)
      % Création d'un objet Type
      S =str2func(Type);
      hType =S();
      a =properties(hType);
      delete(hType);
      for U =1:length(a)
        V.(a{U}) =lobjet.(a{U});
      end
    end

    %-------------------------------
    % ResetProp remet les properties
    % aux valeurs par défauts
    %
    %   l'objet Type: lobjet, doit avoir les méthodes
    %      databrut et
    %      initial
    %-------------------------------
    function ResetProp(lobjet, Type)
      % Création d'un objet Type
      S =str2func(Type);
      hType =S();
      lobjet.initial(hType.databrut());
      delete(hType);
    end

    %---------------------------------------------------
    % copie retourne un objet avec les properties actuel
    %
    %   l'objet Type: lobjet, doit avoir les méthodes
    %      databrut et
    %      initial
    %----------------------------------
    function hType =copie(lobjet, Type)
      % si on a un seul paramètre, le Type est celui de lobjet
      if nargin == 1
        Type =class(lobjet);
      end
      % Création d'un objet Type
      S =str2func(Type);
      hType =S();
      hType.initial(lobjet.databrut());
    end

  end  %methods
end
