% Function num2texte(X, N)
%          num2texte(X)
%
% transformation de la variable numérique "X" au format texte
% sur N caractères où on comble avec des zéros par la gauche.
%
% Si N est omis, N =3
%
% Ex:  num2texte(5,2)  --> 05
%      num2texte(5)    --> 005
%______________________________
%
function texte =num2texte(X, N)
  if (nargin < 2) | ~isnumeric(N) | isempty(N) | (N < 1)
    N =3;
  end
  t =['%0' num2str(N) 'd'];
  texte =sprintf(t,X);
end
