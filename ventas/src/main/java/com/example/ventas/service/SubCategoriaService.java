package com.example.ventas.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.SubCategoria;

public interface SubCategoriaService {

    public List<SubCategoria> listar();

    public SubCategoria guardar(SubCategoria subcategoria);

    public SubCategoria actualizar(SubCategoria subcategoria);

    public Optional<SubCategoria> listarPorId(Integer id);

    public void eliminarPorId(Integer id);

    // Otros métodos existentes
    List<SubCategoria> listarPorCategoria(Integer idCategoria);

    List<SubCategoria> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado);
}
