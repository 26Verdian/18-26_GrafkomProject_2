#include <cstdlib>
#include <iostream>
#include <fstream>
#include <GL/glew.h>
#include <GL/freeglut.h>
#include "getBMP.h"

int gridSizex = 8; // ukuran panjang grid papan catur
int gridSizey = 4; // ukuran lebar grid papan catur
float board = -0.5;
float box = -0.5;
float chessx = 0;
float chessy = 0;
float chessz = 0;
float angleX = 0.0f;
float angleY = 0.0f;
int prevMouseX = 0;
int prevMouseY = 0;
bool isRotating = false; // tracking pergerakan mouse
int animationDuration = 1000;

//menggambar kotak catur hitam dan putih yang pertama
void drawChessboard1() {

    //loop untuk menggambar kotak hitam dan putih
    for (int i = 0; i < gridSizex; ++i) { //loop baris
        for (int j = 0; j < gridSizey; ++j) { //loop kolom
            //menentukan warna putih atau hitam
            if ((i + j) % 2 == 0) {
                glColor3f(1.0, 1.0, 1.0);
            }
            else {
                glColor3f(0.0, 0.0, 0.0);
            }

            glPushMatrix();
            glTranslatef(i - gridSizex / 2, 0.0, j - gridSizey / 2); // mengatur posisi kotak
            glScalef(1.0, 0.2, 1.0);
            glutSolidCube(1.0); // untuk menggambar cube atau kotak
            glPopMatrix();
        }
    }
}

//menggambar kotak catur hitam dan putih yang kedua
void drawChessboard2() {
    glTranslatef(chessx, chessy, chessz);

    //loop untuk menggambar kotak hitam dan putih
    for (int i = 0; i < gridSizex; ++i) { //loop baris
        for (int j = 0; j < gridSizey; ++j) { //loop kolom
            //menentukan warna putih atau hitam
            if ((i + j) % 2 == 0) {
                glColor3f(1.0, 1.0, 1.0);
            }
            else {
                glColor3f(0.0, 0.0, 0.0);
            }

            glPushMatrix();
            glTranslatef(i - gridSizex / 2, -0.6, j - gridSizey / 2); // mengatur posisi kotak
            glScalef(1.0, 0.2, 1.0);
            glutSolidCube(1.0); // untuk menggambar cube atau kotak
            glPopMatrix();
        }
    }
}

//Fungsi untuk membuka box
void openBox(int value) {
    if (box < 5.0) {
        box += 0.05;
        glutPostRedisplay();
        glutTimerFunc(animationDuration / 100, openBox, 0);
    }
}

//Fungsi untuk menutup box
void closeBox(int value) {
    if (box > -0.5) {
        box -= 0.05;
        glutPostRedisplay();
        glutTimerFunc(animationDuration / 100, closeBox, 0);
    }
}

//menggambar papan kayu catur pertama
void drawWoodenBoard1() {
    glColor3f(0.6, 0.4, 0.2); // warna cokelat

    glPushMatrix();
    glTranslatef(-0.5, -0.3, -0.5);
    glScalef(8.5, 0.5, 4.5);
    glutSolidCube(1.0);
    glPopMatrix();
}

//menggambar papan kayu catur kedua
void drawWoodenBoard2() {
    glColor3f(0.6, 0.4, 0.2); // warna cokelat

    glPushMatrix();
    glTranslatef(-0.5, -0.3, board);
    glScalef(8.5, 0.5, 4.5);
    glutSolidCube(1.0);
    glPopMatrix();
}

GLuint textures;

// Fungsi Load Texture
void loadTextures()
{
    // Storage untuk image file
    imageFile* image[1];

    // meng-Load Image
    image[0] = getBMP("../../Textures/Chess.bmp");

    // Membuat texture object texture[0]. 
    glBindTexture(GL_TEXTURE_2D, textures);

    // Menspesifikasikan image data untuk texture objek yang aktif.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image[0]->width, image[0]->height, 0,
        GL_RGBA, GL_UNSIGNED_BYTE, image[0]->data);

    // Meng-Set texture parameters untuk wrapping.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    // Meng-Set texture parameters untuk filtering.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
}


