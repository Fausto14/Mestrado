function [matrixAccClasseRodReso somaEscoresAcertosResoGeral somaEscoresErrosResoGeral] = gerarDados(param,conf)

%% Configurações gerais
ptrn = param.ptrn;
numRodadas = param.numRodadas;
numFolds = param.numFolds;
qtdClasses = param.qtdClasses;
frac = param.frac;
base = param.base;

vIni = param.vIni;
vInc = param.vInc;
vFin = param.vFin;
resolucoes = param.resolucoes;

matrizErrosClasse = param.matrizErrosClasse;
vetorEscoresClasses = param.vetorEscoresClasses;

%conhfigurações do SVM
% paraC = ceil(0.1 * ptrn * size(dados.y, 1))+80;
paraC = conf.paraC;
sigma = conf.sigma;
fkernel = conf.fkernel;
fkernel = conf.metodo;
options.MaxIter = conf.options.MaxIter;

%%ABRIR ARQUIVO
nameFile = sprintf('results/Base%d_resultsSVM_train%d_SIGMA%.2f_R%d_%s.txt',base,ptrn*100,conf.sigma,numRodadas,conf.fkernel);
nameFile2 = sprintf('results/Base%d_Resumo_resultsSVM_train%d_SIGMA%.2f_R%d_%s.txt',base,ptrn*100,conf.sigma,numRodadas,conf.fkernel);
fileID = fopen(nameFile,'w');
fileID2 = fopen(nameFile2,'w');
accGeral = zeros(qtdClasses,1);

somaEscoresAcertosClasse = zeros(qtdClasses,1);
somaEscoresErrosClasse = zeros(qtdClasses,1);

matrixConfusion = zeros(qtdClasses);

