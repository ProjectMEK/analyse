%
% Classe CLirKeithley(CLiranalyse)
%
% MEK - mars 2016
%
%     whatstim(1) = ; %session  0 = notinclude  1 = include as condition
%     whatstim(2) = ; %condition
%     whatstim(3) = ; %seq-type
%
% METHODS
% 
%       changeStatusCheckbox(tO, src, event)
%  tO = CLirKeithley(hF)                 % CONSTRUCTOR
%       fermeture(tO, src, event)
%   V = grepNomFichier(tO)
%       lecture(tO, src, event)
%       selection(tO, src, event)
%
%-------------------------------------------------------------------------------
classdef CLirKeithley < CLirOutils

  properties
    whatstim =[0 0 1];      % information sur session, condition, seq-type
  end

  methods

    %------------
    % CONSTRUCTOR
    %-----------------------------
    function tO = CLirKeithley(hF)
      tO.Typo =CEFich('Keithley');
      tO.Fich =hF;
      GUILirKeithley(tO);
      if isdir(tO.Fich.Info.prenom)
        cd(tO.Fich.Info.prenom);
      end
    end

    %------------------------------
    % sélection du fichier à ouvrir
    %---------------------------------
    function choixFichier(tO, src, event)
      % On demande quel fichier on doit ouvrir
      [ya_un_fichier, pname] =tO.selection('*.adw',tO.txtml.kinomfich,0);
      if ya_un_fichier
        lafile =fullfile(pname, tO.fname);
        set(findobj('Tag','NomFich'),'String',lafile);
      end
    end

    %-----------------------------------------------------------------
    % Ici on récupère les informations dans le GUI afin de passer à la
    % lecture du fichier voulu.
    %--------------------------------------------
    function changeStatusCheckbox(tO, src, event)
        % Le tag qui contient en dernier caractère le numéro du checkbox
        S =get(src, 'Tag');
        N =str2num(S(end));
        tO.whatstim(N) =get(src, 'Value');
    end

    %--------------------------
    % ici on passe à la lecture
    %-------------------------------
    function lecture(tO, src, event)
      try
        if tO.grepNomFichier();
          tO.prepare();
          lirkith(tO);
          mnouvre2(tO.Fich, tO.Typo, tO.txtml);
        end
      catch moo;
        rethrow(moo);
      end
    end

    %-----------------------------------------------------------------
    % Ici on récupère les informations dans le GUI afin de passer à la
    % lecture du fichier voulu. Si le fichier n'existe pas on retourne 0.
    %------------------------------
    function V = grepNomFichier(tO)
        V =0;
        % nom du fichier
        lafile =strtrim(get(findobj('Tag','NomFich'),'String'));
        if isempty(dir(lafile))
            % si on a pas choisi de fichier ou qu'il n'existe pas, on sort.
            return;
        end
        V =1;
        [pname,fname,ex] =fileparts(lafile);
        if ~isdir(pname)
            pname =pwd();
        end
        tO.fname ={[fname ex]};
        cd(pname);
    end

  end % methods
end % classdef
