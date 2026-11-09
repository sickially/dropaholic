import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation {
    id: presentation

    Slide {
        Rectangle { anchors.fill: parent; color: "#0b0b10" }
        Text {
            anchors.centerIn: parent
            text: "Instalando o Dropaholic..."
            color: "#a78bfa"
            font.pixelSize: 28
        }
    }
}
