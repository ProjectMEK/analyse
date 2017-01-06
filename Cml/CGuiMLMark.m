%
% Classe CGuiMLMark
%
% Gère les informations du GUI Marquage
%
% MEK
% 2015/06/03
%
classdef CGuiMLMark < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='POUR QUITTER LE MARQUAGE, cliquez sur le X à droite --->';

    %(PP) PANEL PERMAMENT
    ppaid ='?';
    ppaidtip ='Documentation sur le marquage';
    ppcansrc ='Source';
    ppptsmrk ='Pts';
    ppdelptall ='Tous les pts';
    ppdelptalltip ='Choisir tous les points des canaux et essais sélectionnés, pour la suppression';
    ppdelenumtip ='no des points à supprimer en ordre croissant, Ex: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12';
    ppdelpthide ='Cacher';
    ppdelpthidetip ='Supprimera le point voulu sans changer l''ordre des points suivants';
    ppdelbutton ='Suppr';
    ppdelbuttontip ='Supprimera tous les points sélectionnés ci-haut.';
    ppesscat ='Marquage par essai(s) ou catégorie(s)';
    ppesscattip ='Si non coché, tous les essais sont sélectionnés';
    ppreplace ='Remplacer les points choisis ci-haut';
    ppreplacetip ='En mode Exporter: point source(i)-->point destination(i)';

    % BOUTON GO...START...AU TRAVAIL
    buttonGo ='Au travail';

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    poexpletit ='Exp.';
    poexpletittip ='Exportation d''un canal à l''autre';
    poexpnom ='Exportation';
    poexpcorr ='Correspondance canal source(i)-->canal destination(i)';
    poexpcorrtip ='On doit avoir: Nb de canaux sources = Nb de canaux destinations';
    poexpcandst ='Destination';

    % ONGLET MINMAX
    pominletit ='Min.';
    pominletittip ='Min Max';
    pominnom ='Min.Max.';
    pominmin ='Minimum';
    pominmax ='Maximum';

    % ONGLET MONTÉ...
    pomonteletit ='Monté.';
    pomonteletittip ='Début - fin: Montée -Descente';
    pomontenom ='Montée-Descente';
    pomontemnt ='Montée';
    pomontedbt ='Début';
    pomontefin ='Fin';
    pomontedsc ='Descente';
    pomontedytxt ='Delta Y';
    pomontedytxttip ='Différence d''Amplitude nécessaire pour considérer une montée ou une descente';
    pomontedytip ='Valeur de la variation d''amplitude (ex: 10, 150, etc) ou pourcentage du max-min (ex: 10%, 45%, etc) à partir de laquelle vous considérez qu''il y a une montée ou une descente. Par défaut (si laissé à 0), 50% : (Max - Min) X 50% ';
    pomontedxtxt ='Delta X';
    pomontedxtxttip ='Différence temporelle (sec) nécessaire pour monter ou descendre de Delta Y';
    pomontedxtip ='largeur en seconde afin d''avoir une variation d''amplitude de DeltaY. Si laissé à 0: ¼ sec.';
    pomontedttxt ='Delta T';
    pomontedttxttip ='Nb d''échantillon à considérer pour discréminer les "petits pics" (bruit)';
    pomontedttip ='Nombre d''échantillon à considérer pour déclarer un début ou une fin. Par défaut = 3 (Si laissé à zéro)';
    pomontedef ='D';
    pomontedeftip ='Valeurs par défaut (ou zéro) pour ce cadre';

    % ONGLET TEMPOREL
    potmpletit ='Temps.';
    potmpletittip ='Marquage temporel';
    potmpnom ='Marquage temporel';
    potmpvaltxt ='Temps précis ou no du pt: ';
    potmpvaltip ='Premier temps précis à marquer (peut être le no d''un point pour le marquage successif, ex: p1)';
    potmpstep ='Intervalle entre les pts subséquents: ';
    potmpsteptip ='À partir du temps ci-haut, nombre de seconde pour le prochain point';

    % ONGLET AMPLITUDE
    poampletit ='Amplit.';
    poampletittip ='Marquer une amplitude';
    poampnom ='Marquage d''amplitude';
    poampvaltxt ='Amplitude (ou no. de point) à marquer: ';
    poampvaltip =sprintf('Valeur numérique --> Amplitude\n\np0 ou pi --> premier échantillon\npf --> dernier échantillon\np1 p2 p... --> point marqué');
    poamppcenttxt ='% de l''amplitude du point ci-haut: ';
    poamppcenttip =sprintf('Si vous avez inscrit un point plutôt qu''une amplitude ci-haut,\nvous pouvez vouloir un pourcentage de l''amplitude correspondante');
    poampdectxt ='Décalage temporel +/-: ';
    poampdectip =sprintf('L''amplitude considéré sera celle du point demandé ci-haut,\ndécalé de la valeur temporelle en sec ci-contre.');
    poampdirtxt ='Direction: ';
    poampdir ={'du début vers la fin >>>', '<<< de la fin vers le début'};
    poampdirtip ='Par où commencer à marquer le point no 1, de la gauche ou de la droite';

    % ONGLET EMG
    poemgletit ='Emg.';
    poemgletittip ='Marquer les débuts et fins de l''activité musculaire dans un signal EMG';
    poemgnom ='Marquage EMG';
    poemgrefdoc ='Ref/Doc';
    poemgaglrhtxt ='Seuil de détection (h):';
    poemgaglrhtip =sprintf('Plus la valeur de h est petite, moins on détecte d''évènement, et\nplus elle est grande, plus on peut générer de fausse détection.');
    poemgaglrltxt ='Largeur de fenêtre en Nb d''échantillon (L):';
    poemgaglrltip =sprintf('Sélectionner L aussi grand que possible (afin d''obtenir une estimation\nde la variance fiable), mais plus petite que la plus courte période\nstationnaire (période avec une variance constante) à détecter.');
    poemgaglrdtxt ='Nombre minimum d''échantillon (d):';
    poemgaglrdtip =sprintf('Nombre minimum d''échantillon utilisé pour l''estimation ML.\nSélectionner d telle que ta+d sera encore situé à l''intérieur de\nla période stationnaire indiquée par le temps d''alarme actuelle (ta).\nCe paramètre n''est pas très critique. Habituellement, un petit\nnombre d''échantillons (par exemple, d = 10) sera Ok.');
    poemgvoir ='Voir';
    poemgvoirtip ='Pour tester les paramètres sur le premier canal/essai sélectionné';

    % ONGLET BIDON
    pobidletit ='Bidon';
    pobidletittip ='Ajouter un point bidon';
    pobidnom ='Point Bidon';
    pobidpostxt ='Position qu''occupera le point bidon: ';
    pobidposmantip ='Si laissé vide, la ListBox à droite sera lu';
    pobidposmantxt ='(Ou, avec le clavier): ';

    % ONGLET TEST
    potestletit ='Test';
    potestletittip ='Détection des changements';
    potestnom ='Détection Changement';
    potestdoctxt ='Pour explication, allez voir: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    potestseuiltxt ='Seuil, Threshold';
    potestseuiltxttip ='Valeur minimum pour la détection d''un changement';
    potestseuiltip ='Valeur à dépasser lors de la somme cumulative';
    potestgplus ='Montée (+)';
    potestgmoins ='Descente (-)';
    potestdriftxt ='Dérive, Drift';
    potestdriftxttip ='Pour éviter les faux positifs ou les longues pentes douces';
    potestdriftip ='Valeur de dérive, peux aussi annuler une partie du bruit du signal';
    potestvoir ='Voir';
    potestvoirtip ='Teste le seuil et la dérive sur le premier essai sélectionné et affiche g+ et g-';

    % TEXTE COMMUN
    pocommunrepet ='Nb de répétition: ';
    pocommunint ='tout l''intervalle';
    pocommuninttip ='répéter le marquage successif sur tout l''intervalle de travail';
    pocommunintertxt ='[ Intervalle de travail ]';
    pocommunintertxttip =sprintf('p0 ou pi --> premier échantillon\npf --> le dernier\nvaleur numérique --> temps en sec\np1 p2 p... --> point marqué');
    pocommuninterdbttip ='Pour commencer au premier échantillon, laissez à P0 ou Pi';
    pocommuninterfintip ='Si laissé à Pf, le dernier échantillon de ce canal sera utilisé';
    pocommuncanexttip ='Mettre une copie des points à marquer ci-haut vers les canaux choisis ci-contre';
    pocommunrempltip ='Copier en remplaçant le point si nécessaire';

    % EN COURS DE ROUTE
    po_ou ='ou';
    po_et ='et';
    po_debut ='début';
    po_fin ='fin';
    potravchmnm ='Il faut choisir Min et/ou Max';
    potravchmddm ='Il faut faire au moins un choix Montée/Descente/Début/Fin';
    potravchmd ='Il faut faire au moins un choix Montée/Descente';
    potravchmontdesc ='Montée/Descentes';
    potravcan ='canal';
    potravess ='essai';
    potravnpt ='no.point';
    potravdfinterr ='Début et/ou fin de l''interval mal défini';
    potraverrfnc ='Erreur dans la fonction';
    potravemgrech ='Recherche activité musc. pour le';
    potravafflon ='L''affichage des courbes et des points peuvent être long...';
    potravetmperr ='Expression temporelle non valide';
    potraveincerr ='Expression d''incrément non valide';
    potravexpr ='Expression';
    potravnvalid ='non valide';
    potravsderiv ='Les valeurs du seuil et de la dérive ne peuvent être à zéro en même temps';
    potravcusumrech ='Recherche des changements en cours...';
    potravfermer ='Le retour à l''affichage régulier peut être assez long lorsqu''il y a plusieurs points à afficher';
    potravmaw ='Homme au travail';

    % BAR DE STATUS
    barstatus ='Commencez par choisir le type de marquage, puis remplissez les options nécessaires';

  end  %properties

  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %___________________________________________________________________________
    % CONSTRUCTOR
    %---------------------------------------------------------------------------

    function tO =CGuiMLMark()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('guimark');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
