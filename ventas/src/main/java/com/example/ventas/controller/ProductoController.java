package com.example.ventas.controller;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.Producto;

import com.example.ventas.service.ProductoService;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/producto")
public class ProductoController {
    @Autowired
    private ProductoService productoService;

    @GetMapping("/productoPorSubCategoria/{idSubCategoria}")
    public ResponseEntity<List<Producto>> listarProductosPorSubCategoria(@PathVariable Integer idSubCategoria) {
        List<Producto> productos = productoService.listarPorSubCategoria(idSubCategoria);
        return ResponseEntity.ok(productos);
    }

    @GetMapping()
    public ResponseEntity<List<Producto>> list() {
        return ResponseEntity.ok().body(productoService.listar());
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<Producto>> buscar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) LocalDateTime createdAt,
            @RequestParam(required = false) LocalDateTime updatedAt,
            @RequestParam(required = false) String estado) {

        List<Producto> productos = productoService.buscar(nombre, createdAt, updatedAt, estado);
        return ResponseEntity.ok().body(productos);
    }

    @PostMapping()
    public ResponseEntity<Producto> save(@RequestBody Producto producto) {
        return ResponseEntity.ok(productoService.guardar(producto));
    }

    @PutMapping()
    public ResponseEntity<Producto> update(@RequestBody Producto producto) {
        return ResponseEntity.ok(productoService.actualizar(producto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Producto> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(productoService.listarPorId(id).get());
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id) {
        productoService.eliminarPorId(id);
        return "Eliminacion Correcta";
    }
}
