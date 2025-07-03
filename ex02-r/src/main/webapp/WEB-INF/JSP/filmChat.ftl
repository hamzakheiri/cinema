
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
        .message {
            margin: 5px 0;
            padding: 5px;
            border-radius: 3px;
            background-color: #f0f0f0;
        }
        .message.system {
            background-color: #e7f3ff;
            font-style: italic;
        }
        .upload-section {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .image-link {
            display: inline-block;
            margin: 5px;
            padding: 5px 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 3px;
        }
        .image-link:hover {
            background-color: #0056b3;
        }
        .user-sessions {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .user-sessions table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .user-sessions th, .user-sessions td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .user-sessions th {
            background-color: #f2f2f2;
            font-weight: bold;
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
            <p>Welcome <strong>${anonymousName}</strong> | Your IP: ${userIp}</p>
        </div>
        <div id="chat-messages" class="chat-messages">
            <!-- Load existing messages -->
            <#if messages?? && messages?size gt 0>
                <#list messages as msg>
                    <div class="message">
                        <strong>${msg.sender}</strong> (
                        <#if msg.timestamp?is_string>
                            ${msg.timestamp?substring(11, 16)}
                        <#else>
                            ${msg.timestamp?string("HH:mm")}
                        </#if>
                        ): ${msg.content}
                    </div>
                </#list>
            <#else>
                <div class="message system">No messages yet. Start the conversation!</div>
            </#if>
        </div>
        <div class="chat-input">
            <input type="text" id="sender" placeholder="Your name" value="${anonymousName}" />
            <input type="text" id="message" placeholder="Type a message..." />
            <button id="send-btn" onclick="sendMessage()" disabled>Send</button>
        </div>
    </div>

    <!-- Image Upload Section -->
    <div class="upload-section">
        <h3>Upload Avatar (${anonymousName})</h3>
        <form id="upload-form" enctype="multipart/form-data">
            <input type="file" id="file-input" accept="image/*" />
            <button type="button" onclick="uploadImage()">Upload</button>
        </form>
        <div id="upload-result"></div>

        <h4>Your Uploaded Images</h4>
        <div id="image-list"></div>
    </div>

    <!-- User Sessions Section -->
    <div class="user-sessions">
        <h3>User Authentication History</h3>
        <div class="sessions-list">
            <#if userSessions?? && userSessions?size gt 0>
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>IP Address</th>
                            <th>Login Time</th>
                            <th>Last Activity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list userSessions as session>
                            <tr>
                                <td>${session.userId}</td>
                                <td>${session.ipAddress}</td>
                                <td>
                                    <#if session.loginTime?is_string>
                                        ${session.loginTime?replace("T", " ")}
                                    <#else>
                                        ${session.loginTime?string("yyyy-MM-dd HH:mm:ss")}
                                    </#if>
                                </td>
                                <td>
                                    <#if session.lastActivity?is_string>
                                        ${session.lastActivity?replace("T", " ")}
                                    <#else>
                                        ${session.lastActivity?string("yyyy-MM-dd HH:mm:ss")}
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <p>No user sessions found.</p>
            </#if>
        </div>
    </div>

<#assign ctx = request.contextPath>
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
                const contextPathElement = document.getElementById('context-path');
                console.log('Context path element:', contextPathElement);
                if (!contextPathElement) {
                    console.error('context-path element not found!');
                    addMessage('System', 'Error: context-path element not found', 'system');
                    return;
                }
                const contextPath = contextPathElement.textContent.trim();
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
                    content: content,
                    userIp: '${userIp}'
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
            // loadImageList will be called from outside noparse section
        });
    </script>
</#noparse>

<script>
    // Image upload function (outside noparse so FreeMarker can process ${ctx})
    function uploadImage() {
        const fileInput = document.getElementById('file-input');
        const file = fileInput.files[0];

        if (!file) {
            document.getElementById('upload-result').innerHTML = '<p style="color: red;">Please select a file</p>';
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        fetch('${ctx}/images', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(result => {
            document.getElementById('upload-result').innerHTML = '<p style="color: green;">' + result + '</p>';
            loadImageList();
            fileInput.value = '';
        })
        .catch(error => {
            document.getElementById('upload-result').innerHTML = '<p style="color: red;">Upload failed: ' + error + '</p>';
        });
    }

    // Load available images (outside noparse so FreeMarker can process ${ctx})
    function loadImageList() {
        fetch('${ctx}/images/list')
        .then(response => response.json())
        .then(images => {
            const imageListDiv = document.getElementById('image-list');
            imageListDiv.innerHTML = '';

            if (images.length === 0) {
                imageListDiv.innerHTML = '<p>No images uploaded yet.</p>';
            } else {
                images.forEach(imageInfo => {
                    const link = document.createElement('a');
                    link.href = '${ctx}/images/' + imageInfo.storedName;
                    link.target = '_blank';
                    link.className = 'image-link';
                    link.textContent = imageInfo.originalName;
                    link.title = 'Uploaded: ' + imageInfo.uploadTime;
                    imageListDiv.appendChild(link);
                });
            }
        })
        .catch(error => {
            console.error('Failed to load image list:', error);
        });
    }

    // Load images when page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadImageList();
    });
</script>

</body>
</html>
