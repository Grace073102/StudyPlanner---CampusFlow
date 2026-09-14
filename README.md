# CampusFlow – Study Planner

CampusFlow is an iOS study planning application developed using Swift and SwiftUI. The application is designed to help university students manage assignments, organise academic tasks, plan study activities, and monitor their progress.

The project was developed as an MVP (Minimum Viable Product) with a focus on usability, clear architecture, local data persistence, error handling, and testing.

---

## 1. Problem

University students often need to manage multiple assignments, deadlines, subjects, and smaller academic tasks at the same time.

Important information may be spread across learning management systems, calendars, notes, and reminder applications. This can make it difficult for students to understand what they need to work on and how much work they have remaining.

CampusFlow addresses this problem by providing one place where students can:

- manage assignments
- organise assignments by course
- break assignments into smaller tasks
- plan when tasks should be completed
- estimate study time
- monitor upcoming deadlines
- track task and assignment progress

---

## 2. Target User

The primary user of CampusFlow is a university student managing multiple courses and assignments.

The application is particularly useful for students who need a simple way to convert large assignments into smaller and more manageable study tasks.

---

## 3. Core Features

### Assignment Management

Students can:

- add an assignment
- edit an assignment
- delete an assignment
- enter an assignment title
- enter the course
- select a due date
- select a priority
- enter an optional description

Assignments can have three priority levels:

- High
- Medium
- Low

---

### Task Management

Assignments can be divided into smaller academic tasks.

Students can:

- add tasks
- edit tasks
- delete tasks
- mark tasks as completed
- assign a planned study date
- enter an estimated study duration

This allows a large assignment to be broken into smaller and more manageable pieces of work.

---

### Upcoming Tasks

The main dashboard displays tasks that are planned within the next seven days.

This helps students quickly identify work that should be completed soon.

---

### Task Filtering

The task screen allows students to view tasks using different filters:

- All
- Today
- This Week
- Completed

This allows students to focus on the tasks that are most relevant to their current study plan.

---

### Today's Study Plan

CampusFlow provides a summary of tasks planned for the current day.

The summary displays:
- number of incomplete tasks planned for today
- total estimated study time for today


The study duration is calculated from the estimated duration of the incomplete tasks planned for the current day.

---

### Upcoming Deadlines

The dashboard displays upcoming assignment deadlines.

This allows students to see which assignments are approaching their due dates and identify their priority levels.

---

### Progress Tracking

CampusFlow tracks progress using completed academic tasks.

Assignment progress is calculated using:
Completed Tasks / Total Tasks

For example, if an assignment contains four tasks and two are completed:
2 / 4 = 50%

The application also calculates overall progress across all assignments.

---

## 4. Application Architecture

CampusFlow uses an MVVM-based layered architecture.

The main architecture is:
```text
Student
   │
   ▼
SwiftUI Views
   │
   ▼
ViewModels
   │
   ▼
Use Case
   │
   ▼
Repository
   │
   ▼
JSON Persistence
```

The architecture separates user interface code, application state, business logic, domain models, and data persistence.

This separation improves maintainability and makes individual parts of the application easier to test.

---

## 5. Human-System Interaction

The application is designed around interactions between the student and the CampusFlow system.

A typical interaction for adding an assignment is:
```text
Student
   │
   │ Taps "+"
   ▼
AddAssignmentView
   │
   │ Enters assignment information
   ▼
AssignmentViewModel
   │
   ▼
AddAssignmentUseCase
   │
   │ Validates input
   ▼
AssignmentRepository
   │
   ▼
JSONAssignmentRepository
   │
   │ Saves assignment
   ▼
JSON File
   │
   ▼
Updated assignment data
   │
   ▼
AssignmentView
   │
   ▼
Student sees updated dashboard
```

The human-system boundary exists between the student and the SwiftUI interface. The student provides input through the interface, while the application handles validation, business logic, persistence, calculations, and presentation of results.

---

## 6. Domain Models

### Assignment

`Assignment` represents an academic assignment.

Important information stored by an assignment includes:
id, title, course, dueDate, priority, description, tasks

Each assignment can contain multiple `AcademicTask` objects.

---

### AcademicTask

`AcademicTask` represents a smaller piece of work associated with an assignment.

Important information includes:
id, title, isCompleted, plannedDate, estimatedMinutes

The planned date allows the student to decide when they intend to work on the task.

The estimated duration allows CampusFlow to calculate the student's planned study workload.

---

## 7. ViewModels

CampusFlow currently uses two main ViewModels.

### AssignmentViewModel

`AssignmentViewModel` manages assignment-related application state.

Its responsibilities include:
- loading assignments
- adding assignments
- updating assignments
- deleting assignments
- publishing assignment changes to the UI
- calculating overall assignment progress
- communicating repository errors to the UI

The ViewModel communicates with the repository rather than directly accessing JSON storage.

---

### TaskViewModel

`TaskViewModel` manages task-related functionality.

Its responsibilities include:
- retrieving all tasks
- retrieving today's tasks
- retrieving this week's tasks
- retrieving upcoming tasks
- retrieving completed tasks
- adding tasks
- editing tasks
- deleting tasks
- toggling task completion
- calculating today's study duration

