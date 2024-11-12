package com.example.ventas.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.example.ventas.entity.SubCategoria;

public interface SubCategoriaRepository extends JpaRepository<SubCategoria, Integer> {
    List<SubCategoria> findByCategoriaId(Integer idCategoria);

    @Query("SELECT c FROM SubCategoria c WHERE "
            + "(:nombre IS NULL OR c.nombre LIKE %:nombre%) AND "
            + "(:estado IS NULL OR c.estado = :estado) AND "
            + "(:createdAt IS NULL OR c.createdAt >= :createdAt) AND "
            + "(:updatedAt IS NULL OR c.updatedAt <= :updatedAt)")

    List<SubCategoria> buscarPorParametros(
            @Param("nombre") String nombre,
            @Param("createdAt") LocalDateTime createdAt,
            @Param("updatedAt") LocalDateTime updatedAt,
            @Param("estado") String estado);
}
