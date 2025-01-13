public with sharing class AdopcionController {
    @AuraEnabled(cacheable=true)
    public static Adopcion__c getAdopcionDetails(String recordId) {
        try {
            // Consulta para obtener los detalles de la adopción junto con la raza de la mascota
            Adopcion__c adoption = [SELECT Name, Estado__c, Fecha_de_adopcion__c, 
                                    Mascota__r.Name, Mascota__r.Raza__c 
                                    FROM Adopcion__c 
                                    WHERE Id = :recordId LIMIT 1];
            return adoption;
        } catch (Exception e) {
            // Usamos AuraHandledException para capturar errores de forma adecuada
            throw new AuraHandledException('Error fetching adoption details: ' + e.getMessage());
        }
    }

    // Método para actualizar el estado de la adopción
    @AuraEnabled
    public static void updateAdopcionState(String recordId, String newState) {
        try {
            // Obtiene el registro de adopción por ID
            Adopcion__c adoption = [SELECT Id, Estado__c FROM Adopcion__c WHERE Id = :recordId LIMIT 1];
            
            // Actualiza el estado de adopción
            adoption.Estado__c = newState;
            
            // Realiza el update
            update adoption;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating adoption state: ' + e.getMessage());
        }
    }
}