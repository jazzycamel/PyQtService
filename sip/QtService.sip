%Import QtCore/QtCoremod.sip

%If (Qt_5_0_0 -)

class QtServiceController {
	
%TypeHeaderCode
#include "qtservice.h"
%End

public:
    enum StartupType
    {
	    AutoStartup = 0, ManualStartup
    };

    QtServiceController(const QString &name);
    virtual ~QtServiceController();

    bool isInstalled() const;
    bool isRunning() const;

    QString serviceName() const;
    QString serviceDescription() const;
    StartupType startupType() const;
    QString serviceFilePath() const;

    static bool install(const QString &serviceFilePath, const QString &account = QString(),
                const QString &password = QString());
    bool uninstall();

    bool start(const QStringList &arguments);
    bool start();
    bool stop();
    bool pause();
    bool resume();
    bool sendCommand(int code);
};

class QtCoreService {

%TypeHeaderCode
#include "qtservice.h"
typedef QtService<QCoreApplication> QtCoreService;
%End


public:
	QtCoreService(SIP_PYLIST argv /TypeHint="List[str]"/, const QString &name)  /PostHook=__pyQtQAppHook__/ [(int &argc, char **argv, const QString &name)];
%MethodCode
		int argc;
		char **argv;
		const QString *name=a1;

		if((argv=pyqt5_from_argv_list(a0, argc))==NULL) sipIsErr=1;
		else {
			static int nargc;
			nargc=argc;

			Py_BEGIN_ALLOW_THREADS
			sipCpp=new sipQtCoreService(nargc, argv, *name);
			Py_END_ALLOW_THREADS

			pyqt5_update_argv_list(a0, argc, argv);

		}
%End

    enum MessageType
    {
	Success = 0, Error, Warning, Information
    };

    enum ServiceFlag
    {
        Default = 0x00,
        CanBeSuspended = 0x01,
        CannotBeStopped = 0x02,
        NeedsStopOnShutdown = 0x04
    };
    typedef QFlags<QtCoreService::ServiceFlag> ServiceFlags;

	QString serviceName() const;
	QString serviceDescription() const;
	void setServiceDescription(const QString &description);

	QtServiceController::StartupType startupType() const;
	void setStartupType(QtServiceController::StartupType startupType);

	QtCoreService::ServiceFlags serviceFlags() const;
	void setServiceFlags(ServiceFlags flags);

	int exec();

	void logMessage(
			const QString &message,
			QtCoreService::MessageType=QtCoreService::Success,
			int id=0,
			uint category=0,
			const QByteArray &data=QByteArray()
	);

	virtual void start();
%MethodCode
	return NULL;
%End
%VirtualCallCode

	void stop();
	void pause();
	void resume();

%End
};

%ModuleHeaderCode
// Imports from QtCore.
typedef char **(*pyqt5_from_argv_list_t)(PyObject *, int &);
extern pyqt5_from_argv_list_t pyqt5_from_argv_list;

typedef void (*pyqt5_update_argv_list_t)(PyObject *, int, char **);
extern pyqt5_update_argv_list_t pyqt5_update_argv_list;
%End

%ModuleCode
pyqt5_from_argv_list_t pyqt5_from_argv_list;
pyqt5_update_argv_list_t pyqt5_update_argv_list;
%End

%PostInitialisationCode
// Imports from QtCore.
pyqt5_from_argv_list = (pyqt5_from_argv_list_t)sipImportSymbol("pyqt5_from_argv_list");
pyqt5_update_argv_list = (pyqt5_update_argv_list_t)sipImportSymbol("pyqt5_update_argv_list");
%End

%End