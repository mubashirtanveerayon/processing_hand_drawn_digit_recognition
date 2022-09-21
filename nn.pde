class NeuralNetwork{

    ArrayList<Matrix> weights,biases;
    boolean initialized;
    int numInputs,numOutputs,numLayers=0;
    float learningRate = 0.3f;

    public NeuralNetwork(ArrayList<Matrix>w,ArrayList<Matrix>b){
        if(w.size() != b.size()){
            println("invalid model");
            return;
        }
        weights = new ArrayList<>(w);
        biases = new ArrayList<>(b);
        numInputs = w.get(0).cols;
        numOutputs = w.get(w.size()-1).rows;
        numLayers = w.size()-1;
        
    }

    public NeuralNetwork(int numI,int numO){
        numInputs = numI;
        numOutputs = numO;

        weights = new ArrayList<Matrix>();
        biases = new ArrayList<Matrix>();
    }

    public void initialize(){
        initialized = numLayers>0;
        if(initialized){
          println("Initialized neural network with "+numLayers+" hidden layers, "+numInputs+" inputs and "+numOutputs+" outputs!");  
        }
    }

    public boolean export() {
        if(!initialized)return false;
        new File("model").mkdir();
        PrintWriter writer;
        for(int i=0;i<=numLayers;i++){
            writer = createWriter("model/layer"+String.valueOf(i)+".weight");
            writer.println(weights.get(i).toString());
            writer.flush();
            writer.close();
            
            writer = createWriter("model/layer"+String.valueOf(i)+".bias");
            writer.println(biases.get(i).toString());
            writer.flush();
            writer.close();
        }
        
        return true;

    }

    public void addLayer(int numNodes){
        if(initialized)return;
        if(numLayers==0){
            weights.add(new Matrix(numNodes,numInputs).randomize());
            weights.add(new Matrix(numOutputs,numNodes).randomize());
            biases.add(new Matrix(numNodes,1).randomize());
            biases.add(new Matrix(numOutputs,1).randomize());
        }else{
            weights.remove(weights.size()-1);
            biases.remove(biases.size()-1);
            weights.add(new Matrix(numNodes,weights.get(weights.size()-1).rows).randomize());
            biases.add(new Matrix(numNodes,1).randomize());
            biases.add(new Matrix(numOutputs,1).randomize());
            weights.add(new Matrix(numOutputs,numNodes).randomize());
        }
        numLayers++;
    }

    public Matrix feedForward(Matrix input){
        if(!initialized)return null;
        Matrix result = input;
        for(int i=0;i<weights.size();i++){
            result = mult(weights.get(i),result).addSelf(biases.get(i)).sigmoidSelf();
        }
        return result;
    }

    public void train(final Matrix input,final Matrix target){
        //feedforward
        Matrix result = input.copy();
        ArrayList<Matrix> layerOutputs = new ArrayList<>();
        layerOutputs.add(input.copy());
        for(int i=0;i<weights.size();i++){
            result = mult(weights.get(i),result).addSelf(biases.get(i)).sigmoidSelf();
            layerOutputs.add(result.copy());
        }

        //backpropagation
        Matrix outputError = add(target,mult(result,-1));
        Matrix layerError = outputError;

        for(int i=layerOutputs.size()-1;i>=1;i--){
            Matrix gradient = layerError.copy().multSelf(learningRate).multElementWiseSelf(layerOutputs.get(i).dsigmoidFromPreviousSigmoidSelf());

            Matrix wDT = mult(gradient,transpose(layerOutputs.get(i-1)));
            Matrix w = weights.get(i-1);

            layerError = mult(transpose(w),layerError);
            w.addSelf(wDT);
            Matrix b = biases.get(i-1);
            b.addSelf(gradient);
        }

    }

}
 NeuralNetwork createModel(String modelPath) {
        ArrayList<Matrix> weights = new ArrayList<Matrix>();
        ArrayList<Matrix> biases = new ArrayList<Matrix>();
        
        File[] files = new File(sketchPath()+"/"+modelPath).listFiles();
        for(File f:files){
            String[] content = loadStrings(f.getPath());
            if(f.getName().endsWith("weight")){
              weights.add(fromString(content));  
            }else if(f.getName().endsWith("bias")){
             biases.add(fromString(content));  
            }
        }
        return new NeuralNetwork(weights,biases);
    }
