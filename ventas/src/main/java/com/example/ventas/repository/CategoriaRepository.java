package com.example.ventas.repository;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ventas.entity.Categoria;
import java.util.List;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;

public interface CategoriaRepository extends JpaRepository<Categoria, Integer> {

    @Query("SELECT c FROM Categoria c WHERE "
            + "(:nombre IS NULL OR c.nombre LIKE %:nombre%) AND "
            + "(:estado IS NULL OR c.estado = :estado) AND "
            + "(:createdAt IS NULL OR c.createdAt >= :createdAt) AND "
            + "(:updatedAt IS NULL OR c.updatedAt <= :updatedAt)")

    List<Categoria> buscarPorParametros(
            @Param("nombre") String nombre,
            @Param("createdAt") LocalDateTime createdAt,
            @Param("updatedAt") LocalDateTime updatedAt,
            @Param("estado") String estado);
}
