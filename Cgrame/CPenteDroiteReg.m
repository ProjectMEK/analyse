%
% Classe CPenteDroiteReg
%
% On trouve la droite de r�gression � partir des �chantillons d�termin�s puis on �crit
% le r�sultat dans un fichier texte.
%
classdef CPenteDroiteReg < handle

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
    pairage =1;                   % si = 1 --> [1er pt avec 2i�me] [3i�me avec 4i�me] ...
                                  % si = 2 --> [1er pt avec 2i�me] [2i�me avec 3i�me] ...
                                  % si = 3 --> Calculer une seule pente � partir de la fen�tre de travail
    av_ap =[];                    % d�termine de quelle portion on r�duit le range
    unit =[];                     % 1 --> �chantillons, 2 --> secondes
  end

  %------
  methods

    %------------
    % CONSTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet cr��.
    %---------------------------
    function tO = CPenteDroiteReg()

      % initialisation des propri�t�s
      OA =CAnalyse.getInstance();
      tO.ofich =OA.findcurfich();
      tO.hdchnl =tO.ofich.Hdchnl;
      tO.vg =tO.ofich.Vg;
      tO.ptchnl =tO.ofich.Ptchnl;

      % cr�ation du GUI
      tO.fig =GuiPenteDroiteReg(tO);

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

    %--------------------------------------------
    % C'est ici que l'on va faire le travail pour
    % sortir les pentes voulues.
    %-----------------------------
    function travail(tO, varargin)

      % appel les menus multi-lingues
      hL =CGuiMLMoyPenteTrie();
      % On ouvre une waitbar "modal" pour montrer o� on est rendu et en plus on
      % barre l'acc�s au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,hL.wbar2, 'G', 'C');
  
      % choisi le fichier pour l'�criture des pentes
      try
        [fichtxt,lieu] =uiputfile('*.*',hL.putfich2);
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
      tO.calculerPente(hL);

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

    %------------------------------
    % Lecture des param�tres du GUI
    %------------------------------
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
      % popupmenu pour d�terminer le type de pairage des points
      tO.pairage =get(findobj('Tag','PMpairagePoints'), 'Value');
      tO.av_ap =str2num(get(findobj('Tag','EDnombreAvantApres'), 'String'));
      tO.unit =get(findobj('Tag','PMchoixUnit'), 'Value');
      % si on a choisi "�chantillon" alors le nombre pour
      % Avant/Apr�s doit �tre entier.
      if tO.unit == 1
        tO.av_ap =round(tO.av_ap);
      end
    end

    %------------------------------------------------------------------
    % Tous les param�tres sont maintenant connus, on proc�de au travail
    % en fonction des choix fait dans le GUI.
    % En entr�e, hL est le handle d'un objet CGuiMLMoyPenteTrie pour
    % l'affichage multi-lingue.
    %------------------------------------------------------------------
    function calculerPente(tO,hL)
      % Pour �crire dans le fichier, on va faire tous les calculs de pente,
      %  puis, on va proc�der dans un ordre �tabli.

      % Ligne d'ent�te g�n�rale
      fprintf(tO.fid, '%s: %s\n%s\n', hL.fichori,tO.ofich.Info.finame,hL.legcan);
      % on �crit la "l�gende des noms de canaux"
      for U =1:tO.Ncan
        fprintf(tO.fid, '  C%i --> %s\n', tO.can(U), tO.hdchnl.adname{tO.can(U)});
      end
    	% on �crit les bornes dans le fichier
    	lesU =hL.tipunit;
    	fprintf(tO.fid, '\n%s: [ %s --- %s ]\n%s: %0.2f %s\n\n', ...
    	        hL.fentrav,tO.debfentrav,tO.finfentrav,hL.vnegli,tO.av_ap, lesU{tO.unit});
      % on pr�pare la ligne de titre qui va contenir le num�ro d'essai, (canal et point)
      letitre =hL.titess;
      % Dans tous les cas, on va b�tir une matrice contenant les pentes calcul�es
      % PENT(i, j, k) = pente du [(point i � i+1) (canal j) (essais k)]
      % puis, on va �crire les r�sultats dans le fichier.
      % Dans le cas ou on cherche la pente entre deux points, on aura max(i) = 1
      % On va �crire les r�sultats dans le fichhier de sortie de la m�me mani�re.
      % On a toujours �crit dans les fichiers texte de fa�on � pouvoir lire et
      % traiter dans "STATISTICA", cad: chaque ligne contient les infos pour un essai.
      % Pour ceux qui utilisent Excel, on peut transposer une ligne en colonne lorsque
      % on fait un copie et coller sp�cial.
      %
      % ex. pour la moyenne entre deux bornes
      % Essai,C1P1,C2P1,...,CNP1   --> C suivi du num�ro du canal, P suivi du num�ro du point
      %     1, xx , xx ,..., xx    --> xx seraient les valeurs de pente
      %     2,...
      %
      % ex. pour la moyenne autour des points
      % Essai,C1P1,C1P2,... C1PS,C2P1,C2P2,... C2PS,C3P1,...   --> m�me convention
      %     1, xx , xx ,...  xx , xx , xx ,...
      %     2,...
      %

      % calcul de l'incr�ment pour la waitbar
      incr =0.9/(tO.Ncan*tO.Ness);
      curwb =0.1;
      % objet de la classe CDtchnl pour manipuler les datas des canaux/essais
      Dt =CDtchnl();

      switch tO.pairage
      case {1,2}
        % on a choisi (1): Pairage des points --> [1er pt avec 2i�me] [3i�me avec 4i�me] ...
        % ou
        % on a choisi (2): Pairage des points --> [1er pt avec 2i�me] [2i�me avec 3i�me] ...
        % croiser sera l'incr�ment � ajouter pour sauter � la prochaine paire de points
        croiser =~(tO.pairage-1)+1;

      	% VALEUR � N�GLIGER
      	% si on a choisi "�chantillons", �a ne varie pas
      	delta =ones(tO.Ncan, tO.Ness)*tO.av_ap;
      	% si on a choisi "secondes", on peut avoir une valeur diff�rente
      	if tO.unit == 2
          delta =delta.*tO.hdchnl.rate(tO.can, tO.ess);
        end
        % nombre de pente max � calculer pour tous
        [PT,Npt] =tO.quelPoint();
        if croiser == 1
          Npt =Npt-PT;
        else
          Npt =floor((Npt-PT+1)/2);
        end
        % cr�ation de la matrice des pentes
        PENT =NaN(Npt, tO.Ncan, tO.Ness);
        % on passe tous les canaux s�lectionn�s
        for U =1:tO.Ncan

          % ligne de titre
          cur =PT;
          for K =1:Npt
            letitre =sprintf('%s%sC%i(P%i-P%i)', letitre, tO.sep, tO.can(U), cur, cur+1);
            cur =cur+croiser;
          end

          % on lit le canal U
          tO.ofich.getcanal(Dt, tO.can(U));

          for V =1:tO.Ness
            % point de travail courant: [cur  cur+1]
            cur =PT;
            % on d�termine les bornes entre lesquelles on veut la pente
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
              % est-ce que l'on est � l'ext�rieur des points disponibles?
              if cur+1 > tO.hdchnl.npoints(tO.can(U), tO.ess(V))
                break;
              end
              curpi =tO.ptchnl.valeurDePoint(['P' num2str(cur)], tO.can(U), tO.ess(V));
              curpf =tO.ptchnl.valeurDePoint(['P' num2str(cur+1)], tO.can(U), tO.ess(V));
              % il faut v�rifier que les points existent
              % et sont dans la fen�tre de travail [debut:fin]
              if isempty(debut) || isempty(fin) || curpi < debut || curpf > fin
                cur =cur+croiser;
                continue;
              end
              foo=tO.hdchnl.point(tO.can(U), tO.ess(V));
              % on fait la moyenne sur quels �chantillons?
              Ti =curpi+delta(U,V);
              Tf =curpf-delta(U,V);
              % v�rificatin de ces bornes
              if Ti >= Tf
                cur =cur+croiser;
                continue;
              end
              % on fabrique la matrice du temps
              temps =[Ti:Tf]' /tO.hdchnl.rate(tO.can(U),tO.ess(V));
              % on calcule la pente entre ces bornes
              if ~isempty(temps)
                poo =polyfit(temps, Dt.Dato.(Dt.Nom)(Ti:Tf, tO.ess(V)), 1);
                PENT(P, U, V) =poo(1);
              end
              cur =cur+croiser;
            end
            % affichage dans la waitbar
            waitbar(curwb,tO.wb);
            curwb =curwb+incr;
          end
        end

      case 3
        % on a choisi: Calculer une seule pente � partir de la fen�tre de travail

        fprintf(tO.fid, '%s\n\n', hL.penfait);
        % nombre de pente � calculer par canal/essai
        Npt =1;
        % matrice des pentes
        PENT =NaN(Npt, tO.Ncan, tO.Ness);
        % on passe tous les canaux
        for U =1:tO.Ncan
          % ligne de titre
          letitre =sprintf('%s%sC%i(%s-%s)', letitre, tO.sep, tO.can(U),tO.debfentrav,tO.finfentrav);
          % on lit le canal U
          tO.ofich.getcanal(Dt, tO.can(U));
          % on passe tous les essais
          for V =1:tO.Ness
            % valeur � retrancher des calculs
            if tO.unit == 1
              % on travaille en �chantillon
              enleve =round(tO.av_ap);
            else
              % on travaille en seconde
              enleve =round(tO.av_ap*tO.hdchnl.rate(tO.can(U),tO.ess(V)));
            end
            % on d�termine les bornes entre lesquelles il faut calculer la pente
            debut =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(U), tO.ess(V));
            fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
            % v�rification de l'ordre croissant entre debut et fin
            if fin < debut
            	foo =debut;
            	debut =fin;
            	fin =foo;
            end
            % on tient compte de la valeur � retrancher
            debut =debut+enleve;
            fin =fin-enleve;
            % on fabrique la matrice du temps
            temps =[debut:fin]' /tO.hdchnl.rate(tO.can(U),tO.ess(V));
            % on calcule la pente entre ces bornes
            if ~isempty(temps)
              poo =polyfit(temps, Dt.Dato.(Dt.Nom)(debut:fin, tO.ess(V)), 1);
              PENT(1, U, V) =poo(1);
            end
            % affichage dans la waitbar
            waitbar(curwb,tO.wb);
            curwb =curwb+incr;
          end  % essais
        end  % canaux

      end  % switch tO.pairage

      % on fait le m�nage
      delete(Dt);
      % on �crit la ligne de titre des canaux
      fprintf(tO.fid, '%s', letitre);
      % les pentes �tant calcul�es on �crit les r�sultats
      N =size(PENT,1);   % Nombre de moyenne

      % on passe tous les essais
      for U =1:tO.Ness
        % �criture du num�ro de l'essai
        fprintf(tO.fid, '\n%i', tO.ess(U));
        % on passe tous les canaux
        for V =1:tO.Ncan
          % on passe toutes les pentes
          for W =1:N
            % �criture de la pente
            fprintf(tO.fid, '%s%g', tO.sep, PENT(W, V, U));
          end
        end
      end

    end

    %-------------------------------------------------------------------
    % v�rification pour savoir � quel point on commence et le nombre max
    % de points d�termin� par la fen�tre de travail.
    %-------------------------------------------------------------------
    function [P,NP] = quelPoint(tO)
      P =0;
      refdbt =tO.ptchnl.valeurDePoint(tO.debfentrav, tO.can(1), tO.ess(1));
      for U =1:tO.hdchnl.npoints
        refpt =tO.ptchnl.valeurDePoint(['P' num2str(U)], tO.can(1), tO.ess(1));
        if refpt >= refdbt & P == 0
          P =U;
          break;
        end
      end
      % le nombre max de point sera:
      ztmp =tO.hdchnl.npoints(tO.can, tO.ess);
      NP =max(ztmp(:));
      % on v�rifie la borne sup�rieure de la fen�tre de travail
      letxt =strtrim(lower(tO.finfentrav));
      if ~strncmp(letxt,'p',1) || ~isempty(strfind(letxt,'pf'))
        return;
      end
      % on doit savoir si c'est un point ou si une op�ration '+ - / *' a �t� faite
      foo ={'+','-','/','*'};
      for U =1:length(foo)
        if ~isempty(strfind(letxt,foo{U}))
          return;
        end
      end
      if ~isempty(str2num(letxt(2:end)))
        NP =str2num(letxt(2:end));
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
