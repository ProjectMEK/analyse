%
% Lecture des fichiers RAW cr�� par Kiethley
% 
%*******************************************************************************
% Les probl�mes rencontr�s avec cette fonction sont habituellement
% reli�s aux nom de canaux ou de stimulus qui comportent des caract�res
% accentu�s. Cela peut �tre corrig� dans le menu �dit canal.
%*******************************************************************************
% Le format du fichier venant de l'application d�velopp� par les gens de
% Marseille est sous cette forme
%
%  Ent�te de d�part
%  Essai 1
%      canal 1
%      canal 2
%      ...
%      canal N
%  Essai 2
%      canal 1
%      canal 2
%      ...
%      canal N
%  ...
%  Essai U
%      canal 1
%      canal 2
%      ...
%      canal N
%
% Comme le format d'Analyse s�pare non pas les essais mais les canaux, on va
% chercher � lire et �crire tous les canaux X dans les diff�rents essais et
% faire une seule �criture pour ce canal.
%-------------------------------------------------------------------------------
function lirkith(Ppa);
  % handle sur l'objet fichier Analyse
  hF =Ppa.Fich;

  % handles sur les propri�t�s du fichier
  hHdchnl =hF.Hdchnl;
  hVg =hF.Vg;
  hF.Info.foname =hF.Info.finame;

  % On ferme le GUI qui ne sert plus
  if ~isempty(Ppa.Fig)
    delete(Ppa.Fig);
    Ppa.Fig =[];
  end

  % handle sur le waitbar
  hT =Ppa.txtml;
  dd = waitbar(0, [hT.lectfich 'Keithley' hT.vide hT.patience]);
  waitbar(1/1000, dd);

  % Pr�paration/Ouverture du fichier Keithley
  fid = fopen(Ppa.fname{1}, 'r');
  %-------------------
  % ENT�TE du fichier
  %-------------------
  hVg.nad =fread(fid,1,'int32');                  % nb de canaux
  Ppa.col =hVg.nad;
  hHdchnl.adname =findnames(fid,hVg.nad);
  % Cr�ation des noms de variable de canaux
  for U =1:hVg.nad
    hHdchnl.cindx{U} =['C' num2str(U)];
  end

  K.ses = fread(fid,1,'int32');                   % nb sessions
  allnam{1} = findnames(fid,K.ses);
  
  K.nst = fread(fid,1,'int32');                   % nb conditions
  allnam{2} = findnames(fid,K.nst);
  
  K.sqtp = fread(fid,1,'int32');                  % nb s�quence types
  allnam{3} = findnames(fid,K.sqtp);

  hVg.ess =fread(fid,1,'int32');                  % nb d'essai

  %-----------------------------------------------------------------------------
  % Nom des stimulus
  %
  % ATTENTION ici, � ceux qui disent que le pluriel de stimulus est stimuli.
  % 
  % Avec les anciennes r�gles, nous venant du latin, ils ont raison. Car
  % l'application du pluriel en latin sur des mots finissant en "um" finiront
  % en "a" et ceux finissant en "us" finiront en "i".
  %
  % MAIS, depuis 1990:
  % Le nouveau fran�ais ne se base plus sur le latin et accepte "des stimulus".
  %-----------------------------------------------------------------------------
  [hVg.nomstim, K] =findnames2(allnam, Ppa.whatstim, K);
  hVg.nst =length(hVg.nomstim);

  % Initialisation des variables pour les datas
  dtchnl(5000, hVg.ess) =0;
  Dt =CDtchnl();
  ind(1:hVg.ess) =1;

  curstim =1;

  if hVg.ess > 0 & hVg.nad > 0
    %---------------------------------------------------------------------------
    % On initialise les propri�t�s de hdchnl comme si tous les canaux �taient
    % vide, donc par d�faut seulement 1 �chantillon � 1 Hz
    %---------------------------------------------------------------------------
    hHdchnl.sweeptime =ones(hVg.nad, hVg.ess);
    hHdchnl.rate =ones(hVg.nad, hVg.ess);
    hHdchnl.nsmpls =ones(hVg.nad, hVg.ess);
    hHdchnl.max(hVg.nad,hVg.ess) =0;
    hHdchnl.min(hVg.nad,hVg.ess) =0;
    hHdchnl.npoints(hVg.nad,hVg.ess) =0;
    hHdchnl.point(hVg.nad,hVg.ess) =0;
    hHdchnl.frontcut(1:hVg.nad,1:hVg.ess) =0;
    hHdchnl.numstim =ones(1,hVg.ess);
    hdchnl =hHdchnl.databrut();
    vg =hVg.databrut();
    laver ='-V7';
    ptchnl =[];
    tpchnl =[];
    catego =[];
    autre =[];
    % Pr�paration pour la sauvegarde des ent�tes
    save(hF.Info.fitmp, 'vg','hdchnl','ptchnl','tpchnl','catego','autre', laver);

    % On conserve la position du d�but de l'essai 1 dans le fichier
    posE1 =ftell(fid);

    %---------------------------------------------------------------------------
    % On fait la lecture des datas canal par canal.
    %     Il faudra donc aller lire le canal X dans tous les essais
    %     puis le sauvegarder et passer au canal suivant.
    %---------------------------------------------------------------------------
    for j =1:hVg.nad
      waitbar(j/hVg.nad, dd, [hT.lectcanal num2str(j)]);
      %-------------------------------------
      % on se replace au d�but de l'essai 1
      %_____________________________________
      fseek(fid, posE1, 'bof');

      for k = 1:hVg.ess
        cursess = fread(fid,1,'int32');
        curcond = fread(fid,1,'int32');
        cursqtp = fread(fid,1,'int32');
        ncans   = fread(fid,1,'int32');
        if Ppa.whatstim(1)==0
          cursess = 1;
        end
        if Ppa.whatstim(2)==0
          totcond = 1;
          curcond = 1;
        else
          totcond = K.nst;
        end
        if Ppa.whatstim(3)==0
          totsqtp = 1;
          cursqtp = 1;
        else
          totsqtp = K.sqtp;
        end
        canutil =1;
        % on calcule le num�ro de la condition
        ind(k) =((cursess -1)*totcond*totsqtp) + ((curcond -1)* totsqtp) + cursqtp;
        if ncans > 0
          %---------------------------------------------------------------------
          % On lit le num�ro du canal dans le fichier
          %---------------------------------------------------------------------
          ncanal = fread(fid,1,'int32');
          for curcan=1:hVg.nad
            if j == ncanal
              freqech = fread(fid,1,'float32');          % fr�quence d'�chant.(4 Bytes)
              if isempty(freqech) | (freqech == 0)
                freqech = 1;
              end
              hHdchnl.rate(ncanal,k) = freqech;
              numdata = fread(fid,1,'int32');            % nombre de samples  (4 Bytes)
              if isempty(numdata) | (numdata < 1)
                numdata =max(1, numdata);
              else
                dtchnl(1:numdata,k) = fread(fid,numdata,'single'); % Float(32 bits)
                hHdchnl.nsmpls(ncanal,k) = numdata;
              end
              hHdchnl.numstim(1,k) =ind(k);
              hHdchnl.sweeptime(ncanal,k) = numdata/freqech;
              hHdchnl.comment{ncanal,k} ={[hHdchnl.adname{curcan} '://']};
            else
              % on saute la fr�quence d'acquisition
              fseek(fid, 4, 'cof');
              % nombre de samples  (4 Bytes)
              numdata = fread(fid,1,'int32');
              if ~isempty(numdata) & (numdata > 0)
                fseek(fid, numdata*4, 'cof');            % on saute les datas
              end
            end
            % si il reste des canaux dans l'essai
            if canutil < ncans
              ncanal =fread(fid,1,'int32');           % num�ro de canal
              canutil =canutil+1;
            end
          end  % for curcan=1:hVg.nad
        end  % if ncans > 0
      
      end  %  for k = 1:hVg.ess

      %-------------------------------------------------------------------------
      % On sauvegarde le canal dans l'objet fichier Analyse
      % Comme notre matrice dtchnl a un minimum de 5000 �chantillons
      % on va conserver le maximum util.
      %-------------------------------------------------------------------------
      lebout =max(hHdchnl.nsmpls(j,:));
      Ppa.sauveCanal(dtchnl(1:lebout, :), Dt, j);
      %-------------------------------------------------------------------------
      % remise � z�ro de toutes les valeurs
      % De cette fa�on on conserve la variable de la m�me grosseur et on remet
      % les valeurs � z�ro sans "recreer" un espace m�moire
      % (pas de r�-allocation de m�moire).
      %-------------------------------------------------------------------------
      dtchnl(:) =0;
    end  % for j =1:hVg.nad
  end

  % on ferme le fichier Keithley
  fclose(fid);

  % on finalise
  for U =1:hVg.ess
    for V =1:hVg.nad
      %-------------------------------------------------------------------------
      % Avec l'application d�velopp� � Marseille, il est possible d'avoir
      % un nombre de canaux diff�rent pour chacun des essais. C'est ce que l'on
      % v�rifie ici.
      %-------------------------------------------------------------------------
      if isempty(hHdchnl.comment{V, U})
        hHdchnl.numstim(1,U) =ind(U);
        hHdchnl.comment{V, U} ={[hHdchnl.adname{V} '://']};
      end
    end
  end
  hVg.valeur =1;
  P.hdchnl =hHdchnl.databrut();
  P.vg =hVg.databrut();
  save(hF.Info.fitmp, '-Struct', 'P', '-Append');
  delete(Dt);
  hF.Info.fitmp =[];

  % on ferme la waitbar
  close(dd);