void drawBox() {
    // Meng-Load texture
    static bool textureLoaded = false;
    if (!textureLoaded) {
        loadTextures();
        textureLoaded = true;
    }

    // Enable texturing 
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textures);

    // Mulai menggambar Box yang akan dibuat
    glColor3f(1.0, 1.0, 1.0); // warna putih

    glPushMatrix();
    glTranslatef(-0.5, -0.3, box);

    glBegin(GL_QUADS);
    // Front face
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, 2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    // Top face
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, 0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, 0.75, 2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, -2.5);
    glEnd();

    glBegin(GL_QUADS);
    // Bottom face
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, -0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    // Right face
    glTexCoord2f(0.0, 0.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(4.5, 0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    // Left face
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(-4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(-4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, 2.5);
    glEnd();

    glPopMatrix();

    // Disable texturing
    glDisable(GL_TEXTURE_2D);
}

void reshape(int w, int h) {
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0, (GLfloat)w / (GLfloat)h, 0.1, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

//fungsi mouse untuk input
void mouse(int button, int state, int x, int y) {
    if (button == GLUT_LEFT_BUTTON) {
        if (state == GLUT_DOWN) {
            prevMouseX = x;
            prevMouseY = y;
            isRotating = true;
        }
        else if (state == GLUT_UP) {
            isRotating = false;
        }
    }
}

//berfungsi untuk pergerakan mouse agar bisa memutar display
void motion(int x, int y) {
    if (isRotating) {
        int dx = x - prevMouseX;
        int dy = y - prevMouseY;
        angleX += dx;
        angleY += dy;
        prevMouseX = x;
        prevMouseY = y;
        glutPostRedisplay();
    }
}

void keyboard(unsigned char key, int x, int y) {
    switch (key) {
    case 'a':
        // Memulai animasi membuka Box
        glutTimerFunc(0, openBox, 0);
        break;
    case 'd':
        if (board <= -0.5) {
            // Memulai animasi menutup Box
            glutTimerFunc(0, closeBox, 0);
        }
        break;

    case 'o':
        // Membuka Chess Board
        if (box >= 5.0) {
            board = 3.5;
            chessy = 0.6;
            chessz = 4;
            glutPostRedisplay();
        }
        break;
    case 'c':
        // Menutup Chess Board
        board = -0.5;
        chessy = 0;
        chessz = 0;
        glutPostRedisplay();
        break;
    }
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();

    gluLookAt(5.0, 5.0, 15.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0);

    printf("Tombol kontrol:\n");
    printf("A = Membuka Box\n");
    printf("D = Menutup Box (Hanya bisa ditutup jika papan catur telah tertutup 'C')\n");
    printf("O = Membuka Papan Catur(Hanya bisa dibuka jika box telah terbuka 'A')\n");
    printf("C = Menutup Papan Catur\n");

    // mengaplikasikan rotasi mouse
    glRotatef(angleY, 1.0, 0.0, 0.0);
    glRotatef(angleX, 0.0, 1.0, 0.0);

    drawWoodenBoard1();
    drawWoodenBoard2();
    drawChessboard1();
    drawChessboard2();
    drawBox();

    glutSwapBuffers();
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Papan Catur");

    glEnable(GL_DEPTH_TEST); // Berfungsi agar setiap object tidak bertabrakan dan memiliki depth atau kedalaman

    glutKeyboardFunc(keyboard);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMouseFunc(mouse); // Agar input dari mouse terdetect
    glutMotionFunc(motion); // Mengubah gerakan mouse menjadi motion di dalam display
    glutMainLoop();

    return 0;
}
