import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ManagerDBB {

    private final DataDBB infosDB;
    private Connection connexion;

    public ManagerDBB(){
        infosDB = new DataDBB();
    }
    public Connection connexion() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");

        connexion = DriverManager.getConnection(infosDB.useURL(), infosDB.useUser(), infosDB.usePasswd());

        return connexion;

    }

    public void closeDBB() throws SQLException {
        connexion.close();
    }




}
