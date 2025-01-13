trigger CalcularProximaVacunacion on Mascota__c (before insert, before update) {
    List<Historial_de_Vacunacion__c> historialVacunacionList = new List<Historial_de_Vacunacion__c>();

    for (Mascota__c mascota : Trigger.new) {
        // Si la mascota ya tiene una fecha de última vacunación
        if (mascota.Fecha_de_la_ultima_vacunacion__c != null) {
            // Llamar al método para calcular la próxima vacunación
            VacunacionUtility.calcularProximaVacunacion(mascota);

            // Crear un registro de historial de vacunación
            Historial_de_Vacunacion__c nuevoHistorial = new Historial_de_Vacunacion__c(
                Mascota__c = mascota.Id,
                Fecha__c = mascota.Fecha_de_la_proxima_vacunacion__c,
                Lugar__c = 'Lugar de vacunación' // Puedes personalizar este campo
            );
            historialVacunacionList.add(nuevoHistorial);
        }
    }

    // Insertar los registros de historial de vacunación si es necesario
    if (!historialVacunacionList.isEmpty()) {
        insert historialVacunacionList;
    }
}