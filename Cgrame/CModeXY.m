%
% Classe CModeXY
%
% gestion de l'affichage X vs Y
%
classdef CModeXY < handle
  properties
    Fid =[];
    Fig =[];
    IpmnuXy =[];
    cano =[];
    canoXY =[];
    XX =[];
    YY =[];
  end

  methods

    %------------
    % CONSTRUCTOR
    %--------------------------
    function obj = CModeXY(Ppa)
      try
        obj.Initialise(Ppa);
      catch mmoo;
        CQueEsEsteError.dispOct(mmoo);
        rethrow(mmoo);
      end
    end

    %
    % DESTRUCTOR
    %-------------------
    function delete(obj)
      delete(obj.Fig);
    end

    %---------------------------
    function Initialise(obj, hF)
      try
        obj.Fid =hF;
        vg =hF.Vg;
        obj.IpmnuXy =findobj('tag', 'IpmnuXy');
        obj.XX =vg.x;
        obj.YY =vg.y;
        obj.VerifieListXY();
        IModeXY(obj);
        lenom =obj.listcanxy();
        if isempty(obj.XX)      % aucun choix de fait
          vg.choixy=1;
        else                    % ici on a au moins un XX de choisi
          if isempty(vg.choixy) | vg.choixy == 0 | vg.choixy > length(obj.YY)
            vg.choixy =1;
          end
          vg.x =vg.x(vg.choixy);
          if length(obj.YY)
            vg.y =vg.y(vg.choixy);
          end
        end
        obj.canoXY.setString(lenom);
        obj.canoXY.setValue(vg.choixy);
      catch moo;
        CQueEsEsteError.dispOct(moo);
        rethrow(moo);
      end
    end

    %--------------------------------
    % au sortir de l'affichage X vs Y
    % on efface pas le GUI, on le "cache"
    %--------------------------------
    function mnucacher(obj,src,event)
      figure(obj.getFigIp());
      obj.cacher();
    end

    %------------------------------------
    % on a cliquer sur un choix de courbe
    % X vs Y pour les afficher
    %---------------------------------
    function mnuvoircan(obj,src,event)
      obj.voircan();
    end

    %---------------------------------------------------
    % sera utilisé si un fichier est en affichage X vs Y
    % et que vous ouvrez un autre fichier, lors du retour
    % au premier fichier, on demandera si le GUI est là
    %------------------------------
    function varargout = YetiLa(tO)
      cOk =false;
      if tO.Fid.Vg.xy
        tO.montrer();
        cOk =true;
      end
      if nargout
        varargout{1} =cOk;
      end
    end

    %----------------------
    % rendre le GUI visible
    %--------------------
    function montrer(obj)
      hA =CAnalyse.getInstance();
      obj.Fid.Vg.xy =true;
      obj.cano.setString(obj.Fid.Hdchnl.Listadname);
      set(obj.Fig, 'Units','pixels', 'Position',hA.laPosXY, 'Units','normalized' , 'Visible','on');
      set(obj.IpmnuXy, 'checked','on');
      hA.OFig.affiche();
    end

    %------------------------
    % rendre le GUI invisible
    %-------------------
    function cacher(obj)
      obj.AuRepos();
      hA =CAnalyse.getInstance();
      obj.Fid.Vg.xy =false;
      hA.OFig.affiche();
    end

    %-----------------------------
    % Cacher le GUI temporairement
    % ça peut être pour l'Ouverture d'un autre fichier
    %--------------------
    function AuRepos(obj)
      hA =CAnalyse.getInstance();
      set(obj.Fig, 'units','pixels', 'visible','off');
      hA.laPosXY =get(obj.Fig, 'Position');
      set(obj.IpmnuXy, 'checked','off');
    end

    %-------------------------------------
    % Si on Enlève un/des canaux
    % Bat, si true(on est en mode batch)
    %-------------------------------------
    function delcan(obj,lescan,Bat)
      if ~exist('Bat')
        Bat =false;
      end
      vg =obj.Fid.Vg;
      if ~isempty(lescan)
        if ~isempty(obj.XX)
          legrp(length(obj.XX)) =false;
          % on cherche la présence des canaux à effacer dans les Abcisses et Ordonnées
          for U =1:length(lescan)
            yena =find(obj.XX == lescan(U));
            if ~isempty(yena)
              legrp(yena) =true;
            end
            if ~isempty(obj.YY)
              yena =find(obj.YY == lescan(U));
              if ~isempty(yena)
                legrp(yena) =true;
              end
            end
          end
          elgrp =find(legrp);
          if (length(obj.XX) > length(obj.YY)) && (lescan(end) == obj.XX(end))
            obj.XX(end) =[];
            elgrp(end) =[];
          end
          obj.XX(elgrp) =[];
          obj.YY(elgrp) =[];
          % On décrémente les canaux supérieurs à ceux effacés
          for U =length(lescan):-1:1
            if length(obj.XX)
              yena =find(lescan(U) < obj.XX);
              if yena
                obj.XX(yena) =obj.XX(yena)-1;
              end
              if length(obj.YY)
                yena =find(lescan(U) < obj.YY);
                if yena
                  obj.YY(yena) =obj.YY(yena)-1;
                end
              end
            end
          end
          if ~Bat
            lesnoms =obj.listcanxy();
            bidon =obj.cano.getValue();
            if bidon > vg.nad
              bidon =vg.nad;
            end
            obj.cano.setValue(bidon);
            obj.cano.setString(obj.Fid.Hdchnl.Listadname);
            obj.canoXY.setValue(1);
            obj.canoXY.setString(lesnoms);
          end
          if ~isempty(obj.YY)
            vg.x =obj.XX(1);
            vg.y =obj.YY(1);
          else
            vg.x =1;
            vg.y =1;
          end
        end
      end
      if vg.xy & ~Bat
        obj.voircan();
      end
    end

    %------------------------------
    % mise à jour des listbox suite
    % à des changements de noms de canaux
    %--------------------
    function editnom(obj)
      lesnoms =obj.listcanxy();
      obj.cano.setString(obj.Fid.Hdchnl.Listadname);
      obj.canoXY.setValue(1);
      obj.canoXY.setString(lesnoms);
    end

    %--------------------------------
    % Préparation à fermer le fichier
    %-------------------
    function sauver(obj)
      vg =obj.Fid.Vg;
      vg.choixy =obj.canoXY.getValue();
      vg.x =obj.XX;
      vg.y =obj.YY;
      vg.xlim =0;
    end

    %------------------------------------
    % Retourne le handle du GUI principal
    %--------------------------
    function fig =getFigIp(obj)
      hA =CAnalyse.getInstance();
      fig =hA.OFig.fig;
    end

    %----------------------------------------
    % On a choisi d'afficher une paire X vs Y
    % on la vérifie et on affiche si tout est Ok
    %--------------------
    function voircan(obj)
      lecan =obj.canoXY.getValue();
      if isempty(obj.YY) || lecan(1) > length(obj.YY)
        return;
      end
      if lecan(end) > length(obj.YY)
        lecan(end) =[];
      end
      vg =obj.Fid.Vg;
      hdchnl =obj.Fid.Hdchnl;
      vg.x =[];
      vg.y =[];
      for i =1:length(lecan)
        vg.x(i) =obj.XX(lecan(i));
        vg.y(i) =obj.YY(lecan(i));
        if ~ (hdchnl.rate(vg.x(i),1) == hdchnl.rate(vg.y(i),1))
          disp('Incohérence entre les fréquences d''acquisition');
          return;
        end
      end
      OA =CAnalyse.getInstance();
      OA.OFig.affiche();
    end

    %---------------------------------
    % vérification des paires "X vs Y"
    %--------------------------
    function VerifieListXY(obj)
      if isempty(obj.XX)
        obj.YY =[];
      else
        while length(obj.XX) > length(obj.YY)+1
          obj.XX(end) =[];
        end
      end
    end

    %-----------------------------------------------------------------------------
    % En mode XY, on ajoute un axe du temps qui va monitorer les points à afficher
    % dans les autres fenêtres. Il nous faut savoir les limite, min et max, temporelles
    % nécessaires pour voir toutes les courbes demandées.
    %-----------------------------------
    function togglefiltmp(obj,src,event)
      vg =obj.Fid.Vg;
      vg.filtp =get(findobj('tag','IpFilTemps'),'value');
      if vg.filtp
        hndl =findobj('Tag','FilTempsMin');
        set(hndl,'enable','on');
        lemin =str2num(get(hndl,'string'));
        hndl =findobj('Tag','FilTempsMax');
        set(hndl,'enable','on');
        lemax =str2num(get(hndl,'string'));
        set(findobj('tag','IpAxeTemps'),'enable','on');
        if lemax < lemin
          return;
        end
      else
        set(findobj('Tag','FilTempsMin'),'enable','off');
        set(findobj('Tag','FilTempsMax'),'enable','off');
        set(findobj('tag','IpAxeTemps') ,'enable','off')
      end
      obj.voircan();
    end

    %-----------------------------------------------
    % Que fait-on si on clique dans le slider du GUI
    %----------------------------------
    function deroultemps(obj,src,event)
      vg =obj.Fid.Vg;
      tasse =get(findobj('Type','uicontrol','tag', 'IpAxeTemps'),'value');
      hndmin =findobj('Tag','FilTempsMin');
      hndmax =findobj('Tag','FilTempsMax');
      brnmin =str2num(get(hndmin,'string'));
      brnmax =str2num(get(hndmax,'string'));
      set(hndmin,'string',num2str(tasse));
      vg.filtpmin =tasse;
      vg.filtpmax =brnmax-brnmin+tasse;
      set(hndmax,'string',num2str(vg.filtpmax));
      obj.voircan();  
    end

    %---------------------------------------
    % Enlève/delete une paire de canaux(X,Y)
    %------------------------------
    function effacer(obj,src,event)
      lecan =obj.canoXY.getValue();
      lesx =obj.XX;
      if not(length(lesx))
        return;
      end
      lesy =obj.YY;
      if lecan(end) > length(lesy)
        lesx(lecan(end)) =[];
        lecan(end) =[];
      end
      for i =length(lecan):-1:1
        lesx(lecan(i)) =[];
        lesy(lecan(i)) =[];
      end
      obj.XX =lesx;
      obj.YY =lesy;
      obj.editnom();
      if length(lesy)
        vg.x =lesx(1);
        vg.y =lesy(1);
        figure(obj.getFigIp());
        hA =CAnalyse.getInstance();
        hA.OFig.affiche();
        figure(obj.Fig);
      end
    end

    %-----------------------------------------------
    % Enlève/delete toutes les paires de canaux(X,Y)
    %--------------------------------
    function effaceles(obj,src,event)
      obj.XX =[];
      obj.YY =[];
      lesnoms =obj.listcanxy();
      obj.canoXY.setValue(1);
      obj.canoXY.setString(lesnoms);
    end

    %------------------------------------
    % Édition des canaux Abcisse/Ordonnée
    %------------------------------
    function editcan(obj,src,event)
      if strcmp(get(obj.Fig,'SelectionType'), 'open')
        lecan =obj.cano.getValue();
        if length(obj.XX) > length(obj.YY)
          obj.YY(end+1) =lecan;
        else
          obj.XX(end+1) =lecan;
        end
        obj.editnom();
      end
    end

    %---------------------------------
    % Min et Max de l'échelle de temps
    %--------------------------------
    function edittemps(obj,src,event)
      vg =obj.Fid.Vg;
      filtpmin =str2num(get(findobj('Tag','FilTempsMin'),'string'));
      filtpmax =str2num(get(findobj('Tag','FilTempsMax'),'string'));
      if filtpmax > filtpmin
      	vg.filtpmin =filtpmin;
      	vg.filtpmax =filtpmax;
        set(findobj('tag','IpAxeTemps'),'value',vg.filtpmin);
        obj.voircan();
      else
      	%set(findobj('Tag','FilTempsMin'),'string',num2str(vg.filtpmin));
      	%set(findobj('Tag','FilTempsMax'),'string',num2str(vg.filtpmax));
      end
    end

    %---------------------------------------
    % Choix du type de marquage manuel en XY
    % Lorsque l'on clique dans l'axe pour marquer manuellement,
    % le canal pour marquer sera selon l'abcisse (X) mais la tolérance
    % (± delta) sera selon l'ordonnée (Y)
    %-------------------------------
    function marklesx(obj,src,event)
      action =get(findobj('Tag','IpMarkX'),'value');
      if action
        set(findobj('Tag','IpMarkY'),'value',0);
        obj.Fid.Vg.xymarkx =true;
      else
        set(findobj('Tag','IpMarkY'),'value',1);
        obj.Fid.Vg.xymarkx =false;
      end
    end

    %---------------------------------------
    % Choix du type de marquage manuel en XY
    % Lorsque l'on clique dans l'axe pour marquer manuellement,
    % le canal pour marquer sera selon l'ordonnée (Y) mais la tolérance
    % (± delta) sera selon l'abcisse (X)
    %-------------------------------
    function marklesy(obj,src,event)
      action =get(findobj('Tag','IpMarkY'),'value');
      if action
        set(findobj('Tag','IpMarkX'),'value',0);
        obj.Fid.Vg.xymarkx=false;
      else
        set(findobj('Tag','IpMarkX'),'value',1);
        obj.Fid.Vg.xymarkx=true;
      end
    end

    %------------------------------------
    % callback pour modifier la tolérance
    % pour le marquage manuelle
    %-----------------------------------
    function marklesecart(obj,src,event)
      enx =str2num(get(findobj('Tag','IpMarkXEcart'),'string'));
      eny =str2num(get(findobj('Tag','IpMarkYEcart'),'string'));
      vg =obj.Fid.Vg;
      if ~isempty(enx)
        vg.xymarkxecart =enx;
      else
        set(findobj('Tag','IpMarkXEcart'),'string',num2str(vg.xymarkxecart));
      end
      if ~isempty(eny)
        vg.xymarkyecart =eny;
      else
        set(findobj('Tag','IpMarkYEcart'),'string',num2str(vg.xymarkyecart));
      end
    end

  end   % methods

  methods (Access =protected)

    %-----------------------------------------------
    % fabrication de la liste des paires canux(X, Y)
    %-------------------------------
    function onsort = listcanxy(obj)
      onsort=[];
    	hdcnnl =obj.Fid.Hdchnl;
    	obj.VerifieListXY();
      if ~isempty(obj.YY)
        for ii =1:length(obj.YY)
          a =deblank(hdcnnl.adname{obj.XX(ii)});
          b =deblank(hdcnnl.adname{obj.YY(ii)});
          onsort{ii} =[a ' ---***--- ' b];
        end
      end
      if length(obj.XX) > length(obj.YY)
        onsort{end+1} =deblank(hdcnnl.adname{obj.XX(end)});
      end
      if isempty(onsort)
        onsort ={'vide'};
      end
    end

  end  % methods (Access =protected)
end % classdef