The `TaskViewModel` works with assignment data through the `AssignmentViewModel`.

---

## 8. Use Case

### AddAssignmentUseCase

`AddAssignmentUseCase` contains the business logic required when creating a new assignment.

Before an assignment is created, the use case validates the user's input.

The following validation rules are applied:

1. The assignment title cannot be empty.
2. The course cannot be empty.
3. The due date cannot be in the past.

For example:

```swift
guard !cleanedTitle.isEmpty else {
    throw AddAssignmentError.missingTitle
}
```

If validation succeeds, an `Assignment` is created and passed to the repository.

The use case keeps this business logic separate from the SwiftUI interface.

---

## 9. Repository Pattern

CampusFlow uses the Repository Pattern to separate application logic from data persistence.

The repository abstraction is:
```text
AssignmentRepository
        │
        ▼
JSONAssignmentRepository
```
`AssignmentRepository` defines the operations required by the application, including:
load, add, update, delete

The ViewModel depends on the repository abstraction rather than directly managing the JSON file.

This makes the architecture easier to maintain and test.

---

## 10. Data Persistence

CampusFlow uses JSON for local data persistence.

The main implementation is JSONAssignmentRepository.

Swift's `Codable` system is used with JSONEncoder and JSONDecoder to convert assignment objects between Swift models and JSON data.

The application stores its working assignment data locally in the application's Documents directory.

This allows changes made by the student to remain available after the application is closed and reopened.

Persisted changes include:
- added assignments
- edited assignments
- deleted assignments
- added tasks
- edited tasks
- deleted tasks
- completed tasks

---

## 11. Sample Data

The project contains sample assignment data to provide meaningful content when the application is first used.

Sample data demonstrates:
- multiple courses
- different assignment priorities
- different due dates
- completed and incomplete tasks
- planned study dates
- estimated study durations

This makes the MVP easier to demonstrate and evaluate.

---

## 12. Error Handling and Validation

CampusFlow includes user-focused error handling to prevent invalid data and explain problems clearly.

### Assignment Validation

The application prevents an assignment from being added when:

- the title is empty
- the course is empty
- the selected due date is invalid

The `AddAssignmentUseCase` provides human-readable errors such as "Enter an assignment title before saving" and "Enter the course of this assignment".

---

### UI Validation

Where possible, invalid actions are prevented before they occur.

For example, save buttons can be disabled when required fields are empty.

This reduces unnecessary errors and gives the student immediate feedback.

---

### Delete Confirmation

Destructive actions require confirmation.

Before an assignment is deleted, the application displays a confirmation message explaining that the assignment and its subtasks will be permanently deleted.

Similar protection is provided for destructive task operations where applicable.

---

### Persistence Errors

The repository handles errors that may occur when loading or saving JSON data.

Repository errors are passed through the `AssignmentViewModel` and can be displayed to the student using an alert.

This prevents persistence failures from occurring silently.

---

## 13. Main Views

The application contains SwiftUI views responsible for different parts of the student workflow.

### AssignmentView

The main dashboard.

It displays:
- greeting
- upcoming deadlines
- today's study plan
- upcoming tasks
- overall progress
- navigation to additional task information

---

### AssignmentListView

Displays the student's assignments and provides access to assignment details.

---

### AddAssignmentView

Allows the student to create a new assignment.

The student can enter:
- assignment title
- course
- due date
- priority
- description

---

### EditAssignmentView

Allows an existing assignment to be updated.

---

### AssignmentDetailView

Displays detailed information about an assignment.

It provides access to:
- assignment progress
- subtasks
- description
- editing
- deletion

---

### AssignmentProgressView

Displays progress for an individual assignment based on its completed tasks.

---

### SubtaskListView

Displays and manages the tasks associated with an assignment.

---

### DetailTaskView

Provides a more detailed overview of academic tasks and allows tasks to be filtered.

---

### TaskView

Displays an individual academic task and its relevant information.

---

### UpcomingDeadlinesView

Displays assignments with approaching deadlines.

---

### ProgressOverviewView

Displays overall progress across the student's academic tasks.

---

## 14. Project Structure

The project is organised into separate folders for models, repositories, use cases, ViewModels, views, resources, and extensions.

```text
StudyPlanner
│
├── Extension
│   └── PriorityColor.swift
│
├── Model
│   ├── AcademicTask.swift
│   └── Assignment.swift
│
├── Repositories
│   ├── AssignmentRepository.swift
│   ├── JSONProductRepository.swift
│   └── LocalAssignmentRepository.swift
│
├── Resources
│   └── SampleAssignments.json
│
├── UseCases
│   └── AddAssignmentUseCase.swift
│
├── ViewModels
│   ├── AssignmentViewModel.swift
│   └── TaskViewModel.swift
│
├── Views
│   │
│   ├── AssignmentViews
│   │   ├── AddAssignmentView.swift
│   │   ├── AssignmentDetailView.swift
│   │   ├── AssignmentListView.swift
│   │   ├── AssignmentProgressView.swift
│   │   ├── EditAssignmentView.swift
│   │   └── SubtaskListView.swift
│   │
│   ├── SettingsView
│   │   ├── AssignmentView.swift
│   │   ├── ProgressOverviewView.swift
│   │   ├── RootView.swift
│   │   └── UpcomingDeadlinesView.swift
│   │
│   └── TasksViews
│       ├── DetailTaskView.swift
│       └── TaskView.swift
│
├── Assets
│
├── ContentView.swift
└── StudyPlannerApp.swift

StudyPlannerTests/
└── AssignmentViewModelTests.swift
```
---

