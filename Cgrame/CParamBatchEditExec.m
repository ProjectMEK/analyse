%
% classdef CParamBatchEditExec < handle
%
% METHODS
%
classdef CParamBatchEditExec < handle

  properties
      % Info sur les fichiers à traiter
      Nfich =0;
      listFich ={'aucun fichier à traiter'};
      % Info sur les actions
      Naction =0;
      listAction =[];
      % handle du fichier virtuel
      fiVirt =[];
      %
      status =0;
      erreur =0;
      Path =pwd;
      ChoixEntree =1;
      ChoixSortie =4;
      isFichierIn =0;
      isFichierOut =0;
      PathEntree =pwd;
      PathSortie =pwd;
      ListeFentree ={'aucun fichier à traiter'};
      ListeFsortie ={'Fichier de sortie à déterminer'};
      prefixe =1;
      prenom =[];
      NbFTraiter =0;
      exten ='.mat';
      tot =0;
      elno =0;
      tacfic =1;
      tach =[];
  end  %properties

end
