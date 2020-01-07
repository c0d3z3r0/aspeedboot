/*
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Original work:
 *  ASPEED Technology Inc.
 *  Gary Hsu, <gary_hsu@aspeedtech.com>
 *
 * Derived work:
 *  Copyright (C) 2019 Michael Niewöhner <foss@mniewoehner.de>
 */

	.macro init_delay_timer
	ldr r0, =0x1e782024                          @ Set Timer3 Reload
	str r2, [r0]

	ldr r0, =0x1e6c0038                          @ Clear Timer3 ISR
	ldr r1, =0x00040000
	str r1, [r0]

	ldr r0, =0x1e782030                          @ Enable Timer3
	ldr r1, [r0]
	mov r2, #7
	orr r1, r1, r2, lsl #8
	str r1, [r0]

	ldr r0, =0x1e6c0090                          @ Check ISR for Timer3 timeout
	.endm

	.macro check_delay_timer
	ldr r1, [r0]
	bic r1, r1, #0xFFFBFFFF
	mov r2, r1, lsr #18
	cmp r2, #0x01
	.endm

	.macro clear_delay_timer
	ldr r0, =0x1e782030                          @ Disable Timer3
	ldr r1, [r0]
	bic r1, r1, #0x00000F00
	str r1, [r0]

	ldr r0, =0x1e6c0038                          @ Clear Timer3 ISR
	ldr r1, =0x00040000
	str r1, [r0]
	.endm
