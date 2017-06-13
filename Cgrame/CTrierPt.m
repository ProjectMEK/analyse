%
% Classe CTrierPt
%
% On fait le trie des points marqu�s
%
classdef CTrierPt < handle

  %---------
  properties
    % identification des fichiers au format Analyse ou texte
    ofich =[];      % handle du fichier courant
    hdchnl =[];     % handle de l'ent�te des data
    vg =[];         % handle des variables globales
    ptchnl =[];     % handle de l'objet des points marqu�s

    % Objet graphique
    fig =[];        % handle du GUI GuiTrierPt.m
    wb =[];         % handle de la waitbar

    % valeur � lire dans le GUI
    can =[];                      % canaux s�lectionn�s
    Ncan =[];                     % nombre de canaux s�lectionn�s
    ess =[];                      % essais s�lectionn�s
    Ness =[];                     % nombre d'essais s�lectionn�s
    debfentrav =[];               % d�but du range de travail
    finfentrav =[];               % fin du range de travail
  end

  %------
  methods

    %------------
    % CONSTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet cr��.
    %---------------------------
    function tO = CTrierPt()

      % initialisation des propri�t�s
      OA =CAnalyse.getInstance();
      tO.ofich =OA.findcurfich();
      tO.hdchnl =tO.ofich.Hdchnl;
      tO.vg =tO.ofich.Vg;
      tO.ptchnl =tO.ofich.Ptchnl;

      % cr�ation du GUI
      tO.fig =GuiTrierPt(tO);

    end

    %------------
    % DESTRUCTOR
    %
    % tO --> thisObject, le handle de l'objet cr��.
    %---------------------------
    function delete(tO)

      if ~isempty(tO.wb)
        % suppression de la waitbar
      	close(tO.wb);
      end
      if ~isempty(tO.fig)
        % suppression de la figure
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

    %-------------------------------------------
    % C'est ici que l'on va contr�ler le travail
    %-------------------------------------------
    function travail(tO, varargin)

      % On ouvre une waitbar "modal" pour montrer o� on est rendu et en plus on
      % barre l'acc�s au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,'Moyennage en cours', 'G', 'C');
  
      % Lecture des param�tres du GUI
      tO.lireLeGUI();
  
      % appel de la fonction qui va faire le vrai travail
      oK =tO.faireLeTrie();

      if oK
        % on ferme proprement la figure.
        delete(tO.fig);
        tO.fig =[];
      end
      % on ferme proprement le waitbar.
      close(tO.wb);
      tO.wb =[];
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
      % D�but et fin de la fen�tre de travail (format texte)
      tO.debfentrav =get(findobj('Tag','EDfenTravDebut'), 'String');
      tO.finfentrav =get(findobj('Tag','EDfenTravFin'), 'String');
    end

    %------------------------------------------------------------------
    % Tous les param�tres sont maintenant connus, on proc�de au travail
    % en fonction des choix fait dans le GUI.
    %------------------------------------------------------------------
    function fini = faireLeTrie(tO)

      % si il n'y a pas d'erreur, on retourne true
      fini =true;

      for U =1:tO.Ncan

        for V =1:tO.Ness

          % on d�termine les bornes entre lesquelles il faut moyenner
          [debut,fin] =tO.quelPoints(tO.can(U), tO.ess(V));
          fin =tO.ptchnl.valeurDePoint(tO.finfentrav, tO.can(U), tO.ess(V));
          % v�rification de l'ordre croissant entre debut et fin
          if fin < debut
          	foo =debut;
          	debut =fin;
          	fin =foo;
          end
          tO.ptchnl.OnTrie(tO.can(U), tO.ess(V));

        end
      end

    end

    %-------------------------------------------------------------------
    % analyse du texte entr� pour d�terminer quels points on devra trier
    %-------------------------------------------------------------------
    function [P1,PF] = quelPoints(tO,can,tri)
      P1 =1;
      PF =tO.hdchnl.npoints(can,tri);
      % texte du premier point
      pti =lower(strtrim(tO.debfentrav));
      % texte du dernier point
      ptf =lower(strtrim(tO.finfentrav));
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
