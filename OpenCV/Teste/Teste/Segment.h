#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <stdlib.h>
#include <stdio.h>

using namespace cv;

/// Global variables

int threshold_value = 0;
int threshold_type = 3;;
int const max_value = 255;
int const max_type = 4;
int const max_BINARY_value = 255;

Mat src, src_gray, dst, erosion_dst, dilate_dst, detected_edges;
char* window_name = "Segmentation of Image";


/// Function headers
void Threshold_Demo(int, void*);

/**
* @function main
*/
void run(String img)
{
	/// Load an image
	src = imread(img);


	/// Create a window to display results
	//namedWindow(window_name, CV_WINDOW_AUTOSIZE);


	/// Create Trackbar to choose type of Threshold
	/*
	createTrackbar(trackbar_type,
	window_name, &threshold_type,
	max_type, Threshold_Demo);

	createTrackbar(trackbar_value,
	window_name, &threshold_value,
	max_value, Threshold_Demo);

	/// Call the function to initialize
	Threshold_Demo(0, 0);
	*/

	imshow("Original Image", src);

	/// Convert the image to Gray
	cvtColor(src, src_gray, CV_BGR2GRAY);
	imshow("Gray Scale", src_gray);

	//Canny
	Canny(src_gray, detected_edges, 90, 90 * 3, 3);
	imshow("Canny", detected_edges);

	//binary
	threshold(src_gray, dst, 110, max_BINARY_value, 0);
	imshow("Binary", dst);

	//Erosion Image
	Mat element = getStructuringElement(0, Size(3, 3));

	//morphologyEx(dst, dilate_dst, 3, 5);
	//dilate(detected_edges, dilate_dst, element);
	//imshow("Erosion Result", dilate_dst);

	

}


/**
* @function Threshold_Demo
*/
void Threshold_Demo(int, void*)
{
	/* 0: Binary
	1: Binary Inverted
	2: Threshold Truncated
	3: Threshold to Zero
	4: Threshold to Zero Inverted
	*/

	threshold(src_gray, dst, threshold_value, max_BINARY_value, threshold_type);

	imshow(window_name, dst);
}