## 15. Unit Testing

The StudyPlanner application includes unit tests using the XCTest framework. The tests verify important application logic including assignment creation, input validation, assignment completion, progress calculation, and task planning.

The project currently includes 8 unit tests:

1. `testAddAssignment()`
   - Verifies that a valid assignment can be successfully added to the repository.

2. `testAddAssignmentWithEmptyTitle()`
   - Verifies that an assignment cannot be created when the title is empty.

3. `testAddAssignmentWithEmptyCourse()`
   - Verifies that an assignment cannot be created when the course is empty.

4. `testAddAssignmentWithPastDueDate()`
   - Verifies that an assignment cannot be created with a due date in the past.

5. `testAssignmentIsCompleted()`
   - Verifies that an assignment is considered completed when all of its tasks are completed.

6. `testProgressCalculation()`
   - Verifies that task completion progress is calculated correctly. For example, one completed task out of two tasks produces a progress value of 0.5 (50%).

7. `testAddTaskLogic()`
   - Verifies that a new task can be added to an assignment successfully.

8. `testTaskPlannedForToday()`
   - Verifies that a task with today's planned date is correctly identified as a task planned for today.

A mock repository, `MockAddAssignmentRepository`, is used during testing so that assignment operations can be tested independently without modifying the application's actual stored data.

---

## 16. Main User Workflow

A typical CampusFlow workflow is:

```text
Open CampusFlow
      ↓
View dashboard
      ↓
Check upcoming deadlines
      ↓
Add an assignment
      ↓
Enter course and due date
      ↓
Select priority
      ↓
Save assignment
      ↓
Open assignment
      ↓
Break assignment into tasks
      ↓
Plan study dates
      ↓
Estimate study duration
      ↓
Complete tasks
      ↓
Monitor progress
```

This workflow supports the application's primary goal of helping students turn assignment requirements into manageable study activities.

---

## 17. Current Limitations

CampusFlow is an MVP and therefore has several limitations.

The current version does not include:

- user accounts
- cloud synchronisation
- direct LMS integration
- collaboration between students
- automatic assignment importing
- push notifications
- cross-device synchronisation

Data is currently stored locally on the device.

---

## 18. Future Improvements

Possible future improvements include:

### Calendar Integration

CampusFlow could integrate planned tasks with the student's device calendar.

### Notifications

Students could receive reminders for:

- upcoming assignments
- tasks planned for today
- approaching deadlines

### LMS Integration

Future versions could retrieve assignment information directly from university learning management systems.

### Cloud Synchronisation

Assignments and tasks could be synchronised across multiple devices.

### Workload Analytics

Additional analytics could help students understand:

- weekly study workload
- completed study hours
- workload by course
- approaching high-workload periods

### Collaboration

Future versions could allow students to share study plans or coordinate group assignment activities.

---

## 19. Error Recovery

CampusFlow attempts to provide clear recovery paths when errors occur.

For invalid user input, the student can correct the relevant field and attempt the action again.

For persistence failures, the application displays a human-readable message rather than silently ignoring the failure.

For destructive operations, confirmation is required before data is permanently removed.

These decisions aim to make errors understandable and recoverable from the student's perspective.

---

## 20. Human-System Architecture Summary

The CampusFlow architecture can be summarised as:

```text
┌───────────────────────────────┐
│            HUMAN              │
│                               │
│           Student             │
└───────────────┬───────────────┘
                │
        Human-System Boundary
                │
┌───────────────▼───────────────┐
│         SwiftUI Views         │
│                               │
│ AssignmentView                │
│ AddAssignmentView             │
│ AssignmentDetailView          │
│ DetailTaskView                │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│          ViewModels           │
│                               │
│ AssignmentViewModel           │
│ TaskViewModel                 │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│           Use Case            │
│                               │
│ AddAssignmentUseCase          │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│          Repository           │
│                               │
│ AssignmentRepository          │
│ JSONAssignmentRepository      │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       Local Persistence       │
│                               │
│          JSON File            │
└───────────────────────────────┘
```

This architecture separates the student's interaction with the system from the application's internal processing and persistence responsibilities.

---

## 21. Conclusion

CampusFlow provides a focused study planning solution for university students.

The MVP allows students to manage assignments, divide assessments into smaller academic tasks, plan study dates, estimate required study time, monitor upcoming deadlines, and track their progress.

The application uses a layered MVVM architecture with ViewModels, a Use Case, repository abstraction, JSON persistence, validation, error handling, and unit testing.

The current implementation provides a foundation that could later be expanded with calendar integration, notifications, cloud synchronisation, LMS integration, workload analytics, and collaborative study planning.

---
