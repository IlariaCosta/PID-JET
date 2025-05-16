clc 
clear all 
close all 
%%
cartella = "C:\Users\feder\Desktop\Lavoro Borsa\controllo temperature\codici miei\C41"
files = dir(fullfile(cartella,'*.mat*'))
files = files(~[files.isdir]);
nomiFile = {files.name};
q = 1;
k = 1;

for i = 1: length(nomiFile)
     load(nomiFile{1,i})
    for j = 1:32
        fieldName = sprintf('S%dA', j);         
        flag = Error.(fieldName){1,1};          
        flag1 = Error.(fieldName){1,2};
        % Ora puoi controllare il flag come vuoi
        if flag == 0 && flag1 ==0 
            pulse_lan{k} = nomiFile{1,i};
            k = k+1;
            break;
        end
    end

end 

%%
for i =1:length(nomiFile)
    sparo = load(nomiFile{1,i});
    
    if (sparo.Error.NE == 0 || sparo.Error.N2 == 0)
        pulse_impurezze{q} = {nomiFile{1,i}};
        q = q+1;
    end

end 

save("C:\Users\feder\Desktop\Lavoro Borsa\controllo temperature\codici miei\pulse_impurezze.mat","pulse_impurezze");
save("C:\Users\feder\Desktop\Lavoro Borsa\controllo temperature\codici miei\nomiFile.mat", "nomiFile")
save("C:\Users\feder\Desktop\Lavoro Borsa\controllo temperature\codici miei\pulse_lan.mat", "pulse_lan")
