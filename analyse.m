%
% Outil d'analyse des datas
% Initi� au Laboratoire GRAME
% D�partement de Kin�siologie
%
% Premi�re version utile: Oct 1998
%
% Copyrigth 1998 � 2017
%   Auteur principal: Marcel �tienne Kaszap
%   ont particip� en apportant des id�es, du code et/ou du financement (pour la main d'oeuvre)
%     Normand Teasdale, Laboratoire GRAME, d�pt. Kin�siologie, U. Laval
%     Martin Simoneau, Laboratoire GRAME, d�pt. Kin�siologie, U. Laval
%     Olivier Martin, GIPSA-Lab, Grenoble et enseignant � l'UFR STAPS.
%     Caroline , �tudiante en stage.
%     Thelma Coyle, CNRS, Marseille
%     G�rald Quaire  (d�but 1999, ses contributions sur le selspot ne sont plus utilis�es)
%     Jean-Philippe Pialasse, �tudiant++, Laboratoire GRAME, d�pt. Kin�siologie, U. Laval
%
%   Plusieurs autres dont je n'ai pas les noms ont particip�s � l'�laboration
%   de la documentation, sur un site "wiki".
%
% dtchnl -> tableau des datas (pour un canal)
%           (i,k): les 'i' sont les samples, les 'k' les essais
%
%      vg -> variables de travail "globales"
%  hdchnl -> structure pour les param�tres de chaque canal/essai
%  ptchnl -> structure pour conserver les points marqu�s
%  catego -> structure pour conserver les cat�gories
%  lestri -> structure pour conserver la trace des courbes affich�es
% couleur -> code des couleurs pour l'affichages de plusieurs courbes
%     fic
%      hh
%
%  Pour lancer l'application, le nom du fichier seulement
%      analyse  ou analyse()
%
%-------------------------
function analyse(varargin)
  % On coupe les warning pour �viter trop de "crap information"
  warning('off','all');
  %----------------------------------
  % Adresse du fichier de pr�f�rences
  %----------------------------------
  FF =fullfile(tempdir(), 'grame.mat');

  if nargin == 0                 % On ouvre Analyse
    commande ='ouverture';
  else                           % Analyse est d�j� ouvert
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
      % initialise les valeurs par d�faut global pour l'application
      CValet.valdefaut();
      % cr�ation de l'instance unique de l'application
      hA =CAnalyse.getInstance();
      % comme param�tres, on lui passe le num�ro de version en format num�rique et en texte
      hA.initial(8.0236, '8.02.36');
      % lecture du fichier des pr�f�rences (Cette fonction est incluse dans ce mfile)
      tmp =LeerParam(FF);
      hA.initLesPreferencias(tmp);
      % cr�ation du GUI principal
      hA.OFig =CDessine();
    catch tuhermanita;
      warning('on','all');
      parleMoiDe(tuhermanita);
    end

  %-----------------------------------------------
  % Fonctionne bien, ferme et red�marre Analyse
  %-----------------------------------------------
  case 'arcommence'
  	try
      analyse('terminus');
  	  analyse();
  	catch fuu;
  	  parleMoiDe(fuu);
  	end

  %--------------
  case 'terminus'
    try
      OA =CAnalyse.getInstance();
      while OA.Fic.nf
      	b =OA.fermecur();
      	if ~b
        	return;
      	end
      end
      % avant de quitter, on sauvegarde les pr�f�rences tel que demand�.
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
      pause(0.25);
      clear java;
      clear all;
      warning('on','all');
    catch moo;
      CQueEsEsteError.dispOct(moo);
    end
  end  %case
end

%----------------------------------------
% Sauvegarde des param�tres (pr�f�rences)
% afin de pouvoir r�-ouvrir dans le m�me
% mode qu'� la fermeture.
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
%    cd(OAn.Fic.basedir);
    save(leFich, 'diablo', '-v6');
  else
    fid =fopen(leFich, 'r');
    if fid ~= -1
      fclose(fid);
      delete(leFich);
    end
  end
end

%----------------------------------------------------------
% mai 2013, commence la gestion des pr�f�rences impliquants
% une modification dans les param�tres sauvegard�s pour la
% r�-ouverture.
% Fonction pour lire le fichier des pr�f�rences, S sera le
% path complet du dit fichier.
% C'est un fichier au format Matlab (.mat) qui contient une
% variable, appel� "diablo".
%
%-------------------------
function cur =LeerParam(S)
  cur =[];

  % pour ne pas afficher les warnings inutiles de diff�rences de caract�res
  % nous les d�-sactiverons temporairement.
  warning off;

  try

    % ouverture en lecture du fichier des pr�f�rences
    fid =fopen(S, 'r');

    if fid ~= -1

      % Le fichier s'est ouvert sans erreur, il existe donc
      fclose(fid);
      % on load le ficher au complet
      foo =load(S);
      % on v�rifie que la variable diablo existe
      if isfield(foo, 'diablo')
        cur =foo.diablo;
      end

    end

  catch Me;
    parleMoiDe(Me);
  end

end
