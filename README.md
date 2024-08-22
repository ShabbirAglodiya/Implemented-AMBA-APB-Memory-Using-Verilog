# Implemented-AMBA-APB-Memory-Using-Verilog

# Overview of APB (Advanced Peripheral Bus) Memory Interface
The APB (Advanced Peripheral Bus) is a simple bus protocol used in many SoC (System on Chip) designs. It is commonly used for communication with low-bandwidth peripherals that do not require the high-speed operation of other buses like the AHB (Advanced High-performance Bus). The APB protocol is optimized for minimal power consumption and reduced interface complexity.

# APB Memory Design (Verilog Code Analysis)
The Verilog design provided (APB_Memory) simulates an APB slave that interacts with a memory block. This module is designed to perform both read and write operations to a memory array based on the APB protocol.

## Inputs:
•	Pclk: Clock signal.

•	Prst: Asynchronous reset signal, active low.

•	Paddr: 5-bit address bus for accessing memory locations.

•	Pselx: Select signal, indicating the slave is being addressed.

•	Penable: Signal to enable data transfer.

•	Pwrite: Signal to determine whether the operation is read (0) or write (1).

•	Pwdata: 32-bit data input bus for writing to memory.

## Outputs:
•	Pready: Indicates that the slave is ready for a data transfer.
•	Pslverr: Error signal indicating an invalid address access.
•	Prdata: 32-bit data output bus for reading from memory.
•	temp: A temporary register used to hold written data for verification.

## Memory Array:
•	A 32x32-bit memory array is declared using the mem register. This array is accessed based on the Paddr signal.

## Finite State Machine (FSM):
The design follows a simple three-state FSM:
•	Idle: Default state, where the module waits for a Pselx signal.
•	Setup: Prepares the memory for either a read or write operation.
•	Access: Performs the actual data transfer (read or write).

## Operation:
•	Reset: When Prst is asserted (low), the module resets to the idle state.
•	Write Operation: If Pwrite and Penable are high, data from Pwdata is written to the memory location specified by Paddr. If Paddr exceeds the bounds of the memory (greater than 31), Pslverr is set.
•	Read Operation: If Pwrite is low and Penable is high, data from the memory location specified by Paddr is read and assigned to Prdata.

# Testbench Analysis (APB_Memory_tb)
The testbench simulates the APB Memory design by applying various signals and observing the outputs.
## Key Components:
•	Clock Generation: A clock signal is generated with a period of 20 units (half-period of 10 units).
•	Tasks:
o	reset_and_init: Resets the design and initializes the input signals.
o	write_transfer: Writes random data to a random address in the memory.
o	read_transfer: Reads data from a random address in the memory.
o	read_write_transfer: Repeats the write and read operations five times to verify memory functionality.

## Simulation Flow:
•	The design is first reset and initialized.
•	A series of write and read operations are performed to verify the correct functionality of the memory.
•	The $strobe system task is used to print messages to the console, displaying the data being written or read along with the corresponding address.

## Waveform Analysis:
The output waveform image (Output_Waveform.png) displays the signal transitions during the testbench simulation.
•	Clock (Pclk): The clock signal toggles regularly, providing the timing reference for the design.
•	Reset (Prst): The reset signal is asserted at the beginning, resetting the design.
•	Signals (Pselx, Penable, Pwrite, Paddr, Pwdata): These signals control the read/write operations, with Pselx selecting the slave, Penable enabling the transfer, and Pwrite indicating the operation type (read or write).
•	Outputs (Pready, Pslverr, Prdata): Pready indicates when the module is ready for the next operation, Pslverr signals an error, and Prdata shows the data being read from memory.
The waveform demonstrates the interaction between these signals, validating the functionality of the APB Memory design. It shows data being written to and read from various memory locations, with the corresponding address and data values displayed.

# Conclusion
The provided Verilog design and testbench successfully simulate an APB slave memory module. The design follows a structured approach with a clear FSM, and the testbench thoroughly validates its functionality through a series of read and write operations. The output waveform confirms the correctness of the implementation, aligning with the expected behavior described in the design.

