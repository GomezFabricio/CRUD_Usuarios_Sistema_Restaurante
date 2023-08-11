from models.usuarios.model_users import UserModel
from flask import flash, redirect, url_for
import re

class UserController:
    def __init__(self, dni=0, nombre="", apellido="", telefono=0, idUsuario=0, idRol=0, idPersona=0, usuario="", password=""):
        self.dni = dni
        self.nombre = nombre
        self.apellido = apellido
        self.telefono = telefono
        self.id_usuario = idUsuario
        self.id_rol = idRol
        self.id_persona = idPersona
        self.usuario = usuario
        self.password = password
        self.error = None
        self.error_messages = []
        self.user_model = UserModel(
            self.dni, self.nombre, self.apellido, self.telefono, self.id_usuario, self.id_rol, self.id_persona, self.usuario, self.password
        )

    def GetUsers(self):
        list_users = self.user_model.ListUsers()
        return list_users

    def AddUser(self):

        if not re.match(r'^[A-Za-z\sáéíóúÁÉÍÓÚñÑ]+$', self.nombre):
            self.error_messages.append("El nombre solo debe contener letras y espacios")

        if not re.match(r'^[A-Za-z\sáéíóúÁÉÍÓÚñÑ]+$', self.apellido):
            self.error_messages.append("El apellido solo debe contener letras y espacios")  

        if not re.match(r'^\d{8}$', self.dni):
            self.error_messages.append("El número de DNI debe tener 8 dígitos")

        if not re.match(r'^\d{10}$', self.telefono):
            self.error_messages.append("El número de teléfono debe tener 10 dígitos")

        if self.error_messages:
            self.error = self.error_messages
            return

        try:
            self.user_model.AddUser()
        except Exception as e:
            self.error = str(e)

    def DeleteUser(self):
        try:
            self.user_model.DeleteUser()
        except Exception as e:
            self.error = str(e)

    def UpdateUser(self):

        if not re.match(r'^[A-Za-z\sáéíóúÁÉÍÓÚñÑ]+$', self.nombre):
            self.error_messages.append("El nombre solo debe contener letras y espacios")

        if not re.match(r'^[A-Za-z\sáéíóúÁÉÍÓÚñÑ]+$', self.apellido):
            self.error_messages.append("El apellido solo debe contener letras y espacios")  

        if not re.match(r'^\d{8}$', self.dni):
            self.error_messages.append("El número de DNI debe tener 8 dígitos")

        if not re.match(r'^\d{10}$', self.telefono):
            self.error_messages.append("El número de teléfono debe tener 10 dígitos")

        if self.error_messages:
            self.error = self.error_messages
            return

        try:
            self.user_model.UpdateUser()
        except Exception as e:
            self.error = str(e)

    def get_roles(self):
        roles = self.user_model.get_roles()
        return roles

    def get_rol_by_id(self):
        roles = self.user_model.get_rol_by_id()
        return roles

    def get_user_by_id(self):
        user = self.user_model.get_user_by_id()
        
        if user is None:
            self.error = "El usuario no existe"
        
        return user