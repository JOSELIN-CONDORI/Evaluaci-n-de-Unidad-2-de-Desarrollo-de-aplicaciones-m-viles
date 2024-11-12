package com.example.ventas.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.Producto;
import com.example.ventas.entity.SubCategoria;
import com.example.ventas.repository.ProductoRepository;
import com.example.ventas.service.ProductoService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductoServiceImpl implements ProductoService {

    @Autowired
    private SubCategoriaServiceImpl subCategoriaService;

    @Autowired
    private ProductoRepository productoRepository;

    @Override
    public List<Producto> buscar(String nombre, LocalDateTime createdAt, LocalDateTime updatedAt, String estado) {
        return productoRepository.buscarPorParametros(nombre, createdAt, updatedAt, estado);
    }

    @Override
    public List<Producto> listar() {
        return productoRepository.findAll();
    }

    @Override
    public Producto guardar(Producto producto) {
        return productoRepository.save(producto);
    }

    // @Override
    // public Producto actualizar(Producto producto) {
    // return productoRepository.save(producto);
    // }

    @Override
    public Producto actualizar(Producto producto) {

        Producto productoExistente = productoRepository.findById(producto.getId())
                .orElseThrow(() -> new EntityNotFoundException("producto no encontrado"));
        // Solo actualiza los campos que deseas cambiar
        productoExistente.setNombre(producto.getNombre());
        productoExistente.setDescrip(producto.getDescrip());
        productoExistente.setPrecio(producto.getPrecio());
        productoExistente.setStock(producto.getStock());
        productoExistente.setFoto(producto.getFoto());
        productoExistente.setSubCategoria(producto.getSubCategoria());
        productoExistente.setEstado(producto.getEstado());
        // Guarda los cambios
        return productoRepository.save(productoExistente);
    }

    @Override
    public Optional<Producto> listarPorId(Integer id) {
        Producto producto = productoRepository.findById(id).orElse(null);
        if (producto != null) {
            System.out.println("Antes de la petición");
            Optional<SubCategoria> subCategoriaOptional = subCategoriaService
                    .listarPorId(producto.getSubCategoria().getId());
            if (subCategoriaOptional.isPresent()) {
                SubCategoria subCategoria = subCategoriaOptional.get();
                producto.setSubCategoria(subCategoria);
            }
        }

        return Optional.ofNullable(producto);
    }

    @Override
    public void eliminarPorId(Integer id) {
        productoRepository.deleteById(id);
    }

    @Override
    public List<Producto> listarPorSubCategoria(Integer idSubCategoria) {
        // Obtener la lista de Productos por categoría directamente desde el
        // repositorio
        return productoRepository.findBySubCategoriaId(idSubCategoria);
    }
}
