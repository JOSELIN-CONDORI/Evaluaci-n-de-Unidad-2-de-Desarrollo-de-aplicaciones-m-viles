package com.example.ventas.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.example.ventas.entity.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    List<Producto> findBySubCategoriaId(Integer idSubCategoria);

    @Query("SELECT c FROM Producto c WHERE "
            + "(:nombre IS NULL OR c.nombre LIKE %:nombre%) AND "
            + "(:estado IS NULL OR c.estado = :estado) AND "
            + "(:createdAt IS NULL OR c.createdAt >= :createdAt) AND "
            + "(:updatedAt IS NULL OR c.updatedAt <= :updatedAt)")

    List<Producto> buscarPorParametros(
            @Param("nombre") String nombre,
            @Param("createdAt") LocalDateTime createdAt,
            @Param("updatedAt") LocalDateTime updatedAt,
            @Param("estado") String estado);
}
