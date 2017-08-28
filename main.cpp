#include <QQuickStyle>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setOrganizationName("qmob-solutions");
    app.setOrganizationDomain("qmob.solutions");
    app.setApplicationName("agora-client-qtconbr");

    QQuickStyle::setStyle("material");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
