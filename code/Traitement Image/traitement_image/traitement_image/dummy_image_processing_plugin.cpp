/*
 * dummy_gabarit_version_etudiante.cpp
 *
 *  Created on: Jun 08, 2016
 *      Author: chaj1907, micj1901
 */


//aucun include externe local autre que la librairie boost (déjà installée) ou
//les include standard n'est permis. Tout doit tenir dans ce fichier. 
//Si vous utilisez une librairie externe le code source doit tenir ici.
#include <cstdint>
#include <iostream>
#include <cmath>
#include <cstdio>
#include <boost/shared_array.hpp>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <vector>
#include <math.h>
#include "image_processing_plugin.h"
using namespace std;

char* TEMPL_PATH = "../../images/templ.rgb";


//Modifiez cette classe-ci, vous pouvez faire littéralement ce que vous voulez y compris la renommer
//à condition de faire un "replace all"
//à condition de conserver le constructeur par défaut et aucun autre
//le destructeur virtuel
//et à condition que vous conserviez les 2 fonctions publiques virtuelles telles quelles.
class DummyImageProcessingPlugin : public ImageProcessingPlugin
{
public:
	DummyImageProcessingPlugin(); 			//vous devez utiliser ce constructeur et aucun autre
	virtual ~DummyImageProcessingPlugin();
	
	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_ptrImage Image data.
	 *  \param in_unWidth Image width (= 480).
	 *  \param in_unHeight Image height (= 480).
	 *  \param out_dXPos X coordinate (sub-)pixel position of the ball.
	 *  \param out_dYPos Y coordinate (sub-)pixel position of the ball.
	 *
	 */
	virtual void OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
			double & out_dXPos, double & out_dYPos);

			
			
	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_dXPos X coordinate position of the ball in <arbitrary input units.
	 *  \param in_dYPos Y coordinate position of the ball.
	 *  \param out_dXDiff X speed of the ball in <input units> per second.
	 *  \param out_dYDiff Y speed of the ball in <input units> per second.
	 *
	 */
	virtual void OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff);

private:
};

DummyImageProcessingPlugin::DummyImageProcessingPlugin()
{
//Insérez votre code ici
}

DummyImageProcessingPlugin::~DummyImageProcessingPlugin()
{
//Insérez votre code ici
}

boost::shared_array<uint8_t> load_img(char* filename, int width, int height, bool isOnlyRed)
{
	// Open image file
	ifstream image_file(filename, ios::binary);
	if (!image_file)
	{
		cerr << "Erreur: Chemin de l'image invalide" << endl;
	}

	int image_size = width * height;

	if (!isOnlyRed)
	{
		image_size *= 3;
	}

	// Check file size
	image_file.seekg(0, image_file.end);
	image_file.seekg(0, image_file.beg);

	// Read file
	boost::shared_array<uint8_t> image(new uint8_t[image_size]);
	image_file.read(reinterpret_cast<char *>(image.get()), image_size);

	if (!isOnlyRed)
	{
		boost::shared_array<uint8_t> imageR(new uint8_t[image_size / 3]);

		for (int i = 0; i < image_size; i += 3)
		{
			imageR[i / 3] = image[i];
		}

		return imageR;
	}

	return image;

	// Votre code ici: l'image est un tableau lineaire de uint8.
	// Chaque pixel contient 3 uint8 soit les composantes: Red, Green, Blue (expliquant le "*3" dans IMAGE_SIZE)
	// Les pixels sont sotckes en mode: row-major order.
	// L'outil convert de imagemagick peut etre interessant pour convertir le format d'image si requis:
	// convert -depth 8 -size 480x480 test.rgb test.png
}


void DummyImageProcessingPlugin::OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
		double & out_dXPos, double & out_dYPos)
{
	int step = 6;

	int templWidth = 48, templHeight = 48;
	int imageWidth = 480, imageHeight = 480;

	int corr = 0;
	int max = 0;
	int iMax = 0;
	int jMax = 0;

	boost::shared_array<uint8_t> templ = load_img(TEMPL_PATH, templWidth, templHeight, true);

	int meanTempl = 0;
	for (int n = 0; n<templWidth * templHeight; n++)
	{
		meanTempl += templ[n];
	}
	meanTempl = meanTempl / (templWidth  *templHeight);

	boost::shared_array<long> templMeans(new long[templWidth * templHeight]);
	for (int n = 0; n < templWidth * templHeight; n++)
	{
		templMeans[n] = (long)(templ[n] - meanTempl);
	}

	for (int j = 0; j<imageHeight - templHeight; j += step)
	{
		for (int i = 0; i<imageWidth - templWidth; i += step)
		{
			corr = 0;
			for (int n = 0; n<templHeight; n++)
			{
				for (int m = 0; m<templWidth; m++)
				{
					corr += templMeans[n * templWidth + m] * in_ptrImage[(n + j) * imageWidth + (m + i)];
				}
			}

			if (max < corr)
			{
				max = corr;
				iMax = i;
				jMax = j;
			}
		}
	}
	if (max < 3050000)
	{
		iMax = -1;
		jMax = -1;
	}
	else
	{
		iMax += templWidth / 2;
		jMax += templHeight / 2;
	}

	out_dXPos = iMax;
	out_dYPos = -jMax;
}

