
% g
% Ici on check si lapos peut fitter dans le moniteur
% en fonction d'un point de référence donné par le coin
% bas-gauche de la fenref
%
function V =CaFitTi(fenref, lapos)
  V =lapos;
  Laref =max(1, fenref(1));
  monpos =get(0,'MonitorPositions');
  % on recherche dans quel moniteur on affiche
  for U =1:size(monpos, 1)
    if (Laref >= monpos(U, 1)) & (Laref <= monpos(U, 3))
      V(1) =min(max(monpos(U, 1), V(1)), monpos(U, 3)-V(3));
      V(2) =min(max(1, V(2)), monpos(U, 4)-monpos(U, 2)+1-V(4)-25);
    end
  end
end