%total máximo de escores de acertos do classificador
maxEscoresAcertos = (1-ptrn)*50*(sum(vetorEscoresClasses'));

for reso = resolucoes
    %% Pré-processamento
    % dados = carregaDados('DB_GLCM.txt', 4);
    if param.base == 1
        fileGLCM = sprintf(param.pathGLCM,reso);
    else
        if reso == 100
            fileGLCM = sprintf(param.pathGLCM,99*100);
        else
            fileGLCM = sprintf(param.pathGLCM,reso*100);
        end
    end
    temp = load(fileGLCM);
    dados.x = temp(:, 1:end-1);
    dados.y = temp(:, end);
    
    if base == 1 
        dados.y = dados.y + 1;
    end
    clear temp

    %optParam = searchParamSVM(dados, paramsSVM, 3, ptrn );
    fprintf(fileID,'##################################################################\n');
    fprintf(fileID,'################RESULTADOS - GLCM %d%% DE RESOLUCAO###############\n', reso);
    fprintf(fileID,'##################################################################\n\n\n');
    
    %% Avaliando o método
    for i = 1 : numRodadas
        %index da posição na matrix resolucao
        %pos = reso/vInc;
        pos = (reso/vInc)-13;
        %% Embaralhando os dados
        [dadosTrein, dadosTeste] = embaralhaDados(dados, ptrn, 2);


        %% Treinamento do SVM
        fprintf('Treinando o SVM...\nRodada %d - Resolução %d\n', i,reso);
        fprintf(fileID,'################RODADA %d################\n\n', i);

        [Y, time] = multisvm(dadosTrein.x, dadosTrein.y, dadosTeste.x, conf);

        % Matriz de confusao e acurácia
        matrizesConf{i} = confusionmat(dadosTeste.y', Y');
        matrixConfusion = matrixConfusion + matrizesConf{i};
        %acuracia(i) = trace(matrizesConf{i}) / length(Y);
        
        %%CÁCULO DOS PREÇO|ESCORES DO COURO POR REALIZAÇÃO(RODADA
        % BASEADO NA MATRIZ DE CONFUSÃO
        for lin = 1 : qtdClasses
            for col = 1 : qtdClasses
                if lin == col  %acertos - diagonal principal
                    somaEscoresAcertosClasse(lin) = somaEscoresAcertosClasse(lin) + (vetorEscoresClasses(lin) * (matrizesConf{i}(lin,col)/frac));
                else %erros
                    somaEscoresErrosClasse(lin) = somaEscoresErrosClasse(lin) + (matrizesConf{i}(lin,col)*(matrizErrosClasse(lin,col)/frac));
                end
            end
            %matriz 3d - rodada:classe:resolução
            somaEscoresAcertosResoGeral(lin,i,pos) = somaEscoresAcertosClasse(lin);
            somaEscoresErrosResoGeral(lin,i,pos) = somaEscoresErrosClasse(lin);
        end
       
        %%
        %escrevendo a matriz de confusao
        fprintf(fileID,'MATRIZ DE CONFUSÃO\n');
        fprintf(fileID,'%3d %3d %3d %3d %3d %3d %3d\r\n',matrizesConf{i}');
        fprintf(fileID,'\n');
        
        %escrevendo a soma dos escores por classe baseado na matriz acima
        fprintf(fileID,'#SOMA DOS ESCORES DE ACERTOS E ERROS#\n');
        fprintf(fileID,'%2s %10s %10s\r\n','CLASSE','ACERTO','ERRO');
        for k = 1 : qtdClasses
            fprintf(fileID,'%3d %11.1f %11.1f\r\n',k,somaEscoresAcertosClasse(k),somaEscoresErrosClasse(k));
        end
        fprintf(fileID,'\n%2s %9.1f %11.1f\r\n','TOTAL',sum(somaEscoresAcertosResoGeral(:,i,pos)),sum(somaEscoresErrosResoGeral(:,i,pos)));
        
        fprintf(fileID,'\n');
        
        %zera novamente o vetor de acertos e erros por classe
        somaEscoresAcertosClasse = zeros(qtdClasses,1);
        somaEscoresErrosClasse = zeros(qtdClasses,1);

        fprintf(fileID,'RESULTADO DAS MÉTRICAS NA RODADA %d POR CLASSE\n\n',i);
        fprintf(fileID,'%2s %10s\r\n','CLASSE','ACC_PC');

        %calculando a accurácia por classe
        for k = 1 : qtdClasses
            acc = matrizesConf{i}(k,k)/sum(matrizesConf{i}(k,:));
            accGeral(k) = accGeral(k) + acc;
            vetorAccClasse(k,i) = acc;
            %vetorAccClasseRodReso{k}(i,pos) = acc;
            matrixAccClasseRodReso(k,i,pos) = acc;
            %vetorAccResoRodClasse{pos}(i,k) = acc;
            fprintf(fileID,'%3d %12.3f \r\n',k,acc);
        end
        fprintf(fileID,'\n');
    end
    fprintf('FIM DE TODO O PROCESSO...\n');

    %mediaAcc = mean(acuracia);

    fprintf(fileID,'################GERAL################\n\n', i);
    fprintf(fileID,'RESULTADO GERAL DAS MÉTRICAS POR CLASSE : GLCM %d%%\n\n',reso);
    
    %escrevendo a matriz de confusao
    fprintf(fileID,'MATRIZ DE CONFUSÃO: GLCM %d%%\n\n',reso);
    fprintf(fileID,'%3.1f %3.1f %3.1f %3.1f %3.1f %3.1f %3.1f\r\n',(matrixConfusion')/numRodadas);
    fprintf(fileID,'\n');
        
    matrixConfusion = zeros(qtdClasses);    
        
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
    
    %%soma dos acertos e erros por Resolução
    %totalEscoresAcertosReso = sum(somaEscoresAcertosResoGeral{1,reso}');
end

%ESCREVENDO NO ARQUIVO O RESULTADO (ACUÁRIA E DESVIO PADRÃO) GERAL DAS CLASSES EM CADA RESOLUÇÃO
fprintf(fileID2,'RESULTADO GERAL DAS MÉTRICAS POR CLASSE E RESOLUÇÕES : GLCM - ACURÁCIA E DESVIO PADRÃO (%d RODADAS | RESOLUÇÃO DE %d ATÉ %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','CLASSE');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%10s   ','ACC|STD');
end
fprintf(fileID2,'\r\n');

for k = 1 : qtdClasses
    fprintf(fileID2,'%3d   ',k);
    for reso = 1 : (vFin/vInc)-13
        fprintf(fileID2,' %7.3f|%1.3f',vetorAccClasseReso(k,reso),vetorDesvClasseReso(k,reso));
    end
    fprintf(fileID2,'\r\n');
end
fprintf(fileID2,'\n%2s ','MÉDIA');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,' %7.3f|%1.3f',mean(vetorAccClasseReso(:,reso)),mean(vetorDesvClasseReso(:,reso)));
end
fprintf(fileID2,'\r\n');

%ESCREVENDO NO ARQUIVO O SOMATÓRIO DOS ESCORES DE ACERTOS E ERROS DAS CLASSES EM CADA RODADA POR RESOLUÇÃO
fprintf(fileID2,'\n\nSOMATÓRIO DOS ESCORES DE ACERTOS E ERROS DAS CLASSES EM CADA RODADA POR RESOLUÇÃO (%d RODADAS | RESOLUÇÃO DE %d ATÉ %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','RODADA');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%10s   ','ACE|ERR');
end
fprintf(fileID2,'\r\n');

for rod = 1 : numRodadas
    fprintf(fileID2,'%3d ',rod);
    for reso = 1 : (vFin/vInc)-13
        fprintf(fileID2,'       %03d|%03d',sum(somaEscoresAcertosResoGeral(:,rod,reso)),sum(somaEscoresErrosResoGeral(:,rod,reso)));
    end
    fprintf(fileID2,'\r\n');
end

%ESCREVENDO NO ARQUIVO A MÉDIA DOS TOTAIS DE ACERTOS E ERROS POR CLASSE EM
%CADA RESOLUÇÃO
fprintf(fileID2,'\n\nMÉDIA DOS TOTAIS DOS ESCORES DE ACERTOS E ERROS POR CLASSE EM CADA RESOLUÇÃO (%d RODADAS | RESOLUÇÃO DE %d ATÉ %d%%)\n\n',numRodadas,vIni,vFin);

fprintf(fileID2,'%6s ','');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%7d%%     ',reso);
end
fprintf(fileID2,'\r\n');

fprintf(fileID2,'%2s ','CLASSE');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'|%10s   ','ACE|ERR');
end
fprintf(fileID2,'\r\n');

for k = 1 : qtdClasses
    fprintf(fileID2,'%3d   ',k);
    for reso = 1 : (vFin/vInc)-13
        fprintf(fileID2,'   %05.1f|%05.1f',mean(somaEscoresAcertosResoGeral(k,:,reso)),mean(somaEscoresErrosResoGeral(k,:,reso)));
    end
    fprintf(fileID2,'\r\n');
end
fprintf(fileID2,'\n%2s ','MÉDIA');
for reso = 1 : (vFin/vInc)-13
    fprintf(fileID2,'   %05.1f|%05.1f',mean2(somaEscoresAcertosResoGeral(:,:,reso)),mean2(somaEscoresErrosResoGeral(:,:,reso)));
end
fprintf(fileID2,'\r\n');

%fechando os arquivos
fclose(fileID);
fclose(fileID2);


fprintf('\nSalvando Matrizes\n');

fileSaveAcc = sprintf('acc_Base%d_Rods%d.mat',param.base,numRodadas);
fileSaveAcertos = sprintf('acertos_Base%d_Rods%d.mat',param.base,numRodadas);
fileSaveErros = sprintf('erros_Base%d_Rods%d.mat',param.base,numRodadas);

save(fileSaveAcc,'matrixAccClasseRodReso');
save(fileSaveAcertos,'somaEscoresAcertosResoGeral');
save(fileSaveErros,'somaEscoresErrosResoGeral');

fprintf('Ok! Arquivos gerados e Matrizes salvas\n');
