%
% Classe CTpchnlAnalyse
%
% Gestion des échelles de temps
% L'échelle de temps nous permet d'afficher les datas en fonction
% du temps. mais toutefois, le premier échantillon pourrait être
% loin du zéro...
%
classdef CTpchnlAnalyse < CTpchnl

  properties
    hMnuNormal;   % handle du menu "Retour à la normale"
    hMnu;         % handle du menu "Échelle temporelle"
    Fig;
  end

  methods

    %------------
    % CONSTRUCTOR
    %-------------------------------
    function obj =CTpchnlAnalyse(hF)
      obj =obj@CTpchnl(hF);
      obj.hMnu =findobj('tag', 'IpmnuTemps');
      obj.hMnuNormal =findobj('tag','IpmnutempsNormal');
    end

    %----------------------
    function initial(tO, V)
      T =tO.isValidStruc(V);
      if ~isempty(T) && isa(T(1), 'struct')
        for U =1:length(T)
          tO.Dato{U} =CEchelTps(tO, T(U).nom, T(U).canal, T(U).point);
        end
        tO.nbech =length(tO.Dato);
      end
    end

    %----------------------------------
    function OnMenuClicked(obj, lerang)
      obj.hFich.Vg.letemps =lerang;
      obj.CheckMenu();
    end

    %-----------------------
    function CacherMenu(obj)
      leskid =get(obj.hMnu, 'Children');
      set(leskid, 'visible','off');
      set(obj.hMnuNormal, 'visible','on');
    end

    %-------------------------
    function AfficherMenu(obj)
      for U =1:obj.nbech
        obj.Dato{U}.montrer();
      end
      obj.CheckMenu();
    end

    %----------------------
    function CheckMenu(obj)
      s =get(obj.hMnu,'Children');
      set(s, 'Checked','off');
      lerang =obj.hFich.Vg.letemps;
      if lerang
        obj.Dato{lerang}.checkon();
      else
        set(obj.hMnuNormal, 'checked','on');
      end
    end

    %----------------------------------
    function QuelEchel(obj, src, event)
      echel =get(findobj('tag','PmnuEchelDispo'),'Value');
      if obj.nbech == 0
        return
      else
        set(findobj('tag','NomEchel'), 'String',obj.Dato{echel}.nom);
        set(findobj('tag','ETleCanal'),'value', obj.Dato{echel}.canal);
        [listpt,lenb] =obj.getpoint(obj.Dato{echel}.canal);
        lepoint =obj.Dato{echel}.point;
        if lenb == 0
          lepoint =1;
        elseif lepoint > lenb
          lepoint =lenb;
        end
        set(findobj('tag','ETlePoint'), 'value',1, 'String',listpt, 'value',lepoint);
      end
    end

    %------------------------------------
    function ChangeCanal(obj, src, event)
      lecanal =get(findobj('tag','ETleCanal'),'Value');
      [listpt,lenb] =obj.getpoint(lecanal);
      set(findobj('tag','ETlePoint'), 'value',1, 'String',listpt);
    end

    %--------------------------------
    function Ajouter(obj, src, event)
      lecanal =get(findobj('tag','ETleCanal'),'value');
      lepoint =get(findobj('tag','ETlePoint'),'value');
      nom =deblank(get(findobj('tag','NomEchel'),'String'));
      test =obj.AjouTp(nom, lecanal, lepoint);
      if test
        dep =obj.FaireListEchel();
        set(findobj('tag','PmnuEchelDispo'), 'value',1, 'string',dep, 'Value',obj.nbech);
      end
    end

    %-----------------------------------------------
    function Cok =AjouTp(obj, nom, lecanal, lepoint)
      Cok =false;
    	hdchnl =obj.hFich.Hdchnl;
    	ptchnl =obj.hFich.Ptchnl;
      lenb =min(hdchnl.npoints(lecanal,:));
      if lenb == 0
        return;
      end
      ctibon =true;
      for jj =1:obj.hFich.Vg.ess
        if ptchnl.Dato(lepoint,hdchnl.point(lecanal,jj),2) == -1
          ctibon =false;
          disp(['Point bidon dans l''essai: ' num2str(jj)]);
          break;
        end
      end
      if ctibon
        if isempty(deblank(nom))
          nom =['sans nom'];
        end
        obj.Dato{end+1} =CEchelTps(obj, nom, lecanal, lepoint);
        obj.nbech =length(obj.Dato);
        Cok =true;
      end
    end

    %---------------------------------
    function Modifier(obj, src, event)
    	hdchnl =obj.hFich.Hdchnl;
     	ptchnl =obj.hFich.Ptchnl;
      lecanal =get(findobj('tag','ETleCanal'),'value');
      lepoint =get(findobj('tag','ETlePoint'),'value');
      echel =get(findobj('tag','PmnuEchelDispo'),'Value');
      nom =get(findobj('tag','NomEchel'),'String');
      test =obj.ModifTp(echel, nom, lecanal, lepoint);
      if test
        dep =obj.FaireListEchel();
        set(findobj('tag','PmnuEchelDispo'), 'value',1, 'string',dep, 'Value',echel);
      end
    end

    %-------------------------------------------------------
    function Cok =ModifTp(obj, echel, nom, lecanal, lepoint)
      Cok =false;
      if obj.nbech
      	hdchnl =obj.hFich.Hdchnl;
      	ptchnl =obj.hFich.Ptchnl;
        lenb =min(hdchnl.npoints(lecanal,:));
        if lenb == 0
          return;
        end
        ctibon =true;
        for U =1:obj.hFich.Vg.ess
          if ptchnl.Dato(lepoint,hdchnl.point(lecanal,U),2) == -1
            ctibon =false;
            disp(['Point bidon dans l''essai: ' num2str(U)]);
            break;
          end
        end
        if ctibon
          if isempty(deblank(nom))
            nom =['sans nom'];
          end
          obj.Dato{echel}.Modifier(nom, lecanal, lepoint);
          Cok =true;
        end
      end
    end

    %----------------------------------
    function Supprimer(obj, src, event)
      if obj.nbech
        echel =get(findobj('tag','PmnuEchelDispo'),'Value');
        obj.EnleveEchel(echel);
        if obj.nbech
          if echel > obj.nbech
            echel =obj.nbech;
          end
          dep =obj.FaireListEchel();
          lenom =obj.Dato{echel}.nom;
          lecanal =obj.Dato{echel}.canal;
          lepoint =obj.Dato{echel}.point;
        else
          dep =['Aucune'];
          echel =1;
          lepoint =1;
          lecanal =1;
          lenom =[''];
        end
        [listpt,lenb] =obj.getpoint(lecanal);
        if lenb == 0
          lepoint =1;
        elseif lepoint > lenb
          lepoint =lenb;
        end
        set(findobj('tag','PmnuEchelDispo'), 'value',1, 'string',dep, 'Value',echel);
        set(findobj('tag','NomEchel'), 'string',lenom);
        set(findobj('tag','ETleCanal'), 'Value',lecanal);
        set(findobj('tag','ETlePoint'), 'Value',1, 'string',listpt, 'Value',lepoint);
      end
    end

    %----------------------------------
    function Delcan(obj, lescan, Bat)
      if ~exist('Bat')
        Bat =false;
      end
      if obj.nbech & length(lescan)
        for U =length(lescan):-1:1
          combien =obj.nbech;
          for echel =combien:-1:1
            if lescan(U) == obj.Dato{echel}.canal
              obj.EnleveEchel(echel);
            elseif lescan(U) < obj.Dato{echel}.canal
            	obj.Dato{echel}.canal =obj.Dato{echel}.canal-1;
            end
          end
        end
        if ~Bat
          obj.ResetMenu();
        end
      end
    end

    %---------------------------------
    function DelPoint(obj, canal, pts)
      if obj.nbech
      	[a ,tot] =obj.getpoint(canal);
      	dernier =obj.nbech;
      	for echel =dernier:-1:1
      		if obj.Dato{echel}.canal == canal & obj.Dato{echel}.point == pts
      			obj.EnleveEchel(echel);
      		elseif obj.Dato{echel}.canal == canal & obj.Dato{echel}.point > pts
      			obj.Dato{echel}.point =obj.Dato{echel}.point-1;
      			if obj.Dato{echel}.point > tot
      				obj.EnleveEchel(echel);
      			end
      		end
      	end
      	obj.ResetMenu();
      end
    end

    %----------------------
    function ResetMenu(obj)
      if obj.hFich.Vg.letemps > obj.nbech
        obj.OnMenuClicked(0);
      else
        obj.OnMenuClicked(obj.hFich.Vg.letemps);
      end
    end

    %-----------------------------------
    function FermerEdit(obj, src, event)
      combien =obj.nbech;
      for echel =combien:-1:1
        lecanal =obj.Dato{echel}.canal;
        lepoint =obj.Dato{echel}.point;
        [listpt,lenb] =obj.getpoint(lecanal);
        if lenb == 0 || lepoint > lenb
          obj.EnleveEchel(echel);
        end
      end
      delete(obj.Fig);
      obj.ResetMenu();
      hA =CAnalyse.getInstance();
      hA.OFig.affiche();
    end

    %---------------------------------
    function AssimilerNouveau(obj, tp)
      % Utilisé lors d'ajout de fichier par CValet
      % tp est un handle sur le tpchnl du fichier à importer
      obj.ValidEchelles();
      if tp.nbech
      	test =[];
       	for U =1:tp.nbech
        	if obj.hFich.Vg.nad < tp.Dato{U}.canal
      			test(end+1) =U;
      		elseif tp.Dato{U}.point > min(obj.hFich.Hdchnl.npoints(tp.Dato{U}.canal,:))
      			test(end+1) =U;
      		end
        end
     		S =1:tp.nbech;
       	if ~isempty(test)
       		S(test) =[];
       	end
        if ~isempty(S)
          if obj.nbech
            for V =S
              tst =true;
              for K =1:obj.nbech
                if strcmpi(obj.Dato{K}.nom, tp.Dato{V}.nom) & ...
                   obj.Dato{K}.canal == tp.Dato{V}.canal & ...
                   obj.Dato{K}.point == tp.Dato{V}.point
                  tst =false;
                  break;
                end
              end
              if tst
                obj.AjouTp(tp.Dato{V}.nom, tp.Dato{V}.canal, tp.Dato{V}.point);
              end
            end
          else
            for V =S
              test =obj.AjouTp(tp.Dato{V}.nom, tp.Dato{V}.canal, tp.Dato{V}.point);
            end
          end
        end
      end
      obj.ResetMenu();
    end

  end  % methods
end  % classdef
