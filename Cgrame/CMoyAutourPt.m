%
% Classe CMoyAutourPt
%
% On fait la moyenne autour des points marqués puis on écris
% le résultat dans un fichier texte.
%
classdef CMoyAutourPt < handle

  %---------
  properties
    % identification des fichiers au format Analyse ou texte
    ofich =[];      % handle du fichier courant
    hdchnl =[];     % handle de l'entête des data
    vg =[];         % handle des variables globales
    ptchnl =[];     % handle de l'objet des points marqués
    fid =[];        % handle du fichier texte pour la sortie

    % Objet graphique
    fig =[];        % handle du GUI GuiMoyAutourPt.m
    wb =[];         % handle de la waitbar

    % valeur à lire dans le GUI
    can =[];                      % canaux sélectionnés
    Ncan =[];                     % nombre de canaux sélectionnés
    ess =[];                      % essais sélectionnés
    Ness =[];                     % nombre d'essais sélectionnés
    saut =[char(13) char(10)];    % retour de chariot
    sep =[];                      % caractère pour séparer les champs dans le fichier de sortie texte
    debfentrav =[];               % début du range de travail
    finfentrav =[];               % fin du range de travail
    autour =[];                   % si = 0: on fait la moyenne entre "debfentrav et finfentrav"
                                  % si = 1: on fait la moyenne autour des points marqués
                                  %         entre [point marqué - av_ap] et [point marqué + av_ap]
    av_ap =[];                    % détermine le range pour la moyenne autour des points
    unit =[];                     % 1 --> échantillons, 2 --> secondes
  end

  %------
  methods

    %------------
    % CONSTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet créé.
    %---------------------------
    function tO = CMoyAutourPt()

      % initialisation des propriétés
      OA =CAnalyse.getInstance();
      tO.ofich =OA.findcurfich();
      tO.hdchnl =tO.ofich.Hdchnl;
      tO.vg =tO.ofich.Vg;
      tO.ptchnl =tO.ofich.Ptchnl;

      % création du GUI
      tO.fig =GuiMoyAutourPt(tO);

    end

    %------------
    % DESTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet créé.
    %---------------------------
    function delete(tO)

      if ~isempty(tO.wb)
      	close(tO.wb);
      end

      if ~isempty(tO.fig)
      	delete(tO.fig);
      end
      
    end


    %--------------------------------------------------
    % Sélection de tous les essais.
    % - on change la propriété value du listbox
    % - on reset la checkbox (elle a un rôle de bouton)
    %--------------------------------------------------
    function tous(tO, src, varargin)
      % recherche de la listbox
      lb_ess =findobj('Tag','LBchoixEss');
      % lecture des valeurs textes de la listbox
      listess =get(lb_ess, 'String');
      % ré-initialisation de la propriété "value" de la listbox
      set(lb_ess, 'Value',[1:length(listess)]);
      % reset la checkbox
      set(src, 'Value',0);
    end

    %---------------------------------------
    % ici on toggle les cases pour les infos
    % sur le nombres d'échantillon avant ou
    % après le point marqué.
    %---------------------------------------
    function moyenneAutour(tO, src, evt)
      % on lit la value du checkbox
      foo =CEOnOff(get(src, 'Value'));
      % on affiche les infos ou on les cache
      set(findobj('Tag','EDnombreAvantApres'), 'Visible',char(foo));
      set(findobj('Tag','PMchoixUnit'), 'Visible',char(foo));
    end

    %--------------------------------------------
    % C'est ici que l'on va faire le travail pour
    % sortir les moyennes voulues.
    %-----------------------------
    function travail(tO, varargin)

      % appel les menus multi-lingues
      hL =CGuiMLMoyPenteTrie();
      % On ouvre une waitbar "modal" pour montrer où on est rendu et en plus on
      % barre l'accès au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,hL.wbar1, 'G', 'C');
  
      % choisi le fichier pour l'écriture des moyennes
      try
        [fichtxt,lieu] =uiputfile('*.*',hL.putfich1);
        pcourant =pwd;
        cd(lieu);
      catch
        disp(hL.errfich);
        close(tO.wb);
        tO.wb =[];
        return;
      end
  
      % Lecture des paramètres du GUI
      tO.lireLeGUI();
  
      % ouverture du fichier en écriture
      tO.fid =fopen(fichtxt,'w');
      waitbar(0.1,tO.wb);
  
      % appel de la fonction qui va faire le vrai travail
      tO.faireMoyenne(hL);

      % on ajoute un saut de ligne au fichier
      fprintf(tO.fid, '\n');

      % on ferme tout proprement ce qui a été ouvert.
      fclose(tO.fid);
      close(tO.wb);
      tO.wb =[];
      delete(tO.fig);
      tO.fig =[];
      cd(pcourant);
    end

    %---------------------------------------
    % Lecture des paramètres du GUI
    % on retournera "K", une structure avec
    % un champ par élément du GUI
    %---------------------------------------
    function lireLeGUI(tO);
      % lecture du choix des canaux
      tO.can =get(findobj('Tag','LBchoixCan'),'Value')';
      tO.Ncan =length(tO.can);
      % lecture du choix des essais
      tO.ess =get(findobj('Tag','LBchoixEss'),'Value')';
      tO.Ness =length(tO.ess);
      % préparation des variables de saut de lignes et séparateur de champs
      sep =get(findobj('Tag','PMchoixSep'),'Value');
      seplist ={','; ';'; char(9)};
      tO.sep =seplist{sep};
      % Début et fin de la fenêtre de travail
      tO.debfentrav =get(findobj('Tag','EDfenTravDebut'), 'String');
      tO.finfentrav =get(findobj('Tag','EDfenTravFin'), 'String');
      % checkbox pour travailler autour des points
      tO.autour =get(findobj('Tag','CBchoixAutour'), 'Value');
      if tO.autour
        tO.av_ap =str2num(get(findobj('Tag','EDnombreAvantApres'), 'String'));
        tO.unit =get(findobj('Tag','PMchoixUnit'), 'Value');
        % si on a choisi "échantillon" alors le nombre pour
        % Avant/Après doit être entier.
        if tO.unit == 1
          tO.av_ap =round(tO.av_ap);
        end
      end
    end

    %------------------------------------------------------------------
    % Tous les paramètres sont maintenant connus, on procède au travail
    % en fonction des choix fait dans le GUI.
    % En entrée, hL est le handle d'un objet CGuiMLMoyPenteTrie pour
    % l'affichage multi-lingue.
    %------------------------------------------------------------------
    function faireMoyenne(tO,hL)
      % Pour écrire dans le fichier, on va faire toutes les moyennes, puis,
      % on va procéder dans un ordre établi.

      % Ligne d'entête générale
      fprintf(tO.fid, '%s: %s\n%s\n', hL.fichori,tO.ofich.Info.finame,hL.legcan);

      % on écrit la "légende des noms de canaux"
      for U =1:tO.Ncan
        fprintf(tO.fid, '\n  C%i --> %s', tO.can(U), tO.hdchnl.adname{tO.can(U)});
      end

    	% on écrit les bornes dans le fichier
    	fprintf(tO.fid, '\n\n%s, [%s --- %s]\n\n', hL.fentrav,tO.debfentrav,tO.finfentrav);

      % on prépare la ligne de titre qui va contenir le numéro de canal et de point
      letitre =hL.titess;
      % calcul de l'incrément pour la waitbar
      incr =0.9/(tO.Ncan*tO.Ness);
      curwb =0.1;

      %
      % Dans les deux cas, on va bâtir une matrice contenant les moyennes calculées
      %
      % MOY(i, j, k) = moyenne du [(point i) (canal j) (essais k)]
      %
      % Dans le cas ou on fait une moyenne entre deux points, on aura max(i) = 1
      % On va écrire les résultats dans le fichhier de sortie de la même manière.
      % On a toujours écrit dans les fichiers texte de façon èa pouvoir lire et
      % traiter dans "STATISTICA", cad: chaque ligne contient les infos pour un essai.
      % Pour ceux qui utilisent Excel, on peut transposer une ligne en colonne lorsque
      % on fait un copie et coller spécial.
      %
      % ex. pour la moyenne entre deux bornes
      % Essai,C1P1,C2P1,...,CNP1   --> C suivi du numéro du canal, P suivi du numéro du point
      %     1, xx , xx ,..., xx    --> xx seraient les valeurs de moyenne
      %     2,...
      %
      % ex. pour la moyenne autour des points
      % Essai,C1P1,C1P2,... C1PS,C2P1,C2P2,... C2PS,C3P1,...   --> même convention
      %     1, xx , xx ,...  xx , xx , xx ,...
      %     2,...
      %
      if tO.autour
        % on a choisi le moyennage autour des points marqués

      	% on écrit les paramètres "delta-T" pour le calcul autour des points
      	fprintf(tO.fid, '%s +/- %g %s %s\n\n', hL.moyfait1,tO.av_ap, hL.tipunit{tO.unit},hL.autpt);

      	% si on a choisi "échantillons", ça ne varie pas
      	delta =ones(tO.Ncan, tO.Ness)*tO.av_ap;
      	% si on a choisi "secondes", on peut avoir une valeur différente
      	if tO.unit == 2
          delta =delta.*tO.hdchnl.rate(tO.can, tO.ess);
        end

        % nombre de moyenne max à calculer pour tous
        Npt =max(max(tO.hdchnl.npoints(tO.can, tO.ess)));
        MOY =zeros(Npt, tO.Ncan, tO.Ness);    % matrice des moyennes
        Dt =CDtchnl();                        % objet de la classe CDtchnl pour manipuler les datas

        for U =1:tO.Ncan

          % ligne de titre
          for K =1:Npt
            letitre =sprintf('%s%sC%iP%i', letitre, tO.sep, tO.can(U), K);
          end

          % on lit le canal U
          tO.ofich.getcanal(Dt, tO.can(U));

          for V =1:tO.Ness

            % on détermine les bornes entre lesquelles il faut moyenner
            debut =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(U), tO.ess(V));
            fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
            % vérification de l'ordre croissant entre debut et fin
            if fin < debut
            	foo =debut;
            	debut =fin;
            	fin =foo;
            end

            % on fait le tour de tous les points
            for P =1:Npt

              % il faut vérifier que les points existent
              % et sont dans la fenêtre de travail [debut:fin]
              if isempty(debut) || isempty(fin) || P > tO.hdchnl.npoints(tO.can(U), tO.ess(V))
                MOY(P, U, V) =nan;
                continue;
              end
              foo=tO.hdchnl.point(tO.can(U), tO.ess(V));
              % on fait la moyenne sur quels échantillons?
              Ti =tO.ptchnl.Dato(P, foo, 1) - delta(U,V);
              Tf =tO.ptchnl.Dato(P, foo, 1) + delta(U,V);

              % vérificatin de ces bornes
              if Ti < debut || Tf > fin
                MOY(P, U, V) =nan;
                continue;
              end

              % on calcule la moyenne entre ces bornes
              MOY(P, U, V) =mean(Dt.Dato.(Dt.Nom)(Ti:Tf, tO.ess(V)));
            end
            % affichage dans la waitbar
            waitbar(curwb,tO.wb);
            curwb =curwb+incr;
          end
        end

      else
      	% on a choisi le moyennage entre deux bornes
        fprintf(tO.fid, '%s\n\n', hL.moyfait2);

        Npt =1;                               % nombre de moyenne à calculer par canal/essai
        MOY =zeros(Npt, tO.Ncan, tO.Ness);    % matrice des moyennes
        Dt =CDtchnl();                        % objet de la classe CDtchnl pour manipuler les datas

        for U =1:tO.Ncan

          % ligne de titre
          letitre =sprintf('%s%sC%iP1', letitre, tO.sep, tO.can(U));

          % on lit le canal U
          tO.ofich.getcanal(Dt, tO.can(U));

          for V =1:tO.Ness

            % on détermine les bornes entre lesquelles il faut moyenner
            debut =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(U), tO.ess(V));
            fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
            % vérification de l'ordre croissant entre debut et fin
            if fin < debut
            	foo =debut;
            	debut =fin;
            	fin =foo;
            end

            % on calcule la moyenne entre ces bornes
            MOY(1, U, V) =mean(Dt.Dato.(Dt.Nom)(debut:fin, tO.ess(V)));
            % affichage dans la waitbar
            waitbar(curwb,tO.wb);
            curwb =curwb+incr;
          end
        end

        % on fait le ménage
        delete(Dt);
      end

      % on écrit la ligne de titre des canaux
      fprintf(tO.fid, '%s', letitre);

      % les moyennes étant calculées on écrit les résultats
      N =size(MOY,1);   % Nombre de moyenne

      % on passe tous les essais
      for U =1:tO.Ness

        % écriture du numéro de l'essai
        fprintf(tO.fid, '\n%i', tO.ess(U));

        % on passe tous les canaux
        for V =1:tO.Ncan

          % on passe toutes les moyennes
          for W =1:N
            % écriture de la moyenne
            fprintf(tO.fid, '%s%g', tO.sep, MOY(W, V, U));
          end
        end
      end

    end

    %-------------------------------------------
    % On a cliqué sur la fermeture de la fenêtre
    %----------------------------
    function fermer(tO, varargin)
      delete(tO.fig);
      tO.fig =[];
    end


  end
end
