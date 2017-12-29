package connexion;

public class DataDBB {
    private final String url, user, passwd;

    public DataDBB() {

        url = "jdbc:mysql://localhost:3306/captainbdd";
        user = "root";
        passwd = "Bdd2017!";

    }
    public String useURL(){
        return url;
    }
    public String useUser(){
        return user;
    }
    public String usePasswd(){
        return passwd;
    }


}
