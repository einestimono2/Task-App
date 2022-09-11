enum TaskFilter { all, pending, completed, removed }

extension TaskFilterString on TaskFilter {
  String get name {
    switch (this) {
      case TaskFilter.all:
        return "All";
      case TaskFilter.pending:
        return "Pending";
      case TaskFilter.completed:
        return "Completed";
      case TaskFilter.removed:
        return "Removed";
      default:
        throw Exception("Something went wrong");
    }
  }
}
