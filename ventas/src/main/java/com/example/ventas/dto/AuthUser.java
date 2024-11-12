package com.example.ventas.dto;

import lombok.Data;

@Data
public class AuthUser {
    private int id;
    private String name;
    private String email;
    private String apellido_p;
    private String apellido_m;
    private String dni;
    private String codigo;
}
