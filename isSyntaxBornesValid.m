%
% isSyntaxBornesValid(t)
%
%     param: t    string représentant des points ou valeurs temporelles
%
%     on va avoir besoin de la fonction isSyntaxBorneValid(t)
%
function resultat =isSyntaxBornesValid(t)
  resultat =false;
  pat ='\s+';
  iss =regexp(t, pat, 'split');
  nbParam =length(iss);
  for u =1:nbParam
    resultat =isSyntaxBorneValid(iss{u});
    if ~resultat
      disp(['Mauvais paramètre: ' iss{u}]);
      break;
    end
  end
end
