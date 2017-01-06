%
% Class CImportPoint
%
% On importe des points à partir d'un fichier .INI
% (dans le menu "Outils" du GUI principal: "importer point (Y vs X)"
%
% ***********************************************************
% *  LES COORDONNÉES DOIVENT ÊTRE SÉPARÉ PAR DES ESPACES   **
% ***********************************************************
%
classdef CImportPoint < handle

  properties
    Fig =[];              % handle de la figure des params
    Fich =[];             % nom du fichier .INI
    fid =[];              % handle du fichier ( fclose(fid) )
    fname =[];            % nom du fichier .INI
    pname =[];            % path du fichier .INI
    Tmax =[];             % temps permis pour considérer un groupe de smpl équiv.
    Rmax =1;              % rayon max de recherche
    OnTrie =false;        % doit-on trier les points en ordre chronologique
    Mat =[];              % matrice des points à marquer
    nbCol =0;             % nombre de colonnes lues dans le fichier .INI
    nbPts =0;             % nombre de point à marquer
    cX =[];               % canal de la première colonne
    cY =[];               % canal de la deuxième colonne
    cPt =[];              % canal à marquer
  end

  methods

    %------------
    % CONSTRUCTOR
    %--------------------------
    function tO =CImportPoint()
      if tO.Selection()
        tO.Fich =fullfile(tO.pname, tO.fname);
        if tO.LirFichier();
          IImportPoint(tO);
        end
      else
        tO.Fermeture();
      end
    end

    %-----------------------------------
    % On sélectionne le fichier à ouvrir
    % pour importer les points.
    %------------------------------
    function EsBueno =Selection(tO)
      [tO.fname, tO.pname, EsBueno] =quelfich('*.ini','Ouverture d''un fichier pour importer des points', false);
    end

    %---------------------------------------------
    % On lit le fichier dans la propriété "tO.Mat"
    % on vérifie que l'on a bien deux colonnes
    %---------------------------
    function CoK =LirFichier(tO)
      CoK =false;
      tO.fid =fopen(tO.Fich, 'r');
      S =tO.Suivante();
      while S ~= -1
        if ~strncmp(S, '#', 1) & ~isempty(S)
          tO.Mat(end+1, :) =sscanf(S, '%f')';
        end
        S =tO.Suivante();
      end
      fclose(tO.fid);
      G =size(tO.Mat, 2);
      if G == 2
        tO.nbCol =size(tO.Mat, 2);
        tO.nbPts =size(tO.Mat, 1);
        CoK =true;
      else
        disp(['Vérifiez le fichier ' tO.fname ', les séparateurs doivent être des espaces']);
      end
    end

    %------------------------------------------------------
    % on lit la ligne suivante du fichier ayant pour handle
    % tO.fid, puis on enlève les espace au début et à la fin.
    %-----------------------
    function V =Suivante(tO)
      V =fgetl(tO.fid);
      if V ~= -1
        V =strtrim(V);
      end
    end

    %-------------------------------
    % change le "rayon de recherche"
    % Distance max à considérer pour trouver une occurence
    %-------------------------------------
    function TestAparicion(tO, src, event)
      V =str2double(get(src, 'String'));
      if isnan(V)
        set(src, 'String',num2str(tO.Rmax));
      else
        tO.Rmax =V;
      end
    end

    %-----------------------------------------
    % synchronise les propriétés de l'objet tO
    % avec les valeurs du GUI. Puis ajoute les
    % points demandés.
    %-------------------------------
    function Lecture(tO, src, event)
      tO.cX =get(findobj('tag','ChoixCanX'), 'Value');
      tO.cY =get(findobj('tag','ChoixCanY'), 'Value');
      tO.cPt =get(findobj('tag','CanMark'), 'Value');
      if tO.cX == tO.cY
        uicontrol(findobj('tag','ChoixCanX'));
        return;
      end
      tO.OnTrie =get(findobj('Tag','OnTrie'), 'Value');
      delete(tO.Fig);
      AjoutePoints(tO);
    end

    %-----------------
    % fermeture du GUI
    %---------------------------------
    function Fermeture(tO, src, event)
      if ishandle(tO.Fig)
        delete(tO.Fig);
      end
    end

  end % methods
end % classdef
