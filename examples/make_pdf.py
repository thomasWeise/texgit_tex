"""Create a PDF and store it in the file provided as command line argument."""
from fpdf import FPDF
from sys import argv

pdf = FPDF()                    # Create an instance of an FPDF class.
pdf.add_page()                  # Add a page.
pdf.set_font("Arial", size=12)  # Set the font.
pdf.cell(200, 10, txt="Hello World!", align='C')
pdf.output(argv[1])     # Save the PDF to the specified file.
