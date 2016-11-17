%
% Pos =MONITCUR()
%
% Au retour on aura la position du moniteur où se
% trouve le curseur: [posx posy largeur hauteur]
%
function mPos =monitcur()
  cur =get(0,'pointerlocation');
  M =get(0, 'MonitorPositions');
  nbmon =size(M, 1);
  lapos =M(1,:);
  mPos =lapos;
  for U =1:nbmon
    lapos(:) =[M(U,1) 1 M(U,3) M(U,4)-M(U,2)+1];
    if (cur(1) > lapos(1)) & (cur(1) < (lapos(3))) & ...
       (cur(2) > lapos(2)) & (cur(2) < (lapos(4)))
      mPos =lapos;
      break;
    end
  end
end