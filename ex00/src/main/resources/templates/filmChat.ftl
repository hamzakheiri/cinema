
<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Debug</title>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
    <!-- Use an older version of stomp.js that's more compatible -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
<button onclick="connect()">Connect</button>
<button onclick="sendTest()">Send Chat Message (JSON)</button>
<button onclick="sendStringTest()">Send Chat Message (String)</button>
<button onclick="testTest()">Send Simple Test</button>
<button onclick="testRestEndpoint()">Test REST Endpoint</button>
<button onclick="testWebSocketEndpoint()">Test WebSocket Endpoint</button>
<div id="output"></div>
<#assign ctx = request.contextPath />
<h2> ${ctx}</h2>
<#noparse>
    <script>
        let stompClient = null;
        const filmId = 1; // Hardcoded for testing

        function log(message) {
            const output = document.getElementById('output');
            output.innerHTML += `<div>${new Date().toISOString()}: ${message}</div>`;
        }

        function connect() {
            try {
                log("Attempting connection...");

                // Check if SockJS is defined
                if (typeof SockJS === 'undefined') {
                    log("ERROR: SockJS is not defined. Make sure the library is loaded properly.");
                    return;
                }

                // Get the context path from the page
                const contextPath = document.querySelector('h2').textContent.trim();
                log(`Using context path: ${contextPath}`);

                // Build the WebSocket URL with the context path
                const sockJsUrl = contextPath + '/ws';
                log(`Connecting to SockJS at: ${sockJsUrl}`);

                // Create SockJS instance with default options
                log("Creating SockJS instance...");
                const socket = new SockJS(sockJsUrl);
                log("SockJS instance created successfully");

                // Check if Stomp is defined
                if (typeof Stomp === 'undefined') {
                    log("ERROR: Stomp is not defined. Make sure the library is loaded properly.");
                    return;
                }

                log("Creating Stomp client...");
                stompClient = Stomp.over(socket);
                log("Stomp client created successfully");

                // Enable detailed debugging
                stompClient.debug = (msg) => {
                    log(`STOMP: ${msg}`);
                    console.log("STOMP DEBUG:", msg);
                };

                log("Connecting to STOMP broker...");
                stompClient.connect({},
                    (frame) => {
                        log(`Connected! Frame: ${JSON.stringify(frame)}`);
                        console.log("Connected with frame:", frame);

                        // Subscribe to film chat messages
                        log("Subscribing to film chat messages...");
                        stompClient.subscribe(`/topic/films/${filmId}/chat/messages`, (message) => {
                            log(`RECEIVED FILM CHAT MESSAGE: ${message.body}`);
                            console.log("Received film chat message:", message);

                            // Try to parse the message if it's JSON
                            try {
                                const parsedMessage = JSON.parse(message.body);
                                log(`Parsed message - Sender: ${parsedMessage.sender}, Content: ${parsedMessage.content}`);
                            } catch (e) {
                                // If it's not JSON, just display as is
                                log(`Raw message content: ${message.body}`);
                            }
                        });

                        // Also subscribe to test topic for echo messages
                        log("Subscribing to test topic...");
                        stompClient.subscribe('/topic/test', (message) => {
                            log(`RECEIVED TEST ECHO: ${message.body}`);
                            console.log("Received test echo:", message);

                            // Try to parse the message if it's JSON
                            try {
                                const parsedMessage = JSON.parse(message.body);
                                log(`Parsed test message: ${JSON.stringify(parsedMessage)}`);
                            } catch (e) {
                                // If it's not JSON, just display as is
                                log(`Raw test message: ${message.body}`);
                            }
                        });

                        // Also subscribe to echo topic
                        log("Subscribing to echo topic...");
                        stompClient.subscribe('/topic/echo', (message) => {
                            log(`RECEIVED ECHO: ${message.body}`);
                            console.log("Received echo:", message);
                        });

                        // Also subscribe to greetings topic
                        log("Subscribing to greetings topic...");
                        stompClient.subscribe('/topic/greetings', (message) => {
                            log(`RECEIVED GREETING: ${message.body}`);
                            console.log("Received greeting:", message);
                        });

                        // Log connection success with more details
                        log('Connection established successfully!');

                        // Add a test message to verify the connection is working
                        setTimeout(() => {
                            log("Sending automatic test message...");
                            try {
                                stompClient.send("/app/test", {}, "Automatic test message");
                                log("Automatic test message sent");
                            } catch (e) {
                                log(`Error sending automatic test: ${e.message}`);
                                console.error("Automatic test error:", e);
                            }
                        }, 1000);
                    },
                    (error) => {
                        log(`Connection error: ${error}`);
                        console.error("STOMP connection error:", error);
                    }
                );
            } catch (e) {
                log(`Exception during connection: ${e.message}`);
                console.error("Connection exception:", e);
            }
        }

        function sendTest() {
            try {
                if (!stompClient) {
                    log("ERROR: STOMP client not initialized. Please connect first.");
                    return;
                }

                if (!stompClient.connected) {
                    log("ERROR: Not connected to STOMP broker. Please connect first.");
                    return;
                }

                // Create a message that matches the ChatMessage class structure
                const testMessage = {
                    sender: "debug-user",
                    content: "TEST MESSAGE " + new Date().toISOString()
                };

                // Log the message and destination
                log(`Sending to /app/films/${filmId}/chat/send: ${JSON.stringify(testMessage)}`);
                console.log("Sending chat message:", testMessage, "to", `/app/films/${filmId}/chat/send`);

                // Send the message with proper headers
                stompClient.send(
                    `/app/films/${filmId}/chat/send`,
                    {
                        'content-type': 'application/json'
                    },
                    JSON.stringify(testMessage)
                );

                log("Chat message sent successfully");
                log(`Waiting for response on /topic/films/${filmId}/chat/messages...`);
            } catch (e) {
                log(`Exception during chat message send: ${e.message}`);
                console.error("Chat message send error:", e);
            }
        }

        function sendStringTest() {
            try {
                if (!stompClient) {
                    log("ERROR: STOMP client not initialized. Please connect first.");
                    return;
                }

                if (!stompClient.connected) {
                    log("ERROR: Not connected to STOMP broker. Please connect first.");
                    return;
                }

                // Create a message that matches the ChatMessage class structure
                const testMessage = {
                    sender: "string-user",
                    content: "STRING MESSAGE " + new Date().toISOString()
                };

                // Log the message and destination
                log(`Sending string to /app/films/${filmId}/chat/send-string: ${JSON.stringify(testMessage)}`);
                console.log("Sending string message:", testMessage);

                // Send the message as a string to the string endpoint
                stompClient.send(
                    `/app/films/${filmId}/chat/send-string`,
                    {
                        'content-type': 'text/plain'
                    },
                    JSON.stringify(testMessage)
                );

                log("String message sent successfully");
                log(`Waiting for response on /topic/films/${filmId}/chat/messages...`);
            } catch (e) {
                log(`Exception during string message send: ${e.message}`);
                console.error("String message send error:", e);
            }
        }

        function testTest() {
            try {
                if (!stompClient) {
                    log("ERROR: STOMP client not initialized. Please connect first.");
                    return;
                }

                if (!stompClient.connected) {
                    log("ERROR: Not connected to STOMP broker. Please connect first.");
                    return;
                }

                const testMessage = "Hello WebSocket! " + new Date().toISOString();
                log(`Sending test message to /app/test: ${testMessage}`);
                console.log("Sending test message:", testMessage);

                // Send as plain text instead of JSON string
                stompClient.send("/app/test", {}, testMessage);
                log("Test message sent successfully");

                // Also log that we're expecting a response
                log("Waiting for response on /topic/test...");
            } catch (e) {
                log(`Exception during test message send: ${e.message}`);
                console.error("Test message send error:", e);
            }
        }

        function testRestEndpoint() {
            log("Testing REST endpoint...");

            // Make an AJAX call to the test-message endpoint
            fetch(`${document.querySelector('h2').textContent.trim()}/test-message`)
                .then(response => response.json())
                .then(data => {
                    log(`REST endpoint response: ${JSON.stringify(data)}`);
                    console.log("REST endpoint response:", data);
                    log("Check for messages on the subscribed topics...");
                })
                .catch(error => {
                    log(`Error calling REST endpoint: ${error.message}`);
                    console.error("REST endpoint error:", error);
                });
        }

        function testWebSocketEndpoint() {
            log("Testing WebSocket endpoint...");

            // Make an AJAX call to the test-ws endpoint
            fetch(`${document.querySelector('h2').textContent.trim()}/test-ws`)
                .then(response => response.text())
                .then(data => {
                    log(`WebSocket test response: ${data}`);
                    console.log("WebSocket test response:", data);
                    log("Check for messages on the subscribed topics...");
                })
                .catch(error => {
                    log(`Error calling WebSocket test endpoint: ${error.message}`);
                    console.error("WebSocket test endpoint error:", error);
                });
        }
    </script>
</#noparse>
</body>
</html>
