"""
urls.py - Configuración de rutas URL del proyecto
"""

from django.contrib import admin
from django.urls import path
from clientes import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.registrar_cliente, name='registro_cliente'),
    path('buscar-cliente/', views.buscar_cliente_ajax, name='buscar_cliente'),
    path('guardar-cliente/', views.guardar_cliente, name='guardar_cliente'),
    path('eliminar-cliente/', views.eliminar_cliente, name='eliminar_cliente'),
    path('obtener-tipos/', views.obtener_tipos_ajax, name='obtener_tipos'),
]
