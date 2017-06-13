%
% Cette fonction va d�finir les path utiles pour travailler avec Analyse puis va
% d�marrer Analyse. Mais avant tout, il faut avoir download� les dossiers
% n�cessaires comme suit, soit que l'ensemble des dossiers est regroupp� dans "src"
%
% src/
% src/startAnalyse.m
%     analyse/
%             Cgrame/
%             Cml/
%             doc/
%             emg/
%             Igrame/
%             install/
%             lang/
%             Outil/
%     communs/
%             CGrame/
%
% Le fichier "startAnalyse.m" se trouve dans "src/analyse/install"
% Faites-en une copie dans le dossier "src"
% pour lancer "startAnalyse", placez-vous dans le dossier "src"
%
function startAnalyse(varargin)

  % Comme on va travailler avec les paths, il faut savoir dans quel OS on travaille
  % le caract�re pour S�parer les Dossiers sera
  SD =filesep();

  % On va r�cup�rer le path complet du fichier "setAnalyse.m"
  moi =which('startAnalyse');

  % On va en extirper le path
  [bpath, fnom] =fileparts(moi);

  % Au cas ou 'startAnalyse' serait encore dans "src/analyse/install"
  txtpath =[SD 'analyse' SD 'install'];
  ltxt =length(txtpath);
  if strcmp(bpath(end-ltxt+1:end), txtpath)
    bpath(end-ltxt+1:end) =[];
  end

  % fabrication du path � ajouter
  bpath_an =[bpath SD 'analyse;'];
  bpath_anCg =[bpath SD 'analyse' SD 'Cgrame;'];
  bpath_anCml =[bpath SD 'analyse' SD 'Cml;'];
  bpath_anEmg =[bpath SD 'analyse' SD 'emg;'];
  bpath_anIg =[bpath SD 'analyse' SD 'Igrame;'];
  bpath_anOu =[bpath SD 'analyse' SD 'Outil;'];
  bpath_com =[bpath SD 'communs;'];
  bpath_comCG =[bpath SD 'communs' SD 'CGrame;'];
  An_path =[bpath_an bpath_anCg bpath_anIg bpath_anCml bpath_anEmg bpath_anOu bpath_com bpath_comCG];

  % Maintenant il faut savoir si on est en Matlab ou en Octave
  % les deux environnements utilisent la fonction ver()
  matlab =isempty(ver('Octave'));

  %-------------------------------------------------------------------
  % Pour ceux qui ne veulent pas faire un reset des Paths d�j� �tablis
  % conserver uniquement les lignes "addpath..." ci-bas
  %-------------------------------------------------------------------

  if matlab  % on travaille avec Matlab

    % le path par d�faut sera r�-install� par restoredefaultpath()
    restoredefaultpath();
    % maintenant on va ajouter les path pour Analyse
    addpath(An_path);

  else % on travaille avec Octave

    % La commande pathdef(), nous renvoie la liste des paths pour Octave
    pdef =pathdef();
    % on va resetter le path � partir des valeurs obtenues
    path(pdef);
    % maintenant on va ajouter les path pour Analyse
    addpath(An_path);
    % on va changer la valeur par d�faut pour la sauvegarde des fichiers
    save_default_options ('-v7');

  end

  % On peut maintenant d�marrer Analyse
  mots =sprintf('Les paths sont d�finis.\nLancement d''Analyse...');
  disp(mots);

  analyse();

end
