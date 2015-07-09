/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import javax.swing.JFrame;
import org.jvnet.substance.SubstanceLookAndFeel;

/**
 *
 * @author Esquivel Oscar
 * @author Garbanzo Diana
 */
public class Main {

    /**
     * @param args the command line arguments
     */
     public static void main(String[] args) {
        JFrame.setDefaultLookAndFeelDecorated(true);
        SubstanceLookAndFeel.setSkin("org.jvnet.substance.skin.BusinessBlackSteelSkin");
        // Instancia de JFrame
        JFNotas interfaz = new JFNotas();
    }   
}