%
% Classe CLirTexte(CLiranalyse)
%
% Gestion de la transformation d'un fichier texte en format Analyse
%
% MEK - mai 2011
%
classdef CLirTexte < CLirOutils

  properties
    horvert =[];
    iscol1 =[];
    nbess =[];
    nus =[];
    fcut =[];
    lpe =[];
    frq =[];
    delim =[];
    nbdelim =[];
    nlnom =[];
    nle =[];
    nlepe =[];
    smpl =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    %-------------------------
    function tO =CLirTexte(hF)
      tO.Typo =CEFich('Texte');
      tO.Fich =hF;
      GUILirTexte(tO);
      if isdir(tO.Fich.Info.prenom)
        cd(tO.Fich.Info.prenom);
      end
    end

    %--------------------------------------------
    % fonction callback pour vérifier les entrées
    % manuels des noms de fichiers textes
    %-------------------------------------
    function Fichiermanuel(tO, src, event)
      % valeur par défaut
      tipoint ={'-----'};
      % lecture du nom entré
      nombre =strtrim(get(src, 'String'));
      if isdir(nombre) || isempty(nombre)
        % le nom de ficheir est un dossier ou est vide
    		set(findobj('tag','MultiFichier'), 'Value',1, 'string',tipoint);
    		return;
      end
      hV =tO.Fich.Info;
      U =dir(nombre);
      if isempty(U)
        % le nom entré ne correspond à aucun fichier
    		set(findobj('tag','MultiFichier'), 'Value',1, 'string',tipoint);
      else
        [a, b, c] =fileparts(nombre);
        if isempty(a)
          a =pwd();
        end
        cd(a);
        % on bâti la liste des fichiers dans le dossier
        Fichiers ={};
        for S =1:length(U)
          if ~U(S).isdir
            Fichiers{end+1} =U(S).name;
          end
        end
        if isempty(Fichiers)
      		set(findobj('tag','MultiFichier'), 'Value',1, 'string',tipoint);
        else
          Fichiers =sort(Fichiers);
      		set(findobj('tag','MultiFichier'), 'Value',1, 'string',Fichiers);
        end
      end
    end

    %------------------------------------------
    % fonction callback pour faire la sélection
    % des fichiers à l'aide du GUI
    %------------------------------------
    function choixFichier(tO, src, event)
      [ya_un_fichier, pname] =tO.selection('*.*','Ouverture d''un fichier Texte',1);
      if ya_un_fichier
        cd(pname);
      	if length(tO.fname) > 1
      	  set(findobj('tag','NomdeFichier'),'String',pname);
      	  set(findobj('tag','MultiFichier'), 'Value',1, 'string', tO.fname);
        else
      	  lafile =fullfile(pname, tO.fname{1});
          set(findobj('tag','NomdeFichier'),'String',lafile);
      	  set(findobj('tag','MultiFichier'), 'Value',1, 'string', tO.fname);
        end
      end
    end

    %----------------------------------
    % N'a pas été ré-activé depuis 2009
    % callback pour changer le mode de lecture des essais
    % soit à la suite verticalement ou horizontalement
    %-----------------------------------
    function ToggleEssai(tO, src, event)
  	  quetal =get(src, 'Value');
      if quetal
        set(src,'TooltipString','Si plusieurs essais par fichier, ils sont les uns à côté des autres', 'String','ESS...');
        set(findobj('tag','textefenverti'),'visible','off');
        set(findobj('tag','NbdeLigneEnteteEss'),'visible','off');
        set(findobj('tag','TexteNbdeLigneEnteteEss'),'visible','off');
        set(findobj('tag','textefenhoriz'),'visible','on');
        set(findobj('tag','elprimero'),'visible','on');
        set(findobj('tag','primerotext'),'visible','on');
      else
        set(src,'TooltipString','Si plusieurs essais par fichier, ils sont les uns au dessus des autres', 'String','ESS :')
        set(findobj('tag','textefenhoriz'),'visible','off');
        set(findobj('tag','textefenverti'),'visible','on');
        set(findobj('tag','elprimero'),'visible','off');
        set(findobj('tag','primerotext'),'visible','off');
        set(findobj('tag','NbdeLigneEnteteEss'),'visible','on');
        set(findobj('tag','TexteNbdeLigneEnteteEss'),'visible','on');
      end
    end

    %------------------
    % dé-activé en 2009
    %-----------------------------------
    function ToggleColon(tO, src, event)
  	  quetal =get(src,'value');
      if quetal
      	set(src,'string','Oui');
      else
      	set(src,'string','Non');
      end
    end

    %--------------------------------
    % callback pour partir la lecture
    %-------------------------------
    function Lecture(tO, src, event)
      lirtext(tO);
      mnouvre2(tO.Fich, tO.Typo, tO.txtml);
    end

  end % methods
end % calssdef
