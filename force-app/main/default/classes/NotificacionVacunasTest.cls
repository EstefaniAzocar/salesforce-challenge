@isTest
public class NotificacionVacunasTest {

    @isTest
    static void testNotificacionVacunas() {
        // Preparar datos de prueba

        // Crear una mascota con fecha de vacunación hace 1 año
        Mascota__c mascotaConVacunaVencida = new Mascota__c(
            Name = 'Copito',
            Especie__c = 'Gato',
            Raza__c = 'Siamés',
            Fecha_de_la_ultima_vacunacion__c = Date.today().addDays(-365), // Fecha de vacunación hace 1 año
            Fecha_de_la_proxima_vacunacion__c = Date.today().addDays(365)  // Fecha de próxima vacunación dentro de 1 año
        );
        insert mascotaConVacunaVencida;

        // Crear una mascota con fecha de vacunación dentro del año
        Mascota__c mascotaConVacunaValida = new Mascota__c(
            Name = 'Fido',
            Especie__c = 'Perro',
            Raza__c = 'Labrador',
            Fecha_de_la_ultima_vacunacion__c = Date.today().addDays(-100), // Fecha de vacunación hace menos de 1 año
            Fecha_de_la_proxima_vacunacion__c = Date.today().addDays(265)  // Fecha de próxima vacunación dentro de 1 año
        );
        insert mascotaConVacunaValida;

        // Crear adopciones asociadas a las mascotas
        Adopcion__c adopcion1 = new Adopcion__c(Mascota__c = mascotaConVacunaVencida.Id);
        Adopcion__c adopcion2 = new Adopcion__c(Mascota__c = mascotaConVacunaValida.Id);
        insert new List<Adopcion__c>{adopcion1, adopcion2};

        // Ejecutar el batch
        Test.startTest();
        NotificacionVacunas batch = new NotificacionVacunas();
        Database.executeBatch(batch);
        Test.stopTest();

        // Paso 1: Verificar que se haya creado una tarea solo para la mascota con vacuna vencida
        List<Task> tareas = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId IN :new List<Id>{mascotaConVacunaVencida.Id, mascotaConVacunaValida.Id}];

        // Verificar que solo la mascota con vacuna vencida tenga tarea
        System.assertEquals(1, tareas.size(), 'Debería haberse creado una tarea para la mascota con vacuna vencida');
        System.assertEquals('Recordatorio de Vacunación', tareas[0].Subject, 'El sujeto de la tarea es incorrecto');
        System.assertEquals(mascotaConVacunaVencida.Id, tareas[0].WhatId, 'La tarea no está asociada a la mascota correcta');

        // Paso 2: Verificar que la tarea tiene una fecha de actividad correcta
        System.assertEquals(Date.today().addDays(1), tareas[0].ActivityDate, 'La fecha de actividad de la tarea es incorrecta');
        
        // Paso 3: Verificar que no se haya creado ninguna tarea para la mascota con vacuna válida
        List<Task> tareasNoCreadas = [SELECT Id FROM Task WHERE WhatId = :mascotaConVacunaValida.Id];
        System.assertEquals(0, tareasNoCreadas.size(), 'No debería haberse creado ninguna tarea para la mascota con vacuna válida');
    }
}