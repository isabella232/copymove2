#pragma once

#include <QScrollArea>

class QLabel;

class ScrollArea : public QScrollArea {
        Q_OBJECT
    public:
        explicit ScrollArea( QWidget* parent = 0 );

    signals:

    public slots:
        void slotDrawImage( QImage image , bool fit );

    protected:
        virtual void wheelEvent( QWheelEvent* event );
        virtual void mouseDoubleClickEvent( QMouseEvent* );
        virtual void mousePressEvent( QMouseEvent* event );
        virtual void mouseReleaseEvent( QMouseEvent* );
        virtual void mouseMoveEvent( QMouseEvent* );

    private:
        void zoom();
        void autoZoom();

        float mZoom;
        QLabel* mLabel;
        QSize mImageSize;

        bool mMousePressed;
        QPointF mMousePosition;
};
