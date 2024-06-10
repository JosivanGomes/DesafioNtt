public with sharing class Utils {
    public static Boolean validaCpf(String cpf) {
        if(cpf == '11111111111'){
            return false;
        }

        return true;

    }

    public static Boolean validaCnpj(String cnpj) {
        if(cnpj == '11111111111111'){
            return false;
        }
        
        return true;
    }
}