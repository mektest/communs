% Laboratoire GRAME
% MEK - juin 2011
%
% Classe CDatoImport
% pour faire les importation d'un fichier Analyse à un autre
%
classdef CDatoImport < handle
  properties
    debcan;           % donne la concordance du premier canal importé
    fincan;           % donne ...           ... dernier ...
    modcan;           % Nb de canaux ajouté, sinon < 0
    debess;           % donne la concordance du premier essai importé
    finess;           % donne ...           ... dernier ...
    modess;           % Nb d'essai ajouté, sinon < 0
    f0nad;            % donne le nombre de canal du fichier actif avant modif
    f1nad;            % donne ...                       ... importé ...
    f0ess;            % donne le nombre d'essai du fichier actif avant modif
    f1ess;            % donne ...                      ... importé ...
  end
end
