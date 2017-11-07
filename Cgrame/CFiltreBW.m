%
% Class CFiltreBW
%
% Fonction pour passer un filtre ButterWorth sur les canaux demandés.
% Les choix sont : passe-bas
%                  passe-haut
%                  passe-bande
%                  coupe-bande (fiter-notch)
%
% METHODS
%       CFiltreBW()                    CONSTRUCTOR
%
%
%
classdef CFiltreBW < handle

  properties
    fig =[];     % handle du GUI
  end

  methods

    %------------------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %------------------------------------------------------
    % Affiche le GUI pour définir les paramètres de travail
    %------------------------------------------------------
    function guiFiltreBW(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      GUIFiltreBW(tO, hdchnl.Listadname);
    end

    %-------------------------------
    % Sélection du type de filtre
    %-------------------------------
    function quelChoix(tO, src, evt)
      bouton =get(src,'Value');
      switch(bouton)
      case {1, 2}
        tO.affiche2FC('off');
        set(findobj('tag','TextOrdreFiltre'), 'Position',[35 125 165 20]);
        set(findobj('tag','EditOrdreFiltre'),'Position',[200 125 50 20]);
        set(findobj('tag','TextFreqCoupe1'), 'Position',[35 70 165 20]);
        set(findobj('tag','EditFreqCoupe1'), 'Position',[200 70 50 20]);
      case {3, 4}
        set(findobj('tag','TextOrdreFiltre'), 'Position',[35 140 165 20]);
        set(findobj('tag','EditOrdreFiltre'), 'Position',[180 140 50 20]);
        set(findobj('tag','TextFreqCoupe1'), 'Position',[50 105 200 20]);
        set(findobj('tag','EditFreqCoupe1'), 'Position',[75 60 50 20]);
        tO.affiche2FC('on');
      end
    end

    %-----------------------------------------
    % gestion des Objets à afficher ou enlever
    %-----------------------------------------
    function affiche2FC(tO, v)
      set(findobj('tag','TextFreqCoupe2'), 'visible',v);
      set(findobj('tag','EditFreqCoupe2'), 'visible',v);
    end


    %------------------------------------------------
    % Fonction pour lire le GUI et passer à l'action.
    %------------------------------------------------
    function travail(tO,varargin)
      % lecture de l'interface
      foo.afaire =get(findobj('tag','QuelFiltre'),'Value');
      foo.lescan =get(findobj('tag','ChoixCanFiltre'),'Value');
      foo.nouveau =get(findobj('tag','EcraseCanal') ,'Value');     % on écrase le canal source
      foo.ord =get(findobj('tag','EditOrdreFiltre'),'String');
      foo.frc1 =get(findobj('tag','EditFreqCoupe1'),'String');
      foo.frc2 =get(findobj('tag','EditFreqCoupe2'),'String');
      % infos du fichier à traiter
      OA =CAnalyse.getInstance();
      hF =OA.findcurfich();
      tO.cParti(hF,foo);
    end

    %--------------------------------------------
    % Utile pour forger le nouveau nom d'un canal
    %--------------------------------------------
    function nom = nouveauNom(tO,vieux,afaire)
      % choix pour la modification du nom de canal
      prenom ={'BUT.bas', 'BUT.haut', 'BUT.band', 'BUT.coupe'};
      nom =[prenom{afaire} deblank(vieux)];
    end

    %--------------------------------------------------------
    % Ici on effectue le travail pour la fonction ButterWorth
    % même chose en mode batch
    % En entrée  Ofich  --> handle du fichier à traiter
    %                S  --> structure des param du GUI
    %              Bat  --> true si on est en mode batch
    %--------------------------------------------------------
    function cParti(tO,Ofich,S,Bat)
      if ~exist('Bat','var')
        Bat =false;
      end
      % infos de base du fichier
      OA =CAnalyse.getInstance();
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      % création d'un canal temporaire de travail
      dtchnl =CDtchnl();
      % variable pour les calculs
      S.nouveau =~S.nouveau;
      nombre =length(S.lescan);                         % Nb de canal à filtrer
      ordre =str2double(S.ord);                         % ordre du ButterW
      frcut1 =str2double(S.frc1);                       % fréq de coupure bas
      frcut2 =str2double(S.frc2);                       % fréq de coupure haut
      prenom ={'BUT.bas', 'BUT.haut', 'BUT.band', 'BUT.coupe'};       % modification du nom de canal
      if S.nouveau
        % si on écrase pas, on place les nouveaux à la fin
        Ncan =vg.nad+1:vg.nad+nombre;
        hdchnl.duplic(S.lescan);
      else
        Ncan =S.lescan;
      end
      % gestion du waitbar
      wbval =0;
      wbstep =1/nombre;
      leTit ='Filtrage du canal: ';
      tt =false;
      hwb =findobj('type','figure','name',OA.wbnom);
      if isempty(hwb)
        hwb =waitbar(0.01, leTit, 'name',OA.wbnom);
        tt =true;
      end
      % on travaille sur chacun des canaux séparément
      for i =1:nombre
      	Ofich.getcanal(dtchnl, S.lescan(i));
      	N =dtchnl.Nom;
        hdchnl.adname{Ncan(i)} =tO.nouveauNom(hdchnl.adname{Ncan(i)}, S.afaire);
        %_____________________________________________
        % on a tous le même nombres d'échantillons
        %---------------------------------------------
        if min(hdchnl.nsmpls(Ncan(i),:)) == max(hdchnl.nsmpls(Ncan(i),:))
          try
            Ftit =[leTit num2str(S.lescan(i))];
            waitbar(wbval,hwb,Ftit);
            wbval =wbval+wbstep;
            tO.verifFreq(hdchnl, S.afaire, S.lescan(i), 1, S.frc1, S.frc2);
            lemoins =hdchnl.nsmpls(Ncan(i),1);
            fniq =double(hdchnl.rate(Ncan(i),1))/2;
            cuchillo1 =max(0.0001, min(0.9999, frcut1/fniq));
            cuchillo2 =max(0.0001, min(0.9999, frcut2/fniq));
            if S.afaire == 1
              [b,a] =butter(ordre,cuchillo1);
              for j =1:vg.ess
                vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',Ord=',S.ord,', Freq=',S.frc1,'//'];
                hdchnl.comment{Ncan(i), j} =vc;
              end
            elseif S.afaire == 2
              [b,a] =butter(ordre,cuchillo1,'high');
              for j =1:vg.ess
                vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',Ord=',S.ord,', Freq=',S.frc1,'//'];
                hdchnl.comment{Ncan(i), j} =vc;
              end
            elseif S.afaire == 3
              [b,a] =butter(ordre,[cuchillo1 cuchillo2]);
              for j =1:vg.ess
                vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',F1= ' S.frc1 ',F2= ' S.frc2 '//'];
                hdchnl.comment{Ncan(i), j} =vc;
              end
            else
              [b,a] =butter(ordre,[cuchillo1 cuchillo2],'stop');
              for j =1:vg.ess
                vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',F1= ' S.frc1 ',F2= ' S.frc2 '//'];
                hdchnl.comment{Ncan(i), j} =vc;
              end
            end
            dtchnl.Dato.(N)(1:lemoins,:) =filtfilt(b,a,double(dtchnl.Dato.(N)(1:lemoins,:)));
            for j =1:vg.ess
              hdchnl.max(Ncan(i), j) =max(dtchnl.Dato.(N)(1:lemoins,j));
              hdchnl.min(Ncan(i), j) =min(dtchnl.Dato.(N)(1:lemoins,j));
            end
          catch me
            disp(me.message);
          end
        else
          wbstep2 =wbstep/vg.ess;
          for j =1:vg.ess
            Ftit =[leTit num2str(S.lescan(i)) ', essai: ' num2str(j)];
            waitbar(wbval,hwb,Ftit);
            wbval =wbval+wbstep2;
            try
              tO.verifFreq(hdchnl, S.afaire, Ncan(i), j, S.frc1, S.frc2);
            catch me
              disp(me.message);
              continue;
            end
            lemoins =hdchnl.nsmpls(Ncan(i),j);
            fniq =double(hdchnl.rate(Ncan(i),j))/2;
            cuchillo1 =max(0.001, min(0.999, frcut1/fniq));
            cuchillo2 =max(0.001, min(0.999, frcut2/fniq));
            if S.afaire == 1
              [b,a] =butter(ordre,cuchillo1);
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',Ord=',S.ord,', Freq=',S.frc1,'//'];
              hdchnl.comment{Ncan(i), j} =vc;
            elseif S.afaire == 2
              [b,a] =butter(ordre,cuchillo1,'high');
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',Ord=',S.ord,', Freq=',S.frc1,'//'];
              hdchnl.comment{Ncan(i), j} =vc;
            elseif S.afaire == 3
              [b,a] =butter(ordre,[cuchillo1 cuchillo2]);
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',F1=' S.frc1 ', F2=' S.frc2 '//'];
              hdchnl.comment{Ncan(i), j} =vc;
            else
              [b,a] =butter(ordre,[cuchillo1 cuchillo2],'stop');
              vc =[hdchnl.comment{Ncan(i), j} ' ' prenom{S.afaire} ',F1=' S.frc1 ', F2=' S.frc2 '//'];
              hdchnl.comment{Ncan(i), j} =vc;
            end
            try
              dtchnl.Dato.(N)(1:lemoins,j) =filtfilt(b,a,double(dtchnl.Dato.(N)(1:lemoins,j)));
              hdchnl.max(Ncan(i), j) =max(dtchnl.Dato.(N)(1:lemoins,j));
              hdchnl.min(Ncan(i), j) =min(dtchnl.Dato.(N)(1:lemoins,j));
            catch auvol
              disp(['Erreur, canal: ' num2str(S.lescan(i)) ' essai: ' num2str(j)]);
              disp(auvol.message);
            end
          end
        end
        Ofich.setcanal(dtchnl, Ncan(i));
      end  % for i =1:nombre
      if tt
        delete(hwb);
      end
      delete(tO.fig);
      vg.sauve =1;
      if Bat
        % si on est en mode batch, on ne doit pas afficher dans le GUI principal
        if S.nouveau
          vg.nad =vg.nad+nombre;
        end
      else
        if S.nouveau
          vg.nad =vg.nad+nombre;
          gaglobal('editnom');
        else
          OA.OFig.affiche();
        end
      end
    end

    %------------------------------------------------------------------------
    % on vérifie que la fréq de coupure respecte la fonction butter de matlab
    %------------------------------------------------------------------------
    function verifFreq(tO,hdchnl, afaire, can, ess, ft1, ft2)
      f1 =str2num(ft1);
      f2 =str2num(ft2);
      if afaire < 3  % Butterworth Passe-Bas/Haut
        if 2*f1 > hdchnl.rate(can,ess)
          mots =sprintf(['La fréquence de coupure doit être inférieure à la moitié ', ...
                'de la fréquence d''aquisition: can(%i) ess(%i)'], can, ess);
          e =MException('MFILTRE:VERIFFREQ',mots);
          throw(e);
        end
      else  % passe bande et coupe bande
        if 2*f1 > hdchnl.rate(can,ess) || 2*f2 > hdchnl.rate(can,ess) || f1 <= 0 || f1 >= f2
          mots =sprintf(['Les fréquences de coupure doivent être non-nulles et inférieures à la moitié ', ...
                'de la fréquence d''aquisition: can(%i) ess(%i)'], can, ess);
          e =MException('MFILTRE:VERIFFREQ',mots);
          throw(e);
        end
      end
    end


  end
end
