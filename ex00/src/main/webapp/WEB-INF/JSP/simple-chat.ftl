<!DOCTYPE html>
<html>
<head>
    <title>Simple Chat</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        #messages {
            height: 300px;
            overflow-y: scroll;
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
        }
        .message { margin-bottom: 5px; }
        .sender { font-weight: bold; }
        .content { margin-left: 10px; }
    </style>
</head>
<body>
    <h1>Simple Chat</h1>

    <div>
        <label for="room">Room:</label>
        <input type="text" id="room" value="general" />
        <button id="connect">Connect</button>
        <button id="disconnect" disabled>Disconnect</button>
    </div>

    <div id="messages"></div>

    <div>
        <input type="text" id="sender" placeholder="Your name" />
        <input type="text" id="content" placeholder="Type a message..." />
        <button id="send" disabled>Send</button>
    </div>

    <script>
        let stompClient = null;
        let currentRoom = null;

        function connect() {
            const room = $('#room').val();
            if (!room) {
                alert('Please enter a room name');
                return;
            }

            currentRoom = room;

            const socket = new SockJS('/ex00_war/ws');
            stompClient = Stomp.over(socket);

            stompClient.connect({}, function(frame) {
                console.log('Connected: ' + frame);

                $('#connect').prop('disabled', true);
                $('#disconnect').prop('disabled', false);
                $('#send').prop('disabled', false);

                // Subscribe to the room topic
                stompClient.subscribe('/topic/chat/' + room, function(message) {
                    showMessage(JSON.parse(message.body));
                });

                // Also subscribe to simple-test topic
                stompClient.subscribe('/topic/simple-test', function(message) {
                    console.log('Simple test message received: ' + message.body);
                    showSystemMessage('Simple test: ' + message.body);
                });

                showSystemMessage('Connected to room: ' + room);

                // Send a test message
                stompClient.send('/app/simple-test', {}, JSON.stringify('Hello from room ' + room));
            }, function(error) {
                console.log('Error: ' + error);
                showSystemMessage('Error connecting: ' + error);
            });
        }

        function disconnect() {
            if (stompClient !== null) {
                stompClient.disconnect();
                stompClient = null;
                currentRoom = null;

                $('#connect').prop('disabled', false);
                $('#disconnect').prop('disabled', true);
                $('#send').prop('disabled', true);

                showSystemMessage('Disconnected');
            }
        }

        function sendMessage() {
            const sender = $('#sender').val() || 'Anonymous';
            const content = $('#content').val();

            if (!content) {
                alert('Please enter a message');
                return;
            }

            const message = {
                sender: sender,
                content: content
            };

            stompClient.send('/app/chat/' + currentRoom, {}, JSON.stringify(message));
            $('#content').val('');
        }

        function showMessage(message) {
            $('#messages').append(
                '<div class="message">' +
                '<span class="sender">' + message.sender + ':</span>' +
                '<span class="content">' + message.content + '</span>' +
                '</div>'
            );
            scrollToBottom();
        }

        function showSystemMessage(message) {
            $('#messages').append(
                '<div class="message" style="color: blue;">' +
                '<span class="content">' + message + '</span>' +
                '</div>'
            );
            scrollToBottom();
        }

        function scrollToBottom() {
            const messages = $('#messages');
            messages.scrollTop(messages[0].scrollHeight);
        }

        $(function() {
            $('#connect').click(connect);
            $('#disconnect').click(disconnect);
            $('#send').click(sendMessage);

            $('#content').keypress(function(e) {
                if (e.which === 13) {
                    sendMessage();
                }
            });
        });
    </script>
</body>
</html>
