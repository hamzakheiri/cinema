<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Test</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
    <!-- Use an older version of stomp.js that's more compatible -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        #log {
            height: 300px;
            overflow-y: scroll;
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
        }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>WebSocket Test Page</h1>
    <div>
        <button id="connect">Connect</button>
        <button id="disconnect" disabled>Disconnect</button>
    </div>
    <div>
        <input type="text" id="message" placeholder="Type a message..." />
        <button id="sendHello" disabled>Send to /hello</button>
        <button id="sendEcho" disabled>Send to /echo</button>
        <button id="sendTest" disabled>Send to /test</button>
        <button id="sendChat" disabled>Send to Chat</button>
    </div>
    <div>
        <button id="testRest">Test REST Endpoint</button>
    </div>
    <div id="log"></div>

    <script>
        let stompClient = null;
        const log = document.getElementById('log');
        const connectButton = document.getElementById('connect');
        const disconnectButton = document.getElementById('disconnect');
        const sendHelloButton = document.getElementById('sendHello');
        const sendEchoButton = document.getElementById('sendEcho');
        const sendTestButton = document.getElementById('sendTest');
        const sendChatButton = document.getElementById('sendChat');
        const testRestButton = document.getElementById('testRest');
        const messageInput = document.getElementById('message');

        function addLogEntry(message, type = 'info') {
            const entry = document.createElement('div');
            entry.className = type;
            entry.textContent = `${new Date().toLocaleTimeString()}: ${message}`;
            log.appendChild(entry);
            log.scrollTop = log.scrollHeight;
        }

        function setConnected(connected) {
            connectButton.disabled = connected;
            disconnectButton.disabled = !connected;
            sendHelloButton.disabled = !connected;
            sendEchoButton.disabled = !connected;
            sendTestButton.disabled = !connected;
            sendChatButton.disabled = !connected;
            messageInput.disabled = !connected;

            if (connected) {
                addLogEntry('Connected to WebSocket', 'success');
            } else {
                addLogEntry('Disconnected from WebSocket', 'info');
            }
        }

        function connect() {
            addLogEntry('Attempting to connect...');

            // Log SockJS availability
            if (typeof SockJS === 'undefined') {
                addLogEntry('SockJS is not defined!', 'error');
                return;
            }
            addLogEntry('SockJS is available');

            try {
                // Create SockJS instance
                addLogEntry('Creating SockJS connection to /ex00_war/ws');
                const socket = new SockJS('/ex00_war/ws');

                // Log Stomp availability
                if (typeof Stomp === 'undefined') {
                    addLogEntry('Stomp is not defined!', 'error');
                    return;
                }
                addLogEntry('Stomp is available');

                // Create Stomp client
                stompClient = Stomp.over(socket);

                // Enable debug logging
                stompClient.debug = function(str) {
                    console.log(str);
                    // Only log important messages to avoid cluttering the UI
                    if (str.includes('error') || str.includes('failed') || str.includes('connect')) {
                        addLogEntry(`STOMP: ${str}`, str.includes('error') ? 'error' : 'info');
                    }
                };

                // Connect to the broker
                addLogEntry('Connecting to STOMP broker...');
                stompClient.connect(
                    {},
                    frame => {
                        setConnected(true);
                        addLogEntry(`Connected: ${frame}`);

                        // Subscribe to various topics
                        stompClient.subscribe('/topic/greetings', message => {
                            addLogEntry(`Received from greetings: ${message.body}`, 'success');
                        });

                        stompClient.subscribe('/topic/echo', message => {
                            addLogEntry(`Received from echo: ${message.body}`, 'success');
                        });

                        stompClient.subscribe('/topic/test', message => {
                            addLogEntry(`Received from test: ${message.body}`, 'success');
                        });

                        stompClient.subscribe('/topic/films/1/chat/messages', message => {
                            try {
                                const chatMessage = JSON.parse(message.body);
                                addLogEntry(`Received chat: ${chatMessage.sender}: ${chatMessage.content}`, 'success');
                            } catch (e) {
                                addLogEntry(`Received raw chat: ${message.body}`, 'success');
                            }
                        });
                    },
                    error => {
                        addLogEntry(`Connection error: ${error}`, 'error');
                        disconnect();
                    }
                );
            } catch (e) {
                addLogEntry(`Exception: ${e.message}`, 'error');
                console.error(e);
            }
        }

        function disconnect() {
            if (stompClient !== null) {
                try {
                    stompClient.disconnect();
                } catch (e) {
                    addLogEntry(`Disconnect error: ${e.message}`, 'error');
                }
            }
            setConnected(false);
            stompClient = null;
        }

        function sendMessage(destination) {
            const message = messageInput.value;
            if (!message.trim()) {
                addLogEntry('Please enter a message', 'error');
                return;
            }

            addLogEntry(`Sending to ${destination}: ${message}`);
            try {
                if (destination === '/app/films/1/chat/send') {
                    // Send as JSON for chat
                    const chatMessage = {
                        sender: 'test-user',
                        content: message
                    };
                    stompClient.send(destination, {'content-type': 'application/json'}, JSON.stringify(chatMessage));
                } else {
                    // Send as plain text for other destinations
                    stompClient.send(destination, {}, message);
                }
                messageInput.value = '';
            } catch (e) {
                addLogEntry(`Send error: ${e.message}`, 'error');
            }
        }

        function testRestEndpoint() {
            addLogEntry('Testing REST endpoint...');
            fetch('/ex00_war/test-ws')
                .then(response => response.text())
                .then(data => {
                    addLogEntry(`REST response: ${data}`, 'info');
                })
                .catch(error => {
                    addLogEntry(`REST error: ${error}`, 'error');
                });
        }

        // Event listeners
        connectButton.addEventListener('click', connect);
        disconnectButton.addEventListener('click', disconnect);
        sendHelloButton.addEventListener('click', () => sendMessage('/app/hello'));
        sendEchoButton.addEventListener('click', () => sendMessage('/app/echo'));
        sendTestButton.addEventListener('click', () => sendMessage('/app/test'));
        sendChatButton.addEventListener('click', () => sendMessage('/app/films/1/chat/send'));
        testRestButton.addEventListener('click', testRestEndpoint);

        messageInput.addEventListener('keypress', e => {
            if (e.key === 'Enter') {
                sendMessage('/app/hello');
            }
        });

        // Log page load
        addLogEntry('Page loaded. Click "Connect" to start WebSocket connection.');
    </script>
</body>
</html>
