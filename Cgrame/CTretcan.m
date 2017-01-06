%
% Classe CTretcan
%
% Traitement de Canal
%
% GUI pour simuler une "calculatrice". nous permettra de faire
% des opérations sur un seul canal/essai ou sur un canal(tous les essai).
% ATTENTION
% la calculatrice fonctionne en RPN... informez-vous!
%
% MEK - juillet 2009
%
classdef CTretcan < handle

  properties
    largeur =150;
    lebord1 =25;
    lespts =false;                % est-ce que l'on garde les pts si on ré-écrit sur un canal
    tous =[];
    fid =[];
    Fig =[];                      % handle de la fenêtre
    hErr =[];                     % handle des message d'erreur Multiligue...
    hdr =[];                      % mappage de hdchnl, avec les canaux et essais utiles
    lapil =[];
    lastring ='';                 % string contenant la commande
    erreur =[];                   % rapporte les problèmes
    cansortie =[];                % canal de sortie
    nomsortie =[];                % nom du canal de sortie
    lesvirg =[];
    lestri =[];                   % essais sélectionnés
    pvirg =[];
    index =[];                    % nombre d'entrée dans lapil
    operation =[];                % 1- Add., 2- Soust., 3- Mult, 4- div.
                                  % 5- Sqrt, 6- Expos., 7- Dist 1D, 8- Dist 2D, 9- Dist 3D
                                  % 10- Sin, 11- Asin, 12- cos, 13- Acos, 14- Tan, 15- Atan
                                  % 16-Abs, 17-Long, 18-Diff, 19-Csum
    matriss =0;                   % matriss(i,j)
                                  %           j --> l'index de référence de la pile
                                  %         i   --> 1  canal ou réél
                                  %                 2  si réél, valeur du réél
                                  %                 3  si canal, fréquence d'acquisition  (hdr.rate
                                  %                 4  si canal, nsmpl                    (hdr.nsmpls
  end  % properties

  methods

    %------------
    % CONSTRUCTOR
    %----------------------
    function tO =CTretcan()
      OA =CAnalyse.getInstance();
      tO.fid =OA.findcurfich();
      tO.Fig =GuiTretcan(tO);
      tO.hErr =CErrMLTretcan();
    end

    %-------------------------------------------------
    % On s'assure que toutes les variables sont nulles
    % ou vides avant de commencer les calculs
    %----------------------
    function miseazero(obj)
      % Est-ce que l'on travail sur tous les essais ???
      obj.tous =get(findobj('tag','CBess'),'Value');
      if obj.tous
        obj.lestri =(1:obj.fid.Vg.ess);               % liste des essais à traiter
      else
        obj.lestri =get(findobj('tag','LBess'),'Value');
      end
      obj.hdr =[];
      obj.corrige();
      obj.lastring ='';
      obj.erreur =0;    
      obj.cansortie =[]; 
      obj.nomsortie =''; 
      obj.lesvirg =[];
      obj.pvirg =0;                      % on initialise le pointeur pour la position des virg
      obj.index =0;                      % canal util dans matriss
      obj.matriss =[];
    end

    %-----------------------------------
    % on a cliqué le bouton "au travail"
    %--------------------------------
    function autravail(obj,src,event)
      % ON S'ASSURE D'AVOIR DES VARIABLES VIDES AU DÉPART
      obj.miseazero();
      vg =obj.fid.Vg;
      % LE NOMBRE DE VIRGULE DOIT "FITTER"
      obj.checkvirg();
      % IMPOSE T-ON UN CANAL DE SORTIE
      obj.checkcansortie();
      if obj.erreur
        return;
      end
      if obj.cansortie > vg.nad
        werreur(obj.hErr, 3, obj.hErr.case3m01);
        return;
      end
      % EMPLACEMENT DES VIRGULES DANS LA STRING
      obj.lesvirg =findstr(obj.lastring,',');
      if length(obj.lesvirg) < 2
        % IL N'Y A QU'UN SEUL CANAL ET RIEN D'AUTRE
        werreur(obj.hErr, 2);
        return;
      end
      %
      %  L'idée, c'est:
      %    décortiquer la string en sous-string (ss) séparée par les virgules.
      %    faire la reconnaissance de chacune des ss.
      %    Canal, Nombre, Opérateur ou '='
      %    Si la sous-string n'est pas un objet canal ou Nombre ou '='
      %      on check le nombre d'objet que l'opérateur nécessite
      %      on exécute l'opération
      %      on remet la réponse dans le buffer
      %      on recommence.
      %
      while obj.pvirg < length(obj.lesvirg)    % On passe toutes les ss
        testeur =obj.anastring();              % testeur =1 si on a un opérateur
        if obj.erreur
          obj.corrige();                       % Vide la Pile
          return
        elseif testeur
          OW =CWoper(obj);
          delete(OW);
          if obj.erreur
            obj.corrige();
            return
          end
        end
      end
      if obj.index > 1
        obj.corrige();
        werreur(obj.hErr, 3, obj.hErr.case3m02);
        return;
      end
      obj.ajustage();
      obj.fid.Hdchnl.ResetListAdname();
      set(findobj('tag','LBcan'),'String',obj.fid.Hdchnl.Listadname);
      vg.sauve =1;
      vg.valeur =0;
    end

    %--------------------------------------------------------------
    %  fonction pour vérifier si il y a un canal de sortie, si oui:
    %  on évalue la string après le signe '='.
    %---------------------------
    function checkcansortie(obj)
      obj.cansortie =0;
      obj.nomsortie ='';
      ss =findstr(obj.lastring, '=');         % Cherche le signe égal
      if ~isempty(ss)                         % siy'enaun
        if length(obj.lastring) < ss+3
          return;
        end
        lastring =obj.lastring(ss+2:end-1);
        obj.lastring(ss:end) =[];
        virgul =findstr(lastring, ',');
        if ~isempty(virgul)
          lechif =str2double(lastring(2:virgul(1)-1));
          if strcmpi(lastring(1),'c') && ~isempty(lechif) && lechif > 0
            obj.cansortie =lechif;
          else
            obj.erreur =1;
            werreur(obj.hErr, 3,[obj.hErr.case3m03 lastring]);
            return;
          end
          lastring =lastring(virgul(1)+1:end);
          if ~isempty(lastring)
            obj.nomsortie =lastring;
          end
        elseif length(lastring) == 1
          obj.nomsortie =lastring;
        else
          lechif =str2double(lastring(2:end));
          if strcmpi(lastring(1),'c') && ~isempty(lechif) && lechif > 0
            obj.cansortie =lechif;
          else
            obj.nomsortie =lastring;
          end
        end
      end
    end

    %-----------------------------------------------------------------
    % Fonction pour découper la string en no de canal, en nombre réel,
    % en opérateur 45=-, 46=., 43=+, 48 à 57: 0-9,
    % ou fonction (sortie alors sera = 1).
    %-------------------------------
    function sortie = anastring(obj)
      vg =obj.fid.Vg;
      hdchnl =obj.fid.Hdchnl;
      sortie =0;
      % LONGUEUR DE LA COMMANDE
      elnumero =length(obj.lestri);
      obj.pvirg =obj.pvirg+1;
      % ON PREND LA SOUS-STRING ENTRE DEUX VIRGULES
      if obj.pvirg > 1
        lemot =obj.lastring(obj.lesvirg(obj.pvirg-1)+1:obj.lesvirg(obj.pvirg)-1);
      else
        lemot =obj.lastring(1:obj.lesvirg(obj.pvirg)-1);     % première ss
      end
      % VALEUR ASCII DU PREMIER CARACTÈRE DE LA SOUS-STRING
      lm =int8(lemot(1));
    %
    % ATTENTION si on implémente une fonction qui commence par "C", il faudra la mettre
    %           au début pour enlever l'ambiguité avec le "C" de canal
      if strncmpi(lemot,'cos',3)                    % Cosinus
        obj.operation =12;
        sortie =1;
      elseif strncmpi(lemot,'csum',4)               % Sommation
        obj.operation =19;
        sortie =1;
      elseif strncmpi(lemot,'c',1)                  % C'est un canal
        if length(lemot) > 1
          % lec CONTIENDRA LA VALEUR NUMÉRIQUE DU CANAL
        	lec =str2double(lemot(2:end));
        	if isnan(lec)
            werreur(obj.hErr, 3, [obj.hErr.case3m04 lemot]);
            obj.erreur = 1;
            return
          end
        else
          werreur(obj.hErr, 3, [obj.hErr.case3m04 lemot]);
          obj.erreur =1;
          return
        end
        if lec > vg.nad
          obj.erreur =1;
          return
        end
        obj.index =obj.index+1;
        obj.matriss(1,obj.index) =lec;
        obj.hdr.rate(obj.index,1:elnumero) =hdchnl.rate(lec,obj.lestri);
        obj.hdr.nsmpls(obj.index,1:elnumero) =hdchnl.nsmpls(lec,obj.lestri);
        obj.lapil{obj.index} =CDtchnl();
        if obj.tous
        	obj.fid.getcanal(obj.lapil{obj.index}, lec);
        else
        	obj.fid.getcaness(obj.lapil{obj.index}, obj.lestri, lec);
        end
        sortie =0;
      elseif lemot == '+'
        obj.operation =1;
        sortie =1;
      elseif lemot == '-'
        obj.operation =2;
        sortie =1;
      elseif lemot == '*'
        obj.operation =3;
        sortie =1;
      elseif lemot == '/'
        obj.operation =4;
        sortie =1;
      elseif strcmpi(deblank(lemot),'pi')
        obj.index =obj.index+1;
        obj.matriss(1,obj.index) =0;
        obj.matriss(2,obj.index) =pi;
        obj.lapil{obj.index} =0;
        obj.hdr.rate(obj.index,1) =0;
        obj.hdr.nsmpls(obj.index,1) =1;
        sortie =0;
      elseif lm ==45|| lm ==43|| lm ==46|| (lm >47 && lm <58)  % pas un canal mais une valeur Réel
      	if isnan(str2double(lemot))
          obj.erreur =1;
          return
        end
        obj.index =obj.index+1;
        obj.matriss(1,obj.index) =0;
        obj.matriss(2,obj.index) =str2double(lemot);
        obj.lapil{obj.index} =0;
        obj.hdr.rate(obj.index,1) =0;
        obj.hdr.nsmpls(obj.index,1) =1;
        sortie =0;
      elseif strncmpi(lemot,'sqrt',4)         % Racine Carrée
        obj.operation =5;
        sortie =1;
      elseif strncmpi(lemot,'exp',3)          % Exposant(x)
        obj.operation =6;
        sortie =1;
      elseif strncmpi(lemot,'dist2',5)        % Distance 2D
        obj.operation =8;
        sortie =1;
      elseif strncmpi(lemot,'dist3',5)        % Distance 3D
        obj.operation =9;
        sortie =1;
      elseif strncmpi(lemot,'dist',4)         % Distance 1D
        obj.operation =7;
        sortie =1;
      elseif strncmpi(lemot,'sin',3)          % Sinus
        obj.operation =10;
        sortie =1;
      elseif strncmpi(lemot,'asin',4)         % Arc Sinus
        obj.operation =11;
        sortie =1;
      elseif strncmpi(lemot,'acos',4)         % Arc Cosinus
        obj.operation =13;
        sortie =1;
      elseif strncmpi(lemot,'tan',3)          % Tangeante
        obj.operation =14;
        sortie =1;
      elseif strncmpi(lemot,'atan',4)         % Arc Tangeante
        obj.operation =15;
        sortie =1;
      elseif strncmpi(lemot,'abs',3)          % Abs
        obj.operation =16;
        sortie =1;
      elseif strncmpi(lemot,'long',4)         % Longueur Vectoriel
        obj.operation =17;
        sortie =1;
      elseif strncmpi(lemot,'diff',4)         % Différentiel
        obj.operation =18;
        sortie =1;
      else
        werreur(obj.hErr, 3, obj.hErr.case3m05);
        obj.erreur =1;
      end
    end

    %--------------------------------------------
    % Fonction pour gérer le retour de la réponse
    %_____________________________________________
    % quiero decir un pequeño  (ad-justage...  :-)
    % que es un chiste (querido padre...)
    %---------------------
    function ajustage(obj)
      vg =obj.fid.Vg;
      hdchnl =obj.fid.Hdchnl;
      if obj.matriss(1,1) == 0
        %________________________
        % la réponse est un RÉÉL
        %------------------------
        set(findobj('tag','Elastring'),'String',[num2str(obj.matriss(2,1)) ',']);
        return;
      end
      nsmpl =size(obj.lapil{1}.Dato.(obj.lapil{1}.Nom),1);
      if obj.cansortie
      	if obj.tous
      		obj.fid.setcanal(obj.lapil{1}, obj.cansortie);
      	else
      		obj.fid.setcaness(obj.lapil{1}, obj.lestri, obj.cansortie);
      	end
        if ~isempty(obj.nomsortie)
          nomcan =obj.nomsortie;
        else
          nomcan =hdchnl.adname{obj.cansortie};
        end
        if obj.lespts == false
          hdchnl.npoints(obj.cansortie,obj.lestri) =0;
          hdchnl.point(obj.cansortie,obj.lestri) =0;
        end
      else
      	hdchnl.duplic(1);
        vg.nad =vg.nad+1;
        obj.cansortie =vg.nad;
      	if obj.tous
      		obj.fid.setcanal(obj.lapil{1}, obj.cansortie);
      	else
      		dato =zeros(nsmpl,vg.ess);
      		dato(1:nsmpl,obj.lestri) =obj.lapil{1}.Dato.(obj.lapil{1}.Nom);
      		obj.lapil{1}.Dato.(obj.lapil{1}.Nom) =dato;
      		obj.fid.setcanal(obj.lapil{1}, obj.cansortie);
      	end
        if ~isempty(obj.nomsortie)
          nomcan =obj.nomsortie;
        else
          nomcan ='Réponse du traitement';
        end
        hdchnl.rate(vg.nad,:) =1;
        hdchnl.nsmpls(vg.nad,:) =1;
        hdchnl.sweeptime(vg.nad,:) =1;
        hdchnl.npoints(obj.cansortie,obj.lestri) =0;
        hdchnl.point(obj.cansortie,obj.lestri) =0;
      end
      hdchnl.rate(obj.cansortie,obj.lestri) =obj.hdr.rate(1,:);
      hdchnl.nsmpls(obj.cansortie,obj.lestri) =obj.hdr.nsmpls(1,:);
      hdchnl.sweeptime(obj.cansortie,obj.lestri) =obj.hdr.nsmpls(1,:)./obj.hdr.rate(1,:);
      cccc =get(findobj('tag','Elastring'),'String');
      hdchnl.adname{obj.cansortie} =nomcan;
      for U =1:length(obj.lestri)
        hdchnl.comment{obj.cansortie, obj.lestri(U)} =cccc;
        hdchnl.max(obj.cansortie, obj.lestri(U)) =max(obj.lapil{1}.Dato.(obj.lapil{1}.Nom)(1:obj.hdr.nsmpls(1,U),U));
        hdchnl.min(obj.cansortie, obj.lestri(U)) =min(obj.lapil{1}.Dato.(obj.lapil{1}.Nom)(1:obj.hdr.nsmpls(1,U),U));
      end
      obj.fid.lesess();
      obj.fid.lescats();
      set(findobj('tag','Elastring'),'String','');
    end

    %------------------------------------
    % si on prend tous les essais ou non,
    % on doit afficher les fen. cat et ess
    %-----------------------------
    function affess(obj,src,event)
      lapos =get(gcf,'position');
      if get(findobj('tag','CBess'),'Value')
        lapos(3) =lapos(3)-obj.largeur-obj.lebord1-5;
      else
        lapos(3) =lapos(3)+obj.largeur+obj.lebord1+5;
      end
      set(gcf,'position',lapos);
    end

    %------------------------------------------
    % si on travaille par catégorie ce callback
    % sera appelé pour le choix de celle-ci
    %------------------------------
    function affess2(obj,src,event)
      vg =obj.fid.Vg;
      catego =obj.fid.Catego;
      lalist =get(findobj('tag','LBcat'),'Value');
      lamat =zeros(vg.niveau,vg.ess);
      a =zeros(vg.niveau);
      niv =1;
      tot =catego.Dato(1,1,1).ncat;
      for i =1:length(lalist)
        while lalist(i) > tot
          niv =niv+1;
          tot =tot+catego.Dato(1,niv,1).ncat;
        end
        a(niv) =a(niv)+1;
        lacat =lalist(i)-(tot-catego.Dato(1,niv,1).ncat);
        lamat(niv,:) =lamat(niv,:)+catego.Dato(2,niv,lacat).ess(:)'; %'
      end
      final =ones(vg.ess,1);
      for i =1:vg.niveau
        if a(i)
          for j =1:vg.ess
            final(j,1) =final(j,1) & lamat(i,j);
          end
        end
      end
      if max(final) >0
        [lestri, vide] =find(final);
        set(findobj('tag','LBess'),'Value',lestri);
      end
    end

    %------------------------------------------------
    % callback pour ajouter le numéro du canal choisi
    %-----------------------------
    function affcan(obj,src,event)
      obj.checkvirg();
      lecan =get(src,'Value');
      obj.lastring =[obj.lastring, 'C', int2str(lecan), ','];
      obj.afflastring();
    end

    %----------------------------------------------
    % Callback
    % synchronise la propriété "lespts" avec le GUI
    %------------------------------------
    function GarderPoints(tO, src, event)
      tO.lespts =get(src, 'Value');
    end

    %-------------------------------------------------------------------
    % Dans chacune des propriétés "UserData" des boutons de ce GUI, on y
    % a placé la valeur "utilisable" pour fabriquer la commande.
    % ici on ajoute pas de virgule.
    %-------------------------------
    function latouche(obj,src,event)
      lemot =get(src, 'UserData');
      obj.lastring =[get(findobj('tag','Elastring'),'String') lemot];
      obj.afflastring();
    end

    %-------------------------------------------------------------------
    % Dans chacune des propriétés "UserData" des boutons de ce GUI, on y
    % a placé la valeur "utilisable" pour fabriquer la commande.
    % ici on ajoute une virgule.
    %---------------------------------------
    function latoucheplusvirg(obj,src,event)
      lemot =get(src, 'UserData');
      obj.checkvirg();
      obj.lastring =[obj.lastring lemot ','];
      obj.afflastring();
    end

    %---------------------------------------------------
    % Callback pour ajouter une fonction trigonométrique
    %---------------------------------------
    function affichfoncttrigo(obj,src,event)
      lemot =get(src, 'UserData');
      prefix ='';
      if get(findobj('tag','TraitInvFncTrig'),'value')
        % Si le bouton "fonction trigo inverse" est sélectionné
      	prefix ='a';
      end
      obj.checkvirg();
      obj.lastring =[obj.lastring prefix lemot ','];
      obj.afflastring();
    end

    %--------------------------------------------
    % affiche la propriété "lastring" dans le GUI
    %------------------------
    function afflastring(obj)
      set(findobj('tag','Elastring'), 'String', obj.lastring);
    end

    %-------------------------------------------------------------
    %  fonction pour vérifier si il y a des espaces ou une virgule
    %  à la fin de la string, on les enlève puis on ajoute une virg.
    %----------------------
    function checkvirg(obj)
      % ON COMMENCE PAR LIRE LA LIGNE DE COMMANDE ET ON AJOUTE UNE VIRGULE
      lastring =[get(findobj('tag','Elastring'),'String') ','];
      % ON ENLÈVE LES ESPACE SI ESPACE IL Y A
      ok =regexp(lastring, '\s');
      if ~isempty(ok)
        lastring(ok) =[];
      end
      % ON ENLÈVE LES VIRGULES RÉPÉTÉS DE SUITE
      ok =regexp(lastring, ',,');
      while ok
        lastring(ok) =[];
        ok =regexp(lastring, ',,');
      end
      % DE MÊME, SI LA COMMANDE COMMENCE PAR UNE VIRGULE, ON L'ENLÈVE
      if lastring(1) == ','
        lastring(1) =[];
      end
      % SI Y RESTE SEULEMENT 1 CARACTÈRE: C'EST NOTRE VIRGULE AJOUTÉ CI-HAUT...
      if length(lastring) < 2
        lastring =[];
      end
      obj.lastring =lastring;
    end

    %------------------
    % terminus on ferme
    %-----------------------------
    function fermer(obj,src,event)
      obj.laferme();
    end

    %----------------
    % on vide la pile
    %--------------------
    function corrige(obj)
      for U =1:length(obj.lapil)
        if (obj.lapil{U} ~= 0) && isvalid(obj.lapil{U})
        	delete(obj.lapil{U});
        end
      end
      obj.lapil =[];
    end

    %----------------------------
    % on casse tout, GUI et objet
    %--------------------
    function laferme(obj)
      delete(obj.Fig);
      obj.fid.Vg.valeur =0;
      gaglobal('editnom');
      delete(obj);
    end

  end  % methods
end  % classdef
