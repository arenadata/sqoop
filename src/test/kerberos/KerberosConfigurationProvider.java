package kerberos;

public interface KerberosConfigurationProvider {

    String getTestPrincipal();

    String getRealm();

    String getKeytabFilePath();

}