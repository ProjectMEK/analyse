%
% Outil d'analyse des datas
% Initié au Laboratoire GRAME
% Département de Kinésiologie
%
% Première version utile: Oct 1998
%
% Copyrigth 1998 à 2017
%   Auteur principal: Marcel Étienne Kaszap
%   ont participé en apportant des idées ou du code
%     Normand Teasdale
%     Martin Simoneau
%     Olivier Martin
%     Caroline 
%     Thelma 
%     Gérald Quaire  (début 1999, ses contributions sur le selspot ne sont plus utilisées)
%     Jean-Philippe Pialasse
%
% dtchnl -> tableau des datas (pour un canal)
%           (i,k): les 'i' sont les samples, les 'k' les essais
%
%      vg -> variables de travail "globales"
%  hdchnl -> structure pour les paramètres de chaque canal/essai
%  ptchnl -> structure pour conserver les points marqués
%  catego -> structure pour conserver les catégories
%  lestri -> structure pour conserver la trace des courbes affichées
% couleur -> code des couleurs pour l'affichages de plusieurs courbes
%     fic
%      hh
%
%  Pour lancer l'application, le nom du fichier seulement
%      analyse  ou analyse()
%
%-------------------------
function analyse(varargin)
  % On coupe les warning pour éviter trop de "crap information"
  warning('off','all');
  %----------------------------------
  % Adresse du fichier de préférences
  %----------------------------------
  FF =fullfile(tempdir(), 'grame.mat');

  if nargin == 0
    commande ='ouverture';
  else
    commande =varargin{1};
  end

  %--------------
  switch commande
  %---------------
  case 'ouverture'
    %
    % CAnalyse.initial(version(num), version(texte))
    %
    try
      % initialise les valeurs par défaut global pour l'application
      CValet.valdefaut();
      % création de l'instance unique de l'application
      hA =CAnalyse.getInstance();
      % comme paramètres, on lui passe le numéro de version en format numérique et en texte
      hA.initial(8.0229, '8.02.29');
      % lecture du fichier des préférences (Cette fonction est dans ce mfile)
      tmp =LeerParam(FF);
      hA.initLesPreferencias(tmp);
      % création du GUI principal
      hA.OFig =CDessine();
    catch tuhermanita
      warning('on','all');
      parleMoiDe(tuhermanita);
    end

  %-----------------------------------------------
  % Fonctionne bien, ferme et redémarre Analyse
  %-----------------------------------------------
  case 'arcommence'
  	analyse('terminus');
  	analyse();

  %--------------
  case 'terminus'
    OA =CAnalyse.getInstance();
    while OA.Fic.nf
    	b =OA.fermecur();
    	if ~b
      	return;
    	end
    end
    sauveLesPref(OA, FF);
    wmfig =findobj('type','figure','tag','WmFig');
    if ~ isempty(wmfig)
      delete(wmfig);
    end
    wmfig =findobj('tag','IpChoiXY');
    if ~ isempty(wmfig)
      delete(wmfig);
    end
    delete(OA);
    clear java;
    clear all;
    warning('on','all');
  end  %case
end

%----------------------------------------
% Sauvegarde des paramètres (préférences)
% afin de pouvoir ré-ouvrir dans le même
% mode qu'à la fermeture.
%---------------------------------
function sauveLesPref(OAn, leFich)
  if OAn.Fic.pref.conserver
    diablo.lepath =pwd;
    diablo.recent =OAn.Fic.recent;
    diablo.pref =OAn.Fic.pref.getData();
    set(OAn.OFig.fig,'units','pixels');
    la_pos =get(OAn.OFig.fig,'position');
    diablo.param =OAn.Vg.affiche;
    diablo.param(2:5,1) =la_pos';
    cd(OAn.Fic.basedir);
    save(leFich, 'diablo', '-v7');
  else
    fid =fopen(leFich, 'r');
    if fid ~= -1
      fclose(fid);
      delete(leFich);
    end
  end
end

%----------------------------------------------------------
% mai 2013, commence la gestion des préférences impliquants
% une modification dans les paramètres sauvegardés pour la
% ré-ouverture.
% Fonction pour lire le fichier des préférences, S sera le
% path complet du dit fichier.
% C'est un fichier au format Matlab (.mat) qui contient une
% variable, appelé "diablo".
%
%-------------------------
function cur =LeerParam(S)
  cur =[];

  % pour ne pas afficher les warnings inutiles de différences de caractères
  % nous les dé-sactiverons temporairement.
  warning off;

  try

    % ouverture en lecture du fichier des préférences
    fid =fopen(S, 'r');

    if fid ~= -1

      % Le fichier s'est ouvert sans erreur, il existe donc
      fclose(fid);
      % on load le ficher au complet
      foo =load(S);
      % on vérifie que la variable diablo existe
      if isfield(foo, 'diablo')
        cur =foo.diablo;
      end

    end

  catch Me
    parleMoiDe(Me);
  end

end
