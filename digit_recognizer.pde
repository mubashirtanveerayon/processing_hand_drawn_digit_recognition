import java.util.Collections;

NeuralNetwork nn;
void setup(){
  size(200,200);
  println("loading data!");
  loadData();
  println("done loading data!");
 
 nn = new NeuralNetwork(784,10);
 nn.addLayer(100);
 //nn.addLayer(40);
 nn.initialize();
//nn = createModel("model");
//nn.initialize();

  stroke(255);
  strokeWeight(12);
  background(0);
}

void draw(){
  
}

void mouseDragged(){
    point(mouseX,mouseY);
}

void keyPressed(){
  if(key == 'c')background(0);
  if(key == 'g'){
    PImage img = get();
    img.resize(28,28);
    int guess = findGuess(nn.feedForward(fromImage(img,false)));
    println("Network's guess : "+guess);
    //println("Confidence "+threshold*100+" %");
  }
  if(key == 's'){
    nn.export();  
  }
  if(key == 't')trainWithAllData();
  if(key == 'a')calculateAccuracy();
  if(key == 'h'){
    PImage img = get();
    img.resize(28,28);
    nn.feedForward(fromImage(img,false)).print();
    //println("Network's guess : "+guess);
    //println("Confidence "+threshold*100+" %");
  }
}

void trainWithAllData(){
  for(int i=0;i<5;i++){
  Collections.shuffle(trainingDatas);
  for(TData td: trainingDatas){
    td.train(nn);  
  }
  
  }
  println("training complete!");
}

void calculateAccuracy(){
  Collections.shuffle(testingDatas);
  int correct=0;
  int testLength = 500;
  for(int i=0;i<testLength;i++){
    TData td = testingDatas.get(i);
    int guess = findGuess(nn.feedForward(td.input));
    if(guess == td.answer){
      correct++;  
    }
  }
  println("Accuracy: "+(float)correct/testLength*100+" %");
}

int findGuess(Matrix output){
  int guess=0;
    float threshold = Float.NEGATIVE_INFINITY;
    for(int i=0;i<output.rows;i++){
      for(int j=0;j<output.cols;j++){
        if(output.array[i][j]>threshold){
            guess = i;
            threshold = output.array[i][j];
        }
      }
    }
    return guess;
}
