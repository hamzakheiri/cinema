<!DOCTYPE html>
<html>
<head>
    <title>Film Chat</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
            color: #333;
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .chat-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .chat-header {
            background: linear-gradient(135deg, #d7ddf5 0%, #e8ddf2 100%);
            color: #2c3e50;
            padding: 20px;
            text-align: center;
        }

        .chat-header h3 {
            margin: 0 0 10px 0;
            font-size: 1.2em;
        }

        .chat-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.9em;
        }

        .chat-messages {
            height: 400px;
            overflow-y: auto;
            padding: 20px;
            background-color: #fafafa;
        }

        .message {
            margin-bottom: 15px;
            padding: 12px 16px;
            border-radius: 18px;
            max-width: 80%;
            word-wrap: break-word;
        }

        .user-message {
            background: linear-gradient(135deg, #d7ddf5 0%, #e8ddf2 100%);
            color: #2c3e50;
            margin-left: auto;
            margin-right: 0;
            text-align: right;
        }

        .other-message {
            background-color: #f0f2f5;
            color: #333;
            margin-right: auto;
            margin-left: 0;
        }

        .system-message {
            background-color: #f8f6f0;
            color: #6b6356;
            text-align: center;
            font-style: italic;
            margin: 10px auto;
            max-width: 60%;
        }

        .sender {
            font-weight: 600;
            margin-bottom: 5px;
            font-size: 0.85em;
            opacity: 0.8;
        }

        .chat-input {
            display: flex;
            padding: 20px;
            background-color: white;
            gap: 10px;
        }

        .chat-input input {
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .chat-input input:focus {
            outline: none;
            border-color: #a2a9d1;
        }

        .chat-input input[type="text"]:first-child {
            flex: 0 0 150px;
        }

        .chat-input input[type="text"]:last-of-type {
            flex: 1;
        }

        .chat-input button {
            padding: 12px 24px;
            background: linear-gradient(135deg, #8d98c7 0%, #a698b8 100%);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 400;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .chat-input button:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(162, 169, 209, 0.4);
        }

        .chat-input button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .section h3 {
            margin-top: 0;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
        }

        .upload-form {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-bottom: 15px;
        }

        .upload-form input[type="file"] {
            flex: 1;
            padding: 8px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
        }

        .upload-form button {
            padding: 10px 20px;
            background: linear-gradient(135deg, #8d98c7 0%, #a698b8 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 400;
        }

        .image-link {
            display: inline-block;
            margin: 5px;
            padding: 8px 16px;
            background: linear-gradient(135deg, #8d98c7 0%, #a698b8 100%);
            color: white;
            text-decoration: none;
            border-radius: 20px;
            font-size: 0.9em;
            transition: transform 0.2s ease;
        }

        .image-link:hover {
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .sessions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            border-radius: 8px;
            overflow: hidden;
        }

        .sessions-table th {
            background: linear-gradient(135deg, #8d98c7 0%, #a698b8 100%);
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .sessions-table td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
        }

        .sessions-table tr:hover {
            background-color: #f8f9fa;
        }

        /* Scrollbar styling */
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .chat-messages::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }

        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
    </style>
</head>
<body>
<h1>🎬 Film Chat</h1>

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
                    <div class="sender">${msg.sender}</div>
                    <div class="content">
                        ${msg.content}
                        <small style="opacity: 0.7; font-size: 0.8em; margin-left: 10px;">
                            <#if msg.timestamp?is_string>
                                ${msg.timestamp?substring(11, 16)}
                            <#else>
                                ${msg.timestamp?string("HH:mm")}
                            </#if>
                        </small>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="message system-message">No messages yet. Start the conversation!</div>
        </#if>
    </div>
    <div class="chat-input">
        <input type="text" id="sender" placeholder="Your name" value="${anonymousName}"/>
        <input type="text" id="message" placeholder="Type your message..."/>
        <button id="send-btn" onclick="sendMessage()">Send</button>
    </div>
</div>

<!-- Image Upload Section -->
<div class="section">
    <h3>📷 Upload Avatar (${anonymousName})</h3>
    <div class="upload-form">
        <input type="file" id="file-input" accept="image/*"/>
        <button type="button" onclick="uploadImage()">Upload</button>
    </div>
    <div id="upload-result"></div>

    <h4>Your Uploaded Images</h4>
    <div id="image-list"></div>
</div>

<!-- User Sessions Section -->
<div class="section">
    <h3>👥 User Authentication History</h3>
    <div class="sessions-list">
        <#if userSessions?? && userSessions?size gt 0>
            <table class="sessions-table">
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

                        // Add a subtle system message to show connection
                        addMessage('System', '✅ Connected to chat', 'system');
                    },
                    (error) => {
                        console.error("STOMP connection error:", error);
                        addMessage('System', '❌ Error connecting to chat server. Retrying...', 'system');
                        // Auto-retry connection after 3 seconds
                        setTimeout(connect, 3000);
                    }
                );
            } catch (e) {
                console.error("Connection exception:", e);
                addMessage('System', '❌ Error: ' + e.message, 'system');
            }
        }

        function disconnect() {
            if (stompClient !== null) {
                stompClient.disconnect();
                stompClient = null;
                addMessage('System', '👋 Disconnected from chat', 'system');
            }
        }

        function sendMessage() {
            try {
                if (!stompClient || !stompClient.connected) {
                    addMessage('System', '⚠️ Connecting to chat server...', 'system');
                    connect();
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
                addMessage('System', '❌ Error sending message: ' + e.message, 'system');
            }
        }

        // Add event listener for Enter key in message input
        document.addEventListener('DOMContentLoaded', function () {
            const messageInput = document.getElementById('message');
            const senderInput = document.getElementById('sender');

            // Enter key support for both inputs
            messageInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            senderInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    messageInput.focus();
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
            document.getElementById('upload-result').innerHTML = '<p style="color: #dc3545; font-weight: 500;">📁 Please select a file</p>';
            return;
        }

        // Show loading state
        document.getElementById('upload-result').innerHTML = '<p style="color: #6c757d; font-weight: 500;">⏳ Uploading...</p>';

        const formData = new FormData();
        formData.append('file', file);

        fetch('${ctx}/images', {
            method: 'POST',
            body: formData
        })
            .then(response => response.text())
            .then(result => {
                document.getElementById('upload-result').innerHTML = '<p style="color: #4a6741; font-weight: 400;">✅ ' + result + '</p>';
                loadImageList();
                fileInput.value = '';
            })
            .catch(error => {
                document.getElementById('upload-result').innerHTML = '<p style="color: #8b4341; font-weight: 400;">❌ Upload failed: ' + error + '</p>';
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
                    imageListDiv.innerHTML = '<p style="color: #61677a; font-style: italic;">📷 No images uploaded yet.</p>';
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
    document.addEventListener('DOMContentLoaded', function () {
        loadImageList();
    });
</script>

</body>
</html>
