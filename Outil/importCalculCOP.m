%
% Importation des paramètre à partir d'un fichier INI
%
% plate-forme de force AMTI
%
function p =importCalculCOP(hObj)
  global leWb lemax iindx fid;
  p.lesParam =false;
  fid =-1;
  % Octave ayant de la misère à gérer par dessus une fenêtre "modal"
  set(hObj.fig,'WindowStyle','normal');
  [nom, pat] =uigetfile({'*.INI','Afficher les fichiers *.ini';'*.*','Afficher tous les fichiers'});
  set(hObj.fig,'WindowStyle','modal');
  leWb =laWaitbarModal(0, 'Lecture des paramètres', 'C', 'C', gcf);
  if ~isequal(nom,0) && ~isequal(pat,0)
    fid =fopen(fullfile(pat,nom), 'rt');
    if fid == -1
      % le fichier ne peut être ouvert
      onFerme();
      return;
    end
    lemax =2;
    tline = fgetl(fid);
    while ischar(tline)
    	lemax =lemax+1;
    	tline = fgetl(fid);
    end
    fseek(fid, 0, -1);  % retour au début "bof"
    iindx =1;
    ligne =suivante();
    while ligne ~= -1
      if (length(ligne) < 3)||(ligne(1) == '#')
        ligne =suivante();
        continue;
      %***** LECTURE DES PARAMÈTRES AMTI
      elseif strncmpi(ligne,'[amti',5)
        while ~ strncmpi(ligne,'[\amti',6)
          if strncmpi(ligne, '[can', 4)             % CANAUX
            while ~ strncmpi(ligne, '[\can', 5)
              if strncmpi(ligne, 'fx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canFx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fy', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canFy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canFz =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canMx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'my', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canMy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.canMz =str2num(ligne(i:end));
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end  % while ~ strncmpi(ligne, '[\can', 5)
          elseif strncmpi(ligne, '[calib', 6)             % CALIBRATION
            while ~ strncmpi(ligne, '[\calib', 7)
              if strncmpi(ligne, 'mc1', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(1,1:length(laVal)) =laVal;
                  end
                end
              elseif strncmpi(ligne, 'mc2', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(2,1:length(laVal)) =laVal;
                  end
                end
              elseif strncmpi(ligne, 'mc3', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(3,1:length(laVal)) =laVal;
                  end
                end
              elseif strncmpi(ligne, 'mc4', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(4,1:length(laVal)) =laVal;
                  end
                end
              elseif strncmpi(ligne, 'mc5', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(5,1:length(laVal)) =laVal;
                  end
                end
              elseif strncmpi(ligne, 'mc6', 3)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  laVal =str2num(ligne(i:end));
                  if ~isempty(laVal)
                    p.amtiMC(6,1:length(laVal)) =laVal;
                  end
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end  % while ~ strncmpi(ligne, '[\calib', 7)
          elseif strncmpi(ligne, '[gain', 5)             % GAIN
            while ~ strncmpi(ligne, '[\gain', 6)
              if strncmpi(ligne, 'fx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainFx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fy', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainFy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainFz =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainMx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'my', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainMy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.gainMz =str2num(ligne(i:end));
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end
          elseif strncmpi(ligne, '[vext', 5)             % Vext
            while ~ strncmpi(ligne, '[\vext', 6)
              if strncmpi(ligne, 'fx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vFx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fy', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vFy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'fz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vFz =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mx', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vMx =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'my', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vMy =str2num(ligne(i:end));
                end
              elseif strncmpi(ligne, 'mz', 2)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.vMz =str2num(ligne(i:end));
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end
          elseif strncmpi(ligne, '[zoff', 5)             % ZOff
            while ~ strncmpi(ligne, '[\zoff', 6)
              if strncmpi(ligne, 'z', 1)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  p.zOff =str2num(ligne(i:end));
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end
          elseif strncmpi(ligne, '[copcog', 6)             % COPCOG
            while ~ strncmpi(ligne, '[\copcog', 7)
              if strncmpi(ligne, 'cops', 4)
                i =findstr(ligne,'=');
                if ~isempty(i)
                  i =i(1);
                  while (i <=length(ligne))&& ((ligne(i) ==' ')||((ligne(i) =='=')) );
                    i =i+1;
                  end
                  if ~isempty(laVal)
                    p.COPseul =str2num(ligne(i:end));
                  end
                end
              end
              ligne =suivante();
              if ligne == -1
                break;
              end
            end  % while ~ strncmpi(ligne, '[\calib', 7)
          end
          ligne =suivante();
          if ligne == -1
            break;
          end
        end % while ~ strncmpi(ligne,'[\amti',6)
      end  % if (length(ligne) < 4)||(ligne(1) == '#')
      ligne =suivante();
    end  % while ligne ~= -1
  end  % if ~isequal...
  onFerme();
end

function li = suivante()
  global leWb lemax iindx fid;
  li =fgetl(fid);
  if li == -1
    return;
  end
  li =strtrim(li);
  waitbar(iindx/lemax, leWb);
  iindx =iindx+1;
end

function onFerme()
  global leWb lemax iindx fid;
  delete(leWb);
  if fid ~= -1
    fclose(fid);
  end
  clear global leWb lemax iindx fid;
end
