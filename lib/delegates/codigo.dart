import 'dart:async';

void main() {
  
  List convidados = ['Daniel', 'Joao', 'Paulo'];           
  
  final controller = StreamController();
  
  //where é uma função anonima com 
  final subscription = controller.stream.where(
    (data){
      return convidados.contains(data);
    }
  ).listen((data){
    print(data);
  });
  
  //quando adicionamos listen ele retorna um StreamSubscription
  //final subscription = controller.stream.listen((data){
  //  print(data);  
  //});
  
  controller.sink.add("Josimar");
  controller.sink.add("Daniel");
  controller.sink.add("Joao");
             
  controller.close();
  
}
