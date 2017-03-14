close all; clear all; clc; addpath('..');
addpath('code\Classification\multisvm\');

%% Criando as combina��es de par�metros para a valida��o cruzada

%% Configura��es gerais
ptrn = 0.74;
numRodadas = 50;
numFolds = 5;
qtdClasses = 7;

% paraC = ceil(0.1 * ptrn * size(dados.y, 1))+80;
conf.paraC = 8;
conf.sigma = 2;

conf.fkernel = 'rbf';
conf.metodo = 'SMO';
conf.options.MaxIter = 15000;

%%ABRIR ARQUIVO
nameFile = sprintf('results/resultsSVM_train%d_SIGMA%.2f_R%d_%s.txt',ptrn*100,conf.sigma,numRodadas,conf.fkernel);
nameFile2 = sprintf('results/Resumo_resultsSVM_train%d_SIGMA%.2f_R%d_%s.txt',ptrn*100,conf.sigma,numRodadas,conf.fkernel);
fileID = fopen(nameFile,'w');
fileID2 = fopen(nameFile2,'w');
accGeral = zeros(qtdClasses,1);

%%
vIni = 1;
vInc = 1;
vFin = 10;
resolucoes = (vIni:vInc:vFin);

%% intervalo da resolu��o que deseja plotar no gr�fico
resoIni = 1;
resoFim = 10;

somaEscoresAcertosClasse = zeros(qtdClasses,1);
somaEscoresErrosClasse = zeros(qtdClasses,1);

%matriz dos valores de erros
matrizErrosClasse(1,:) = [0 1 2 3 4 5 6];
matrizErrosClasse(2,:) = [1 0 1 2 3 4 5];
matrizErrosClasse(3,:) = [2 1 0 1 2 3 4];
matrizErrosClasse(4,:) = [3 2 1 0 1 2 3];
matrizErrosClasse(5,:) = [4 3 2 1 0 1 2];
matrizErrosClasse(6,:) = [5 4 3 2 1 0 1];
matrizErrosClasse(7,:) = [6 5 4 3 2 1 0];

%vetor dos escores por acertos das classes
vetorEscoresClasses = [7 6 5 4 3 2 1];
%vetorPesosClasses   = [10 9 8 7 6 5 4 3];

%total m�ximo de escores de acertos do classificador
maxEscoresAcertos = (1-ptrn)*50*(sum(vetorEscoresClasses'));

for reso = resolucoes
    %% Pr�-processamento
    % dados = carregaDados('DB_GLCM.txt', 4);
    fileGLCM = sprintf('../DB_FEATURES/DB_GLCM_%d.txt',reso);
    temp = load(fileGLCM);
    dados.x = temp(:, 1:end-1);
    dados.y = temp(:, end);
    dados.y = dados.y + 1;
    clear temp

    % i = 1;
    % for sigma = 2.^(-5:5)
    %     
    %     for c = 2.^(-5:5)
    %         conf.paraC = c;
    %         conf.sigma = sigma;
    %         
    %         paramsSVM{i} = conf;
    %         i = i + 1;
    %     end
    % end



    %optParam = searchParamSVM(dados, paramsSVM, 3, ptrn );
    fprintf(fileID,'##################################################################\n');
    fprintf(fileID,'################RESULTADOS - GLCM %d%% DE RESOLUCAO###############\n', reso);
    fprintf(fileID,'##################################################################\n\n\n');
    
    %% Avaliando o m�todo
    for i = 1 : numRodadas
        %index da posi��o na matrix resolucao
        pos = reso/vInc;
        %% Embaralhando os dados
        [dadosTrein, dadosTeste] = embaralhaDados(dados, ptrn, 2);


        %% Treinamento do SVM
        fprintf('Treinando o SVM...\nRodada %d - Resolu��o %d\n', i,reso);
        fprintf(fileID,'################RODADA %d################\n\n', i);

        [Y, time] = multisvm(dadosTrein.x, dadosTrein.y, dadosTeste.x, conf);

        % Matriz de confusao e acur�cia
        matrizesConf{i} = confusionmat(dadosTeste.y', Y');
        %acuracia(i) = trace(matrizesConf{i}) / length(Y);
        
        %%C�CULO DOS PRE�O|ESCORES DO COURO POR REALIZA��O(RODADA
        % BASEADO NA MATRIZ DE CONFUS�O
        for lin = 1 : qtdClasses
            for col = 1 : qtdClasses
                if lin == col  %acertos - diagonal principal
                    somaEscoresAcertosClasse(lin) = somaEscoresAcertosClasse(lin) + (vetorEscoresClasses(lin) * matrizesConf{i}(lin,col));
                else %erros
                    somaEscoresErrosClasse(lin) = somaEscoresErrosClasse(lin) + (matrizesConf{i}(lin,col)*matrizErrosClasse(lin,col));
                end
            end
            %matriz 3d - rodada:classe:resolu��o
            somaEscoresAcertosResoGeral(lin,i,pos) = somaEscoresAcertosClasse(lin);
            somaEscoresErrosResoGeral(lin,i,pos) = somaEscoresErrosClasse(lin);
        end
       
        %%
        %escrevendo a matriz de confusao
        fprintf(fileID,'MATRIZ DE CONFUS�O\n');
        fprintf(fileID,'%3d %3d %3d %3d %3d %3d %3d\r\n',matrizesConf{i}');
        fprintf(fileID,'\n');
        
        %escrevendo a soma dos escores por classe baseado na matriz acima
        fprintf(fileID,'#SOMA DOS ESCORES DE ACERTOS E ERROS#\n');
        fprintf(fileID,'%2s %10s %10s\r\n','CLASSE','ACERTO','ERRO');
        for k = 1 : qtdClasses
            fprintf(fileID,'%3d %11d %11d\r\n',k,somaEscoresAcertosClasse(k),somaEscoresErrosClasse(k));
        end
        fprintf(fileID,'\n%2s %9d %11d\r\n','TOTAL',sum(somaEscoresAcertosResoGeral(:,i,pos)),sum(somaEscoresErrosResoGeral(:,i,pos)));
        
        fprintf(fileID,'\n');
        
        %zera novamente o vetor de acertos e erros por classe
        somaEscoresAcertosClasse = zeros(qtdClasses,1);
        somaEscoresErrosClasse = zeros(qtdClasses,1);

        fprintf(fileID,'RESULTADO DAS M�TRICAS NA RODADA %d POR CLASSE\n\n',i);
        fprintf(fileID,'%2s %10s\r\n','CLASSE','ACC_PC');

        %calculando a accur�cia por classe
        for k = 1 : qtdClasses
            acc = matrizesConf{i}(k,k)/sum(matrizesConf{i}(k,:));
            accGeral(k) = accGeral(k) + acc;
            vetorAccClasse(k,i) = acc;
            vetorAccClasseRodReso{k}(i,pos) = acc;
            matrixAccClasseRodReso(k,i,pos) = acc;
            vetorAccResoRodClasse{pos}(i,k) = acc;
            fprintf(fileID,'%3d %12.3f \r\n',k,acc);
        end
        fprintf(fileID,'\n');
    end

    fprintf('FIM DE TODO O PROCESSO...\n');

    %mediaAcc = mean(acuracia);

    fprintf(fileID,'################GERAL################\n\n', i);
    fprintf(fileID,'RESULTADO GERAL DAS M�TRICAS POR CLASSE : GLCM %d%%\n\n',reso);
    fprintf(fileID,'%2s %10s %10s\r\n','CLASSE','ACC_PC','STD');
    
    
    for k = 1 : qtdClasses,
        
        acc2 = accGeral(k)/numRodadas;
        desv = std(vetorAccClasse(k,:),0,2);
        vetorAccClasseReso(k,pos) = acc2;
        vetorDesvClasseReso(k,pos) = desv;
        
        fprintf(fileID,'%3d %12.3f %12.3f\r\n',k,acc2,desv);
    end

    fprintf(fileID,'\n################FIM DOS RESULTADOS - GLCM %d%% DE RESOLUCAO###############\n\n', reso);
    
    accGeral = zeros(qtdClasses,1);
    
    %%soma dos acertos e erros por Resolu��o
    %totalEscoresAcertosReso = sum(somaEscoresAcertosResoGeral{1,reso}');
end

%ESCREVENDO NO ARQUIVO O RESULTADO (ACU�RIA E DESVIO PADR�O) GERAL DAS CLASSES EM CADA RESOLU��O
fprintf(fileID2,'RESULTADO GERAL DAS M�TRICAS POR CLASSE E RESOLU��ES : GLCM - ACUR�CIA E DESVIO PADR�O (%d RODADAS | RESOLU��O DE %d AT� %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = resolucoes
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','CLASSE');
for reso = resolucoes
    fprintf(fileID2,'|%10s   ','ACC|STD');
end
fprintf(fileID2,'\r\n');

for k = 1 : qtdClasses
    fprintf(fileID2,'%3d   ',k);
    for reso = resolucoes
        fprintf(fileID2,' %7.3f|%1.3f',vetorAccClasseReso(k,reso),vetorDesvClasseReso(k,reso));
    end
    fprintf(fileID2,'\r\n');
end
fprintf(fileID2,'\n%2s ','M�DIA');
for reso = resolucoes
    fprintf(fileID2,' %7.3f|%1.3f',mean(vetorAccClasseReso(:,reso)),mean(vetorDesvClasseReso(:,reso)));
end
fprintf(fileID2,'\r\n');

%ESCREVENDO NO ARQUIVO O SOMAT�RIO DOS ESCORES DE ACERTOS E ERROS DAS CLASSES EM CADA RODADA POR RESOLU��O
fprintf(fileID2,'\n\nSOMAT�RIO DOS ESCORES DE ACERTOS E ERROS DAS CLASSES EM CADA RODADA POR RESOLU��O (%d RODADAS | RESOLU��O DE %d AT� %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = resolucoes
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','RODADA');
for reso = resolucoes
    fprintf(fileID2,'|%10s   ','ACE|ERR');
end
fprintf(fileID2,'\r\n');

for rod = 1 : numRodadas
    fprintf(fileID2,'%3d ',rod);
    for reso = resolucoes
        fprintf(fileID2,'       %03d|%03d',sum(somaEscoresAcertosResoGeral(:,rod,reso)),sum(somaEscoresErrosResoGeral(:,rod,reso)));
    end
    fprintf(fileID2,'\r\n');
end

fprintf('\nGERANDO GR�FICOS E SALVANDO EM ARQUIVOS\n');
%ESCREVENDO NO ARQUIVO A M�DIA DOS TOTAIS DE ACERTOS E ERROS POR CLASSE EM
%CADA RESOLU��O
fprintf(fileID2,'\n\nM�DIA DOS TOTAIS DOS ESCORES DE ACERTOS E ERROS POR CLASSE EM CADA RESOLU��O (%d RODADAS | RESOLU��O DE %d AT� %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = resolucoes
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','CLASSE');
for reso = resolucoes
    fprintf(fileID2,'|%10s   ','ACE|ERR');
end
fprintf(fileID2,'\r\n');

for k = 1 : qtdClasses
    fprintf(fileID2,'%3d   ',k);
    for reso = resolucoes
        fprintf(fileID2,'   %05.1f|%05.1f',mean(somaEscoresAcertosResoGeral(k,:,reso)),mean(somaEscoresErrosResoGeral(k,:,reso)));
    end
    fprintf(fileID2,'\r\n');
end
fprintf(fileID2,'\n%2s ','M�DIA');
for reso = resolucoes
    fprintf(fileID2,'   %05.1f|%05.1f',mean2(somaEscoresAcertosResoGeral(:,:,reso)),mean2(somaEscoresErrosResoGeral(:,:,reso)));
end
fprintf(fileID2,'\r\n');




%% exibir/salvar boxplot


%boxplot das classes por resolu��o
for k = 1 : qtdClasses
    
    gcf = figure('visible','off');
    
    boxplot(vetorAccClasseRodReso{k}(:,resoIni:resoFim));
    % Overlay the mean as green circle
    hold on
    plot(mean(vetorAccClasseRodReso{k}(:,resoIni:resoFim)), 'og');
    hold off
    strTitle = sprintf('Acur�cia da Classe %d por Resolu��o - %d rodadas',k,numRodadas);
    title(strTitle);
    xlabel('Resolu��es da Imagem Original');
    ylabel('Acur�cia');
    
    nameFileGraph = sprintf('graphics/classes_x_resolucao/C%d_Rods%d.png',k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%boxplot das resolu��o por classes
for k = 1 : resoFim
    
    gcf = figure('visible','off');
    
    boxplot(vetorAccResoRodClasse{k});
    % Overlay the mean as green circle
    hold on
    plot(mean(vetorAccResoRodClasse{k}), 'og');
    hold off
    strTitle = sprintf('Acur�cia por Classe na resolu��o de %d%% - %d rodadas',k,numRodadas);
    title(strTitle);
    xlabel('Classes');
    ylabel('Acur�cia');
    
    nameFileGraph = sprintf('graphics/resolucao_x_classes/Reso%d%%_Rods%d.png',k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%BOX PLOT DO CLASSIFICADOR
%boxplot dos somat�rios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realiza��o
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

boxplot(c);
% Overlay the mean as green circle
hold on
plot(mean(c), 'og');
%line(resoIni:resoFim,mean(c));
hold off
strTitle = sprintf('Escores de Acertos do Classificador - %d rodadas',numRodadas);
title(strTitle);
xlabel('Resolu��es da Imagem Original');
ylabel('Valor Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/BoxPlot_Acertos_Rods%d.png',numRodadas);
saveas(gcf,nameFileGraph);

%boxplot dos somat�rios dos escores de erros
gcf = figure('visible','off');

%armazena o valor total de erros do classificador em cada realiza��o
%ou rodada
b = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

boxplot(c);
% Overlay the mean as green circle
hold on
plot(mean(c), 'og');
hold off
strTitle = sprintf('Escores de Erros do Classificador - %d rodadas',numRodadas);
title(strTitle);
xlabel('Resolu��es da Imagem Original');
ylabel('Valor Total de Erros do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/BoxPlot_Erros_Rods%d.png',numRodadas);
saveas(gcf,nameFileGraph);

%LINE PLOT DO CLASSIFICADOR
%lineplot dos somat�rios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realiza��o
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

%armazena o valor total de erros do classificador em cada realiza��o
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

x = resoIni:resoFim;
y1 = 100*mean(vetorAccClasseReso(:,resoIni:resoFim)); %acur�cia do classificador
y2 = mean(c); %m�dia do escores de acertos em todas as rodadas do classificador
y3 = mean(c2); %m�dia do escores de acertos em todas as rodadas do classificador

plot(x,y1,'b','LineWidth',2,'DisplayName','Acur�cia');
hold on
plot(x,y2,'g','LineWidth',2,'DisplayName','Acertos');
hold on
plot(x,y3,'r','LineWidth',2,'DisplayName','Erros');

legend('show','Location','northwest','Orientation','horizontal');
hold off
strTitle = sprintf('Acur�cia, Escores de Acertos e Erros do Classificador - %d rodadas',numRodadas);
title(strTitle);
xlabel('Resolu��es da Imagem Original');
ylabel('M�dia do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Line_Acur�cia_Acertos_Erros_Rods%d.png',numRodadas);
saveas(gcf,nameFileGraph);



%ESCREVENDO NO ARQUIVO O RESULTADO (ACU�RIA E DESVIO PADR�O) GERAL DAS CLASSES EM CADA RESOLU��O
fprintf(fileID2,'\nEXIBINDO OS 5 MELHORES CLASSIFICADORES COM BASE NO TOTAL DE ESCORES DE ACERTOS');
fprintf(fileID2,'\n%2s %10s %10s %10s %10s\r\n','ESCORES','ERROS','ACUR�CIA','RODADA','RESOLU��O');
%[sortC, sortIndices] = sort(c,2,'descend');%ordena a matrix linhas
maxValue = max(c(:));
[rowsOfMaxes, colsOfMaxes] = find(c <= maxValue,5);
for rowMax = rowsOfMaxes'
    for colMax = colsOfMaxes'
        fprintf(fileID2,'%3d %12d %12.1f%% %12d %12d\r\n',c(rowMax,colMax),c2(rowMax,colMax),100*mean(matrixAccClasseRodReso(:,rowMax,colMax)),rowMax,colMax);
    end
    break;
end

%fechando os arquivos
fclose(fileID);
fclose(fileID2);


fprintf('Pronto ...\n');
% % Procurando a matriz de confus�o mais pr�xima da acur�cia m�dia
% [~, posicoes] = sort( abs ( mediaAcc - acuracia ) );
%
%
% desvPadr = std(acuracia);
% matrizConfMedia = matrizesConf{posicoes(1)};
% clear Yh dados dadosTeste dadosTrein i c posicoes