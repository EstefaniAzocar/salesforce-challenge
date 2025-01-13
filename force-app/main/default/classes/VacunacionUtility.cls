public class VacunacionUtility {
    // Método para calcular la próxima fecha de vacunación
    public static void calcularProximaVacunacion(Mascota__c mascota) {
        // Asegúrate de que la mascota tenga una fecha de última vacunación
        if (mascota.Fecha_de_la_ultima_vacunacion__c != null) {
            // Supón que el intervalo de vacunación es un campo personalizado en la mascota
            Integer intervalo = obtenerIntervaloVacunacion(mascota.Especie__c);
            // Calcula la próxima fecha
            mascota.Fecha_de_la_proxima_vacunacion__c = 
                mascota.Fecha_de_la_ultima_vacunacion__c.addDays(intervalo);
        }
    }

    // Método para obtener el intervalo de vacunación de acuerdo con la especie
    private static Integer obtenerIntervaloVacunacion(String especie) {
        // Aquí puedes implementar la lógica para obtener el intervalo según la especie.
        // Este es un ejemplo simple.
        if (especie == 'Perro') {
            return 365; // Ejemplo: un año para perros
        } else if (especie == 'Gato') {
            return 365; // Ejemplo: un año para gatos
        }
        return 0; // Si no hay especie, no hay intervalo
    }
}