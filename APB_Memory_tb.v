module APB_Memory_tb();
    
    reg Pclk, Prst, Pselx, Penable, Pwrite;
    reg [31:0] Pwdata;
    reg [4:0] Paddr;
    
    wire Pready, Pslverr;
    wire [31:0] Prdata, temp;
    
    APB_Memory DUT(.Pclk(Pclk), .Prst(Prst), .Paddr(Paddr), .Pselx(Pselx), .Penable(Penable), .Pwrite(Pwrite), .Pwdata(Pwdata), .Pready(Pready), .Pslverr(Pslverr), .Prdata(Prdata), .temp(temp));
    
    initial Pclk = 0;
    always #10 Pclk = ~Pclk;
    
    task reset_and_init;
        begin
            #5 Prst = 0;
            @(posedge Pclk);
            Prst = 1;
            Pselx = 1'b0;
            Penable = 1'bx;
            Pwrite = 1'bx;
            Paddr = 'bx;
        end
     endtask
        
    task write_transfer;
        begin
            Pselx = 1;
            Pwrite = 1;
            Pwdata = $random;
            Paddr = $random;
            
            @(posedge Pclk)
            Penable = 1;
            
				wait(Pready == 1)
				
            @(posedge Pclk);
            Penable = 0;
            
            $strobe("Writing Data into memory: Data = %0d | Address = %0d",Pwdata,Paddr);
        end
     endtask
     
     task read_transfer;
        begin
            Pselx = 1;
            Pwrite = 0;
				
            @(posedge Pclk);
            Penable = 1;
            
            @(posedge Pclk);
            Penable = 0;
            Pselx = 0;
            
            $strobe("Reading Data From Memory: Data = %0d | Address = %0d",Prdata, Paddr);
        end
     endtask
     
     
     task read_write_transfer;
        begin
            repeat(5)
                begin
                    write_transfer;
                    read_transfer;
                end
        end
     endtask
     
     
     initial begin
     reset_and_init;
     read_write_transfer;
     #80;
     $finish;
     end
endmodule
