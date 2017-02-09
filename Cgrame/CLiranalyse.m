% Laboratoire GRAME
% MEK - Octobre 1998 @ 2009
%
% Classe CLiranalyse
% pour ouvrir les fichiers du format Analyse
%
classdef CLiranalyse < CFichierAnalyse

  methods

    %------------
    % CONSTRUCTOR
    %--------------------------------
    function obj =CLiranalyse(letype)
      obj =obj@CFichierAnalyse(letype);
    end

    %----------------------------------
    % lecture du fichier format Analyse
    %-------------------------
    function Cok =lire(obj, Y)
      Cok =false;
      fic =obj.Info;
      cd(fic.prenom);
      if obj.Vg.valeur
      	fname =fic.finame;
      	pname =fic.prenom;
      else
        [fname,pname,obj.Vg.valeur] =quelfich('*.mat','Ouverture d''un fichier d''acquisition',false);
      end
      if obj.Vg.valeur
      	hA =CAnalyse.getInstance();

      	try
      	  % Matlab accepte cette version
%      	  hFonction =@hA.isfichopen;
      	  hFonction ='isfichopen';
      	catch Moo;
      	  % Octave celle-ci
      	  hFonction =@(P) hA.isfichopen(P);
      	end
      	finame =fullfile(pname,fname);
        if hA.(hFonction)(finame)
          return;
        end

disp('CLiranalyse.lire() --> rendu ici...');

        dd =findall(0, 'type','figure', 'name','WBarLecture');
        TextLocal ='Ouverture d''un fichier MAtlab, veuillez patienter';
        delwb =false;
        if isempty(dd)
          delwb =true;
          dd =waitbar(0.001, TextLocal);
        else
          waitbar(0.001, dd, TextLocal);
        end
        % On doit vérifier le format de fichier
        etalors =obj.SondeFichier(finame);
        figure(dd);
        if isempty(etalors)    % ce n'est pas un fichier Analyse
          if delwb
            delete(dd);
          end
          return;
        elseif ~etalors        % c'est à l'ancien format
          finame =obj.correction(finame, dd, hA, hFonction);
        end
        if isempty(finame)
          if delwb
            delete(dd);
          end
          return;
        end
        waitbar(75/100, dd, TextLocal);
        if Y == CEFich('analyse')
          fic.foname =finame;
        else
          fic.foname =[];
        end
        [fic.prenom, a, b] =fileparts(finame);
        fic.finame =[a b];
        %________________________________________________________
        % Le fichier temporaire sera ouvert dans le répertoire 
        % temporaire de l'usager. (On s'assure qu'il sera unique)
        %--------------------------------------------------------
        test =false;
        Inc =0;
        while ~test
          fic.fich =['~Tmp' num2str(Inc) fic.finame];
          fic.fitmp =fullfile(tempdir(), fic.fich);
          test =isempty(dir(fic.fitmp));
          Inc =Inc+1;
        end
        %---------------------------------------------------------
        % On conserve les champs utiles venant du fichier à ouvrir
        % il faut faire attention à la variable "autre" qui peut être corrompu
        % ou être très volumineuse. Avec Matlab 2007, on peut l'ouvrir.
        %--------------------------------------------------------------
        Tous =whos('-file', finame);
        Nous ={'vg','hdchnl','ptchnl','tpchnl','catego','autre'};
        fifich =[];
        Vamos =[true false];
        while Vamos(1)
          try
            ligne ={};
            for PP =1:length(Tous)
              for RR =1:length(Nous)
                if strncmpi(Tous(PP).name, Nous{RR}, length(Nous{RR}))
                  ligne{end+1} =Nous{RR};
                  break;
                end
              end
            end
            fifich =load(finame, ligne{:});
            if Vamos(2)
              disp('La variable "autre" semble causer problème...');
              return;
            end
            Vamos(1) =false;
          catch bouette
            if Vamos(2)
              disp('Le fichier semble corrompu...');
              return;
            end
            Nous ={'vg','hdchnl','ptchnl','tpchnl','catego'};
            Vamos(2) =true;
          end
        end
        fifich.vg.valeur =obj.Vg.valeur;
        obj.Vg.initial(fifich.vg);
        if obj.Vg.defniv == 0
          obj.Vg.defniv =1;
        end
        obj.Hdchnl.initial(fifich.hdchnl);
        waitbar(85/100,dd);
        if isfield(fifich,'autre')
          obj.autre =fifich.autre;
        else
          obj.autre =[];
        end
        obj.Vg.nst =length(obj.Vg.nomstim);
        if isfield(fifich,'ptchnl') 
          obj.Ptchnl.initial(fifich.ptchnl);
        end
        if isfield(fifich,'catego') && ~isempty(fifich.catego)
          obj.Catego.initial(fifich.catego);
        end
        obj.lescats();
        obj.lesess();
        if isfield(fifich,'tpchnl') & ~isempty(fifich.tpchnl)
          obj.Tpchnl.initial(fifich.tpchnl);
        end
        waitbar(95/100,dd);
        if delwb
          delete(dd);
        end
        Cok =true;
      end
    end

    %-------------------------------------
    % ajouter un fichier de format Analyse
    % dans le fichier courant.
    %------------------------------------
    function ajoutanalyse(obj, hF, quien)
      % hF est le handle du fichier à ajouter
      % quien = 0 si ajouter essais
      %       = 1 si ajouter canaux
      % hW est le handle du waitbar
      a =CDatoImport();
      a.f0nad =obj.Vg.nad;
      a.f0ess =obj.Vg.ess;
      a.f1nad =hF.Vg.nad;
      a.f1ess =hF.Vg.ess;
      if quien
      	a.debcan =obj.Vg.nad+1;
      	a.fincan =obj.Vg.nad+hF.Vg.nad;
      	a.modcan =hF.Vg.nad;
      	a.debess =1;
      	a.finess =hF.Vg.ess;
      	a.modess =a.finess-obj.Vg.ess;
      else
      	a.debcan =1;
      	a.fincan =hF.Vg.nad;
      	a.modcan =a.fincan-obj.Vg.nad;
      	a.debess =obj.Vg.ess+1;
      	a.finess =obj.Vg.ess+hF.Vg.ess;
      	a.modess =hF.Vg.ess;
      end
      % On importe les datas du hdchnl
      CValet.ImportHdchnl(obj, hF, a);
      % On importe les stimulus
      CValet.ImportStim(obj, hF, a);
      % On importe les Dtchnl
      CValet.ImportDtchnl(obj, hF, a);
      % On importe les catégorie
      CValet.ImportCatego(obj, hF, a);
      % On importe les points marqués
      CValet.ImportPtchnl(obj, hF, a);
      % On importe les échelle de temps
      CValet.ImportTpchnl(obj, hF, a);
      delete(a);
    end

  end  % methods
end  % classdef
