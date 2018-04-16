using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Image_Processing
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            trackBar1.Enabled = false;
        }

        public int[] red;
        public int[] blue;
        public int[] green;
        public byte[] bred;
        public byte[] bblue;
        public byte[] bgreen;
        public Bitmap img,tempbitmap;
        int size;
        int val=0;
        int colNum,rowNum; //Number of Columns, Number of Rows
        [DllImport("Project.dll")]
        private static extern int Brightness([In, Out]int[] R, [In, Out]int[] G, [In, Out]int[] B, int size, int val);
        [DllImport("Project.dll")]
        private static extern int GreyScale([In, Out]int[] R, [In, Out]int[] G, [In, Out]int[] B, int size);
        [DllImport("Project.dll")]
        private static extern int NoiseRemoval([In, Out]byte[] R, int size , int c , int r,int windsize);

        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "Images (*.BMP;*.JPG;*.GIF,*.PNG,*.TIFF)|*.BMP;*.JPG;*.GIF;*.PNG;*.TIFF|" + "All files (*.*)|*.*";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                pictureBox1.Load(openFileDialog1.FileName);
                img = new Bitmap(pictureBox1.Image,pictureBox1.Width,pictureBox1.Height);
                tempbitmap = new Bitmap(openFileDialog1.FileName);
                rowNum = tempbitmap.Height;
                colNum = tempbitmap.Width;
                size = tempbitmap.Width * tempbitmap.Height;
                red = new int[size];
                blue = new int[size];
                green = new int[size];
                bred = new byte[size];
                bblue = new byte[size];
                bgreen = new byte[size];
                int index = 0;
                Color col;
                for (int i = 0; i < tempbitmap.Height; i++)
                {
                    for (int j = 0; j < tempbitmap.Width; j++)
                    {
                        col = tempbitmap.GetPixel(j, i);
                        red[index] = col.R;
                        blue[index] = col.B;
                        green[index] = col.G;
                        bred[index] = col.R;
                        bblue[index] = col.B;
                        bgreen[index++] = col.G;
                    }
                }
               
                
                trackBar1.Enabled = true;
            }

        }
        private void trackBar1_Scroll(object sender, EventArgs e)
        {
            trackBar1.Enabled = false;
            trackBar1.UseWaitCursor = true;
            int vall = trackBar1.Value;
            if (val >= vall)
                vall = trackBar1.TickFrequency * -1;
            else
                vall = trackBar1.TickFrequency;
            Brightness(red, green, blue, size, vall);
            
            int index = 0;
            Color col;
            for(int i=0;i< tempbitmap.Height;i++)
            {
                for(int j=0;j< tempbitmap.Width;j++)
                {
                    col = Color.FromArgb(red[index], green[index], blue[index++]);
                    tempbitmap.SetPixel(j, i, col);
                }
            }
            pictureBox1.Image = tempbitmap;
            val = trackBar1.Value;
            trackBar1.UseWaitCursor = false;
            trackBar1.Enabled = true;
        }
        
        private void button2_Click(object sender, EventArgs e)
        {
            Color col;
            int index = 0;
            GreyScale(red, green, blue, size);
            for (int i = 0; i < tempbitmap.Height; i++)
            {
                for (int j = 0; j < tempbitmap.Width; j++)
                {
                    col = Color.FromArgb(red[index], green[index], blue[index++]);
                    tempbitmap.SetPixel(j, i, col);
                }
            }

            pictureBox1.Image = tempbitmap;

            pictureBox1.Refresh();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Color col;
            int index = 0;
            if (Convert.ToInt32(textBox1.Text) % 2 != 1 && Convert.ToInt32(textBox1.Text)!=1)
                MessageBox.Show("Please Enter Odd Number bigger than 1");
            int winsize = Convert.ToInt32(textBox1.Text);
            NoiseRemoval(bred, size, rowNum, colNum,winsize);
            NoiseRemoval(bgreen, size, rowNum, colNum,winsize);
            NoiseRemoval(bblue, size, rowNum, colNum,winsize);

            for (int i = 0; i < tempbitmap.Height; i++)
            {
                for (int j = 0; j < tempbitmap.Width; j++)
                {
                 
                    col = Color.FromArgb(bred[index], bgreen[index], bblue[index++]);
                    tempbitmap.SetPixel(j, i, col);
                }
            }

            pictureBox1.Image = tempbitmap;

            pictureBox1.Refresh();
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }
    }
}
