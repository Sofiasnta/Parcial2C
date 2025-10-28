defmodule Main do

  def main() do

    pieza1 = Pieza.crear_pieza("01", "Resistor", 5, "unidad", 100)
    pieza2 = Pieza.crear_pieza("02", "Capacitor", 3, "unidad", 150)
    pieza3 = Pieza.crear_pieza("03", "Inductor", 4, "unidad", 200)
    pieza4 = Pieza.crear_pieza("04", "Led", 2, "unidad", 200)
    pieza5 = Pieza.crear_pieza("01", "Resistor", 5, "unidad", 100)
    piezas = [pieza1, pieza2, pieza3, pieza4, pieza5]

    IO.puts("---- Piezas creadas ----")
    IO.inspect(piezas)

    escribir_pieza= Pieza.escribir_pieza_csv(piezas, "piezas.csv")
    IO.inspect(escribir_pieza)


    leer_pieza= Pieza.leer_pieza_csv("piezas.csv")
    IO.puts("\n---- Piezas leídas desde CSV ----")
    IO.inspect(leer_pieza)

    contra_stock= Pieza.contar_stock_umbral(piezas, 120)
    IO.puts("Piezas que tienen un stock menor a 120: #{contra_stock}")

    sin_duplicados= Pieza.eliminar_duplicados(piezas)
    IO.puts("\n---- Piezas sin duplicados ----")
    IO.inspect(sin_duplicados)


    movimiento1= Movimiento.crear_movimiento("01", "ENTRADA", 50, "2024-01-10")
    movimiento2= Movimiento.crear_movimiento("02", "SALIDA", 30, "2024-01-11")
    movimiento3= Movimiento.crear_movimiento("03", "ENTRADA", 20, "2024-01-12")
    movimiento4= Movimiento.crear_movimiento("04", "SALIDA", 10, "2024-01-13")
    lista_movimientos=[movimiento1, movimiento2, movimiento3, movimiento4]

    IO.puts("\n---- Movimientos creados ----")
    IO.inspect(lista_movimientos)

    csv_movimiento=Movimiento.escribir_movimiento_csv(lista_movimientos, "movimientos.csv")
    IO.inspect(csv_movimiento)

    aplicar_mov= Movimiento.aplicar_movimientos(piezas, lista_movimientos)
    IO.puts("\n---- Piezas después de aplicar movimientos ----")
    IO.inspect(aplicar_mov)

    movimientos_leidos= Movimiento.leer_movimiento_csv("movimientos.csv")
    IO.puts("\n---- Movimientos leídos desde CSV ----")
    IO.inspect(movimientos_leidos)



    piezas_actualizadas= Movimiento.actualizar_inventario(piezas, movimientos_leidos, "piezas_actualizadas.csv")
    IO.puts("\n---- Piezas con inventario actualizado ----")
    IO.inspect(piezas_actualizadas)


    total_movido= Movimiento.total_movido_rango(lista_movimientos, "2024-01-10", "2024-01-12")
    IO.puts("Total movido entre 2024-01-10 y 2024-01-12: #{total_movido}")


  end

end

Main.main()
