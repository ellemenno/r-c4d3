
using Ayende; // ini read/write util

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;


namespace R_C4D3
{

    public partial class R_C4D3 : Form
    {
        private string iniFolder = "R_C4D3";
        private string iniFile = "menu.ini";
        private string menupath;
        private bool fullscreen;

        public R_C4D3( ) {

            msg("initializing component...");
            try { InitializeComponent(); }
            catch (Exception e) { msg(e.ToString()); }

            msg("reading ini...");
            ReadIni(); // determines window mode and menu path

            msg("setting screen mode...");
            if (fullscreen) { SetFullScreenMode(); }
            else { SetDebugMode(); }

            msg("loading menu...");
            try { LoadMenu(); }
            catch (Exception e) { msg(e.ToString()); }
        }


        public void ReadIni() {
            string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            string iniFolderPath = Path.GetFullPath(Path.Combine(localAppData, ".\\" + iniFolder));
            string iniFilePath = Path.GetFullPath(Path.Combine(localAppData, ".\\" + iniFolder + "\\" + iniFile));
            msg(">> R_C4D3 ini folder: " + iniFolderPath);
            msg(">> R_C4D3 ini file: " + iniFilePath);

            string fullScreenValue = "true"; // default
            string appURI = System.IO.Path.GetDirectoryName(
               System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase
            );
            menupath = appURI + "\\menu\\menu.html";
            fullscreen = false;

            FileInfo ini = new FileInfo(iniFilePath);
            if (!ini.Exists) {
                msg(">> no ini found. creating new with defaults");
                Ayende.Configuration conf = new Ayende.Configuration();
                conf.AddKey("Window");
                conf.SetValue("Window", "FullScreen", fullScreenValue);
                conf.AddKey("Menu");
                conf.SetValue("Menu", "Path", menupath);
                WriteIni(conf, iniFolderPath, iniFilePath);
            }
            else {
                msg(">> ini found, reading in...");
                bool updateNeeded = false;
                System.IO.StreamReader sr = new System.IO.StreamReader(iniFilePath);
                Ayende.Configuration conf = new Ayende.Configuration(sr);
                sr.Close();

                if (conf.KeyExists("Window") && conf.ValueExists("Window", "FullScreen")) {
                    fullScreenValue = conf.GetValue("Window", "FullScreen");
                }
                else {
                    msg(">>   ini missing Window:FullScreen parameter; inserting default");
                    updateNeeded = true;
                    conf.AddKey("Window");
                    conf.SetValue("Window", "FullScreen", fullScreenValue);
                }

                if (conf.KeyExists("Menu") && conf.ValueExists("Menu", "Path")) {
                    menupath = conf.GetValue("Menu", "Path");
                }
                else {
                    msg(">>   ini missing Menu:Path parameter; inserting default");
                    updateNeeded = true;
                    conf.AddKey("Menu");
                    conf.SetValue("Menu", "Path", menupath);
                }

                if (updateNeeded) { WriteIni(conf, iniFolderPath, iniFilePath); }
            }

            msg(">>   FullScreen = " + fullScreenValue);
            msg(">>   Path = " + menupath);
            fullscreen = (fullScreenValue == "true");
        }


        private void WriteIni(Ayende.Configuration conf, string iniFolderPath, string iniFilePath) {
            DirectoryInfo dir = new DirectoryInfo(iniFolderPath);
            if (!dir.Exists) { dir.Create(); }

            bool appendMode = false; // i.e. overwrite
            System.IO.StreamWriter sw = new System.IO.StreamWriter(iniFilePath, appendMode);
            sw.WriteLine(";  ___   ___ _ _  ___ ____");
            sw.WriteLine("; | _ \\ / __| | ||   \\__ /");
            sw.WriteLine("; |   /| (__|_  _| |)  |_\\");
            sw.WriteLine("; |_|_(_)___| |_||___/___/");
            sw.WriteLine("; " + iniFile);
            sw.WriteLine(";");
            sw.WriteLine("; -- -- -- ------ -- -- --");
            sw.WriteLine(";   to restore defaults,");
            sw.WriteLine(";   just delete this file");
            sw.WriteLine(";   and relaunch R_C4D3");
            sw.WriteLine("; -- -- -- ------ -- -- --");
            sw.WriteLine(";");
            conf.Save(sw);
            sw.Close();
        }


        private void SetDebugMode( ) {
            // debug mode is windowed (not fullscreen)
            msg(">> running in windowed mode");
            this.WindowState = System.Windows.Forms.FormWindowState.Normal;
            this.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultLocation;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
        }


        private void SetFullScreenMode( ) {
            // normal mode is fullscreen
            msg(">> running in fullscreen mode");
            System.Windows.Forms.Cursor.Hide();
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
        }


        private void LoadMenu() {
            msg(">> loading menu into web control: " +menupath);
            this.webbie.Url = new System.Uri(menupath, System.UriKind.Absolute);
        }


        static public void msg(string s) {
            System.Diagnostics.StackTrace st = new System.Diagnostics.StackTrace(false);
            string caller = st.GetFrame(1).GetMethod().Name;
            System.Diagnostics.Debug.WriteLine("R_C4D3." +caller +"() - " + s);
        }
    }
}