import java.util.Collections;

ArrayList<TData> trainingDatas = new ArrayList<TData>();
ArrayList<TData> testingDatas = new ArrayList<TData>();

void loadData() {
  for (int i=0; i<10; i++) {
    //loads training data 
    String[] paths = loadStrings("data/training/"+String.valueOf(i)+".txt");
    for (String path : paths) {
      if (path.endsWith("png"))
        trainingDatas.add(new TData(fromImage(loadImage(path), true),i));
    }
    
    //loads testing data, used for calculating accuracy
    paths = loadStrings("data/testing/"+String.valueOf(i)+".txt");
    for (String path : paths) {
      if (path.endsWith("png"))
        testingDatas.add(new TData(fromImage(loadImage(path), false),i));
    }
  }
}

class TData {
  Matrix input, label;
  int answer;
  TData(Matrix input, int idx) {
    this.input = input;
    label = new Matrix(10, 1);
    label.array[idx][0] = 1;
    answer = idx;
  }

  void train(NeuralNetwork nn) {
    nn.train(input, label);
  }
}

Matrix fromImage(PImage img,boolean addNoise) {
  img.loadPixels();
  Matrix result = new Matrix(img.width*img.height, 1);
  for (int i=0; i<result.rows; i++) {
    if(addNoise) result.array[i][0] = random(1)>(float)1/150? (random(-.5,.5)+(brightness(img.pixels[i]))/255.0f):(brightness(img.pixels[i]))/255.0f;
    else result.array[i][0] = (brightness(img.pixels[i]))/255.0f;
  }
  return result;
}
