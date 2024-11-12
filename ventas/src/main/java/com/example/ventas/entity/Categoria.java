package com.example.ventas.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;

@Entity
@Data
public class Categoria {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String nombre;
    private String tag;
    private String foto;
    private String estado;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    private void prePersist() {
        createdAt = LocalDateTime.now(); // Se establece solo al crear
        updatedAt = LocalDateTime.now(); // Se establece al crear
    }

    @PreUpdate
    private void preUpdate() {
        updatedAt = LocalDateTime.now(); // Se actualiza solo al modificar
    }
}