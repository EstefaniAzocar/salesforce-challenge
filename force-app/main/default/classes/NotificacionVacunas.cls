public class NotificacionVacunas implements Database.Batchable<SObject> {
    public String query;

    // Constructor: prepara la consulta
    public NotificacionVacunas() {
        query = 'SELECT Id, Mascota__c, Mascota__r.Fecha_de_la_ultima_vacunacion__c FROM Adopcion__c WHERE Mascota__r.Fecha_de_la_ultima_vacunacion__c != NULL';
        System.debug('Query: ' + query);
    }

    // Método start: inicio del batch
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Start method invoked');
        return Database.getQueryLocator(query);
    }

    // Método execute: proceso de los registros
    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        System.debug('Execute method invoked with scope size: ' + scope.size());
        List<Task> tasksToInsert = new List<Task>();

        // Procesar cada adopción
        for (Adopcion__c adopcion : (List<Adopcion__c>)scope) {
            System.debug('Processing Adopcion__c: ' + adopcion.Id);
            if (adopcion.Mascota__r != null && adopcion.Mascota__r.Fecha_de_la_ultima_vacunacion__c != null) {
                Date lastVaccinationDate = adopcion.Mascota__r.Fecha_de_la_ultima_vacunacion__c;
                Date vaccinationDueDate = lastVaccinationDate.addDays(365); // Fecha de vacunación próxima (1 año después)

                // Si la fecha de la próxima vacunación ha pasado, creamos una tarea
                if (vaccinationDueDate <= System.today()) {
                    System.debug('Creating task for Mascota__c: ' + adopcion.Mascota__c);
                    tasksToInsert.add(new Task(
                        Subject = 'Recordatorio de Vacunación',
                        WhatId = adopcion.Mascota__c,
                        OwnerId = UserInfo.getUserId(),
                        ActivityDate = System.today().addDays(1), // Tarea para el día siguiente
                        Status = 'Not Started',
                        Priority = 'High'
                    ));
                }
            }
        }

        // Insertamos las tareas creadas
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
            System.debug('Tasks inserted: ' + tasksToInsert.size());
        } else {
            System.debug('No tasks to insert');
        }
    }

    // Método finish: al finalizar el batch
    public void finish(Database.BatchableContext BC) {
        System.debug('Finish method invoked');
    }
}