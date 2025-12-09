/**
 * cliente.js - JavaScript del Sistema de Registro de Clientes
 * Gabinete de Abogados
 * 
 * Funciones:
 * - buscarCliente(): Busca un cliente por código
 * - guardarCliente(): Guarda o actualiza un cliente
 * - mostrarMensaje(): Muestra mensajes de notificación
 */

/**
 * Función para buscar cliente mediante AJAX
 * Se activa al presionar el botón Buscar
 */
function buscarCliente() {
    const codCliente = document.getElementById('codClienteBusqueda').value.trim();
    
    if (!codCliente) {
        mostrarMensaje('Por favor ingrese un código de cliente', 'error');
        alert('Por favor ingrese un código de cliente');
        return;
    }
    
    // Mostrar indicador de carga
    const btnSearch = document.querySelector('.btn-search');
    const textoOriginal = btnSearch.textContent;
    btnSearch.innerHTML = '<span class="spinner"></span>Buscando...';
    btnSearch.disabled = true;
    
    // Crear formulario para POST
    const formData = new FormData();
    formData.append('codCliente', codCliente);
    formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);
    
    // Realizar consulta AJAX
    fetch(URL_BUSCAR_CLIENTE, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.exito) {
            // Rellenar formulario con datos encontrados
            document.getElementById('codCliente').value = data.datos.codCliente;
            document.getElementById('nomCliente').value = data.datos.nomCliente;
            document.getElementById('apellCliente').value = data.datos.apellCliente;
            document.getElementById('nDocumento').value = data.datos.nDocumento;
            document.getElementById('idTipoDoc').value = data.datos.idTipoDoc;
            
            const msg = `Cliente encontrado: ${data.datos.nomCliente} ${data.datos.apellCliente}`;
            mostrarMensaje(msg, 'info');
            alert(msg);
        } else {
            mostrarMensaje(data.mensaje, 'error');
            alert(data.mensaje);
        }
    })
    .catch(error => {
        mostrarMensaje('Error en la búsqueda: ' + error, 'error');
        alert('Error en la búsqueda: ' + error);
        console.error('Error:', error);
    })
    .finally(() => {
        // Restaurar botón
        btnSearch.innerHTML = textoOriginal;
        btnSearch.disabled = false;
    });
}

/**
 * Función para guardar cliente
 * Se activa al presionar botón Guardar
 */
function guardarCliente(event) {
    event.preventDefault();
    
    const codCliente = document.getElementById('codCliente').value.trim();
    const nomCliente = document.getElementById('nomCliente').value.trim();
    const apellCliente = document.getElementById('apellCliente').value.trim();
    const nDocumento = document.getElementById('nDocumento').value.trim();
    const idTipoDoc = document.getElementById('idTipoDoc').value.trim();
    
    // Validaciones cliente-side
    if (!codCliente || !nomCliente || !apellCliente || !nDocumento || !idTipoDoc) {
        mostrarMensaje('Todos los campos son obligatorios', 'error');
        alert('Todos los campos son obligatorios');
        return;
    }
    
    if (codCliente.length > 5) {
        mostrarMensaje('Código de cliente no puede exceder 5 caracteres', 'error');
        alert('Código de cliente no puede exceder 5 caracteres');
        return;
    }
    
    if (nomCliente.length > 30 || apellCliente.length > 30) {
        mostrarMensaje('Nombre y apellido no pueden exceder 30 caracteres', 'error');
        alert('Nombre y apellido no pueden exceder 30 caracteres');
        return;
    }
    
    if (nDocumento.length > 15) {
        mostrarMensaje('Número de documento no puede exceder 15 caracteres', 'error');
        alert('Número de documento no puede exceder 15 caracteres');
        return;
    }
    
    // Crear formulario para POST
    const formData = new FormData();
    formData.append('codCliente', codCliente);
    formData.append('nomCliente', nomCliente);
    formData.append('apellCliente', apellCliente);
    formData.append('nDocumento', nDocumento);
    formData.append('idTipoDoc', idTipoDoc);
    formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);
    
    // Mostrar indicador de carga
    const btnSave = document.querySelector('.btn-save');
    const textoOriginal = btnSave.textContent;
    btnSave.innerHTML = '<span class="spinner"></span>Guardando...';
    btnSave.disabled = true;
    
    // Realizar guardado mediante AJAX
    fetch(URL_GUARDAR_CLIENTE, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.exito) {
            mostrarMensaje(data.mensaje, 'success');
            alert(data.mensaje);
            document.getElementById('formRegistro').reset();
            document.getElementById('codClienteBusqueda').value = '';
        } else {
            mostrarMensaje(data.mensaje, 'error');
            alert(data.mensaje);
        }
    })
    .catch(error => {
        mostrarMensaje('Error al guardar: ' + error, 'error');
        alert('Error al guardar: ' + error);
        console.error('Error:', error);
    })
    .finally(() => {
        // Restaurar botón
        btnSave.innerHTML = textoOriginal;
        btnSave.disabled = false;
    });
}

/**
 * Función para eliminar cliente
 */
function eliminarCliente() {
    const codCliente = document.getElementById('codClienteEliminar').value.trim();
    
    if (!codCliente) {
        mostrarMensaje('Por favor ingrese un código de cliente a eliminar', 'error');
        return;
    }
    
    if (!confirm(`¿Está seguro que desea eliminar el cliente con código ${codCliente}?`)) {
        return;
    }
    
    // Mostrar indicador de carga
    const btnDelete = document.querySelector('.btn-delete');
    const textoOriginal = btnDelete.textContent;
    btnDelete.innerHTML = '<span class="spinner"></span>Eliminando...';
    btnDelete.disabled = true;
    
    // Crear formulario para POST
    const formData = new FormData();
    formData.append('codCliente', codCliente);
    formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);
    
    // Realizar eliminación mediante AJAX
    fetch(URL_ELIMINAR_CLIENTE, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.exito) {
            mostrarMensaje(data.mensaje, 'success');
            alert(data.mensaje); // Confirmación extra
            document.getElementById('codClienteEliminar').value = '';
            // Limpiar formulario principal si tenía el mismo cliente
            if (document.getElementById('codCliente').value === codCliente) {
                document.getElementById('formRegistro').reset();
            }
        } else {
            mostrarMensaje(data.mensaje, 'error');
            alert(data.mensaje); // Error visible
        }
    })
    .catch(error => {
        mostrarMensaje('Error al eliminar: ' + error, 'error');
        alert('Error al eliminar: ' + error);
        console.error('Error:', error);
    })
    .finally(() => {
        // Restaurar botón
        btnDelete.innerHTML = textoOriginal;
        btnDelete.disabled = false;
    });
}

/**
 * Función auxiliar para mostrar mensajes
 */
function mostrarMensaje(mensaje, tipo) {
    const divMensaje = document.getElementById('mensaje');
    divMensaje.textContent = mensaje;
    divMensaje.className = `message ${tipo}`;
    
    // Auto-ocultar después de 5 segundos
    setTimeout(() => {
        divMensaje.className = 'message';
    }, 5000);
}

/**
 * Al cargar la página
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Página cargada - Sistema de Registro de Clientes listo');
});
