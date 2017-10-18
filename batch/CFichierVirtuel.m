% Laboratoire GRAME
% MEK - Octobre 2017
%
% Classe CFichierVirtuel
% Pour ouvrir les fichiers du format Analyse lors du travail en batch.
% On aura besoin d'acc�der aux infos du fichier seulement, pas aux datas.
%
classdef CFichierVirtuel < CFichier

  methods

    %-----------------------------
    %         CONSTRUCTOR
    %-----------------------------
    function tO =CFichierVirtuel()
      try
        % Initialisation de CFichier()
        tO.initCFichier();
        tO.Vg =CVgAnalyse();
        % si on fini par avoir besoin de CTpchnl, alors d�commenter la ligne suivante
        % tO.Tpchnl =CTpchnlAnalyse(tO);
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %-------------------------------------------------------------------------------
    % lecture du fichier format Analyse
    % En entr�e  -->  fnom = nom du fichier � ouvrir
    % En sortie  -->  true si le fichier contient les variables {hdchnl, vg, catego}
    %                 false si il manque une de ces variables
    %-------------------------------------------------------------------------------
    function Cok =lire(tO, fnom)
      try
        Cok =true;
        % nom des variables utiles
        Nous ={'vg','hdchnl','catego'};
        fifich =load(fnom, Nous{:});
        if length(fieldnames(fifich)) < length(Nous)
          Cok =false;
          return;
        end
        % on conserve le nom du fichier
        tO.Info.finame =fnom;
        % on initialise tO.Vg
        tO.Vg.initial(fifich.vg);
        % on initialise hdchnl
        tO.Hdchnl.initial(fifich.hdchnl);
        % on initialise les cat�gories
        if isfield(fifich,'catego') && ~isempty(fifich.catego)
          tO.Catego.initial(fifich.catego);
        end
        % on initialise les listes de nom de cat�gories et d'essais
        tO.lescats();
        tO.lesess();
      catch moo;
        Cok =false;
        rethrow(moo);
      end

    end

    %-------------------------------------------------------------------------------------
    % On clone le pr�sent objet. On va donc cr�er une nouvelle instance de CFichierVirtuel
    % En sortie  -->  le handle de l'objet CFichierVirtuel cr�er.
    %                 [] si il y a erreur
    %-------------------------------------------------------------------------------------
    function that = clone(tO)
      try
        % nouvelle instance de CFichierVirtuel
        that =CFichierVirtuel();
        % on initialise les variables
        tO.reClone(that);
      catch qq
        that =[];
        rethrow(qq);
      end

    end

    %-------------------------------------------------------------------------------------
    % On clone le pr�sent objet sans cr�er de nouvelle instance de CFichierVirtuel.
    % En entr�e  -->  that  une instance de CFichierVirtuel
    %-------------------------------------------------------------------------------------
    function reClone(tO, that)
      try
        % on initialise that.Vg
        that.Vg.initial(tO.Vg.databrut());
        % on initialise hdchnl
        that.Hdchnl.initial(tO.Hdchnl.databrut());
        % on initialise les cat�gories
        if ~isempty(tO.Catego.Dato)
          that.Catego.initial(tO.Catego.Dato);
        end
        % on initialise les listes de nom de cat�gories et d'essais
        that.lescats();
        that.lesess();
      catch qq
        delete(that);
        that =[];
        rethrow(qq);
      end

    end

    %------------------------------------
    % Enlever/effacer les canaux "lescan"
    %----------------------------
    function suppcan(obj, lescan)
    end

    %------------------------------------
    % Enlever/effacer les essais "lesess"
    %---------------------------
    function suppess(obj,lesess)
    end

  end
end
