import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item{
    id:glowFrame
    width: ( icList.orientation === Qt.Horizontal ) ? wrapper.regulatorSize : size
    height: ( icList.orientation === Qt.Vertical ) ? wrapper.regulatorSize : size

    property int size: 8
    property int groupingSize : ( IsGroupParent) ? (2 * size) : size

    Item{
        width: (( IsGroupParent ) && (icList.orientation === Qt.Horizontal)) ? 2*glowFrame.size : glowFrame.size
        height: (( IsGroupParent ) && (icList.orientation === Qt.Vertical)) ? 2*glowFrame.size : glowFrame.size
        anchors.centerIn: parent

        Flow{
            flow: ( icList.orientation === Qt.Vertical ) ? Flow.TopToBottom : Flow.LeftToRight
            GlowPoint{
                width: glowFrame.size
                height: width

                visible: ( !IsLauncher ) ? true: false
            }
            GlowPoint{
                width: glowFrame.size
                height: width

                visible: (IsGroupParent) ? true: false
            }
        }
    }
}// number of windows indicator
