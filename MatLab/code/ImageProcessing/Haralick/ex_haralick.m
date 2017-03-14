addpath('..');clear all;clc; close all;

% Example 1: only one distance (3 pixels)
options.dharalick = 1;                 % 3 pixels distance for coocurrence
imgRGB = imread('../dataBases/ROI/c1_1.JPG');
% R = segbalu(I);                    % segmentation
% J = I(:,:,2);                          % green channel
imgHSV = rgb2hsv(imgRGB); imgHSV = imgHSV(:,:,1);

imgGray = rgb2gray(imgRGB);




GLCM2 = graycomatrix(imgGray); %graycomatrix(I,'Offset',[2 0;0 2]); 
stats = GLCM_Features1(GLCM2,0); 
struct2array(stats)