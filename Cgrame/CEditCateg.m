%
% Classe CEditCateg
% 
% Interface pour �diter les categories
%
% vg.defniv nous sert de niveau par d�faut pour indiquer l'appartenance
% des essais dans les diff�rentes fen�tres.
%
classdef CEditCateg < handle

  properties
    hF =[];    % handle du CFichierAnalyse qui contient les cat�gories � traiter
    hFig =[];  % handle de la fen�tre
  end

  methods

    %------------
    % CONSTRUCTOR
    %----------------------------
    function obj =CEditCateg(status)
      hA =CAnalyse.getInstance();
      obj.hF =hA.findcurfich();
      if status
      	GUIEditCateg(obj);
      end
    end

    %-----------
    % DESTRUCTOR
    %-------------------
    function delete(obj)
      if ishandle(obj.hFig)
      	delete(obj.hFig);
      end
    end

    %------------------------------------------
    % Callback du menu "Reb�tir les cat�gories"
    %-----------------------------
    function RebatirCategorie(obj)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
      catego =obj.hF.Catego;
   	  tlet =false;
      for U =1:vg.niveau
        if strcmpi(deblank(catego.Dato(1,U,1).nom),'stimulus')
    	  tlet =true;
    	  break;
        end
      end
      if tlet
        elboton =questdlg('Conserver le Niveau Stimulus (et ses cat�gories)?',...
                          'Stimulus','Oui','Non','Annuler','Oui');
        switch elboton
        case 'Oui'
          catego.Majstim();
        case 'Annuler'
          return;
        end
      end
      catego.RebatirCategorie();
      obj.hF.editcats();
      obj.hF.editess();
    end

    %-----------------------------------------------------------
    % Callback pour changer le niveau par d�faut qui est utilis�
    % pour la nomenclature des essais dans les listbox.
    %------------------------------------
    function DefaultNiveau(obj,src,event)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
      catego =obj.hF.Catego;
      vg.defniv =get(findobj('tag','ECNiveauDefaut'),'value');
      leniv =get(findobj('tag','ECListeNiveau'),'Value');
      lacat =get(findobj('tag','ECListeCategorie'),'Value');
      lessai =catego.BatirListeEssaiLibre(leniv);
      set(findobj('tag','ECEssaiDisponible'),'String',lessai,'Value',1);
      lessaib =catego.BatirListeEssaiAssocie(leniv,lacat);
      set(findobj('tag','ECEssaiAttribue'),'String',lessaib,'Value',1);
      vg.sauve =1;
    end

    %----------------------------------------
    % Callback pour ajouter un nouveau niveau
    %------------------------------------
    function AjouterNiveau(obj,src,event)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
      catego =obj.hF.Catego;
      pabel =deblank(get(findobj('tag','ECNouveauNiveau'),'String'));
      if ~isempty(pabel)
        vg.niveau =vg.niveau+1;
        catego.Dato(1,vg.niveau,1).ness =vg.ess;
        catego.Dato(1,vg.niveau,1).nom =pabel;
        catego.Dato(1,vg.niveau,1).ncat =0;
        catego.Dato(1,vg.niveau,1).ess =ones(1, vg.ess);  % � la cr�ation ils n'appartiennent � personne
        lessai =catego.BatirListeEssaiLibre(vg.niveau);
        set(findobj('tag','ECEssaiDisponible'),'String',lessai);
        set(findobj('tag','ECEssaiAttribue'),'String','0');
        for i =1:vg.niveau
          listniv{i} =catego.Dato(1,i,1).nom;
        end
        set(findobj('tag','ECListeNiveau'),'String',listniv,'Value',vg.niveau);
        set(findobj('tag','ECNiveauDefaut'),'String',listniv,'Value',vg.defniv);
        set(findobj('tag','ECListeCategorie'),'String','.','Value',1);
        set(findobj('tag','ECNouveauNiveau'),'String','');
        vg.sauve =1;
      end
    end

    %---------------------------------------------
    % Callback pour ajouter une nouvelle cat�gorie
    %---------------------------------------
    function AjouterCategorie(obj,src,event)
      vg =obj.hF.Vg;
      hdchnl =obj.hF.Hdchnl;
      catego =obj.hF.Catego;
      pabel =deblank(get(findobj('tag','ECNouvelCategorie'),'String'));
      if ~isempty(pabel)
        leniv =get(findobj('tag','ECListeNiveau'),'Value');
        catego.Dato(1,leniv,1).ncat =catego.Dato(1,leniv,1).ncat+1;
        catego.Dato(2,leniv,catego.Dato(1,leniv,1).ncat).nom =pabel;
        catego.Dato(2,leniv,catego.Dato(1,leniv,1).ncat).ncat =0;
        catego.Dato(2,leniv,catego.Dato(1,leniv,1).ncat).ess([1:vg.ess]) =0;  % � la cr�ation ils sont vides
        set(findobj('tag','ECEssaiAttribue'),'String','0');
        for i =1:catego.Dato(1,leniv,1).ncat
          listcat{i} =catego.Dato(2,leniv,i).nom;
        end
        set(findobj('tag','ECListeCategorie'), 'String',listcat, 'Value',catego.Dato(1,leniv,1).ncat);
        set(findobj('tag','ECNouvelCategorie') ,'String','');
        vg.sauve =1;
      end
    end

    %----------------------------------------
    % Callback pour changer le niveau courant
    % En changeant le niveau, il faut r�-afficher les
    % cat�gories et essais associ�s.
    %-----------------------------------
    function ChangeNiveau(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'),'Value');
        if catego.Dato(1,leniv,1).ncat
          for i =1:catego.Dato(1,leniv,1).ncat
            lacat{i} =catego.Dato(2,leniv,i).nom;
          end
          set(findobj('tag','ECListeCategorie'), 'String',lacat, 'Value',1);
          lessaib =catego.BatirListeEssaiAssocie(leniv,1);
          set(findobj('tag','ECEssaiAttribue'), 'String',lessaib, 'Value',1);
        else
          set(findobj('tag','ECListeCategorie'), 'String','.', 'Value',1);
          set(findobj('tag','ECEssaiAttribue'), 'String','0', 'Value',1);
        end
        lessai =catego.BatirListeEssaiLibre(leniv);
        set(findobj('tag','ECEssaiDisponible'), 'String',lessai, 'Value',1);
      end
    end

    %--------------------------------------------
    % Callback pour changer la cat�gorie courante
    % En changeant la cat�gorie, il faut r�-afficher
    % les essais associ�s.
    %--------------------------------------
    function ChangeCategorie(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'),'Value');
        if catego.Dato(1,leniv,1).ncat
          lacat =get(findobj('tag','ECListeCategorie'),'Value');
          lessaib =catego.BatirListeEssaiAssocie(leniv,lacat);
          set(findobj('tag','ECEssaiAttribue'), 'String',lessaib, 'Value',1);
        end
      end
    end

    %--------------------------------
    % Callback pour enlever un niveau
    %------------------------------------
    function EnleverNiveau(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'),'Value');
        vg.niveau =vg.niveau-1;
        catego.Dato(:,leniv,:) =[];
        vg.sauve =1;
        if vg.niveau
          if vg.defniv > vg.niveau
            vg.defniv =vg.niveau;
          end
          for i =1:vg.niveau
            listniv{i} =catego.Dato(1,i,1).nom;
          end
          set(findobj('tag','ECListeNiveau'), 'String',listniv, 'Value',1);
          obj.ChangeNiveau();
        else
          listniv ='.';
          vg.defniv =1;
          set(findobj('tag','ECListeNiveau'), 'String',listniv, 'Value',1);
          set(findobj('tag','ECListeCategorie'), 'String','.', 'Value',1);
          set(findobj('tag','ECEssaiDisponible'), 'String','0');
          set(findobj('tag','ECEssaiAttribue'), 'String','0');
        end
        set(findobj('tag','ECNiveauDefaut'), 'String',listniv, 'Value',vg.defniv);
      end
    end

    %------------------------------------------
    % Callback pour modifier le nom des niveaux
    %------------------------------------
    function ModifieNiveau(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        for i =1:vg.niveau
          prom{i} =['Niveau ', num2str(i)];
          les4{i} =catego.Dato(1,i,1).nom;
        end
        foo =inputdlg(prom,'Modification',1,les4,'off');
        if ~isempty(foo)
          for i =1:vg.niveau
            catego.Dato(1,i,1).nom =foo{i};
          end
          for i =1:vg.niveau
            listniv{i} =catego.Dato(1,i,1).nom;
          end
          set(findobj('tag','ECListeNiveau'), 'String',listniv);
          obj.ChangeNiveau();
          set(findobj('tag','ECNiveauDefaut'), 'String',listniv, 'Value',vg.defniv);
        end
      end
    end

    %------------------------------------
    % Callback pour enlever une cat�gorie
    %--------------------------------------
    function EnleverCategorie(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'), 'Value');
        if catego.Dato(1,leniv,1).ncat
          lacat =get(findobj('tag','ECListeCategorie'), 'Value');
          catego.Dato(1,leniv,1).ncat =catego.Dato(1,leniv,1).ncat - 1;
          if catego.Dato(2,leniv,lacat).ncat
            for i =1:vg.ess
              if catego.Dato(2,leniv,lacat).ess(i)
                catego.Dato(1,leniv,1).ess(i) =1;
                catego.Dato(1,leniv,1).ness =catego.Dato(1,leniv,1).ness+1;
              end
            end
          end
          for i =lacat:catego.Dato(1,leniv,1).ncat        % Comme on utilise une structure pour la 
            catego.Dato(2,leniv,i) =catego.Dato(2,leniv,i+1);  % gestion des cat, on doit proc�der ainsi
          end
          vg.sauve =1;
          if catego.Dato(1,leniv,1).ncat
            for i =1:catego.Dato(1,leniv,1).ncat
              lescat{i} =catego.Dato(2,leniv,i).nom;
            end
            set(findobj('tag','ECListeCategorie'), 'String',lescat, 'Value',1);
          else
            set(findobj('tag','ECListeCategorie'), 'String','.', 'Value',1);
          end
          obj.ChangeNiveau();
        end
      end
    end

    %---------------------------------------------
    % Callback pour modifier le nom des cat�gories
    %---------------------------------------
    function ModifieCategorie(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'), 'Value');
        if catego.Dato(1,leniv,1).ncat
          for i =1:catego.Dato(1,leniv,1).ncat
            prom{i} =['Cat�gorie ', num2str(i)];
            les4{i} =catego.Dato(2,leniv,i).nom;
          end
          foo =inputdlg(prom,'Modification',1,les4,'off');
          if ~isempty(foo)
            for i =1:catego.Dato(1,leniv,1).ncat
              catego.Dato(2,leniv,i).nom =foo{i};
            end
            for i =1:catego.Dato(1,leniv,1).ncat
              lescat{i} =catego.Dato(2,leniv,i).nom;
            end
            set(findobj('tag','ECListeCategorie'), 'String',lescat);
            obj.ChangeNiveau();
          end
        end
      end
    end

    %-------------------------------------------------
    % Callback pour ajouter des essais � une cat�gorie
    %-----------------------------------
    function AjouterEssai(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'), 'Value');
        if catego.Dato(1,leniv,1).ncat
          lacat =get(findobj('tag','ECListeCategorie'), 'Value');
          if catego.Dato(1,leniv,1).ness
            lalist =get(findobj('tag','ECEssaiDisponible'), 'Value')';  %'
            j =0;k =0;
            for i =1:size(lalist,1)
              while lalist(i) ~= k
                j =j+1;
                if catego.Dato(1,leniv,1).ess(j)
                  k =k+1;
                end
              end
              catego.Dato(1,leniv,1).ess(j) =0;
              catego.Dato(1,leniv,1).ness =catego.Dato(1,leniv,1).ness-1;
              catego.Dato(2,leniv,lacat).ess(j) =1;
              catego.Dato(2,leniv,lacat).ncat =catego.Dato(2,leniv,lacat).ncat+1;
            end
            % mise � jour de la listbox des essais disponibles
            lessai =catego.BatirListeEssaiLibre(leniv);
            set(findobj('tag','ECEssaiDisponible'), 'String',lessai, 'Value',1);
            % mise � jour de la listbox des essais attribu�s
            lessaib =catego.BatirListeEssaiAssocie(leniv,lacat);
            set(findobj('tag','ECEssaiAttribue'), 'String',lessaib, 'Value',1);
            vg.sauve =1;
          end
        end
      end
    end

    %-------------------------------------------------
    % Callback pour enlever des essais � une cat�gorie
    %-----------------------------------
    function EnleverEssai(obj,src,event)
      vg =obj.hF.Vg;
      if vg.niveau
        hdchnl =obj.hF.Hdchnl;
        catego =obj.hF.Catego;
        leniv =get(findobj('tag','ECListeNiveau'), 'Value');
        if catego.Dato(1,leniv,1).ncat
          lacat =get(findobj('tag','ECListeCategorie'), 'Value');
          if catego.Dato(2,leniv,lacat).ncat
            lalist =get(findobj('tag','ECEssaiAttribue'), 'Value')';  %'
            j =0;k =0;
            for i =1:size(lalist,1)
              while lalist(i) ~= k
                j =j+1;
                if catego.Dato(2,leniv,lacat).ess(j)
                  k =k+1;
                end
              end
              catego.Dato(1,leniv,1).ess(j) =1;
              catego.Dato(1,leniv,1).ness =catego.Dato(1,leniv,1).ness+1;
              catego.Dato(2,leniv,lacat).ess(j) =0;
              catego.Dato(2,leniv,lacat).ncat =catego.Dato(2,leniv,lacat).ncat-1;
            end
            % mise � jour de la listbox des essais disponibles
            lessai =catego.BatirListeEssaiLibre(leniv);
            set(findobj('tag','ECEssaiDisponible'), 'String',lessai, 'Value',1);
            % mise � jour de la listbox des essais attribu�s
            lessaib =catego.BatirListeEssaiAssocie(leniv,lacat);
            set(findobj('tag','ECEssaiAttribue'), 'String',lessaib, 'Value',1);
            vg.sauve =1;
          end
        end
      end
    end

    %--------------------------
    % C'est fini, on ferme tout
    %-------------------------------
    function Terminus(obj,src,event)
      if ~obj.hF.Vg.niveau
      	obj.hF.Vg.affniv =false;
      end
      hA =CAnalyse.getInstance();
      delete(obj.hFig);
      figure(hA.OFig.fig);
      obj.hF.editcats();
      obj.hF.editess();
    end

  end  % methods
end  % classdef

%
% catego.Dato(1,niveau*,1)
%                   .nom     -> nom du niveau
%                   .ess(n)  -> 1 si l'essai  n  est encore disponible dans ce niveau
%                   .ness    -> Nb d'essai encore disponible pour ce niveau
%                   .ncat    -> Nb de cat�gorie pour ce niveau
% catego.Dato(2,niveau*,cat�gorie*)
%                   .nom     -> nom de la cat�gorie
%                   .ess(n)  -> 1 si l'essai  n  appartient � cette cat�gorie
%                   .ncat    -> Nb d'essai dans cette cat�gorie
%
%___________________________________________________________
% ON POURRAIT UTILISER UNE FORMULATION PLUS INTUIVE COMME...
%
% catego(niveau*)        -> Structure des niveaux
%               .nom     -> nom du niveau
%               .ess(n)  -> 1 si l'essai  n  est encore disponible dans ce niveau
%               .ness    -> Nb d'essai encore disponible pour ce niveau
%               .ncat    -> Nb de cat�gorie pour ce niveau
%               .cat(cat�gorie*)       -> Structure des cat�gories
%                              .nom    -> nom de la cat�gorie
%                              .ess(n) -> 1 si l'essai  n  appartient � cette cat�gorie
%                              .ncat   -> Nb d'essai dans cette cat�gorie
%
% *ou niveau et cat�gorie sont des entiers
%
