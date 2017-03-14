clear all; close all; clc;
p = path; path(p, '../');


for z = 1 : 10

% Train
tic

    imgsTrain{1} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P3_C1/s (%d).png', randperm(200,1))) ;
    imgsTrain{2} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P3_C2/s (%d).png', randperm(200,1))) ;
    imgsTrain{3} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P3_C3/s (%d).png', randperm(200,1))) ;
    imgsTrain{4} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P4_C4/s (%d).png', randperm(200,1))) ;
    imgsTrain{5} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P4_C5/s (%d).png', randperm(200,1))) ;
    imgsTrain{6} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P2_C6/s (%d).png', randperm(200,1))) ;
    imgsTrain{7} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P2_C7/s (%d).png', randperm(200,1))) ;
    imgsTrain{8} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P1_C8/s (%d).png', randperm(200,1))) ;
    imgsTrain{9} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P1_C9/s (%d).png', randperm(200,1))) ;
    imgsTrain{10} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P1_C10/s (%d).png', randperm(200,1))) ;
    imgsTrain{11} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P5_C11/s (%d).png', randperm(200,1))) ;
    imgsTrain{12} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P6_C12/s (%d).png', randperm(200,1))) ;
    imgsTrain{13} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P6_C13/s (%d).png', randperm(200,1))) ;
    imgsTrain{14} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P6_C14/s (%d).png', randperm(200,1))) ;
    imgsTrain{15} = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P5_C15/s (%d).png', randperm(200,1))) ;

for i = 1 : length(imgsTrain)
    
    points = detectSURFFeatures(rgb2gray(imgsTrain{i}));
    [framesTrain{i}, ~] = extractFeatures(rgb2gray(imgsTrain{i}), points);
        
end
timeTrain(z) = toc;

fprintf('Test\n');
% Test
tic
imT = imread(sprintf('/Users/leandrobm/Dropbox/2015_InTech_Mapa_Topologico/Simulation V-REP/Imagens/P3_C1/s (%d).png', randperm(200,1))) ;
points = detectSURFFeatures(rgb2gray(imT));
[frameT, ~] = extractFeatures(rgb2gray(imT), points);

for i = 1 : 15
    
    indexPairs = matchFeatures(frameT, framesTrain{i});
        
    numIndex(i) = size(indexPairs,1);
end

[~, lbs] = sort(numIndex, 'descend');
lbs(1)

timeTest(z) = toc;

end

path(p);