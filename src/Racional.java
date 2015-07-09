/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Yorle
 */
public class Racional {
     private int num, denom;

     public Racional(double d) {
          String s = String.valueOf(d);
          int digitsDec = s.length() - 1 - s.indexOf('.');        

          int denom = 1;
          for(int i = 0; i < digitsDec; i++){
             d *= 10;
             denom *= 10;
          }
          int num = (int) Math.round(d);

          this.num = num; this.denom = denom;
     }

     public Racional(int num, int denom) {
          this.num = num; this.denom = denom;
     }

     public String toString() {
          return String.valueOf(num) + "/" + String.valueOf(denom);
     }
}
