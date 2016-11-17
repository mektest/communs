%
% isSyntaxBorneValid(t)
%
%     param: t    string représentant un point ou une valeur temporelle ou une expression
%
%     les valeurs de "t" possibles sont
%     0123456789+-*/() Pi Pf P1 P2...
%
%     On pourra avoir des expressions comme: P3+2  -> 2 sec après le point 3
%
function resultat =isSyntaxBorneValid(t)
  resultat =false;
  %  ON ENLÈVE TOUS LES BLANK
  pat ='\s+';
  tt =regexprep(t, pat, '');
  if ~isempty(tt)
    % ON VÉRIFIE LES SÉQUENCES ++ -- +- -+
    pat1 ='[\+/\*-][\+/\*-]';
    pat2 ='[^pif0123456789()\.\*/\+-]+';
    pat3 ='[\+/\*-]$';
    pat4 ='^[/\*]';
    if ~isempty(regexp(tt, pat1)) || ~isempty(regexpi(tt, pat2)) || ~isempty(regexp(tt, pat3)) || ~isempty(regexp(tt, pat4))
      return;
    end
    resultat =true;
  end
end
