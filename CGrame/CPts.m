%
% Classe CPts
%
% voir gco type line...
%
classdef CPts < handle
  properties
    fichier;  % handle du CFichier
    essai;
    canal;
    numero;       % numéro du point
    type;         % type du point  ptchnl(numero,b,2)
    typtxt;       % X ou Y qui sait?
    dttip;        % graphics.datatip
    dtcursor;     % graphics.datacursor
  end  %properties
  %------
  methods
    %-------
    function obj =CPts(H, fid, ess, can, N)  %CONSTRUCTOR
      obj.fichier =fid;
      obj.essai =ess;
      obj.canal =can;
      obj.numero =N;
      obj.dttip =graphics.datatip(H);
      obj.dttip.Visible = 'off';
      obj.dttip.Interpolate ='off';
      obj.dttip.Draggable ='off';
      obj.dttip.MarkerSize =5;
      obj.dttip.FontSize =7;
      obj.dtcursor =graphics.datacursor;
      updatePositionAndString(obj.dttip,obj.dtcursor);  
    end
    %-------
    function delete(obj)  % DESTRUCTOR
      if ishandle(obj.dtcursor)
      	delete(obj.dtcursor);
      end
      if ishandle(obj.dttip)
      	delete(obj.dttip);
      end
    end
    %-------
    function bouge(obj, I)
      obj.dtcursor.DataIndex = I;
      obj.dtcursor.Position = [obj.dtcursor.Target.XData(I),...
                               obj.dtcursor.Target.YData(I)];  
      % Apply cursor to datatip  
      updatePositionAndString(obj.dttip,obj.dtcursor);  
    end
    %-------
    function montrer(obj)
      obj.dttip.Visible = 'on';
    end
    %-------
    function cacher(obj)
      obj.dttip.Visible = 'off';
    end
    %-------
    function pos =lapos(obj)
      pos =obj.dtcursor.Position;
    end
    %-------
    function applique(obj,I)
      ptchnl =obj.fichier.Ptchnl;
      hdchnl =obj.fichier.Hdchnl;
      obj.fichier.Vg.sauve =true;
      ptchnl.Dato(obj.numero,hdchnl.point(obj.canal,obj.essai),1) =I;
      obj.dttip.Draggable ='off';
    end
    %-------
    function fontplus(obj,a,b,c)
      if obj.dttip.FontSize < 36
        obj.dttip.FontSize =obj.dttip.FontSize+1;
      end
    end
    %-------
    function fontmoins(obj,a,b,c)
      if obj.dttip.FontSize > 4
        obj.dttip.FontSize =obj.dttip.FontSize-1;
      end
    end
    %-------
    function marqueurplus(obj,a,b,c)
      if obj.dttip.MarkerSize < 32
        obj.dttip.MarkerSize =obj.dttip.MarkerSize+1;
      end
    end
    %-------
    function marqueurmoins(obj,a,b,c)
      if obj.dttip.MarkerSize > 2
        obj.dttip.MarkerSize =obj.dttip.MarkerSize-1;
      end
    end
    %-------
    function deplace(obj,a,b,c)
      obj.dttip.Draggable ='on';
    end
    %-------
    function efface(obj,a,b,c)
      ptchnl =obj.fichier.Ptchnl;
      hdchnl =obj.fichier.Hdchnl;
      pts =obj.numero;
      if hdchnl.npoints(obj.canal,obj.essai) > 1
        ptchnl.Dato(obj.numero:end-1,hdchnl.point(obj.canal,obj.essai),1) =ptchnl.Dato(obj.numero+1:end,hdchnl.point(obj.canal,obj.essai),1);
        ptchnl.Dato(obj.numero:end-1,hdchnl.point(obj.canal,obj.essai),2) =ptchnl.Dato(obj.numero+1:end,hdchnl.point(obj.canal,obj.essai),2);
      end
      hdchnl.npoints(obj.canal,obj.essai) =hdchnl.npoints(obj.canal,obj.essai)-1;
      obj.efface2();
    end
    %-------
    function bidon(obj,a,b,c)
      ptchnl =obj.fichier.Ptchnl;
      hdchnl =obj.fichier.Hdchnl;
      obj.fichier.Vg.sauve =true;
      ptchnl.Dato(obj.numero,hdchnl.point(obj.canal,obj.essai),2) =-1;
      obj.bidon2();
    end
    %-------
    function Source =Eltexto(obj,a,src,b)
      pos = get(src,'Position');
      Source = {obj.typtxt,['X:' num2str(pos(1),4)],['Y:' num2str(pos(2),4)]};
    end
    %-------
    function Source =EltextoVide(obj,a,src,b)
      Source ={''};
    end
  end %methods
end