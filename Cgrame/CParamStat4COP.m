%
% classdef CParamStat4COP < handle
%
% METHODS
%    V =getBornesText(tO)
%    V =getCanCpx(tO)
%    V =getCanCpy(tO)
%    V =getFenetreDiffer(tO)
%    V =getFichierSortie(tO);
%    V =getFreqCoupure(tO)
%    V =getNumeroSujet(tO)
%    V =getOnFiltre(tO)
%    V =getOrdreFiltre(tO)
%    V =getRecup(tO)
%    V =getRecupDebutText(tO)
%    V =getRecupFinText(tO)
%       importation(tO, p)
%       isValid(tO)
%       isValidNonText(tO)
%       isValidText(tO)
%
classdef CParamStat4COP < handle

  properties (Access =protected)
    canCpx =0;             % canal Cpx
    canCpy =0;             % canal Cpy
    recup =false;          % valeur de recup pour la moyenne
    recupDebutText ='1';
    recupFinText ='5';
    numeroSujet ='1';
    bornesText ='';   % borne temporelle
    onFiltre =true;
    freqCoupure ='10';
    ordreFiltre ='2';
    fenetreDiffer ='11';
    fichierSortie ='';
  end

  methods

    %-----------------------------
    % importation des propriétés à
    % partir de la structure "p"
    %--------------------------
    function importation(tO, p)
      if isa(p,'struct')
        obj =CParamStat4COP();
        champ =fields(p);
        delete(obj);
        for u =1:length(champ)
          if ~isempty(tO.findprop(champ{u}))
            tO.(champ{u}) =p.(champ{u});
          end
        end
      end
    end

    %------------------------------------------
    % Vérification de la valeurs des propriétés
    % avant de passer aux calculs
    %-------------------
    function isValid(tO)
      try
        tO.isValidNonText();
        tO.isValidText();
      catch e
        rethrow(e);
      end
    end
   
    %---------------------------------------
    % vérification des propriétés numériques
    %--------------------------
    function isValidNonText(tO)
      %______________________
      % ON VÉRIFIE LES CANAUX
      if tO.canCpx == 0 || tO.canCpy == 0
        v =MException('ANALYSE:CParamStat4COP:isValidNonText', ...
                      'Vous devez choisir un canal pour Cpx et Cpy');
        throw(v);
      end
      %_____________________
      % ON VÉRIFIE LE FILTRE
      if tO.onFiltre
        if isempty(tO.freqCoupure)
          v =MException('ANALYSE:CParamStat4COP:isValidNonText', ...
                        'Entrez une valeur numérique pour la fréquence de coupure');
          throw(v);
        end
        if isempty(tO.ordreFiltre)
          v =MException('ANALYSE:CParamStat4COP:isValidNonText', ...
                        'Entrez une valeur numérique pour l''ordre du filtre');
          throw(v);
        end
      end
      %____________________________
      % ON VÉRIFIE LA FEN DU DIFFER
      if isempty(tO.fenetreDiffer)
        v =MException('ANALYSE:CParamStat4COP:isValidNonText', ...
                      'Entrez une valeur numérique pour la fenêtre du Differ');
        throw(v);
      end
    end

    %-----------------------------------
    % vérification des propriétés string
    %-----------------------
    function isValidText(tO)
      %______________________________
      % ON VÉRIFIE LE NEMÉRO DU SUJET
      if isempty(tO.numeroSujet)
        tO.numeroSujet ='1';
      end
      %______________________
      % ON VÉRIFIE LES BORNES
      if ~isempty(strtrim(tO.bornesText))
        if ~isSyntaxBornesValid(tO.bornesText) || ...
           ((strncmpi(tO.bornesText, 'i', 1) && (length(regexp(tO.bornesText,'\s+','split')) ~= 5)) || ...
           (~strncmpi(tO.bornesText, 'i', 1) && (length(regexp(tO.bornesText,'\s+','split')) < 2)))
          v =MException('ANALYSE:CParamStat4COP:isValidText', ...
                        'Vérifiez la syntaxe pour la valeur des bornes');
          throw(v);
        end
      end
      %_______________________________
      % ON VÉRIFIE LES DÉBUT/FIN RÉCUP
      if tO.recup
        if  ~isSyntaxBornesValid(tO.recupDebutText)
          v =MException('ANALYSE:CParamStat4COP:isValidText', ...
                        'Vérifiez la syntaxe pour la valeur du début Récup');
          throw(v);
        end
        if ~isSyntaxBornesValid(tO.recupFinText)
          v =MException('ANALYSE:CParamStat4COP:isValidText', ...
                        'Vérifiez la syntaxe pour la valeur de la fin Récup');
          throw(v);
        end
      end
      %________________________________
      % ON VÉRIFIE LE FICHIER DE SORTIE
      if isempty(tO.fichierSortie)
        v =MException('ANALYSE:CParamStat4COP:isValidText', ...
                      'Il faut entrer un nom de fichier de sortie');
        throw(v);
      end
    end

    %-------
    % GETTER
    %------------------------
    function V =getCanCpx(tO)
      V =tO.canCpx;
    end

    %------------------------
    function V =getCanCpy(tO)
      V =tO.canCpy;
    end

    %-----------------------------
    function V =getNumeroSujet(tO)
      V =tO.numeroSujet;
    end

    %-----------------------
    function V =getRecup(tO)
      V =tO.recup;
    end

    %--------------------------------
    function V =getRecupDebutText(tO)
      V =tO.recupDebutText;
    end

    %------------------------------
    function V =getRecupFinText(tO)
      V =tO.recupFinText;
    end

    %----------------------------
    function V =getBornesText(tO)
      V =tO.bornesText;
    end

    %--------------------------
    function V =getOnFiltre(tO)
      V =tO.onFiltre;
    end

    %-----------------------------
    function V =getFreqCoupure(tO)
      V =tO.freqCoupure;
    end

    %-----------------------------
    function V =getOrdreFiltre(tO)
      V =tO.ordreFiltre;
    end

    %-------------------------------
    function V =getFenetreDiffer(tO)
      V =tO.fenetreDiffer;
    end

    %-------------------------------
    function V =getFichierSortie(tO)
      V =tO.fichierSortie;
    end

  end % methods
end % classdef
