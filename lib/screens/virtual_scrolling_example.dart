import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class VirtualScrollingExample extends StatefulWidget {
  const VirtualScrollingExample({super.key});

  @override
  State<VirtualScrollingExample> createState() => _VirtualScrollingExampleState();
}

class _VirtualScrollingExampleState extends State<VirtualScrollingExample> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  bool _isLoading = false;
  final int _totalMessages = 10000; // Simulate having 10k messages
  int _loadedMessages = 0;
  final int _messagesPerBatch = 50;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Load more messages when scrolling to the top
    if (_scrollController.position.pixels <= 100 && 
        !_isLoading && 
        _loadedMessages < _totalMessages) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadInitialMessages() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    
    final newMessages = _generateMessages(_loadedMessages, _messagesPerBatch);
    
    setState(() {
      _messages.addAll(newMessages.reversed); // Add in reverse order for chat
      _loadedMessages += newMessages.length;
      _isLoading = false;
    });

    // Scroll to bottom after initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoading || _loadedMessages >= _totalMessages) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    
    final newMessages = _generateMessages(_loadedMessages, _messagesPerBatch);
    
    setState(() {
      _messages.insertAll(0, newMessages.reversed); // Insert at beginning
      _loadedMessages += newMessages.length;
      _isLoading = false;
    });
  }

  List<ChatMessage> _generateMessages(int startIndex, int count) {
    final random = math.Random();
    final users = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'];
    final avatarColors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    
    final messageTypes = [
      'Hey there! How are you doing?',
      'Just finished my workout! 💪',
      'Anyone up for coffee later?',
      'Working on a new project, super excited!',
      'The weather is amazing today ☀️',
      'Just watched an incredible movie!',
      'Cooking dinner, what are you having?',
      'Weekend plans anyone?',
      'This new song is stuck in my head 🎵',
      'Happy Friday everyone!',
      'Just got back from vacation, it was amazing!',
      'Late night coding session 🖥️',
      'Good morning everyone!',
      'Anyone have book recommendations?',
      'Just finished a great workout class',
      'The sunset looks beautiful today',
      'Working from home today',
      'Just made the best coffee ever ☕',
      'Planning a road trip next month',
      'This restaurant has amazing food!',
    ];

    List<ChatMessage> messages = [];
    
    for (int i = 0; i < count; i++) {
      final messageId = startIndex + i + 1;
      final user = users[random.nextInt(users.length)];
      final isMe = random.nextBool();
      
      messages.add(ChatMessage(
        id: messageId,
        text: messageTypes[random.nextInt(messageTypes.length)],
        sender: isMe ? 'Me' : user,
        isMe: isMe,
        timestamp: DateTime.now().subtract(Duration(
          minutes: (startIndex + i) * 5 + random.nextInt(300)
        )),
        avatarColor: avatarColors[random.nextInt(avatarColors.length)],
        messageType: _getRandomMessageType(random),
      ));
    }
    
    return messages;
  }

  MessageType _getRandomMessageType(math.Random random) {
    final types = MessageType.values;
    return types[random.nextInt(types.length)];
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: _messages.length + 1,
      text: _textController.text.trim(),
      sender: 'Me',
      isMe: true,
      timestamp: DateTime.now(),
      avatarColor: Colors.blue,
      messageType: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _textController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Virtual Chat Room',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              '${_messages.length} of $_totalMessages messages loaded',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _scrollToBottom,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading && _messages.isEmpty)
            const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              // Optimize for large lists
              cacheExtent: 500,
              itemExtent: null, // Dynamic height
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && _isLoading) {
                  return _buildLoadingIndicator();
                }
                
                final messageIndex = _isLoading ? index - 1 : index;
                if (messageIndex >= _messages.length) return const SizedBox.shrink();
                
                final message = _messages[messageIndex];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Loading older messages...'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.avatarColor,
              child: Text(
                message.sender[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: message.isMe 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        message.sender,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMe ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.messageType == MessageType.image) ...[
                          Container(
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (message.messageType == MessageType.file) ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: message.isMe 
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  size: 20,
                                  color: message.isMe ? Colors.white : Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'document.pdf',
                                  style: GoogleFonts.poppins(
                                    color: message.isMe ? Colors.white : Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          message.text,
                          style: GoogleFonts.poppins(
                            color: message.isMe ? Colors.white : Colors.black87,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: GoogleFonts.poppins(
                            color: message.isMe 
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: message.avatarColor,
              child: Text(
                'Me'[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

enum MessageType {
  text,
  image,
  file,
}

class ChatMessage {
  final int id;
  final String text;
  final String sender;
  final bool isMe;
  final DateTime timestamp;
  final Color avatarColor;
  final MessageType messageType;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.isMe,
    required this.timestamp,
    required this.avatarColor,
    required this.messageType,
  });
}