int factorielle(int n)
{
	return (n == 1 || n == 0) ? 1 : factorielle(n - 1) * n;
}

// Calcul la derivee numerique arriere d'ordre N des tableaux de position
// Backward higher - order differences : https ://en.wikipedia.org/wiki/Finite_difference#Higher-order_differences
void deriveeArriereOrdreSuperieur(double positionX[], double positionY[], int nombreImages, int N, double *deriveeX, double *deriveeY)
{
	for (int i = 0; i < N; i++)
	{
		deriveeX[i] = 0;
		deriveeY[i] = 0;
	}
	for (int k = N; k < nombreImages; k++)
	{
		deriveeX[k] = 0;
		deriveeY[k] = 0;
		for (int i = 0; i < N; i++)
		{
			double binomialNumber = factorielle(N) / factorielle(i) * factorielle(N - i);
			deriveeX[k] += pow(-1, i) * binomialNumber * positionX[k - i];
			deriveeY[k] += pow(-1, i) * binomialNumber * positionY[k - i];
		}
	}
}

// Calcul la differenciation numerique arriere d ordre N
void trouverVitesse(double Fe, double positionX[], double positionY[], int nombreImages, int N, double *vitesseX, double *vitesseY)
{
	double h = 1 / Fe;

	// S'il manque de donnees pour l ordre de differenciation, ramene l'ordre au minimum possible
	if (nombreImages < N)
	{
		N = nombreImages;
	}

	// Calcul les derivees d'ordre N
	std::vector<double*> deriveesX;
	vector<double*> deriveesY;
	if (N >= 2)
	{
		for (int k = 2; k <= N; k++)
		{
			double *deriveeX = new double[nombreImages];
			double *deriveeY = new double[nombreImages];
			deriveeArriereOrdreSuperieur(positionX, positionY, nombreImages, k, deriveeX, deriveeY);
			deriveesX.push_back(deriveeX);
			deriveesY.push_back(deriveeY);
		}
	}

	// Calcul principal, traite les premiers calculs de vitesse ou
	// l'incrementation est plus petite que l'ordre de differenciation
	vitesseX[0] = 0;
	vitesseY[0] = 0;
	for (int k = 1; k < nombreImages; k++)
	{
		double sommeDeriveesArrieresX = 0;
		double sommeDeriveesArrieresY = 0;
		for (int n = 2; n <= N; n++)
		{
			sommeDeriveesArrieresX += (pow((-h), n) / factorielle(n)) * deriveesX.at(n - 2)[k];
			sommeDeriveesArrieresY += (pow((-h), n) / factorielle(n)) * deriveesY.at(n - 2)[k];
		}
		vitesseX[k] = (positionX[k] - positionX[k - 1] + sommeDeriveesArrieresX) / h;
		vitesseY[k] = (positionY[k] - positionY[k - 1] + sommeDeriveesArrieresY) / h;
	}
}

void DummyImageProcessingPlugin::OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff)
{
	int ordre = 2;

	double Fe = 30;
	int nombreImages = 11;
	double testX[11] = { in_dXPos };
	double testY[11] = { in_dYPos };
	double *vitesseX = new double[nombreImages];
	double *vitesseY = new double[nombreImages];

	trouverVitesse(Fe, testX, testY, nombreImages, ordre, vitesseX, vitesseY);

	out_dXDiff = *vitesseX;
	out_dYDiff = *vitesseY;
}


//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire

extern "C"
{
	ImageProcessingPlugin * Load();
	void Unload( ImageProcessingPlugin * in_pPlugin );
}

void Unload( ImageProcessingPlugin * in_pPlugin )
{
	delete in_pPlugin;
}

ImageProcessingPlugin * Load()
{
	//si vous changez le nom de la classe asssurez-vous de le changer aussi ci-dessous
	return new DummyImageProcessingPlugin;
}
