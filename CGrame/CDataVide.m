%
% Class CDataVide
%
% Objet utile lorsque l'on a à passer des datas d'une fonction
% à l'autre sans vouloir jouer avec des variables "global".
%
classdef CDataVide < handle
  %---------
  properties
    D;            % variable vide qui pourra être utilisé au besoin
    cur;
  end
end