%
% Classe pour traiter les erreurs rencontrées
%
classdef CQueEsEsteError
  %------
  methods (Static)
    %-------
    function disp(erreur)
      v =CQueEsEsteError.queEsEso(erreur);
      if ~isempty(v)
        disp(v);
      end
    end
    %-------
    function val =queEsEso(e)
      PG =CParamGlobal.getInstance();
      dispError =PG.getDispError();
      if dispError == 0
        val =[];
      else
        if isa(e, 'MException')
          val =CQueEsEsteError.esoEsClass(e, dispError);
        elseif isa(e, 'char')
          val =e;
        elseif isa(e, 'numeric')
          val =num2str(e);
        else
          val ='?';
        end
      end
    end
    %-------
    function val =esoEsClass(Me, forme)
      switch forme
      case 3
        val =[Me.identifier ': ' Me.message];
      case 2
        val =Me.message;
      case 1
        val =[Me.identifier ': ' Me.message];
        if ~isempty(Me.stack)
          for U =1:length(Me.stack)
            val =sprintf('%s\n%s ligne: %i', val, Me.stack(U).name, Me.stack(U).line);
          end
        end
      end
    end
  end % methods
end % Class
