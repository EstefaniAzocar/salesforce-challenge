public with sharing class CertificadoMascotaController {
    public Adopcion__c adopcion { get; set; }
    public Mascota__c mascota { get; set; }

    public CertificadoMascotaController() {
        try {
            // Obtiene el ID de la adopción desde los parámetros de la página
            Id adopcionId = ApexPages.currentPage().getParameters().get('adopcionId');

            // Verifica si el ID es válido
            if (adopcionId != null) {
                // Recupera la adopción y los datos de la mascota relacionada
                adopcion = [SELECT Id, Name, Estado__c, Fecha_de_adopcion__c, 
                            Mascota__r.Name, Mascota__r.Raza__c, Mascota__r.Fecha_de_la_ultima_vacunacion__c
                            FROM Adopcion__c 
                            WHERE Id = :adopcionId LIMIT 1];

                // Asigna la mascota relacionada
                if (adopcion != null && adopcion.Mascota__r != null) {
                    mascota = adopcion.Mascota__r;
                }
            } else {
                // Si no se recibe un ID válido, mostramos un mensaje de error
                System.debug('No se proporcionó un ID de adopción.');
            }
        } catch (Exception e) {
            // Manejo de excepciones si algo sale mal
            System.debug('Error recuperando datos: ' + e.getMessage());
        }
    }
}