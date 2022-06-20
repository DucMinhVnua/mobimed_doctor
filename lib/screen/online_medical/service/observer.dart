class Observer {
  int type;
  Function(dynamic message) onMessage;

  Observer(this.type, this.onMessage);

  void notify(dynamic message) {
    onMessage.call(message);
  }
}

class Observable {
  final Map<String, Observer> _observers = {};

  void registerObserver(String name, Observer observer) {
    _observers[name] = observer;
  }

  void unregisterObserver(String name) {
    _observers.remove(name);
  }

  void notifyObservers(int type, dynamic message) {
    _observers.forEach((k, v) {
      if (v.type == type) {
        v.notify(message);
      }
    });
  }
}
