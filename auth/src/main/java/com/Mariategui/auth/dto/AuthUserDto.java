package com.Mariategui.auth.dto;

import java.time.LocalDateTime;

import javax.persistence.PreUpdate;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthUserDto {
    private int id;
    private String role;
    private String name;
    private String email;
    private String password;
    private String confirmPassword;
    private String foto;
    private String apellido_p;
    private String apellido_m;
    private String dni;
    private String codigo;
    private LocalDateTime created_at = LocalDateTime.now();
    private LocalDateTime updated_at = LocalDateTime.now();

    @PreUpdate
    private void preUpdate() {
        updated_at = LocalDateTime.now();
    }

}
