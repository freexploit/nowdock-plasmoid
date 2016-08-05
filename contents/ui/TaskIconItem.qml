import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kquickcontrolsaddons 2.0 as KQuickControlAddons

Item{
    id: centralItem

    width: wrapper.regulatorSize
    height: wrapper.regulatorSize
    property int doubleSize : 2 * panel.iconSize;

    //big interval to show shadows only after all the crappy adds and removes of tasks
    //have happened
    property int shadowInterval: 100

    property int normalIconInterval: 40

    function updateImages(){
        if(panel.inAnimation === false){
            if(activeLoader.item)
                activeLoader.item.updateImage();

            if(panel.enableShadows === true){
                if(defaultWithShadow.item){
                    defaultWithShadow.item.updateImage();
                }
            }
            else{
                if(defaultNoShadow.item)
                    defaultNoShadow.item.updateImage();
            }
        }
    }

    //Something to show until the buffers are updated
    KQuickControlAddons.QIconItem{
        id: iconImageBackground

        property real relatedSize: panel.iconSize *  ( (2*panel.iconSize - 16) / (2*panel.iconSize) );

        width: relatedSize * wrapper.scale * wrapper.appearScale
        height: width
        anchors.centerIn: parent

        state: KQuickControlAddons.QIconItem.DefaultState
        icon: decoration

        Timer{
            id:hideBackgroundTimer
            repeat:false
            interval: centralItem.shadowInterval
            onTriggered: {
                iconImageBackground.visible = false;
              //  iconImageBuffer.visible = false;
            }
        }
    }

    Image {
        id: iconImageBuffer

        property real newTempSize: panel.iconSize * wrapper.scale * wrapper.appearScale
        width: newTempSize
        height: newTempSize

        anchors.centerIn: parent

        source: simpleIcon.source

        visible: true

        // opacity: (wrapper.containsMouse === false) ? 1 : 0.4

        //    Behavior on opacity {
        //     NumberAnimation { duration: 100 }
        //   }

        Image{
            anchors.fill: iconImageBuffer
            source: activeIcon.source

            opacity: wrapper.containsMouse ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
    }


    Image{
        id:activeIcon
        visible:false
    }

    Image{
        id:simpleIcon
        visible:false
    }

    Loader{
        id:defaultWithShadow
        active: panel.enableShadows === true
        sourceComponent: component
    }


    //active state does not need shadow
    //the shadow from defaultWithShadow is used if needed
    Loader{
        id:activeLoader
        sourceComponent: component2
    }

    Loader{
        id:defaultNoShadow
        active: panel.enableShadows === false
        sourceComponent: componentns
    }


    /* Loader{
        id:activeNoShadow
        active: panel.enableShadows === false
        sourceComponent: componentns
    }*/


    // Another way for the shadow must be found it increases the cpu cycles x2 alsmost,
    // even with the following caching mechanism.
    // it would be must better if we could create an image
    // the first time and use the DropShadow mechanism and then
    // just use that image for the animations

    /*  PlasmaCore.IconItem {
        id: iconImage

        width:64
        height:64

        anchors.centerIn: parent

        active: true
        enabled: true
        usesPlasmaTheme: false

        source: decoration

    }*/

    /* Image{
        id:iconImage
        width: 64
        height: 64
        source: "firefox.png"
    }

    DropShadow {
        id:shadowImageNoActive

        width: 64
        height: 64

        scale: wrapper.scale * wrapper.appearScale

        anchors.centerIn: parent

        radius: 7.0
        samples: 10
        color: "#90080808"
        source: ShaderEffectSource {
            id:effectSource
            width: iconImage.width
            height: iconImage.height
            sourceItem: iconImage
            hideSource: true
            live: false
        }

    }*/

    ///////////////Buffering

    Component {
        id: component
        Item {
            id: yourImageWithLoadedIconContainer
            anchors.fill: parent

            function updateImage(){
                ttt.restart();
            }

            Item{
                id:fixedIcon
                width: 2*panel.iconSize
                height: width

                visible:false

                KQuickControlAddons.QIconItem{
                    id: iconImage
                    width: parent.width - 16
                    height: parent.height - 16
                    anchors.centerIn: parent

                    state: KQuickControlAddons.QIconItem.DefaultState
                    icon: decoration

                    visible: true

                    // too many draws must be disabled, instead
                    // we can blacklist the application which creates
                    // drawing errors (libreoffice writer)
                    ///onIconChanged: centralItem.updateImages();

                    // use this when using Image instead of Rectangle

                    Timer{
                        id:ttt
                        repeat:false
                        interval: centralItem.shadowInterval

                     //   property int counter: 0;

                        onTriggered: {
                            if(index !== -1){
                                shadowImageNoActive.grabToImage(function(result) {
                                    simpleIcon.source = result.url;
                                }, Qt.size(fixedIcon.width,fixedIcon.height) );

                          //      counter = counter + 1;
                             //   console.log("_______ Pos:" +index+" Count:" + counter);

                                hideBackgroundTimer.restart();
                            }
                        }
                    }

                    Component.onCompleted: {
                        ttt.restart();
                    }
                }
            }

            DropShadow {
                id:shadowImageNoActive
                visible:false
                width: fixedIcon.width
                height: fixedIcon.height
                anchors.centerIn: fixedIcon

                radius: 4
                samples: 7
                color: "#cc080808"
                source: fixedIcon
            }
        }
    }

    Component {
        id: component2
        Item {
            id: yourImageWithLoadedIconContainer2
            anchors.fill: parent
            function updateImage(){
                ttt11.restart();
            }

            Item{
                id:fixedIcon2
                width: 2*panel.iconSize
                height: width

                visible:false

                KQuickControlAddons.QIconItem{
                    id: iconImage2
                    width: parent.width - 16
                    height: parent.height - 16
                    anchors.centerIn: parent

                    state: KQuickControlAddons.QIconItem.ActiveState
                    icon: decoration

                    visible: true

                    // use this when using Image instead of Rectangle
                    Timer{
                        id:ttt11
                        repeat:false
                        interval: centralItem.shadowInterval
                        onTriggered: {
                            if(index !== -1){
                                fixedIcon2.grabToImage(function(result) {
                                    activeIcon.source = result.url;
                                }, Qt.size(fixedIcon2.width,fixedIcon2.height) );
                            }
                        }
                    }

                    //                Component.onCompleted: {
                    //             ttt11.restart();
                    //         }
                }
            }

        }
    }


    ////////Components with no shadows//////////////
    Component {
        id: componentns
        Item {
            id: yourImageWithLoadedIconContainerns
            anchors.fill: parent

            function updateImage(){
                tttns.restart();
            }

            Item{
                id:fixedIconns
                width: 2*panel.iconSize
                height: width

                visible:false

                KQuickControlAddons.QIconItem{
                    id: iconImagens
                    width: parent.width - 16
                    height: parent.height - 16
                    anchors.centerIn: parent

                    state: KQuickControlAddons.QIconItem.DefaultState
                    icon: decoration

                    visible: true


                    onIconChanged: centralItem.updateImages();

                    // use this when using Image instead of Rectangle
                    Timer{
                        id:tttns
                        repeat:false
                        interval: centralItem.normalIconInterval
                        onTriggered: {
                            if(index !== -1){
                                fixedIconns.grabToImage(function(result) {
                                    simpleIcon.source = result.url;
                                }, Qt.size(fixedIconns.width,fixedIconns.height) );
                            }
                        }
                    }

                    Component.onCompleted: {
                        tttns.start();
                    }
                }
            }
        }
    }

}// Icon Item
