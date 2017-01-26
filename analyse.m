%
% Outil d'analyse des datas
% Initi� au Laboratoire GRAME
% D�partement de Kin�siologie
%
% Premi�re version utile: Oct 1998
%
% Copyrigth 1998 � 2017
%   Auteur principal: Marcel �tienne Kaszap
%   ont particip� en apportant des id�es ou du code
%     Normand Teasdale
%     Martin Simoneau
%     Olivier Martin
%     Caroline 
%     Thelma 
%     G�rald Quaire  (d�but 1999, ses contributions sur le selspot ne sont plus utilis�es)
%     Jean-Philippe Pialasse
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
  %----------------------------------
  % Adresse du fichier de pr�f�rences
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
      % initialise les valeurs par d�faut global pour l'application
      CValet.valdefaut();
      % cr�ation de l'instance unique de l'application
      hA =CAnalyse.getInstance();
      % comme param�tres, on lui passe le num�ro de version en format num�rique et en texte
      hA.initial(8.0229, '8.02.29');
      % lecture du fichier des pr�f�rences
      tmp =LeerParam(FF);

        disp('rendu ici...')

      hA.initLesPreferencias(tmp);
      % cr�ation du GUI principal
      hA.OFig =CDessine();
    catch tuhermanita
      parleMoiDe(tuhermanita);
    end

  %-----------------------------------------------
  % Fonctionne bien, ferme et red�marre Analyse
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
% mai 2013, commence la gestion des pr�f�rences impliquants
% une modification dans les param�tres sauvegard�s pour la
% r�-ouverture.
% Fonction pour lire le fichier des pr�f�rences, S sera le
% path complet du dit fichier.
%-------------------------
function cur =LeerParam(S)
  cur =[];
  try
    fid =fopen(S, 'r');
    if fid ~= -1
      fclose(fid);
      foo =load(S);
      if isfield(foo, 'diablo')
        cur =foo.diablo;
      end
    end
  catch Me
    parleMoiDe(Me);
  end
end