end

%-------------------------------------------------------------------------------
%  noms_can = FINDNAMES(Kid, count)
%
%  � partir de la position courante, lira/retournera le nom qui est d�limit� par
%  un caract�re "|".
%
%  en Entr�e         Kid:  file Id du fichier en lecture.
%                  count:  le nombre de noms � retourner.
%  en Sortie    noms_can:  {Cellule} liste des noms � retourner.
%-------------------------------------------------------------------------------
function noms_can = findnames(Kid, count)
  noms_can ={};
  for i = 1:count
    nom_ch = '';
    charact = fread(Kid,1,'char');  %starting value - to avoid an empty matrix
    while charact ~= '|'
      nom_ch = [nom_ch charact];
      charact = fread(Kid,1,'char');
    end
    noms_can{end+1} =verifnom(nom_ch);
  end
end

%-------------------------------------------------------------------------------
function [new_stim_names, K]  = findnames2(allnames, whatstim, K)
  nums = [K.ses K.nst K.sqtp];
  whichst = find(whatstim);
  numsts = length(whichst);
  K.temp = prod([nums(whichst)]);  %put into vg.nst later !!!
  if numsts ==1
    new_stim_names = allnames{whichst};
  else
    new_stim_names ={};
    j  = whichst(1);
    j2 = whichst(2);
    for  i = 1:nums(j) 
      for i2 = 1:nums(j2)
        if numsts == 2
          new_stim_names{end+1} =[allnames{j}{i} '#' allnames{j2}{i2}];
        elseif numsts == 3
          j3 = whichst(3);
          for i3 = 1:nums(j3)
            new_stim_names{end+1} =[allnames{j}{i} '#' allnames{j2}{i2} '#' allnames{j3}{i3}];
          end
        end
      end
    end
  end    
end

%-------------------------------------------------------------------------------
%
% On enl�ve tous les caract�res "-_/\" et les espaces � la fin
%
%-------------------------------------------------------------------------------
function nom  = verifnom(lenom)
    interdit ={'-'; '_'; '/'; '\'; ';'; ':'; ' '};
    while ismember(lenom(end), interdit)
      lenom(end) =[];
    end
    nom =strtrim(lenom);
end