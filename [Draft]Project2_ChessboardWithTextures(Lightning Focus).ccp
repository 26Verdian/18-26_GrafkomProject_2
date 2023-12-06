#include <cstdlib>
#include <iostream>
#include <fstream>
#include <GL/glew.h>
#include <GL/freeglut.h>
#include "getBMP.h"


int gridSizex = 8;
int gridSizey = 4;
float board = -0.5;
float box = -0.5;
float chessx = 0;
float chessy = 0;
float chessz = 0;
float angleX = 0.0f;
float angleY = 0.0f;
int prevMouseX = 0;
int prevMouseY = 0;
bool isRotating = false;
int animationDuration = 1000;

GLfloat light_position[] = { 5.0, 5.0, 5.0, 1.0 };
GLfloat light_ambient[] = { 0.2, 0.2, 0.2, 1.0 };
GLfloat light_diffuse[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat light_specular[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat material_ambient[] = { 0.5, 0.5, 0.5, 1.0 };
GLfloat material_diffuse[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat material_specular[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat material_shininess = 100.0;

GLuint textures;

void loadTextures() {
    imageFile* image[1];
    image[0] = getBMP("../../Textures/Chess.bmp");

    glBindTexture(GL_TEXTURE_2D, textures);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image[0]->width, image[0]->height, 0,
        GL_RGBA, GL_UNSIGNED_BYTE, image[0]->data);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
}

void drawChessboard1() {
    for (int i = 0; i < gridSizex; ++i) {
        for (int j = 0; j < gridSizey; ++j) {
            if ((i + j) % 2 == 0) {
                glColor3f(1.0, 1.0, 1.0);
            }
            else {
                glColor3f(0.0, 0.0, 0.0);
            }

            glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
            glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
            glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
            glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

            glPushMatrix();
            glTranslatef(i - gridSizex / 2, 0.0, j - gridSizey / 2);
            glScalef(1.0, 0.2, 1.0);
            glutSolidCube(1.0);
            glPopMatrix();
        }
    }
}

void drawChessboard2() {
    glTranslatef(chessx, chessy, chessz);

    for (int i = 0; i < gridSizex; ++i) {
        for (int j = 0; j < gridSizey; ++j) {
            if ((i + j) % 2 == 0) {
                glColor3f(1.0, 1.0, 1.0);
            }
            else {
                glColor3f(0.0, 0.0, 0.0);
            }

            glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
            glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
            glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
            glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

            glPushMatrix();
            glTranslatef(i - gridSizex / 2, -0.6, j - gridSizey / 2);
            glScalef(1.0, 0.2, 1.0);
            glutSolidCube(1.0);
            glPopMatrix();
        }
    }
}

void openBox(int value) {
    if (box < 5.0) {
        box += 0.05;
        glutPostRedisplay();
        glutTimerFunc(animationDuration / 100, openBox, 0);
    }
}

void closeBox(int value) {
    if (box > -0.5) {
        box -= 0.05;
        glutPostRedisplay();
        glutTimerFunc(animationDuration / 100, closeBox, 0);
    }
}

void drawWoodenBoard1() {
    glColor3f(0.6, 0.4, 0.2);

    glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
    glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

    glPushMatrix();
    glTranslatef(-0.5, -0.3, -0.5);
    glScalef(8.5, 0.5, 4.5);
    glutSolidCube(1.0);
    glPopMatrix();
}

void drawWoodenBoard2() {
    glColor3f(0.6, 0.4, 0.2);

    glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
    glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

    glPushMatrix();
    glTranslatef(-0.5, -0.3, board);
    glScalef(8.5, 0.5, 4.5);
    glutSolidCube(1.0);
    glPopMatrix();
}

void drawBox() {
    static bool textureLoaded = false;
    if (!textureLoaded) {
        loadTextures();
        textureLoaded = true;
    }

    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textures);

    glColor3f(1.0, 1.0, 1.0);

    glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
    glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

    glPushMatrix();
    glTranslatef(-0.5, -0.3, box);

    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, 2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, 0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, 0.75, 2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, -2.5);
    glEnd();

    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, -0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(4.5, 0.75, 2.5);
    glEnd();

    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-4.5, -0.75, 2.5);
    glTexCoord2f(1.0, 0.0); glVertex3f(-4.5, -0.75, -2.5);
    glTexCoord2f(1.0, 1.0); glVertex3f(-4.5, 0.75, -2.5);
    glTexCoord2f(0.0, 1.0); glVertex3f(-4.5, 0.75, 2.5);
    glEnd();

    glPopMatrix();

    glDisable(GL_TEXTURE_2D);
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    gluLookAt(5.0, 5.0, 15.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);

    glRotatef(angleY, 1.0, 0.0, 0.0);
    glRotatef(angleX, 0.0, 1.0, 0.0);

    drawWoodenBoard1();
    drawWoodenBoard2();
    drawChessboard1();
    drawChessboard2();
    drawBox();

    glutSwapBuffers();
}

void reshape(int w, int h) {
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0, (GLfloat)w / (GLfloat)h, 0.1, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

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
        glutTimerFunc(0, openBox, 0);
        break;
    case 'd':
        if (board <= -0.5) {
            glutTimerFunc(0, closeBox, 0);
        }
        break;
    case 'o':
        if (box >= 5.0) {
            board = 3.5;
            chessy = 0.6;
            chessz = 4;
            glutPostRedisplay();
        }
        break;
    case 'c':
        board = -0.5;
        chessy = 0;
        chessz = 0;
        glutPostRedisplay();
        break;
    }
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Papan Catur");

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glLightfv(GL_LIGHT0, GL_POSITION, light_position);
    glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);

    glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, material_specular);
    glMaterialf(GL_FRONT, GL_SHININESS, material_shininess);

    glutKeyboardFunc(keyboard);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMouseFunc(mouse);
    glutMotionFunc(motion);
    glutMainLoop();

    return 0;
}
