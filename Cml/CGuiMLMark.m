%
% Classe CGuiMLMark
%
% G�re les informations du GUI Marquage
%
% MEK
% 2015/06/03
%
classdef CGuiMLMark < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    name ='POUR QUITTER LE MARQUAGE, cliquez sur le X � droite --->';

    %(PP) PANEL PERMAMENT
    ppaid ='?';
    ppaidtip ='Documentation sur le marquage';
    ppcansrc ='Source';
    ppptsmrk ='Pts';
    ppdelptall ='Tous les pts';
    ppdelptalltip ='Choisir tous les points des canaux et essais s�lectionn�s, pour la suppression';
    ppdelenumtip ='no des points � supprimer en ordre croissant, Ex: 1,2,3,6:9,12 = 1 2 3 6 7 8 9 12';
    ppdelpthide ='Cacher';
    ppdelpthidetip ='Supprimera le point voulu sans changer l''ordre des points suivants';
    ppdelbutton ='Suppr';
    ppdelbuttontip ='Supprimera tous les points s�lectionn�s ci-haut.';
    ppesscat ='Marquage par essai(s) ou cat�gorie(s)';
    ppesscattip ='Si non coch�, tous les essais sont s�lectionn�s';
    ppreplace ='Remplacer les points choisis ci-haut';
    ppreplacetip ='En mode Exporter: point source(i)-->point destination(i)';

    % BOUTON GO...START...AU TRAVAIL
    buttonGo ='Au travail';

    %(PO) PANEL DES ONGLETS

    % ONGLET EXPORTATION
    poexpletit ='Exp.';
    poexpletittip ='Exportation d''un canal � l''autre';
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

    % ONGLET MONT�...
    pomonteletit ='Mont�.';
    pomonteletittip ='D�but - fin: Mont�e -Descente';
    pomontenom ='Mont�e-Descente';
    pomontemnt ='Mont�e';
    pomontedbt ='D�but';
    pomontefin ='Fin';
    pomontedsc ='Descente';
    pomontedytxt ='Delta Y';
    pomontedytxttip ='Diff�rence d''Amplitude n�cessaire pour consid�rer une mont�e ou une descente';
    pomontedytip ='Valeur de la variation d''amplitude (ex: 10, 150, etc) ou pourcentage du max-min (ex: 10%, 45%, etc) � partir de laquelle vous consid�rez qu''il y a une mont�e ou une descente. Par d�faut (si laiss� � 0), 50% : (Max - Min) X 50% ';
    pomontedxtxt ='Delta X';
    pomontedxtxttip ='Diff�rence temporelle (sec) n�cessaire pour monter ou descendre de Delta Y';
    pomontedxtip ='largeur en seconde afin d''avoir une variation d''amplitude de DeltaY. Si laiss� � 0: � sec.';
    pomontedttxt ='Delta T';
    pomontedttxttip ='Nb d''�chantillon � consid�rer pour discr�miner les "petits pics" (bruit)';
    pomontedttip ='Nombre d''�chantillon � consid�rer pour d�clarer un d�but ou une fin. Par d�faut = 3 (Si laiss� � z�ro)';
    pomontedef ='D';
    pomontedeftip ='Valeurs par d�faut (ou z�ro) pour ce cadre';

    % ONGLET TEMPOREL
    potmpletit ='Temps.';
    potmpletittip ='Marquage temporel';
    potmpnom ='Marquage temporel';
    potmpvaltxt ='Temps pr�cis ou no du pt: ';
    potmpvaltip ='Premier temps pr�cis � marquer (peut �tre le no d''un point pour le marquage successif, ex: p1)';
    potmpstep ='Intervalle entre les pts subs�quents: ';
    potmpsteptip ='� partir du temps ci-haut, nombre de seconde pour le prochain point';

    % ONGLET AMPLITUDE
    poampletit ='Amplit.';
    poampletittip ='Marquer une amplitude';
    poampnom ='Marquage d''amplitude';
    poampvaltxt ='Amplitude (ou no. de point) � marquer: ';
    poampvaltip =sprintf('Valeur num�rique --> Amplitude\n\np0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p... --> point marqu�');
    poamppcenttxt ='% de l''amplitude du point ci-haut: ';
    poamppcenttip =sprintf('Si vous avez inscrit un point plut�t qu''une amplitude ci-haut,\nvous pouvez vouloir un pourcentage de l''amplitude correspondante');
    poampdectxt ='D�calage temporel +/-: ';
    poampdectip =sprintf('L''amplitude consid�r� sera celle du point demand� ci-haut,\nd�cal� de la valeur temporelle en sec ci-contre.');
    poampdirtxt ='Direction: ';
    poampdir ={'du d�but vers la fin >>>', '<<< de la fin vers le d�but'};
    poampdirtip ='Par o� commencer � marquer le point no 1, de la gauche ou de la droite';

    % ONGLET EMG
    poemgletit ='Emg.';
    poemgletittip ='Marquer les d�buts et fins de l''activit� musculaire dans un signal EMG';
    poemgnom ='Marquage EMG';
    poemgrefdoc ='Ref/Doc';
    poemgaglrhtxt ='Seuil de d�tection (h):';
    poemgaglrhtip =sprintf('Plus la valeur de h est petite, moins on d�tecte d''�v�nement, et\nplus elle est grande, plus on peut g�n�rer de fausse d�tection.');
    poemgaglrltxt ='Largeur de fen�tre en Nb d''�chantillon (L):';
    poemgaglrltip =sprintf('S�lectionner L aussi grand que possible (afin d''obtenir une estimation\nde la variance fiable), mais plus petite que la plus courte p�riode\nstationnaire (p�riode avec une variance constante) � d�tecter.');
    poemgaglrdtxt ='Nombre minimum d''�chantillon (d):';
    poemgaglrdtip =sprintf('Nombre minimum d''�chantillon utilis� pour l''estimation ML.\nS�lectionner d telle que ta+d sera encore situ� � l''int�rieur de\nla p�riode stationnaire indiqu�e par le temps d''alarme actuelle (ta).\nCe param�tre n''est pas tr�s critique. Habituellement, un petit\nnombre d''�chantillons (par exemple, d = 10) sera Ok.');
    poemgvoir ='Voir';
    poemgvoirtip ='Pour tester les param�tres sur le premier canal/essai s�lectionn�';

    % ONGLET BIDON
    pobidletit ='Bidon';
    pobidletittip ='Ajouter un point bidon';
    pobidnom ='Point Bidon';
    pobidpostxt ='Position qu''occupera le point bidon: ';
    pobidposmantip ='Si laiss� vide, la ListBox � droite sera lu';
    pobidposmantxt ='(Ou, avec le clavier): ';

    % ONGLET TEST
    potestletit ='Test';
    potestletittip ='D�tection des changements';
    potestnom ='D�tection Changement';
    potestdoctxt ='Pour explication, allez voir: http://nbviewer.ipython.org/github/demotu/BMC/blob/master/notebooks/DetectCUSUM.ipynb';
    potestseuiltxt ='Seuil, Threshold';
    potestseuiltxttip ='Valeur minimum pour la d�tection d''un changement';
    potestseuiltip ='Valeur � d�passer lors de la somme cumulative';
    potestgplus ='Mont�e (+)';
    potestgmoins ='Descente (-)';
    potestdriftxt ='D�rive, Drift';
    potestdriftxttip ='Pour �viter les faux positifs ou les longues pentes douces';
    potestdriftip ='Valeur de d�rive, peux aussi annuler une partie du bruit du signal';
    potestvoir ='Voir';
    potestvoirtip ='Teste le seuil et la d�rive sur le premier essai s�lectionn� et affiche g+ et g-';

    % TEXTE COMMUN
    pocommunrepet ='Nb de r�p�tition: ';
    pocommunint ='tout l''intervalle';
    pocommuninttip ='r�p�ter le marquage successif sur tout l''intervalle de travail';
    pocommunintertxt ='[ Intervalle de travail ]';
    pocommunintertxttip =sprintf('p0 ou pi --> premier �chantillon\npf --> le dernier\nvaleur num�rique --> temps en sec\np1 p2 p... --> point marqu�');
    pocommuninterdbttip ='Pour commencer au premier �chantillon, laissez � P0 ou Pi';
    pocommuninterfintip ='Si laiss� � Pf, le dernier �chantillon de ce canal sera utilis�';
    pocommuncanexttip ='Mettre une copie des points � marquer ci-haut vers les canaux choisis ci-contre';
    pocommunrempltip ='Copier en rempla�ant le point si n�cessaire';

    % EN COURS DE ROUTE
    po_ou ='ou';
    po_et ='et';
    po_debut ='d�but';
    po_fin ='fin';
    potravchmnm ='Il faut choisir Min et/ou Max';
    potravchmddm ='Il faut faire au moins un choix Mont�e/Descente/D�but/Fin';
    potravchmd ='Il faut faire au moins un choix Mont�e/Descente';
    potravchmontdesc ='Mont�e/Descentes';
    potravcan ='canal';
    potravess ='essai';
    potravnpt ='no.point';
    potravdfinterr ='D�but et/ou fin de l''interval mal d�fini';
    potraverrfnc ='Erreur dans la fonction';
    potravemgrech ='Recherche activit� musc. pour le';
    potravafflon ='L''affichage des courbes et des points peuvent �tre long...';
    potravetmperr ='Expression temporelle non valide';
    potraveincerr ='Expression d''incr�ment non valide';
    potravexpr ='Expression';
    potravnvalid ='non valide';
    potravsderiv ='Les valeurs du seuil et de la d�rive ne peuvent �tre � z�ro en m�me temps';
    potravcusumrech ='Recherche des changements en cours...';
    potravfermer ='Le retour � l''affichage r�gulier peut �tre assez long lorsqu''il y a plusieurs points � afficher';
    potravmaw ='Homme au travail';

    % BAR DE STATUS
    barstatus ='Commencez par choisir le type de marquage, puis remplissez les options n�cessaires';

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
