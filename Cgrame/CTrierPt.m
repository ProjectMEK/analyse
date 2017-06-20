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

      % appel les menus multi-lingues
      hL =CGuiMLMoyPenteTrie();
      % On ouvre une waitbar "modal" pour montrer o� on est rendu et en plus on
      % barre l'acc�s au GUI pour ne pas le modifier pendant le traitement.
      tO.wb =laWaitbarModal(0,hL.wbar3, 'G', 'C');
  
      % Lecture des param�tres du GUI
      tO.lireLeGUI();
      waitbar(0.1,tO.wb);
  
      % appel de la fonction qui va faire le vrai travail
      oK =tO.faireLeTrie(hL);

      if oK
        % on ferme proprement la figure.
        delete(tO.fig);
        tO.fig =[];
      end
      % on ferme proprement le waitbar.
      close(tO.wb);
      tO.wb =[];
      % on r�-affiche
      OA =CAnalyse.getInstance();
      OA.OFig.affiche();
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

    %---------------------------------------------------------------
    % Tous les param�tres doivent �tre connus, on proc�de au travail
    % en fonction des choix fait dans le GUI.
    % En entr�e, hL est le handle d'un objet CGuiMLMoyPenteTrie pour
    % l'affichage multi-lingue.
    %---------------------------------------------------------------
    function fini = faireLeTrie(tO,hL)

      % si il n'y a pas d'erreur, on retourne true
      fini =true;
      % calcul de l'incr�ment pour la waitbar
      incr =0.9/(tO.Ncan*tO.Ness);
      cur =0.1;

      for U =1:tO.Ncan

        for V =1:tO.Ness

          % on d�termine les bornes entre lesquelles il faut moyenner
          PF =tO.hdchnl.npoints(tO.can(U), tO.ess(V));
          if PF < 2
            pasbon =sprintf('%s %s(%i) %s(%i)' ,hL.m2pt,hL.lecan,tO.can(U),hL.less,tO.ess(V));
            disp(pasbon);
            continue;
          end
          debut =numeroPoint(tO.debfentrav,PF);
          if isempty(debut)
            pasbon =sprintf(['%s (%s) %s(%i) %s(%i)'], hL.errsyn, ...
                    tO.debfentrav,hL.lecan,tO.can(U),hL.less,tO.ess(V));
            disp(pasbon);
            fini =false;
            continue;
          end
          fin =numeroPoint(tO.finfentrav,PF);
          if isempty(fin)
            pasbon =sprintf(['%s (%s) %s(%i) %s(%i)'], hL.errsyn,...
                    tO.finfentrav,hL.lecan,tO.can(U),hL.less,tO.ess(V));
            disp(pasbon);
            fini =false;
            continue;
          end
          % v�rification de l'ordre croissant entre debut et fin
          lemode ='ascend';
          if fin < debut
            lemode ='descend';
          end
          tO.ptchnl.trierPoints(tO.can(U),tO.ess(V), debut,fin,lemode);
          % affichage dans la waitbar
          waitbar(cur,tO.wb);
          cur =cur+incr;

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
