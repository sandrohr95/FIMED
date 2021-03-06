package es.uma.khaos.mongo.api.beans.service;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;
import org.apache.commons.codec.binary.Base64;
import java.util.Random;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Encrypt {
    private static final Random RANDOM = new SecureRandom();
    private static final String ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;

    public String getSalt(int length) {
        StringBuilder returnValue = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            returnValue.append(ALPHABET.charAt(RANDOM.nextInt(ALPHABET.length())));
        }
        return new String(returnValue);
    }

    public byte[] hash(char[] password, byte[] salt) {
        PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, KEY_LENGTH);
        Arrays.fill(password, Character.MIN_VALUE);
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            return skf.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new AssertionError("Error while hashing a password: " + e.getMessage(), e);
        } finally {
            spec.clearPassword();
        }
    }

    public String generateSecurePassword(String password, String salt) {
        String returnValue = null;
        byte[] securePassword = hash(password.toCharArray(), salt.getBytes());
        //returnValue = securePassword.toString();

        returnValue = Base64.encodeBase64String(securePassword);
        return returnValue;
    }

    public boolean verifyUserPassword(String providedPassword,
                                      String securedPassword, String salt) {
        boolean returnValue = false;

        // Generate New secure password with the same salt
        String newSecurePassword = generateSecurePassword(providedPassword, salt);

        // Check if two passwords are equal
        returnValue = newSecurePassword.equalsIgnoreCase(securedPassword);

        return returnValue;
    }
}

/*
    public static void main (String []args)
    {
        String myPassword = "myPassword123";

        Encrypt encrypt = new Encrypt();

        // Generate Salt. The generated value can be stored in DB.
        String salt = encrypt.getSalt(30);

        // Protect user's password. The generated value can be stored in DB.
        String mySecurePassword = encrypt.generateSecurePassword(myPassword, salt);

        // Print out protected password
        System.out.println("My secure password = " + mySecurePassword);
        System.out.println("Salt value = " + salt);


        // User provided password to validate
        String providedPassword = "myPassword123";

        // Encrypted and Base64 encoded password read from database
        String securePassword = "E0UrozNWTnA5QSLYGooqQCNMJn5nT+0Ha9hfCm4CAOM=";

        // Salt value stored in database
        //String salt = "xKU25y1fZOL2vSasQlkKn3W46lpZym";

        boolean passwordMatch = encrypt.verifyUserPassword(providedPassword, mySecurePassword, salt);

        if(passwordMatch)
        {
            System.out.println("Provided user password " + providedPassword + " is correct.");
        } else {
            System.out.println("Provided password is incorrect");
        }
    }
*/
