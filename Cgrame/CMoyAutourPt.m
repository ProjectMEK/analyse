%
% Classe CMoyAutourPt
%
% On fait la moyenne autour des points marqu�s puis on �cris
% le r�sultat dans un fichier texte.
%
classdef CMoyAutourPt < handle

  %---------
  properties
    % identification des fichiers au format Analyse ou texte
    ofich =[];      % handle du fichier courant
    hdchnl =[];     % handle de l'ent�te des data
    vg =[];         % handle des variables globales
    ptchnl =[];     % handle de l'objet des points marqu�s
    fid =[];        % handle du fichier texte pour la sortie

    % Objet graphique
    fig =[];        % handle du GUI GuiMoyAutourPt.m
    wb =[];         % handle de la waitbar

    % valeur � lire dans le GUI
    can =[];                      % canaux s�lectionn�s
    Ncan =[];                     % nombre de canaux s�lectionn�s
    ess =[];                      % essais s�lectionn�s
    Ness =[];                     % nombre d'essais s�lectionn�s
    saut =[char(13) char(10)];    % retour de chariot
    sep =[];                      % caract�re pour s�parer les champs dans le fichier de sortie texte
    debfentrav =[];               % d�but du range de travail
    finfentrav =[];               % fin du range de travail
    autour =[];                   % si = 0: on fait la moyenne entre "debfentrav et finfentrav"
                                  % si = 1: on fait la moyenne autour des points marqu�s
                                  %         entre [point marqu� - av_ap] et [point marqu� + av_ap]
    av_ap =[];                    % d�termine le range pour la moyenne autour des points
    unit =[];                     % 1 --> �chantillons, 2 --> secondes
  end

  %------
  methods

    %------------
    % CONSTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet cr��.
    %---------------------------
    function tO = CMoyAutourPt()

      % initialisation des propri�t�s
      OA =CAnalyse.getInstance();
      tO.ofich =OA.findcurfich();
      tO.hdchnl =tO.ofich.Hdchnl;
      tO.vg =tO.ofich.Vg;
      tO.ptchnl =tO.ofich.Ptchnl;

      % cr�ation du GUI
      tO.fig =GuiMoyAutourPt(tO);

    end

    %------------
    % DESTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet cr��.
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
    % S�lection de tous les essais.
    % - on change la propri�t� value du listbox
    % - on reset la checkbox (elle a un r�le de bouton)
    %--------------------------------------------------
    function tous(tO, src, varargin)
      % recherche de la listbox
      lb_ess =findobj('Tag','LBchoixEss');
      % lecture des valeurs textes de la listbox
      listess =get(lb_ess, 'String');
      % r�-initialisation de la propri�t� "value" de la listbox
      set(lb_ess, 'Value',[1:length(listess)]);
      % reset la checkbox
      set(src, 'Value',0);
    end

    %---------------------------------------
    % ici on toggle les cases pour les infos
    % sur le nombres d'�chantillon avant ou
    % apr�s le point marqu�.
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
      % On ouvre une waitbar "modal" pour montrer o� on est rendu et en plus on
      % barre l'acc�s au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,hL.wbar1, 'G', 'C');
  
      % choisi le fichier pour l'�criture des moyennes
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
  
      % Lecture des param�tres du GUI
      tO.lireLeGUI();
  
      % ouverture du fichier en �criture
      tO.fid =fopen(fichtxt,'w');
      waitbar(0.1,tO.wb);
  
      % appel de la fonction qui va faire le vrai travail
      tO.faireMoyenne(hL);

      % on ajoute un saut de ligne au fichier
      fprintf(tO.fid, '\n');

      % on ferme tout proprement ce qui a �t� ouvert.
      fclose(tO.fid);
      close(tO.wb);
      tO.wb =[];
      delete(tO.fig);
      tO.fig =[];
      cd(pcourant);
    end

    %---------------------------------------
    % Lecture des param�tres du GUI
    % on retournera "K", une structure avec
    % un champ par �l�ment du GUI
    %---------------------------------------
    function lireLeGUI(tO);
      % lecture du choix des canaux
      tO.can =get(findobj('Tag','LBchoixCan'),'Value')';
      tO.Ncan =length(tO.can);
      % lecture du choix des essais
      tO.ess =get(findobj('Tag','LBchoixEss'),'Value')';
      tO.Ness =length(tO.ess);
      % pr�paration des variables de saut de lignes et s�parateur de champs
      sep =get(findobj('Tag','PMchoixSep'),'Value');
      seplist ={','; ';'; char(9)};
      tO.sep =seplist{sep};
      % D�but et fin de la fen�tre de travail
      tO.debfentrav =get(findobj('Tag','EDfenTravDebut'), 'String');
      tO.finfentrav =get(findobj('Tag','EDfenTravFin'), 'String');
      % checkbox pour travailler autour des points
      tO.autour =get(findobj('Tag','CBchoixAutour'), 'Value');
      if tO.autour
        tO.av_ap =str2num(get(findobj('Tag','EDnombreAvantApres'), 'String'));
        tO.unit =get(findobj('Tag','PMchoixUnit'), 'Value');
        % si on a choisi "�chantillon" alors le nombre pour
        % Avant/Apr�s doit �tre entier.
        if tO.unit == 1
          tO.av_ap =round(tO.av_ap);
        end
      end
    end

    %------------------------------------------------------------------
    % Tous les param�tres sont maintenant connus, on proc�de au travail
    % en fonction des choix fait dans le GUI.
    % En entr�e, hL est le handle d'un objet CGuiMLMoyPenteTrie pour
    % l'affichage multi-lingue.
    %------------------------------------------------------------------
    function faireMoyenne(tO,hL)
      % Pour �crire dans le fichier, on va faire toutes les moyennes, puis,
      % on va proc�der dans un ordre �tabli.

      % Ligne d'ent�te g�n�rale
      fprintf(tO.fid, '%s: %s\n%s\n', hL.fichori,tO.ofich.Info.finame,hL.legcan);

      % on �crit la "l�gende des noms de canaux"
      for U =1:tO.Ncan
        fprintf(tO.fid, '\n  C%i --> %s', tO.can(U), tO.hdchnl.adname{tO.can(U)});
      end

    	% on �crit les bornes dans le fichier
    	fprintf(tO.fid, '\n\n%s, [%s --- %s]\n\n', hL.fentrav,tO.debfentrav,tO.finfentrav);

      % on pr�pare la ligne de titre qui va contenir le num�ro de canal et de point
      letitre =hL.titess;
      % calcul de l'incr�ment pour la waitbar
      incr =0.9/(tO.Ncan*tO.Ness);
      curwb =0.1;

      %
      % Dans les deux cas, on va b�tir une matrice contenant les moyennes calcul�es
      %
      % MOY(i, j, k) = moyenne du [(point i) (canal j) (essais k)]
      %
      % Dans le cas ou on fait une moyenne entre deux points, on aura max(i) = 1
      % On va �crire les r�sultats dans le fichhier de sortie de la m�me mani�re.
      % On a toujours �crit dans les fichiers texte de fa�on �a pouvoir lire et
      % traiter dans "STATISTICA", cad: chaque ligne contient les infos pour un essai.
      % Pour ceux qui utilisent Excel, on peut transposer une ligne en colonne lorsque
      % on fait un copie et coller sp�cial.
      %
      % ex. pour la moyenne entre deux bornes
      % Essai,C1P1,C2P1,...,CNP1   --> C suivi du num�ro du canal, P suivi du num�ro du point
      %     1, xx , xx ,..., xx    --> xx seraient les valeurs de moyenne
      %     2,...
      %
      % ex. pour la moyenne autour des points
      % Essai,C1P1,C1P2,... C1PS,C2P1,C2P2,... C2PS,C3P1,...   --> m�me convention
      %     1, xx , xx ,...  xx , xx , xx ,...
      %     2,...
      %
      if tO.autour
        % on a choisi le moyennage autour des points marqu�s

      	% on �crit les param�tres "delta-T" pour le calcul autour des points
      	fprintf(tO.fid, '%s +/- %g %s %s\n\n', hL.moyfait1,tO.av_ap, hL.tipunit{tO.unit},hL.autpt);

      	% si on a choisi "�chantillons", �a ne varie pas
      	delta =ones(tO.Ncan, tO.Ness)*tO.av_ap;
      	% si on a choisi "secondes", on peut avoir une valeur diff�rente
      	if tO.unit == 2
          delta =delta.*tO.hdchnl.rate(tO.can, tO.ess);
        end

        % nombre de moyenne max � calculer pour tous
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

            % on d�termine les bornes entre lesquelles il faut moyenner
            debut =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(U), tO.ess(V));
            fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
            % v�rification de l'ordre croissant entre debut et fin
            if fin < debut
            	foo =debut;
            	debut =fin;
            	fin =foo;
            end

            % on fait le tour de tous les points
            for P =1:Npt

              % il faut v�rifier que les points existent
              % et sont dans la fen�tre de travail [debut:fin]
              if isempty(debut) || isempty(fin) || P > tO.hdchnl.npoints(tO.can(U), tO.ess(V))
                MOY(P, U, V) =nan;
                continue;
              end
              foo=tO.hdchnl.point(tO.can(U), tO.ess(V));
              % on fait la moyenne sur quels �chantillons?
              Ti =tO.ptchnl.Dato(P, foo, 1) - delta(U,V);
              Tf =tO.ptchnl.Dato(P, foo, 1) + delta(U,V);

              % v�rificatin de ces bornes
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

        Npt =1;                               % nombre de moyenne � calculer par canal/essai
        MOY =zeros(Npt, tO.Ncan, tO.Ness);    % matrice des moyennes
        Dt =CDtchnl();                        % objet de la classe CDtchnl pour manipuler les datas

        for U =1:tO.Ncan

          % ligne de titre
          letitre =sprintf('%s%sC%iP1', letitre, tO.sep, tO.can(U));

          % on lit le canal U
          tO.ofich.getcanal(Dt, tO.can(U));

          for V =1:tO.Ness

            % on d�termine les bornes entre lesquelles il faut moyenner
            debut =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(U), tO.ess(V));
            fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
            % v�rification de l'ordre croissant entre debut et fin
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

        % on fait le m�nage
        delete(Dt);
      end

      % on �crit la ligne de titre des canaux
      fprintf(tO.fid, '%s', letitre);

      % les moyennes �tant calcul�es on �crit les r�sultats
      N =size(MOY,1);   % Nombre de moyenne

      % on passe tous les essais
      for U =1:tO.Ness

        % �criture du num�ro de l'essai
        fprintf(tO.fid, '\n%i', tO.ess(U));

        % on passe tous les canaux
        for V =1:tO.Ncan

          % on passe toutes les moyennes
          for W =1:N
            % �criture de la moyenne
            fprintf(tO.fid, '%s%g', tO.sep, MOY(W, V, U));
          end
        end
      end

    end

    %-------------------------------------------
    % On a cliqu� sur la fermeture de la fen�tre
    %----------------------------
    function fermer(tO, varargin)
      delete(tO.fig);
      tO.fig =[];
    end


  end
end
