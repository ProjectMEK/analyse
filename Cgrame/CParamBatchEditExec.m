%
% classdef CParamBatchEditExec < handle
%
% METHODS
%
classdef CParamBatchEditExec < handle

  properties
      status =0;
      erreur =0;
      Path =pwd;
      ChoixEntree =1;
      ChoixSortie =4;
      isFichierIn =0;
      isFichierOut =0;
      PathEntree =pwd;
      PathSortie =pwd;
      ListeFentree ={'aucun fichier � traiter'};
      ListeFsortie ={'Fichier de sortie � d�terminer'};
      prefixe =1;
      prenom =[];
      NbFTraiter =0;
      exten ='.mat';
      tot =0;
      elno =0;
      tacfic =1;
      tach(1).Descr ={'****Nouvelle t�che****'};
  end  %properties

end
