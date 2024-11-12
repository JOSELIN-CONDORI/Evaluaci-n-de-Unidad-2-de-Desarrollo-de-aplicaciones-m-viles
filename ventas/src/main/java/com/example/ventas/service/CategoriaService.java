package com.example.ventas.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.example.ventas.entity.Categoria;

public interface CategoriaService {

    public List<Categoria> listar();

    public Categoria guardar(Categoria categoria);

    public Categoria actualizar(Categoria categoria);

    public Optional<Categoria> listarPorId(Integer id);

    public void eliminarPorId(Integer id);

    List<Categoria> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado);

}