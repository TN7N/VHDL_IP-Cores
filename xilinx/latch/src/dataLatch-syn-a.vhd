--! @file dataLatch-syn-a.vhd
--! @brief Data latch generated architecture
-------------------------------------------------------------------------------
-- Architecture : syn
-------------------------------------------------------------------------------
--
--    (c) B&R, 2014
--
--    Redistribution and use in source and binary forms, with or without
--    modification, are permitted provided that the following conditions
--    are met:
--
--    1. Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--
--    2. Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--
--    3. Neither the name of the copyright holders nor the names of its
--       contributors may be used to endorse or promote products derived
--       from this software without prior written permission. For written
--       permission, please contact office@br-automation.com
--
--    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--    COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--    POSSIBILITY OF SUCH DAMAGE.
--
-------------------------------------------------------------------------------
--! Use standard ieee library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! Use libcommon library
library libcommon;
--! Use global package
use libcommon.global.all;

--! Use unisim library
library unisim;
--! Use transparent data latch with asynchronous clear
use unisim.vcomponents.ldc;

--! @brief Xilinx data latch architecture
--! @details This architecture uses an Xilinx primitive component for the data
--!          latch implementation.
architecture syn of dataLatch is
begin
    GEN_LATCH : for i in gDataWidth-1 downto 0 generate
        INST_LATCH : ldc
            port map (
                Q   => oData(i),
                CLR => iClear,
                D   => iData(i),
                G   => iEnable
            );
    end generate GEN_LATCH;
end architecture syn;
