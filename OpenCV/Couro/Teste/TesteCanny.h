#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <stdlib.h>
#include <stdio.h>

using namespace cv;

/// Global variables

Mat src, src_gray;
Mat dst, detected_edges;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 100;
int ratio = 3;
int kernel_size = 3;
char* window_name = "Edge Map";

/**
* @function CannyThreshold
* @brief Trackbar callback - Canny thresholds input with a ratio 1:3
*/
void CannyThreshold(int, void*)
{
	/// Reduce noise with a kernel 3x3
	//blur(src_gray, detected_edges, Size(3, 3));

	/// Canny detector
	Canny(src_gray, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size);
	//Erosion Image
	Mat element = getStructuringElement(0, Size(15, 15), Point(13, 13));
	Mat element2 = getStructuringElement(0, Size(9, 9), Point(1, 1));
	morphologyEx(detected_edges, detected_edges, 1, element);//close
	morphologyEx(detected_edges, detected_edges, 0, element2);//open


	// find the contours
	vector< vector<Point> > contours;
	findContours(detected_edges, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

	// you could also reuse detected_edges here
	Mat mask = Mat::zeros(detected_edges.rows, detected_edges.cols, CV_8UC1);

	// CV_FILLED fills the connected components found
	//drawContours(mask, contours, -1, Scalar(255), CV_FILLED);

	/*
	Before drawing all contours you could also decide
	to only draw the contour of the largest connected component
	found. Here's some commented out code how to do that:
	*/

	vector<double> areas(contours.size());

	for (int i = 0; i < contours.size(); i++)
		areas[i] = contourArea(Mat(contours[i]));

	double max;
	Point maxPosition;
	minMaxLoc(Mat(areas), 0, &max, 0, &maxPosition);
	drawContours(mask, contours, maxPosition.y, Scalar(255), CV_FILLED);



	// let's create a new image now
	Mat crop(detected_edges.rows, detected_edges.cols, CV_8UC3);

	// set background to white
	crop.setTo(Scalar(255, 255, 255));
	erode(mask, mask, element2);
	// and copy the object
	src.copyTo(crop, mask);

	//threshold(mask, mask, 110, 255, 1);

	//drawContours(crop, contours, maxPosition.y, CV_RGB(0, 0, 0), 1, 8, hierarchy);

	namedWindow("mask", CV_WINDOW_FREERATIO);
	//imshow("original", img0);
	imshow("mask", mask);
	// normalize so imwrite(...)/imshow(...) shows the mask correctly!
	bitwise_not(mask, mask);
	normalize(mask.clone(), mask, 0.0, 255.0, CV_MINMAX, CV_8UC1);

	// show the images

	/*namedWindow("canny", CV_WINDOW_FREERATIO);
	imshow("canny", detected_edges);
	namedWindow("cropped", CV_WINDOW_FREERATIO);
	imshow("cropped", crop);*/


	dst = Scalar::all(0);

	src.copyTo(dst, detected_edges);
	imshow(window_name, crop);
}


/** @function teste */
void teste()
{
	/// Load an image
	String path_img = "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\couro_images\\c6_20.jpg";// argv[1]
	src = imread(path_img);
	Scalar value = Scalar(0, 0, 0);
	copyMakeBorder(src, src, 1, 1, 1, 1, BORDER_CONSTANT, value);

	/// Create a matrix of the same type and size as src (for dst)
	dst.create(src.size(), src.type());

	/// Convert the image to grayscale
	cvtColor(src, src_gray, CV_BGR2GRAY);

	/// Create a window
	namedWindow(window_name, CV_WINDOW_KEEPRATIO);

	/// Create a Trackbar for user to enter threshold
	createTrackbar("Min Threshold:", window_name, &lowThreshold, max_lowThreshold, CannyThreshold);

	/// Show the image
	CannyThreshold(0, 0);

	/// Wait until user exit program by pressing a key
	waitKey(0);

	//return 0;
}