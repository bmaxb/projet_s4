// Projet S4
// Equipe P5
#include <iostream>
#include <vector>
#include <math.h>
#include <ctime>

using namespace std;

int selectionnerOrdre()
{
	int ordre;
	cout << "Selectionnez l'ordre de differenciation numerique arriere : ";
	cin >> ordre;
	return ordre;
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
	vector<double*> deriveesX;
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

void afficherVitesse(double *vitesseX, double *vitesseY, int nombreImages, clock_t tempsProcesseur)
{
	cout << endl << "Pour chaque image, la vitesse de la sphere (m / s) est : " << endl << endl
		 << "en X : ";
	for (int i = 0; i < nombreImages; i++)
	{
		cout << vitesseX[i];
		if (i < nombreImages - 1)
		{
			cout << ", ";
		}
	}
	cout << endl << "en Y : ";
	for (int i = 0; i < nombreImages; i++)
	{
		cout << vitesseY[i];
		if (i < nombreImages - 1)
		{
			cout << ", ";
		}
	}
	cout << endl << endl << "Le temps de calcul est de : " << ((float)tempsProcesseur) / CLOCKS_PER_SEC << " s" << endl << endl;
}

void main()
{
	clock_t tempsProcesseur;
	double Fe = 30;
	int nombreImages = 11;
	double testX[11] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	double testY[11] = { 0, 0.0011, 0.0044, 0.01, 0.0178, 0.028, 0.04, 0.05444, 0.071, 0.09, 0.111 };
	double *vitesseX = new double[nombreImages];
	double *vitesseY = new double[nombreImages];

	cout << "CALCUL DE VITESSE" << endl << endl;
	while (true)
	{
		int ordre = selectionnerOrdre();
		tempsProcesseur = clock();
		trouverVitesse(Fe, testX, testY, nombreImages, ordre, vitesseX, vitesseY);
		tempsProcesseur = clock() - tempsProcesseur;
		afficherVitesse(vitesseX, vitesseY, nombreImages, tempsProcesseur);
	}
}