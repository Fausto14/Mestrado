function gerarGraficos(base,param)

numRodadas = param.numRodadas;
resoIni    = param.resoIni;
resoFim    = param.resoFim;
qtdClasses = param.qtdClasses;
melhores   = param.melhores;


%% exibir/salvar boxplot
fprintf('\nGerando gráfico\n');

%BARRA TEMPO DE COMPUTAÇÃO
%bar dos somatórios dos escores de acertos
gcf = figure('visible','off');


%x = 5*(resoIni:resoFim);
x_5  = [5 10 15 20 25 30 35];
x_70 = [70 75 80 85 90 95 100];
x = x_5;%[x_5,x_70];

%tempos
%y1 = [22.3 8.85 6.64 5.52 5.11 5.05 4.81 4.51 4.64 4.49 4.65 4.48 4.47 4.56];%5-35 passos
y_5  = [18.82 7.72 5.934 4.96 4.616 4.594 4.377];
y_70 = [4.123 4.256 4.106 4.267 4.098 4.092 4.182];
y1   = y_5;%[y_5,y_70];

% y8 = [4.51 4.64 4.49 4.65 4.48 4.47 4.56];%70-100 passos

bar(x,y1,'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0],'LineWidth',1);

hold on

legend({'Tempo (s)'},'FontSize',12);


hold off
strTitle = sprintf('Tempo de Computação - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Amostragem');
%ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Bar_Tempo_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%%
%BARRA MEMÓRIA
%bar dos somatórios dos escores de acertos
gcf = figure('visible','off');


%x = 5*(resoIni:resoFim);
x_5  = [5 10 15 20 25 30 35];
x_70 = [70 75 80 85 90 95 100];
x = x_5;%[x_5,x_70];

%tempos
%y1 = [22.3 8.85 6.64 5.52 5.11 5.05 4.81 4.51 4.64 4.49 4.65 4.48 4.47 4.56];%5-35 passos
y_5  = [93.2 29.9 15.5 10.1 7.39 5.7 4.67];
y_70 = [3.85 3.23 2.94 2.48	2.41 2.1 1.98 1.81 1.74	1.57 1.54 1.32 1.33];
y1   = y_5;%[y_5,y_70];

% y8 = [4.51 4.64 4.49 4.65 4.48 4.47 4.56];%70-100 passos

bar(x,y1,'FaceColor',[0,0.5,0.5],'EdgeColor',[0,0.8,0.8],'LineWidth',1);

hold on

legend({'Tamanho (KB)'},'FontSize',12);


hold off
strTitle = sprintf('Tamanho em Memória das imagens   - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Amostragem');
%ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Bar_Memo_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

fprintf('\nFIM.\n');

end