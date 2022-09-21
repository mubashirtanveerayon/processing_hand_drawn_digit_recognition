import java.util.List;

class Matrix {
  public int rows, cols;

  public float[][] array;

  public Matrix(int r, int c) {
    rows = r;
    cols = c;
    array = new float[rows][cols];
  }

//  public Matrix(List<String> mat){
//    String[] dimensions = mat.get(0).split(",");
//    String[] values = mat.get(1).split(",");
//    rows = Integer.parseInt(dimensions[0]);
//    cols = Integer.parseInt(dimensions[1]);

//    array = new float[rows][cols];

//    for(int i=0;i<rows;i++){
//        for(int j=0;j<cols;j++){
//            array[i][j] = Float.parseFloat(values[j+i*cols]);
//        }
//    }
//  }

  public String toString(){
    StringBuffer sb = new StringBuffer("");
    sb.append(String.valueOf(rows)).append(",").append(String.valueOf(cols)).append("\n");
    for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
            sb.append(String.valueOf(array[i][j])).append(",");
        }
    }
    sb.delete(sb.length()-1,sb.length());
    return sb.toString();
  }
  
  public Matrix up1RowSelf(){
      rows++;
      float[][] newArray = new float[rows][cols];
      for(int j=0;j<rows;j++){
        for(int k=0;k<cols;k++){
            newArray[j][k] = array[j][k];
        }
      }
      newArray[rows-1][0] = 1;
      array = newArray;
      return this;
  }
  
  public Matrix multElementWiseSelf(Matrix b){
      if (rows != b.rows || cols != b.cols){
        System.out.println("dimesnsions do not match");
        return null;
      }
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
            array[i][j] *= b.array[i][j];
        }
      }
      return this;
  }
  
  public Matrix multSelf(Matrix b) {
    if (cols != b.rows)return null;
    for (int x=0; x<rows; x++) {
      for (int y=0; y<cols; y++) {
        float sum=0;
        for (int i=0; i<cols; i++) {
         sum += array[x][i] * b.array[i][y];
        }
        array[x][y] = sum;
      }
    }
    return this;
  }

  public Matrix multSelf( float b) {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        array[i][j] *= (float)b;
      }
    }
    return this;
  }

  public Matrix addSelf( Matrix b) {
    if (rows != b.rows || cols != b.cols)return null;
    
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        array[i][j] += b.array[i][j];
      }
    }
    return this;
  }
  
  public Matrix randomize(){
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        array[i][j] = -1 + (float)Math.random()*2; 
      }
    }
    return this;
  }
  
  public void print(){
    System.out.println();
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        System.out.print(" | " + array[i][j] + " | ");  
      }
      System.out.println();
    }
  }  

  public Matrix sigmoidSelf(){
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        array[i][j] = sigmoid(array[i][j]);
      }
    }
    return this;
  }
  
  public Matrix dsigmoidSelf(){
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        array[i][j] = sigmoid(array[i][j])*(1-sigmoid(array[i][j]));
      }
    }  
    return this;
  }
  
  public Matrix dsigmoidFromPreviousSigmoidSelf(){
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        array[i][j] = array[i][j]*(1-array[i][j]);
      }
    }  
    return this;
  }
  
  public Matrix copy() {
    Matrix result = new Matrix(rows, cols);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        result.array[i][j] = array[i][j];
      }
    }

    return result;
  }
  
}

 Matrix up1Row(Matrix m){
      Matrix result = new Matrix(m.rows+1,m.cols);
      for(int j=0;j<result.rows;j++){
        for(int k=0;k<result.cols;k++){
            m.array[j][k] = result.array[j][k];
        }
      }
      result.array[m.rows][0] = 1;
      return result;
  }

 Matrix mult(Matrix a, Matrix b) {
    if (a.cols != b.rows)return null;
    Matrix result = new Matrix(a.rows, b.cols);

    for (int x=0; x<result.rows; x++) {
      for (int y=0; y<result.cols; y++) {
        float sum=0;
        for (int i=0; i<a.cols; i++) {
         sum += a.array[x][i] * b.array[i][y];
        }
        result.array[x][y] = sum;
      }
    }

    return result;
  }

 Matrix mult(Matrix a, float b) {
    Matrix result = new Matrix(a.rows, a.cols);
    for (int i=0; i<a.rows; i++) {
      for (int j=0; j<a.cols; j++) {
        result.array[i][j] = a.array[i][j] * (float)b;
      }
    }
    return result;
  }
  
 Matrix multElementWise(Matrix a,Matrix b){
      if (a.rows != b.rows || a.cols != b.rows)return null;
      Matrix result = new Matrix(a.rows,a.cols);
      for (int i=0; i<a.rows; i++) {
        for (int j=0; j<a.cols; j++) {
            result.array[i][j] *= b.array[i][j];
        }
      }
      return result;
  }

 Matrix add(Matrix a, Matrix b) {
    if (a.rows != b.rows || a.cols != b.cols)return null;
    Matrix result = new Matrix(a.rows, a.cols);
    for (int i=0; i<a.rows; i++) {
      for (int j=0; j<a.cols; j++) {
        result.array[i][j] = a.array[i][j] + b.array[i][j];
      }
    }
    return result;
  }

 Matrix transpose(Matrix m) {
    Matrix result = new Matrix(m.cols, m.rows);
    for (int i=0; i<m.rows; i++) {
      for (int j=0; j<m.cols; j++) {
        result.array[j][i] = m.array[i][j];
      }
    }
    return result;
  }
  
 Matrix fromArray(float[] array){
      Matrix result = new Matrix(array.length,1);
      for(int i=0;i<array.length;i++){
          result.array[i][0] = array[i];
      }
      return result;
  }
  
Matrix fromString(String[] lines){
    String[] dimensions = lines[0].split(",");
    String[] values = lines[1].split(",");
    int rows = Integer.parseInt(dimensions[0]);
    int cols = Integer.parseInt(dimensions[1]);
    Matrix m = new Matrix(rows,cols);
    for(int i=0;i<rows;i++){
        for(int j=0;j<cols;j++){
            m.array[i][j] = Float.parseFloat(values[j+i*cols]);
        }
    }
    return m;
}
  
 float sigmoid(float x){
    return 1/(1+(float)Math.pow(Math.E,-x));
  }
