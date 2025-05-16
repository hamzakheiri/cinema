
<!DOCTYPE html>
<html>
<head>
    <title>Film Chat</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .chat-container {
            border: 1px solid #ccc;
            border-radius: 5px;
            overflow: hidden;
        }
        .chat-header {
            background-color: #f1f1f1;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        .chat-messages {
            height: 300px;
            overflow-y: scroll;
            padding: 10px;
            background-color: #f9f9f9;
        }
        .message {
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 5px;
        }
        .user-message {
            background-color: #e3f2fd;
            margin-left: 20px;
        }
        .other-message {
            background-color: #f1f1f1;
            margin-right: 20px;
        }
        .system-message {
            background-color: #fff3cd;
            text-align: center;
            font-style: italic;
        }
        .sender {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .chat-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ccc;
        }
        .chat-input input {
            flex-grow: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .chat-input button {
            margin-left: 10px;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .chat-input button:hover {
            background-color: #45a049;
        }
        .connection-status {
            margin-bottom: 10px;
        }
        .status-connected {
            color: green;
        }
        .status-disconnected {
            color: red;
        }
    </style>
</head>
<body>
    <h1>Film Chat</h1>

    <div class="connection-status">
        Status: <span id="connection-status" class="status-disconnected">Disconnected</span>
        <button id="connect-btn" onclick="connect()">Connect</button>
        <button id="disconnect-btn" onclick="disconnect()" disabled>Disconnect</button>
    </div>

    <div class="chat-container">
        <div class="chat-header">
            <h3>Film ID: <span id="film-id">${filmId}</span></h3>
        </div>
        <div id="chat-messages" class="chat-messages"></div>
        <div class="chat-input">
            <input type="text" id="sender" placeholder="Your name" />
            <input type="text" id="message" placeholder="Type a message..." />
            <button id="send-btn" onclick="sendMessage()" disabled>Send</button>
        </div>
    </div>

    <#assign ctx = request.contextPath />
    <div style="display: none;">
        <span id="context-path">${ctx}</span>
    </div>
<#noparse>
    <script>
        let stompClient = null;
        let username = '';

        // Get filmId from the page
        const filmId = document.getElementById('film-id').textContent;

        function addMessage(sender, content, type = 'other') {
            const messagesDiv = document.getElementById('chat-messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${type}-message`;

            const senderDiv = document.createElement('div');
            senderDiv.className = 'sender';
            senderDiv.textContent = sender;

            const contentDiv = document.createElement('div');
            contentDiv.className = 'content';
            contentDiv.textContent = content;

            messageDiv.appendChild(senderDiv);
            messageDiv.appendChild(contentDiv);
            messagesDiv.appendChild(messageDiv);

            // Scroll to bottom
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }

        function connect() {
            try {
                // Get the context path from the page
                const contextPath = document.getElementById('context-path').textContent.trim();
                console.log(`Using context path: ${contextPath}`);

                // Build the WebSocket URL with the context path
                const sockJsUrl = contextPath + '/ws';
                console.log(`Connecting to SockJS at: ${sockJsUrl}`);

                // Create SockJS instance
                const socket = new SockJS(sockJsUrl);
                stompClient = Stomp.over(socket);

                // Disable debug logging to avoid console spam
                stompClient.debug = null;

                stompClient.connect({},
                    (frame) => {
                        console.log("Connected with frame:", frame);

                        // Update UI to show connected status
                        document.getElementById('connection-status').textContent = 'Connected';
                        document.getElementById('connection-status').className = 'status-connected';
                        document.getElementById('connect-btn').disabled = true;
                        document.getElementById('disconnect-btn').disabled = false;
                        document.getElementById('send-btn').disabled = false;

                        // Subscribe to film chat messages
                        stompClient.subscribe(`/topic/films/${filmId}/chat/messages`, (message) => {
                            console.log("Received film chat message:", message);

                            try {
                                const parsedMessage = JSON.parse(message.body);
                                const messageType = parsedMessage.sender === username ? 'user' :
                                                   parsedMessage.sender === 'system' ? 'system' : 'other';
                                addMessage(parsedMessage.sender, parsedMessage.content, messageType);
                            } catch (e) {
                                // If it's not JSON, just display as is
                                addMessage('System', message.body, 'system');
                            }
                        });

                        // Add a system message to show connection
                        addMessage('System', 'Connected to chat. You can now send messages.', 'system');
                    },
                    (error) => {
                        console.error("STOMP connection error:", error);
                        addMessage('System', 'Error connecting to chat server. Please try again.', 'system');
                        document.getElementById('connection-status').textContent = 'Connection Error';
                        document.getElementById('connection-status').className = 'status-disconnected';
                    }
                );
            } catch (e) {
                console.error("Connection exception:", e);
                addMessage('System', 'Error: ' + e.message, 'system');
            }
        }

        function disconnect() {
            if (stompClient !== null) {
                stompClient.disconnect();
                stompClient = null;

                // Update UI to show disconnected status
                document.getElementById('connection-status').textContent = 'Disconnected';
                document.getElementById('connection-status').className = 'status-disconnected';
                document.getElementById('connect-btn').disabled = false;
                document.getElementById('disconnect-btn').disabled = true;
                document.getElementById('send-btn').disabled = true;

                // Add a system message
                addMessage('System', 'Disconnected from chat.', 'system');
            }
        }

        function sendMessage() {
            try {
                if (!stompClient || !stompClient.connected) {
                    addMessage('System', 'Not connected to chat server. Please connect first.', 'system');
                    return;
                }

                // Get the sender name and message content
                const senderInput = document.getElementById('sender');
                const messageInput = document.getElementById('message');

                username = senderInput.value.trim() || 'Anonymous';
                const content = messageInput.value.trim();

                if (!content) {
                    return; // Don't send empty messages
                }

                // Create a message that matches the ChatMessage class structure
                const chatMessage = {
                    sender: username,
                    content: content
                };

                console.log("Sending chat message:", chatMessage);

                // Send the message with proper headers
                stompClient.send(
                    `/app/films/${filmId}/chat/send`,
                    {
                        'content-type': 'application/json'
                    },
                    JSON.stringify(chatMessage)
                );

                // Clear the message input
                messageInput.value = '';
                messageInput.focus();

            } catch (e) {
                console.error("Message send error:", e);
                addMessage('System', 'Error sending message: ' + e.message, 'system');
            }
        }

        // Add event listener for Enter key in message input
        document.addEventListener('DOMContentLoaded', function() {
            const messageInput = document.getElementById('message');
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            // Auto-connect when page loads
            setTimeout(connect, 500);
        });
    </script>
</#noparse>
</body>
</html>
