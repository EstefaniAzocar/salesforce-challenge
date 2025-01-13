@isTest
public class CalcularProximaVacunacionTest {

    @isTest
    static void testProximaVacunacion() {
        // Crear una mascota con una fecha de última vacunación
        Mascota__c mascota = new Mascota__c(
            Name = 'Rex', 
            Especie__c = 'Perro',
            Fecha_de_la_ultima_vacunacion__c = Date.today().addDays(-30)
        );
        insert mascota;

        // Ejecutar el trigger
        Test.startTest();
        mascota.Fecha_de_la_ultima_vacunacion__c = Date.today().addDays(-60);  // Cambiar fecha para el test
        update mascota;
        Test.stopTest();

        // Verificar que la fecha de la próxima vacunación se haya calculado
        Mascota__c mascotaRecuperada = [SELECT Fecha_de_la_proxima_vacunacion__c FROM Mascota__c WHERE Id = :mascota.Id];
        System.assertNotEquals(mascotaRecuperada.Fecha_de_la_proxima_vacunacion__c, null);

        // Verificar que se haya insertado un registro de historial de vacunación
        Historial_de_Vacunacion__c historial = [SELECT Id, Fecha__c FROM Historial_de_Vacunacion__c WHERE Mascota__c = :mascota.Id LIMIT 1];
        System.assertNotEquals(historial, null);
        System.assertEquals(historial.Fecha__c, mascotaRecuperada.Fecha_de_la_proxima_vacunacion__c);
    }

    @isTest
    static void testMascotaSinFechaUltimaVacunacion() {
        // Crear una mascota sin fecha de última vacunación
        Mascota__c mascota = new Mascota__c(
            Name = 'Luna', 
            Especie__c = 'Gato'
        );
        insert mascota;

        // Ejecutar el trigger
        Test.startTest();
        update mascota;
        Test.stopTest();

        // Verificar que no se ha actualizado la fecha de próxima vacunación
        Mascota__c mascotaRecuperada = [SELECT Fecha_de_la_proxima_vacunacion__c FROM Mascota__c WHERE Id = :mascota.Id];
        System.assertEquals(mascotaRecuperada.Fecha_de_la_proxima_vacunacion__c, null);
    }
}