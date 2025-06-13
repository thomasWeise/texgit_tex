"""Create a PDF and store it in the file provided as command line argument."""
from sys import argv

from fpdf import FPDF

pdf = FPDF()     # Create an instance of an FPDF class.
pdf.add_page()   # Add a page.

for i in range(1000):  # Draw 1000 almost-random ellipses
    pdf.set_fill_color((i * 4919) % 255, (i * 3527) % 255,
                       (i * 6329) % 255)
    pdf.ellipse((i * 3677) % 130, (i * 5003) % 170,
                (i * 4391) % 130, (i * 9049) % 170, "F")

# Write some text.
pdf.set_font("helvetica", style="B", size=60)  # Set the font.
pdf.set_text_color(255, 255, 255)  # Set text color to white.
pdf.cell(200, 10, text="Hello World!", align="C")

# Here is the important part! argv[1] is our \gitArg result!
pdf.output(argv[1])     # Save the PDF to the specified file.
