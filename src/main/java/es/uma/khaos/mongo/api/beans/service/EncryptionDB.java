package es.uma.khaos.mongo.api.beans.service;
import java.security.Key;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class EncryptionDB
{
    public String encrypt_field(String field, String key)
    {
        String enc = "";
        try
        {
            // Create key and cipher
            Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES");
            // encrypt the text
            cipher.init(Cipher.ENCRYPT_MODE, aesKey);
            byte[] encrypted = cipher.doFinal(field.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b: encrypted) {
                sb.append((char)b);
            }
            // the encrypted String
            enc = sb.toString();
        } catch(Exception e)
        {
            e.printStackTrace();
        }
        return enc;
    }

    public String decrypt_field(String enc, String key)
    {
        String decrypted = "";
        try
        {
            Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES");
            // now convert the string to byte array
            // for decryption
            byte[] bb = new byte[enc.length()];
            for (int i=0; i<enc.length(); i++) {
                bb[i] = (byte) enc.charAt(i);
            }
            // decrypt the text
            cipher.init(Cipher.DECRYPT_MODE, aesKey);
            decrypted = new String(cipher.doFinal(bb));

        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return decrypted;
    }

//    public static void main(String[] args)
//    {
//        EncryptionDB app = new EncryptionDB();
//        String enc = app.encrypt_field("24-11-1995", "OgGUGD9V4kcUZTqmtTrGwfNK");
//        app.decrypt_field(enc,"OgGUGD9V4kcUZTqmtTrGwfNK");
//
//    }

}
