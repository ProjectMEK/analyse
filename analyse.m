%
% Outil d'analyse des datas
% Initié au Laboratoire GRAME
% Département de Kinésiologie
%
% MEK - première version utile: Oct 1998
%
% Copyrigth 1998 à 2016
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
function analyse(varargin)
  %----------------------------------
  % Adresse du fichier de préférences
  %----------------------------------
  FF =fullfile(tempdir(), 'grame.mat');
  if nargin == 0
    commande ='ouverture';
    pourQui ='grame';      %*-*-*-***** ONCOMPILE POUR QUI *****
  else
    commande =varargin{1};
  end

  %--------------
  switch commande
  %---------------
  case 'ouverture'
    %
    % CAnalyse.initial(version(num), version(texte), Commentaire)
    %
    try
      CValet.valdefaut();
      hA =CAnalyse.getInstance();
      hA.initial(8.0226, '8.02.26', pourQui);  % 8.0227 n'a pas été compilé
      tmp =LeerParam(FF);
      hA.initLesPreferencias(tmp);
      hA.OFig =CDessine();
    catch tuhermanita
      parleMoiDe(tuhermanita)
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
    if strcmpi(OA.OAntiVol.tag, 'grame')
      sauveLesPref(OA, FF);
    end
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

%
% Sauvegarde des paramètres (préférences)
% afin de pouvoir ré-ouvrir dans le même
% mode qu'à la fermeture.
%
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

%
% mai 2013, commence la gestion des préférences
% impliquant une modification dans les paramètres
% sauvegardés pour la ré-ouverture
%
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
