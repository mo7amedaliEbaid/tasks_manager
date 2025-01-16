import 'dart:math';

class Task {
  final String from;
  final String subject;
  final String body;
  bool isRead;
  bool isFavorite;

  int randNum = Random().nextInt(999);

  Task({required this.from, required this.subject, required this.body, this.isRead = false, this.isFavorite = false});

  toggleFavorite() {
    this.isFavorite = !this.isFavorite;
  }
}

class DemoData {
  final List<Task> _inbox = [
    Task(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Task(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
  ];

  int getIndexOf(Task email) {
    return _inbox.indexWhere((Task inbox) => inbox.subject == email.subject);
  }

  List<Task> getData() {
    return _inbox;
  }
}
