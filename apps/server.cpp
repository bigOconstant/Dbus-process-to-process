#include <sdbus-c++/sdbus-c++.h>
#include <vector>
#include <string>
#include <iostream>

using std::cout;
using std::endl;

// Yeah, global variable is ugly
sdbus::IObject* g_message{};

void concatenate(sdbus::MethodCall call)
{
    cout<<"Calling remote method"<<endl;
   
    std::string message;
    call >> message;
    cout<<"message:"<<message<<endl;
    
    // Serialize resulting string to the reply and send the reply to the caller
    auto reply = call.createReply();
    reply << "Thanks!";
    reply.send();

    // Emit 'Thanks' signal
    const char* interfaceName = "org.wolf.Messenger";
    auto signal = g_message->createSignal(interfaceName, "messaged");
    signal << "Thanks";
   
    g_message->emitSignal(signal);
}

int main(int argc, char *argv[])
{
    // Create D-Bus connection to the system bus and requests name on it.
    const char* serviceName = "org.wolf.Messenger";
    cout<<"calling create"<<endl;
    auto connection = sdbus::createSessionBusConnection(serviceName);
    cout<<"done calling create"<<endl;

    // Create Messenger D-Bus object.
    const char* objectPath = "/org/wolf/Messenger";
    auto Messenger = sdbus::createObject(*connection, objectPath);

    g_message = Messenger.get();

    // Register D-Bus methods and signals on the Messenge object, and exports the object.
    const char* interfaceName = "org.wolf.Messenger";
    Messenger->registerMethod(interfaceName, "message", "s", "s", &concatenate);
    Messenger->registerSignal(interfaceName, "messaged", "s");
    Messenger->finishRegistration();

    // Run the I/O event loop on the bus connection.
    connection->enterEventLoop();
}