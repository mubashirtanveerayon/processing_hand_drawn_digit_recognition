import java.nio.file.*;
import java.io.File;
import java.util.List;

class pathgenerator{

        public static void main(String[] args) throws Exception{
            for(String name:new File("testing").list()){
                String content = "";
                for(String n:new File("testing/"+name).list()){
                    content += "data/testing/"+name+"/"+n+"\n";
                }
                Path destFile = Paths.get("testing/"+name+".txt");
                if(!Files.exists(destFile)){
                    Files.createFile(destFile);
                }

                Files.write(destFile,content.getBytes());

            }
        }



}
