%
% On fait la moyenne autour des points marqués puis on écris
% le résultat dans un fichier texte
%
classdef CMoyAutourPt < handle

  %---------
  properties
    % identification du fichier au format Analyse courant
    ofich =[];      % handle du fichier courant
    hdchnl =[];     % handle de l'entête des data
    vg =[];         % handle des variables globales
    ptchnl =[];     % handle de l'objet des points marqués

    fig =[];        % handle du GUI GuiMoyAutourPt.m
    wb =[];         % handle de la waitbar

    % identification du fichier texte pour les résultats
    fid =[];        % handle du fichier texte pour la sortie

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

      % On ouvre une waitbar "modal" pour montrer où on est rendu et en plus on
      % barre l'accès au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,'Moyennage en cours', 'G', 'C');
  
      % choisi le fichier pour l'écriture des moyennes
      try
        [fichtxt,lieu] =uiputfile('*.*','Résultat des Moyennes');
        pcourant =pwd;
        cd(lieu);
      catch
        disp('Erreur dans le fichier de sortie.');
        close(tO.wb);
        tO.wb =[];
        return;
      end
  
      % Lecture des paramètres du GUI
      tO.lireLeGUI();
  
      % ouverture du fichier en écriture
      tO.fid =fopen(fichtxt,'w');
  
      % appel de la fonction qui va faire le vrai travail
      tO.faireMoyenne();

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
    %------------------------------------------------------------------
    function faireMoyenne(tO)
      % Pour écrire dans le fichier, on va faire toutes les moyennes, puis,
      % on va procéder dans un ordre établi.

      % Ligne d'entête générale
      fprintf(tO.fid, 'Fichier d''origine: %s\nLégende des canaux\n', tO.ofich.Info.finame);

      % on écrit la "légende des noms de canaux"
      for U =1:tO.Ncan
        fprintf(tO.fid, '  C%i --> %s\n', U, tO.hdchnl.adname{U});
      end

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
      else
      	% on a choisi le moyennage entre deux bornes
      	% on écrit les bornes dans le fichier
      	fprintf(tO.fid, '\nMoyenne entre %s et %s\n\n', tO.debfentrav, tO.finfentrav);

        Npt =1;                               % nombre de moyenne à calculer par canal/essai
        MOY =zeros(Npt, tO.Ncan, tO.Ness);    % matrice des moyennes
        Dt =CDtchnl();                        % objet de la classe CDtchnl pour manipuler les datas

        for U =1:tO.Ncan

          % on lit le canal U
          tO.ofich.getcan(Dt, tO.can(U));

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
            MOY(1, tO.can(U), tO.ess(V)) =mean(Dt.Dato.(Dt.Nom)(debut:fin, tO.ess(V)));
          end
        end

        % on fait le ménage
        delete(Dt);
      end

  
      % Ligne de titre des canaux
      valcan ='No Échantillon';
      frequence ='Fréquence';
      for m =1:nombre
        Dt{m} =CDtchnl();
        tO.ofich.getcaness(Dt{m}, essai, canaux(m));
        valcan =[valcan tab deblank(hdchnl.adname{canaux(m)})];
        frequence =[frequence tab num2str(hdchnl.rate(canaux(m),essai(1))) ' Hz'];
      end
      valcan =[valcan saut];
      frequence =[frequence saut];
      nbdonmax =max(hdchnl.nsmpls(canaux,1));
      for ij =1:nombress
        % Ligne de titre par essai à exporter
        contenu =[saut 'NO ESSAI: ' num2str(essai(ij)) ' (Stimulus: ' vg.nomstim{hdchnl.numstim(essai(ij))} ')' saut];
        fprintf(tO.fid, '%s', contenu);
        fprintf(tO.fid, '%s', frequence);
        fprintf(tO.fid, '%s', valcan);
        for i =1:nbdonmax/pas
          ptrs =((i-1)*pas) + 1;
          contenu =num2str(ptrs);
          for can =1:nombre
            curDt =Dt{can};
            % au cas ou on a différentes fréquences d'échantillonage
            if ptrs > hdchnl.nsmpls(canaux(can),essai(ij))
              contenu =[contenu, tab];
            else
              contenu =[contenu, tab, num2str(curDt.Dato.(curDt.Nom)(ptrs, ij))];
            end
          end
          contenu =[contenu saut];
          fprintf(tO.fid, '%s', contenu);
          waitbar(i/(nbdonmax/pas));   
        end
      end
      for m =1:nombre
        delete(Dt{m});
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
