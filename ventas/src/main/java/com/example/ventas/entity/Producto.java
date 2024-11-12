package com.example.ventas.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Entity
@Data
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String nombre;
    private String descrip;
    private String precio;
    private String stock;
    private String foto;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_categoria_id")
    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    private SubCategoria subCategoria;
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
