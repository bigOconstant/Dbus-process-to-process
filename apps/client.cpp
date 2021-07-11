#include <sdbus-c++/sdbus-c++.h>
#include <vector>
#include <string>
#include <iostream>
#include <unistd.h>
using std::cout;
using std::endl;

void onReceive(sdbus::Signal& signal)
{
    std::string input;
    signal >> input;

    std::cout << "Received signal with string " << input << std::endl;
}

int main(int argc, char *argv[])
{
    if(argc <2) {
        cout<<"please enter a mesasge to send"<<endl;
        return 1;
    }
    // Create proxy object for the Messenger object on the server side. Since here
    // we are creating the proxy instance without passing connection to it, the proxy
    // will create its own connection automatically, and it will be system bus connection.
    const char* serviceName = "org.wolf.Messenger.client";
    cout<<"calling create"<<endl;
    auto connection = sdbus::createSessionBusConnection(serviceName);


    const char* destinationName = "org.wolf.Messenger";
    const char* objectPath = "/org/wolf/Messenger";
    auto MessengerProxy = sdbus::createProxy(std::move(connection),destinationName, objectPath);

    // Let's subscribe for the 'concatenated' signals
    const char* interfaceName = "org.wolf.Messenger";
    MessengerProxy->registerSignalHandler(interfaceName, "messaged", &onReceive);
    MessengerProxy->finishRegistration();

    // Invoke message on given interface of the object
    {
        auto method = MessengerProxy->createMethodCall(interfaceName, "message");
        method << argv[1];
        auto reply = MessengerProxy->callMethod(method);
        std::string result;

        cout<<"About to call results\n"<<endl;
        reply >> result;
        cout<<result<<endl; 
    }

 
    return 0;
}