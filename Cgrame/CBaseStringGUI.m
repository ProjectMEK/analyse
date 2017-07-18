%
% Classe CBaseStringGUI
%
% Gère les informations des classes contenant les string des
% différents GUI de l'application afin de permettre d'avoir
% une application multilingue.
%
% MEK
% 2015/04/14
%
%-------------------------------------------------------------------------------
% METHODS DISPONIBLES
%
%     init(tO, V)
% S = lireVarTexte(tO)
% S = getLangue(tO)
% S = getFileName(tO, H)
%     maj(tO, V)
%_______________________________________________________________________________
%
classdef CBaseStringGUI < handle

  %_____________________________________________________________________________
  properties

    me_llamo ='';   % pour conserver le nom de la variable dans le fichier langue

  end

  %_____________________________________________________________________________
  methods

    %___________________________________________________________________________
    % Initialisation de la variable me_llamo et mise à jour des propriétés
    % à partir des champs de la struct qui provient du fichier de langue
    %---------------------------------------------------------------------------
    function init(tO, V)

      % Initialisation de la variable me_llamo
      tO.me_llamo =V;

      % on lit la struct demandé par V dans le fichier langue.mat puis,
      % mise à jour avec la struct, lu dans le fichier de langue
      tO.maj( tO.lireVarTexte() );

    end

    %___________________________________________________________________________
    % Lire la structure du fichier langue.mat (fr.mat, en.mat etc.)
    % et retourner dans "S" la variable demandée par "V" lors de l'init()
    % et inscrite dans la propriété "me_llamo"
    %---------------------------------------------------------------------------
    function S =lireVarTexte(tO)

      V =tO.me_llamo;
      S =[];
      fname =tO.getFileName();

      % on vérifie que le fichier existe
      if ~isempty(dir(fname))
        foo =whos('-file', fname);

        % on cherche "V" dans les variables du fichiers
        for U =1:length(foo)
          if strncmp(foo(U).name, V, length(V))

            % on a trouvé le bon match
            datos =load(fname, V);
            S =datos.(V);
            break;

          end
        end

      end

    end

    %___________________________________________________________________________
    % Lire la structure du fichier langue.mat (fr.mat, en.mat etc.)
    % et retourner dans "S" le contenu de la variable "langue"
    %---------------------------------------------------------------------------
    function S =getLangue(tO)

      S =[];
      V ='langue';
      fname =tO.getFileName();

      % on vérifie que le fichier existe
      if ~isempty(dir(fname))
        foo =whos('-File', fname);

        % on cherche "V" dans les variables du fichiers
        for U =1:length(foo)
          if strncmp(foo(U).name, V, length(V))

            % on a trouvé le bon match
            datos =load(fname, V);
            S =datos.(V);
            break;

          end
        end
      end

    end

    %___________________________________________________________________________
    % Lire le nom du fichier XX.mat (fr.mat, en.mat etc.)
    % et retourner la réponse dans la variable "S".
    % EN ENTRÉE on a H --> un objet de la classe CAnalyse
    %---------------------------------------------------------------------------
    function S =getFileName(tO, H)

      if nargin == 1
        H =CAnalyse.getInstance();
      end

      S =fullfile(H.Fic.basedir, ['doc/' H.Fic.pref.langue]);

    end

    %___________________________________________________________________________
    % Mise À Jour à partir de la struct qui vient du fichier de langue
    %---------------------------------------------------------------------------
    function maj(tO, V)

      % on s'assure que V est une structure
      if isa(V, 'struct')

        K =CParamGlobal.getInstance();
        if K.matlab
          % Matlab permet l'utilisation de la commande "properties"
          foo =getProp(tO);
        else
          % Octave ne le permet pas
          foo =fieldnames(tO);
        end

        % on fait le tour des prop.
        for U =1:length(foo)

          % si on a les champs identiques au prop, on copie
          if isfield(V, foo{U})
            tO.(foo{U}) =V.(foo{U});
          end

        end

      end

    end

  end  %methods
end