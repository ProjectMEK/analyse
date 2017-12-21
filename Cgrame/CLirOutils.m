%
% Classe CLirOutils()
%
% mars 2016
% MEK
%
% On accumule ici les fonctions utiles à tous les lecteurs
%
% METHODS
%              Fermeture(tO, src, event)
%              prepare(tO)
%              sauveCanal(tO, datos, hDt, C)
%              sauveEssai(tO, datos, hDt, N)
%  varargout = selection(tO, extension, description, multifich)
%
classdef CLirOutils < handle

  properties
      Fig =[];                    % handle du GUI
      txtml =[];                  % handle sur les textes multilingues
      Fich =[];                   % pointe sur un fichier CLiranalyse()
      Typo =[];                   % type pour Analyse
      fname =[];                  % Cell des noms de fichier à importer
      nbf =0;                     % Nb de fichiers sélectionnés
      col =[];                    % nb de colonne (canaux) à lire
  end

  methods

    %------------
    % CONSTRUCTOR
    %------------------------
    function tO =CLirOutils()
      tO.txtml =CGuiMLLire();
    end

    %--------------------------------------------
    %               SAUVEGARDE UN ESSAI À LA FOIS
    %  À la lecture d'un fichier ligne par ligne, lorsque l'on a fini avec
    %  un essai, on sauvegarde tous les canaux de cette essai.
    %
    %  datos:  matrice des (smpls, canaux) pour l'essai N
    %    hDT:  handle sur un objet CDtchnl()
    %      N:  numéro de l'essai
    %-------------------------------------
    function sauveEssai(tO, datos, hDt, N)
      % Si on a des "NAN" dans la matrice, on les met à zéro
      datos(isnan(datos)) =0;
      for U =1:tO.col
        % On lit le canal "U" du fichier et on le place dans hDt
        tO.Fich.getcanal(hDt, U);
        % on écrit les datas dans hDt, essai N
        L =size(datos, 1);
        hDt.Dato.(hDt.Nom)(1:L, N) =datos(:, U);
        % on sauvegarde le canal dans le fichier
        tO.Fich.setcanal(hDt, U);
      end
    end

    %--------------------------------------------
    %               SAUVEGARDE UN CANAL À LA FOIS
    %  À la lecture d'un fichier ligne par ligne, lorsque l'on a fini avec
    %  un canal, on sauvegarde tous les essais de ce canal.
    %
    %  datos:  matrice des (smpls, canaux)
    %    hDT:  handle sur un objet CDtchnl()
    %      C:  numéro du canal
    %-------------------------------------
    function sauveCanal(tO, datos, hDt, C)
      % Si on a des "NAN" dans la matrice, on les met à zéro
      datos(isnan(datos)) =0;
      % On lit le canal "C" du fichier et on le place dans hDt
      tO.Fich.getcanal(hDt, C);
      % on écrit les datas dans hDt
      hDt.Dato.(hDt.Nom) =datos;
      % on sauvegarde le canal dans le fichier
      tO.Fich.setcanal(hDt, C);
    end

    %-----------------------------------------------------------
    % Ici, on va créer un fichier temporaire de travail (Unique)
    %-----------------------------------------------------------
    function prepare(tO)
      Fan =tO.Fich.Info;
      [Va Vb Vc] =fileparts(tO.fname{1});
      Fan.fitmp =fullfile(tempdir(), [Vb '.mat']);
      test =isempty(dir(Fan.fitmp));
      Inc =0;
      while ~test
        Fan.fich =[Vb num2str(Inc) '.mat'];
        Fan.fitmp =fullfile(tempdir(), Fan.fich);
        test =isempty(dir(Fan.fitmp));
        Inc =Inc+1;
      end
      [Va Vb Vc] =fileparts(Fan.fitmp);
      Fan.prenom =Va;
      Fan.finame =[Vb Vc];
      tO.nbf =length(tO.fname);
    end

    %--------------------------------------------------------
    % On ferme proprement l'objet et sa figure s'il y a lieu.
    %--------------------------------------------------------
    function Fermeture(tO, src, event)
      if ~isempty(tO.Fig)
	      delete(tO.Fig);
	    end
      delete(tO.Fich);
    end

    %-------------------------------------------------------------------------------
    % Choix du fichier à ouvrir
    % on inscrira le choix du fichier dans la propriété tO.fname
    % EN ENTRÉE
    % extension    --> extension des fichiers recherchés
    % description  --> description du type de fichier
    % multifich    --> 0 (un fichier à la fois), 1 (peut choisir plusieurs fichiers)
    %
    % si un fichier est choisi on retourne une valeur > 0
    %-------------------------------------------------------------------------------
    function varargout = selection(tO, extension, description, multifich)
      [tO.fname, pname, CoK] =quelfich(extension, description, multifich);
      varargout{1} =CoK;
      if nargout == 2
        varargout{2} =pname;
      end
    end

  end  % methods
end  % classdef
