%
% CGestionString
%
% Organisation des chaînes de caractères pour peupler les menus et boutons
%
% Nous donne la possibilité du "multilingue"
%
% Pour l'utiliser, on l'appelera de cette façon
%      tt = CGestionString.getVar(nom_class, nom_struct)
% ou
%      tt           nous retourne le handle de l'objet nom_class
%      nom_class    est le type d'odjet qui contiendra les string
%      nom_struct   est le nom de la struct qui contient les string
%                   venant du fichier langue.mat (fr.mat, en.mat etc.)
%                   dans le dossier "doc"
%
% 13 avril 2015
% MEK
%
classdef CGestionString

  methods  (Static)

    %___________________________________________________________________________
    % Création de l'objet "tO" de la classe une_class et Mise À Jour à partir
    % des champs de la struct V qui provient du fichier de langue
    %---------------------------------------------------------------------------
    function tO =getVar(une_class, V)

      % on lit la struct demandé par V dans le fichier langue.mat
      s =CGestionString.lireVarTexte(V);

      % on crée l'objet une_class
      c =str2func(une_class);
      tO =c();

      % mise à jour avec la struct lu dans le fichier de langue
      tO.maj(s);

    end

    %___________________________________________________________________________
    % Lire la structure du fichier langue.mat (fr.mat, en.mat etc.)
    % et retourner la variable demandée par "V"
    %---------------------------------------------------------------------------
    function S =lireVarTexte(V, H)

      if nargin == 1
        H =CAnalyse.getInstance();
      end

      S =[];
      fname =fullfile(H.Fic.basedir, ['doc/' H.Fic.pref.langue]);

      %on vérifie que le fichier existe
      if ~isempty(dir(fname))
        foo =whos('-File', fname);

        %on cherche "V" dans les variables du fichiers
        for U =1:length(foo)
          if strncmp(foo(U).name, V, length(V))

            %on a trouvé le bon match
            datos =load(fname, V);
            S =datos.(V);

          end
        end
      end

    end

  end
end