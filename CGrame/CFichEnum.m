%
% Cette énumération contient les type de fichier qu'Analyse pourra ouvrir/convertir.
%
% Le nom doit rester exactement comme il est écrit ici car nous utilisons ce nom pour
% former le nom de la fonction qui sera appelé pour lire le fichier voulu.
%
% ex: pour un fichier texte, la classe s'appelle:  CLireTexte
%                     emg                       :  CLireEMG
%

classdef CFichEnum < uint16
  enumeration
    analyse   (1)
    Texte     (2)
    A21XML    (3)
    HDF5      (4)
    %c3d       (5)
    EMG       (6)
    Keithley  (7)
  end
end
