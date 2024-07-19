#include <iostream>
#include <unistd.h>
#include <stdio.h>
#include <qthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <inttypes.h>
#include "sp12_qtw.h"
#include "ui_sp12_qtw.h"
#include "sp12_macros.h"

using namespace std;

int device_d;
int devices_d[13];

char key;
bool terminating = false;
int first_time;
int thread_runs = false;
bool init_done = false;
int loopback_code;
bool prbs_counter_reset, prbs_force_error;
uint64_t prbs_type;
string fname, fname_control, mpc_data_fn;
bool gth_reset, clink_reset, mpc_enable, spy_addr_reset, ptlut_clk_reset, sync_clk_reset, rx_buffers_reset, daq_reset, ptlut_clk_kill, force_oos;
bool orbit_ev_bx, gem_logic;
int gtx_rate;
int module_index;
int mpc_test_index, iterations, ptlut_rx_clk_delay_val;
bool do_control = false;
string lb_target;
int endcap_lut[13], sector_lut[13];
uint64_t fib_en_mask[13];
bool lb_stress = false;

extern sp12_qtw *f;

extern "C" void log_printf(const char *pszFormat, ...);
int flash_main(string s1, string s2, string s3, bool do_control);
int loopback_main(int th_dev, string dest, int iterations);
int prbs_enable_main(string command, int loopback_code, int type, bool force);
int prbs_errors_main(string command);
int prbs_mpc_enable(int prbs_type);
int resets_main(bool gth_reset, bool clink_reset, bool mpc_enable, bool spy_addr_reset,
                bool ptlut_clk_reset, bool sync_clk_reset, bool rx_buffers_reset, bool daq_reset,
                bool ptlut_clk_kill, bool force_oos, bool orbit_ev_bx, bool gem_logic,
				int endcap[13], int sector[13]);

//int gtx_bitrate(string command, uint64_t rate);
int fill_buffer_mem(int module_index);
int read_buffer_mem(int module_index);
int test_core_link(int module_index);
int write_rldram(int th_dev);
int read_rldram(bool print_err);
int test_rldram(int iterations);
int init_rldram(int fd, bool training);
int mpc_test(int mpc_test_index, int iterations);
int mpc_test_sp04(int mpc_test_index, int iterations);
int mpc_idle();
int mpc_prep();
int SP04_prbs_check();
int reset_core_link();
int write_core_link();
int core_link_phase_inc(int target);
void write_verify_pc_luts(bool verify, int endcap[13], int sector[13], bool ge11_prim);
int core_logic_test();
//int read_mpc_spy_mem();
uint64_t read_link_ids(int endcap, int sector);
int daq_mpc_data_into_file(string mpc_data_fn, int iterations, bool only_read);
int rldram_detect_read_delays();
int rldram_detect_write_delays();
int rldram_detect_window();
int read_rldram_random_addr(int iterations);
int ttc_command(int code);
int random_trigger(int code, bool enable);
int ttc_config();
//int af_monitor(int iterations);
int af_write_delays(int endcap, int sector);
int af_read_delays(int endcap, int sector, int iterations);
int read_ptlut_file();
void free_ptlut_buffers();
void cosmics_rate_monitor();
void hmt_rate_monitor();

bool ptlut_training = false;
bool prim_conv_lut_verify = false;
bool ge11_prim = false;

extern char best_rd_delay[4][18];

class lb_thread_c : public QThread
{
public:
    int th_dev; // file descriptor for device
    string command; // which loopback to run
    int iterations; // how many iterations
    int num; // thread's number
  lb_thread_c()
  {
	th_dev = -1;
  }
  protected:
    void run()
    {
        log_printf("creating loopback thread %d\n", num);
        loopback_main(th_dev, command, iterations);
        log_printf("ending loopback thread %d\n", num);
    }
};

class ptlut_wr_thread_c : public QThread
{
public:
    int th_dev; // file descriptor for device
    int iterations; // how many iterations
    int num; // thread's number
  ptlut_wr_thread_c()
  {
	th_dev = -1;
  }
  protected:

    void run()
    {
        log_printf("creating PT LUT write thread %d\n", num);

		write_rldram(th_dev);
        
        log_printf("ending PT LUT write thread %d\n", num);
    }
};

class sp12_thread_c : public QThread
{
protected:
    void run()
    {
        log_printf("thread starts\n");

        key = ' '; // reset command
        first_time = 1; // reset first time flag
        while (true)
        {
            usleep (10000);
            switch (key)
            {
            case 'E':
                // erase flash
                flash_main("erase", fname, fname_control, do_control); // need to know how many blocks to erase
                break;

            case 'W':
                // write flash
                flash_main("write", fname, fname_control, do_control);
                break;

            case 'V':
                // verify flash
			  for (int ic = 0; ic < iterations; ic ++)
				{
				  if (terminating)
					{
					  terminating = false;
					  break;
					}
				  flash_main("verify", fname, fname_control, do_control);
				}
                break;

            case 'C':
                // configure FPGAs
                flash_main("reboot", "", "", do_control);
                break;

            case 'r':
                // reset config state machine
                flash_main("reset", "", "", do_control);
                break;

            case 'u':
                flash_main("status", "", "", false);
                break;

            case 'L':
                // run loopback test with fast memory array
                loopback_main(device_d, "memory", iterations);
                break;

            case 'P':
                // run loopback test with core link
                loopback_main(device_d, lb_target, iterations);
                break;

            case 'x':
                // enable prbs for GTX

                prbs_enable_main("gtx", loopback_code, prbs_type, prbs_force_error);
                break;


            case 'e':
                // check GTH prbs error flags
                prbs_errors_main("gth");
                break;

            case 'c':
                // check GTX prbs error counters
                prbs_errors_main("gtx");
                break;

            case 'B':
                // check GTX prbs error bits
                prbs_errors_main("gtx_bits");
                break;

            case 'R':
                // send resets
                resets_main(gth_reset, clink_reset, mpc_enable, spy_addr_reset,
                            ptlut_clk_reset, sync_clk_reset, rx_buffers_reset, daq_reset,
                            ptlut_clk_kill, force_oos, orbit_ev_bx, gem_logic,
							endcap_lut, sector_lut);
                break;
	       
            case 'w':
                for (int di = 0; di < 13; di++)
                {
                    if (devices_d[di] >= 0)
                    {
                        log_printf ("device index: %d\n", di);
			write_rldram(devices_d[di]);
                    }
                }
                break;
		
            case 'D':
                read_rldram(true);
                break;

            case 'm':
                test_rldram(iterations);
                break;

            case 'I':
                for (int di = 0; di < 13; di++)
                {
                    if (devices_d[di] >= 0)
                    {
                        log_printf ("device index: %d\n", di);
                        device_d = devices_d[di];
                        init_rldram(devices_d[di], ptlut_training);
                    }
                }
                break;

                //            case 'T':
                //                reset_core_link();
                //                break;

                //            case 'i':
                //                write_core_link();
                //                break;

            case 'h':
                core_link_phase_inc(0);
                break;

            case 'H':
                core_link_phase_inc(1);
                break;

            case 'o':
                write_verify_pc_luts(prim_conv_lut_verify, endcap_lut, sector_lut, ge11_prim);
                break;

            case 'k':
                core_logic_test();
                break;

                //            case 'U':
                //                read_mpc_spy_mem();
                //                break;

            case 'd':
                mpc_idle();
                break;

            case 'a':
                mpc_prep();
                break;


            case 'M':
                prbs_mpc_enable(prbs_type);
                break;

            case 'F':
                mpc_test (mpc_test_index, iterations);
                break;

                //            case 'n':
                //                read_link_ids();
                //                break;

            case 's':
                daq_mpc_data_into_file(mpc_data_fn, iterations, true);
                break;

            case 't':
                for (int di = 0; di < 13; di++)
                {
                    if (devices_d[di] >= 0)
                    {
                        log_printf ("device index: %d\n", di);
                        device_d = devices_d[di];
                        rldram_detect_read_delays();

			// store detected delays in file
			char rdelfname[20];
			sprintf(rdelfname, "rdel%02d.txt", di);
			FILE *rdelf = fopen (rdelfname, "w");
			for (int i = 0; i < 4; i++) // quad loop
			  {
			    for (int j = 0; j < 18; j++) // bit loop
			      {
				fprintf (rdelf, "%02d ", best_rd_delay[i][j]);
			      }
			    fprintf (rdelf, "\n");
			  }
			
			fclose (rdelf);
                    }
                }

                break;

            case 'y':
                for (int di = 0; di < 13; di++)
                {
                    if (devices_d[di] >= 0)
                    {
                        log_printf ("device index: %d\n", di);
                        device_d = devices_d[di];
                        rldram_detect_write_delays();

			// store detected delays in file
			char wdelfname[20];
			sprintf(wdelfname, "wdel%02d.txt", di);
			FILE *wdelf = fopen (wdelfname, "w");
			for (int i = 0; i < 4; i++) // quad loop
			  {
			    for (int j = 0; j < 18; j++) // bit loop
			      {
				fprintf (wdelf, "%02d ", best_rd_delay[i][j]);
			      }
			    fprintf (wdelf, "\n");
			  }
			
			fclose (wdelf);
                    }
                }
                break;

            case 'O':
                rldram_detect_window();
                break;

            case 'j':
                for (int di = 0; di < 13; di++)
                {
                    if (devices_d[di] >= 0)
                    {
                        log_printf ("device index: %d\n", di);
                        device_d = devices_d[di];
                        read_rldram_random_addr(iterations);
                    }
                }
                break;

            case 'A':
                //af_monitor(iterations);
                for (int id = 0; id < 13; id++)
                {
                    if (devices_d[id] >= 0)
                    {
                        device_d = devices_d[id];
                        log_printf ("device index: %d\n", id);
                        af_read_delays(endcap_lut[id], sector_lut[id], iterations);
                    }
                }
                break;
/*
            case 'S':
                mpc_test_sp04(mpc_test_index, iterations);
                break;


            case '4':
                SP04_prbs_check();
                break;
*/

            case '3':
                cosmics_rate_monitor();
                break;
            case '5':
                hmt_rate_monitor();
                break;
            }
            if (key == 'Q') break;
            key = ' ';
        }

        log_printf("thread quits\n");
    }
};

sp12_thread_c sp12_thread;
lb_thread_c lb_thread[100];
ptlut_wr_thread_c ptlut_wr_thread[100];
int lb_thread_cnt = 0;
int ptlut_wr_thread_cnt = 0;

sp12_qtw::sp12_qtw(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::sp12_qtw)
{
    ui->setupUi(this);
    ui->Progress->setValue(0);

    ui->reset_list->addItem("PCIe JTAG");
    ui->reset_list->addItem("Core lnk");
    ui->reset_list->addItem("PTLUT clk");
    ui->reset_list->addItem("Sync clk");
    ui->reset_list->addItem("RX bufrs");
    ui->reset_list->addItem("DAQ");
    ui->reset_list->addItem("Spy addr");
    ui->reset_list->addItem("PTclk kill");
    ui->reset_list->addItem("Force OOS");
    ui->reset_list->addItem("OrbEvBx");
    ui->reset_list->addItem("GEM logic");

    ui->reset_list->setCurrentRow(1);

    ui->mpc_test_list->addItem("All 0");
    ui->mpc_test_list->addItem("All 1");
    ui->mpc_test_list->addItem("LFC");
    ui->mpc_test_list->addItem("Random");
    ui->mpc_test_list->setCurrentRow(3);

    ui->trigger_src->addItem("L1A");
    ui->trigger_src->addItem("MPC data");
    ui->trigger_src->addItem("Rank");
    ui->trigger_src->addItem("LinkErr");
//    ui->trigger_src->setCurrentRow(0);

    ui->device_list->addItem("+1:0");
    ui->device_list->addItem("+6:1");
    ui->device_list->addItem("+3:2");
    ui->device_list->addItem("+4:3");
    ui->device_list->addItem("+2:4");
    ui->device_list->addItem("+5:5");
    ui->device_list->addItem("-1:6");
    ui->device_list->addItem("-6:7");
    ui->device_list->addItem("-3:8");
    ui->device_list->addItem("-4:9");
    ui->device_list->addItem("-2:10");
    ui->device_list->addItem("-5:11");
    //    ui->device_list->addItem("MS:12");

    ui->l1a_rate_list->addItem("1");
    ui->l1a_rate_list->addItem("100");
    ui->l1a_rate_list->addItem("1k");
    ui->l1a_rate_list->addItem("5k");
    ui->l1a_rate_list->addItem("10k");
    ui->l1a_rate_list->addItem("25k");
    ui->l1a_rate_list->addItem("50k");
    ui->l1a_rate_list->addItem("100k");

    ui->bc0_source_tbl->setColumnCount(69);
    ui->bc0_source_tbl->setRowCount(6);
    ui->bc0_source_tbl->horizontalHeader()->setDefaultSectionSize(22);
    ui->bc0_source_tbl->verticalHeader()->setDefaultSectionSize(20);
      // set the resize mode to fixed, so the user cannot change the height/width
    //ui->bc0_source_tbl->horizontalHeader()->setResizeMode(QHeaderView::Fixed);
    ui->bc0_source_tbl->verticalHeader()->setResizeMode(QHeaderView::Fixed);

	// set default values for delays that are currently optimal
	ui->bc0_delay_spin->setValue(117);
	ui->gmt_link_comma_delay_spin->setValue(31);
	ui->single_delay_sb->setValue(7);
	ui->gem_delay_sb->setValue(110);

    QTableWidgetItem *checkBoxItem[4][68];
    QTableWidgetItem *st_item[68], *ch_item[68];
    char stn[6][10] = {"1A", "1B", "2", "3", "4", "N"}; // station names
    char ln[100];

    // row headers
    ui->bc0_source_tbl->setItem(0, 0, new QTableWidgetItem("Station"));
    ui->bc0_source_tbl->setItem(1, 0, new QTableWidgetItem("CSCID"));
    ui->bc0_source_tbl->setItem(2, 0, new QTableWidgetItem("Cham 1"));
    ui->bc0_source_tbl->setItem(3, 0, new QTableWidgetItem("Mispl"));
    ui->bc0_source_tbl->setItem(4, 0, new QTableWidgetItem("RX rst"));
    ui->bc0_source_tbl->setItem(5, 0, new QTableWidgetItem("Fib en"));

    // column headers
    for (int j = 0; j < 54; j++)
    {
        sprintf (ln, "%s", stn[5-j/9]);
        st_item[j] = new QTableWidgetItem(ln); // create station text item
        ui->bc0_source_tbl->setItem(0, j+1, st_item[j]); // put into table cell
        sprintf (ln, "%d", 9-(j%9));
        ch_item[j] = new QTableWidgetItem(ln); // create chamber text item
        ui->bc0_source_tbl->setItem(1, j+1, ch_item[j]); // put into table cell
    }
    for (int j = 54; j < 61; j++)
    {
        st_item[j] = new QTableWidgetItem("RP"); // create station text item
        ui->bc0_source_tbl->setItem(0, j+1, st_item[j]); // put into table cell
        sprintf (ln, "%d", 60-j);
        ch_item[j] = new QTableWidgetItem(ln); // create chamber text item
        ui->bc0_source_tbl->setItem(1, j+1, ch_item[j]); // put into table cell
    }
    for (int j = 61; j < 68; j++)
    {
        st_item[j] = new QTableWidgetItem("G1"); // create station text item
        ui->bc0_source_tbl->setItem(0, j+1, st_item[j]); // put into table cell
        sprintf (ln, "%d", 67-j);
        ch_item[j] = new QTableWidgetItem(ln); // create chamber text item
        ui->bc0_source_tbl->setItem(1, j+1, ch_item[j]); // put into table cell
    }
    // adding checkboxes
    for (int i = 0; i < 4; i++) // row loop
    {
        for (int j = 0; j < 68; j++) // was 54
        {
            if ((i == 2 || i == 3) && j % 9 == 8 && j != 8 && j < 54)
            {}
            else
//            if (i != 2 || j % 9 != 8 || j == 8) // don't make reset checkboxes for non-link chambers
            {
                checkBoxItem[i][j] = new QTableWidgetItem(); // create check box item
                checkBoxItem[i][j]->setCheckState(Qt::Unchecked); // make it unchecked
                ui->bc0_source_tbl->setItem(i+2, j+1, checkBoxItem[i][j]); // put into table cell
            }
        }
    }
    // start thread
    sp12_thread.start();

}

sp12_qtw::~sp12_qtw()
{
    key = 'Q'; // quit command for thread

    usleep(10000);

    if (::close(device_d) < 0 )
    {
        log_printf("ERROR: problem closing device file\n");
    }
    delete ui;
}



class LogEvent : public QEvent
{
public:
    LogEvent( const QString& message, const int destination)
        : QEvent( QEvent::User ),
          m_message(message),
          m_destination (destination)
    {};

    QString m_message;
    int m_destination; // 0 = log, 1 = progress bar
};

bool sp12_qtw::event( QEvent *e )
{
    if ( e->type() == QEvent::User )
    {
        switch (((LogEvent*)e)->m_destination)
        {
        case 0: // user appends log
//            ui->log->setPlainText((ui->log->toPlainText()) + (((LogEvent*)e)->m_message));
//            ui->log->moveCursor (QTextCursor::End) ;
//            ui->log->ensureCursorVisible() ;
            break;

        case 1: // progress bar
            bool ok;
            int prog = ((LogEvent*)e)->m_message.toInt(&ok, 10);
            if (ok) ui->Progress->setValue(prog);
            break;
        }
        return true;
    }

    return QWidget::event( e );
}



extern "C" void log_printf(const char *pszFormat, ...)
{
    static char szErrBuf[2000];
    va_list argList;
    va_start(argList, pszFormat);
    vsnprintf(szErrBuf, sizeof(szErrBuf)-10, pszFormat, argList);
    szErrBuf[sizeof(szErrBuf)-10] = '\0';
    printf (szErrBuf);
    //    qApp->postEvent( f, new LogEvent(szErrBuf, 0) );
}

extern "C" void set_progress(int pcent)
{
    static char line[10];
    sprintf (line, "%d", pcent);
    qApp->postEvent( f, new LogEvent(line, 1) );
}



void sp12_qtw::on_configure_button_released()
{
    if (ui->control_rb->isChecked()) do_control = true;
    else do_control = false;
    key = 'C';
}

void sp12_qtw::on_erase_button_released()
{
    fname    = ui->flash_fname->toPlainText().toStdString();
    fname_control = ui->flash_fname_control->toPlainText().toStdString();
    if (ui->control_rb->isChecked()) do_control = true;
    else do_control = false;

    key = 'E';
}

void sp12_qtw::on_write_button_released()
{
    fname = ui->flash_fname->toPlainText().toStdString();
    fname_control = ui->flash_fname_control->toPlainText().toStdString();
    if (ui->control_rb->isChecked()) do_control = true;
    else do_control = false;
    key = 'W';
}

void sp12_qtw::on_verify_button_released()
{
    iterations = ui->iterations_spin->value();
    fname = ui->flash_fname->toPlainText().toStdString();
    fname_control = ui->flash_fname_control->toPlainText().toStdString();
    if (ui->control_rb->isChecked()) do_control = true;
    else do_control = false;
    key = 'V';
}

pthread_t lb_pthread[100];

void* loopback_main_pthread(void* ptr)
{
    loopback_main(*((int*)ptr), "memory", iterations);
    return NULL;
}

void sp12_qtw::on_loopback_button_released()
{
    iterations = ui->iterations_spin->value();
    lb_stress = ui->lb_stress_cb->isChecked();
    //key = 'L';
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
	     lb_thread[lb_thread_cnt].th_dev = device_d;
	     lb_thread[lb_thread_cnt].command = "memory";
	     lb_thread[lb_thread_cnt].iterations = iterations;
	     lb_thread[lb_thread_cnt].num = lb_thread_cnt;
	     lb_thread[lb_thread_cnt].start();
	     lb_thread_cnt++;
	    /*
            int pid = fork();
             if (pid == 0) // child
             {
                 loopback_main(device_d, "memory", iterations);
                 _exit(EXIT_SUCCESS);
		 }*/
        }
    }

}


void sp12_qtw::on_send_reset_button_released()
{
    QModelIndexList indexes = ui->reset_list->selectionModel()->selectedIndexes();

    gth_reset = false;
    clink_reset = false;
    mpc_enable = false;
    spy_addr_reset = false;
    ptlut_clk_reset = false;
    sync_clk_reset = false;
    rx_buffers_reset = false;
    daq_reset = false;
    ptlut_clk_kill = false;
    force_oos = false;
	orbit_ev_bx = false;
	gem_logic = false;

    foreach(QModelIndex index, indexes)
    {
        switch(index.row())
        {
        case 0:  gth_reset = true; break;
        case 1:  clink_reset = true; break;
        case 2:  ptlut_clk_reset = true; break;
        case 3:  sync_clk_reset = true; break;
        case 4:  rx_buffers_reset = true; break;
        case 5:  daq_reset = true; break;
        case 6:  spy_addr_reset = true; break;
        case 7:  ptlut_clk_kill = true; break;
        case 8:  force_oos = true; break;
        case 9:  orbit_ev_bx = true; break;
        case 10: gem_logic = true; break;
        }
    }

    key = 'R';
}


void sp12_qtw::on_configure_reset_released()
{
    if (ui->control_rb->isChecked()) do_control = true;
    else do_control = false;
    key = 'r';
}

void sp12_qtw::on_configure_status_released()
{
    key = 'u';
}

void sp12_qtw::on_write_rldram_button_released()
{
  
  // reserve buffer, fill with data first
  if (read_ptlut_file() == 1)
    {

      ptlut_wr_thread_cnt = 0;
      for (int id = 0; id < 13; id++)
		{
		  if (devices_d[id] >= 0)
			{
			  device_d = devices_d[id];
			  log_printf ("device index: %d, fd: %d\n", id, device_d);
//			  ptlut_wr_thread[ptlut_wr_thread_cnt].th_dev = device_d;
//			  ptlut_wr_thread[ptlut_wr_thread_cnt].iterations = iterations;
//			  ptlut_wr_thread[ptlut_wr_thread_cnt].num = ptlut_wr_thread_cnt;
//			  ptlut_wr_thread[ptlut_wr_thread_cnt].start();
//			  ptlut_wr_thread_cnt++;
              int pid = fork();
              if (pid == 0) // child
              {
                  write_rldram(device_d);
                  _exit(EXIT_SUCCESS);
              }
            }
		}
	  // wait until all threads exit
//	  bool threads_done;
//	  do
//        {
//		  threads_done = true;
//		  for (int i = 0; i < ptlut_wr_thread_cnt; i++)
//            {
//			  if (!ptlut_wr_thread[i].isFinished()) threads_done = false;
//            }
//		  usleep (100000);
//        } while (!threads_done);
//	  log_printf ("flash: all PT LUT write threads exited\n");
    }

  free_ptlut_buffers();

  //  key = 'w';
}

void sp12_qtw::on_terminate_button_released()
{
    terminating = true;
}

void sp12_qtw::on_read_rldram_button_released()
{
    //key = 'D';
    log_printf ("Currently not working\n");
}

void sp12_qtw::on_test_rldram_button_released()
{
    iterations = ui->iterations_spin->value();
    key = 'm';
}

void sp12_qtw::on_reset_rldram_button_released()
{
    ptlut_training = ui->training_cb->isChecked();
    key = 'I';
}

void sp12_qtw::on_mcp_format_button_released()
{
    mpc_test_index = ui->mpc_test_list->currentRow();
    iterations = ui->iterations_spin->value();
    key = 'F';
}

void sp12_qtw::on_mpc_status_button_released()
{
    mpc_test_index = ui->mpc_test_list->currentRow();
    iterations = ui->iterations_spin->value();
    key = 'S';
}

void sp12_qtw::on_send_idle_button_released()
{
    key = 'd';
}

void sp12_qtw::on_prep_mpc_button_released()
{
    key = 'a';
}


void sp12_qtw::on_write_cl_b_released()
{
    key = 'i';
}

void sp12_qtw::on_core_link_loopback_pb_released()
{
    lb_target = "inject_64";
    iterations = ui->iterations_spin->value();
    lb_stress = ui->lb_stress_cb->isChecked();
//    key = 'P';
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
//            lb_thread[lb_thread_cnt].th_dev = device_d;
//            lb_thread[lb_thread_cnt].command = lb_target;
//            lb_thread[lb_thread_cnt].iterations = iterations;
//            lb_thread[lb_thread_cnt].num = lb_thread_cnt;
//            lb_thread[lb_thread_cnt].start();
//            lb_thread_cnt++;

            int pid = fork();
            if (pid == 0) // child
            {
                loopback_main(device_d, lb_target, iterations);
                _exit(EXIT_SUCCESS);
            }

        }
    }
}

void sp12_qtw::on_core_link_loopback_32_pb_released()
{
    lb_target = "inject_32";
    iterations = ui->iterations_spin->value();
    lb_stress = ui->lb_stress_cb->isChecked();
//    key = 'P';
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
//            lb_thread[lb_thread_cnt].th_dev = device_d;
//            lb_thread[lb_thread_cnt].command = lb_target;
//            lb_thread[lb_thread_cnt].iterations = iterations;
//            lb_thread[lb_thread_cnt].num = lb_thread_cnt;
//            lb_thread[lb_thread_cnt].start();
//            lb_thread_cnt++;
            int pid = fork();
            if (pid == 0) // child
            {
                loopback_main(device_d, lb_target, iterations);
                _exit(EXIT_SUCCESS);
            }
        }
    }
}

void sp12_qtw::on_core_phase_inc_pb_released()
{
    key = 'h';
}

void sp12_qtw::on_control_phase_inc_pb_released()
{
    key = 'H';
}


void sp12_qtw::on_prim_conv_lut_write_pb_released()
{
    prim_conv_lut_verify = false;
    ge11_prim = false;
    key = 'o';
}

void sp12_qtw::on_core_logic_test_pb_released()
{
    key = 'k';
}

void sp12_qtw::on_pushButton_released()
{
    lb_target = "mpc_spy";
    iterations = ui->iterations_spin->value();
    lb_stress = ui->lb_stress_cb->isChecked();
    key = 'P';

}

void sp12_qtw::on_pushButton_2_released()
{
    key = 'U';
}

void sp12_qtw::on_bc0_button_released()
{
    ttc_command (3); // event counter reset
}

void sp12_qtw::on_l1reset_button_released()
{
    ttc_command (8); // orbit counter reset
}

void sp12_qtw::on_resync_pb_released()
{
    ttc_command (4); // resync
}

void sp12_qtw::on_read_link_ids_button_released()
{
    //    key = 'n';
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
            fib_en_mask[id] = read_link_ids (endcap_lut[id], sector_lut[id]);
        }
    }
}


void sp12_qtw::on_mpc_data_to_file_pb_released()
{
    mpc_data_fn = ui->mpc_data_fn->toPlainText().toStdString();
    iterations = ui->iterations_spin->value();
    terminating = false;
    key = 's';
}

void sp12_qtw::on_set_delays_pb_released()
{
    uint64_t bc0_delay =(int) ui->bc0_delay_spin->text().toInt(0, 10);
    int daq_delay = ui->daq_delay_spin->text().toInt(0, 10);
    uint64_t gmt_delay = ui->gmt_link_comma_delay_spin->text().toInt(0, 10);
    int single_delay = ui->single_delay_sb->text().toInt(0,10);
    bool single_en = ui->single_en_cb->isChecked();
    int gem_delay = ui->gem_delay_sb->text().toInt(0,10);


    log_printf("setting delays: BC0: %d, DAQ: %d GMT: %d GEM: %d\n", (int)bc0_delay, daq_delay, (int) gmt_delay, (int) gem_delay);

    int trg_src = ui->trigger_src->currentRow(); // read user's trigger source selection
    QList<QListWidgetItem*> selection = ui->trigger_src->selectedItems();
    if (selection.size() == 0) trg_src = -1; // no selection


    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            int fd = devices_d[id];
            log_printf ("device index: %d\n", id);

            uint32_t REG_MEM_BASE = 0x80000; // 0xc0000  bytes

            int ch = REG_BANK_CH; // config register bank
            uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0x11 << 3); // delay register

            uint64_t value = 0;
            mread(fd, &value, 8, saddr);
            log_printf(    "trigger_config readback: %016llx\n", value);


            // just set spy memory trigger source and delay, bc0 delay, gmt_delay, don't touch anything else
            //if (trg_src >= 0)
            {

                value &= ~0x10ULL; // clean bc0_err trigger
                value &= ~0x0ff80ULL; // clean up delay
                value &= ~0x70000ULL; // clean up trigger source
                value &= ~0x7fc00000000ULL; // clean up bc0 delay
                value &= ~0x7ff80000000000ULL; // clean up gmt delay

                if (trg_src >= 0 && trg_src <= 2) value += (1ULL << (16 + trg_src)); // trig source
                if (trg_src == 3) value |= 0x10ULL; // bc0_err trigger
                value += (daq_delay << 7);  // set delays and trigger source (local run works)
                value |= (bc0_delay << 34);
                value |= (gmt_delay << 43);
                log_printf("trigger_config to write: %016llx\n", value);
                mwrite(fd, &value, 8, saddr);

                value = 0;
                mread(fd, &value, 8, saddr);
                log_printf("trigger_config readback: %016llx\n", value);
            }

            // write single trigger delay
            value = 0;
            saddr = REG_MEM_BASE + (ch << 12) + (0x32 << 3); // core_config register
            mread(fd, &value, 8, saddr);
            value &= ~(7ULL << 24);
            value &= ~(1ULL << 12);
            value |= ((single_delay & 7) << 24);
            if (single_en) value |= (1ULL << 12);
            mwrite(fd, &value, 8, saddr);
            log_printf("core_config readback: %016llx\n", value);

//            saddr = REG_MEM_BASE + (ch << 12) + (0x72 << 3); // gem_data_del register - manual delays
//            mread(fd, &value, 8, saddr);
//            log_printf("gem_data_del readback: %016llx\n", value);
//            uint64_t gdd = gem_delay;
//            value = (gdd << 30) |(gdd << 25) | (gdd << 20) | (gdd << 15) | (gdd << 10) | (gdd << 5) | gdd;
//            mwrite(fd, &value, 8, saddr);
//            mread(fd, &value, 8, saddr);
//            log_printf("gem_data_del readback: %016llx\n", value);

            saddr = REG_MEM_BASE + (ch << 12) + (0x76 << 3);
            mread(fd, &value, 8, saddr);
            log_printf("gem bc0 delay readback: %016llx\n", value);
            value = gem_delay & 0x3ff;
            mwrite(fd, &value, 8, saddr);
            mread(fd, &value, 8, saddr);
            log_printf("gem bc0 delay readback: %016llx\n", value);
        }
    }
}

void sp12_qtw::on_reset_rldram_button_clicked()
{

}

void sp12_qtw::on_read_rldram_button_clicked()
{

}

void sp12_qtw::on_lb_pt_button_released()
{
    lb_target = "pt_mem_data";
    iterations = ui->iterations_spin->value();
    lb_stress = ui->lb_stress_cb->isChecked();
    key = 'P';

}


void sp12_qtw::on_iddr_phase_button_released()
{
    uint64_t value;
    uint32_t MEM_BASE_CL = 0x80000;
    uint32_t ch = REG_BANK_CH;
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // control register has address 0
    for (int i = 0; i < 1; i++)
    {
//        value = 0x300; // psen + psinc
//        value = 0x100; // psen
        value = 0xc00; // idelay_ce + idelay_inc
        mwrite(device_d, &value, 8, saddr);
        value = 0; // remove
        mwrite(device_d, &value, 8, saddr);
        usleep(10000);
    }

}

void sp12_qtw::on_detect_delays_button_released()
{
    ptlut_rx_clk_delay_val = ui->ptlut_rx_clk_delay->value();
    key = 't';
}

void sp12_qtw::on_detect_write_delays_pb_released()
{
    ptlut_rx_clk_delay_val = ui->ptlut_rx_clk_delay->value();
    key = 'y';
}

void sp12_qtw::on_pushButton_3_released()
{
    ptlut_rx_clk_delay_val = ui->ptlut_rx_clk_delay->value();
    key = 'O';
}

void sp12_qtw::on_random_addr_test_pb_released()
{
    iterations = ui->iterations_spin->value();
    key = 'j';
}

int sector_ind[] = {1,6,3,4,2,5}; // determined by the order of boards detected by PCIe

void sp12_qtw::on_device_list_clicked(const QModelIndex &index)
{
    int dev_ind;
    char dev_name [100];
    log_printf("passed index: %d\n", index.row());

    QModelIndexList indexes = ui->device_list->selectionModel()->selectedIndexes();

    // close all devices
    for (int i = 0; i < 13; i++)
    {
        ::close(devices_d[i]);
        devices_d[i] = -1;
    }

    int dev_count = 0;

    foreach(QModelIndex index, indexes)
    {
        dev_ind = index.row();
        sprintf (dev_name, "/dev/utca_sp12%d", dev_ind);
        // open device
        device_d = ::open(dev_name,O_RDWR);
        if (device_d < 0)
        {
            log_printf("ERROR: Can not open device file for MTF7: %s\n", dev_name);
        }
        else
        {
            log_printf("opened device: %s\n", dev_name);
            devices_d[dev_ind] = device_d;
        }

        endcap_lut[dev_ind] = (dev_ind / 6) + 1;
        sector_lut[dev_ind] = sector_ind[(dev_ind % 6)];
	dev_count++;
    }

    // read and update the BC0 source register only if one chamber selected

    uint64_t ch1 = 0, mispl = 0;
    uint32_t REG_MEM_BASE = 0x80000; // bytes

    int ch = REG_BANK_CH; // config register bank
    uint32_t ch1_addr = REG_MEM_BASE + (ch << 12) + (0x52 << 3);
    uint32_t mispl_addr = REG_MEM_BASE + (ch << 12) + (0x53 << 3);

    if (dev_count == 1)
      {

	mread(device_d, &ch1, 8, ch1_addr);
	mread(device_d, &mispl, 8, mispl_addr);

	log_printf ("old ch1  : %016llx\n", ch1);
	log_printf ("old mispl: %016llx\n", mispl);


	for (int i = 53; i >=0; i--)
	  {
	    bool ch1_bit = ch1 & 1;
	    ui->bc0_source_tbl->item(2, i+1)->setCheckState((Qt::CheckState)ch1_bit);
	    ch1 >>= 1;
	    
	    bool mispl_bit = mispl & 1;
	    ui->bc0_source_tbl->item(3, i+1)->setCheckState((Qt::CheckState)mispl_bit);
	    mispl >>= 1;
	  }
      }

}

void sp12_qtw::on_prim_conv_lut_verify_pb_released()
{
    prim_conv_lut_verify = true;
    ge11_prim = false;
    key = 'o';

}

void sp12_qtw::on_occup_counters_read_pb_released()
{
    int fd = device_d;
    uint64_t value;
    uint32_t saddr;

    log_printf("reading occupancy counters\n");

    // module addresses
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes

    uint32_t stub_rate[6][9];
    uint32_t track_rate[6];

    memset (stub_rate, 0x1, sizeof(stub_rate));
    memset (track_rate, 0x2, sizeof(track_rate));

    int ch = REG_BANK_CH; // config register bank
    int rcnt = 0;
    for (int i = 0x33; i <= 0x50; i++)
    {
        // form address {chamber[6], sel[2], addr[7], 3'b0}
        saddr = MEM_BASE + (ch << 12) + (i << 3) ;
        mread(fd, &value, 8, saddr);
        //log_printf ("Occupancy #%02x: %016llx\n", i, value);

	int st = rcnt/5; // station index
	int cham = (rcnt%5) * 2; // chamber index in low bits
	stub_rate[st][cham] = value & 0x3ffffffULL;

	if (cham < 8) stub_rate[st][cham+1] = (value >> 32) & 0x3ffffffULL;
	else track_rate[st] = (value >> 32) & 0x3ffffffULL;
	// track rates duplicate, [0]==[3], [1]==[4], [2]==[5]

	rcnt++;
    }
    
    for (int i = 0; i <= 5; i++) // station loop
    {
	log_printf ("st: %d rates: %03d %03d %03d %03d %03d %03d %03d %03d %03d\n",
	//log_printf ("st: %d rates: %03x %03x %03x %03x %03x %03x %03x %03x %03x\n",
			    i, 
			    stub_rate[i][0],
			    stub_rate[i][1],
			    stub_rate[i][2],
			    stub_rate[i][3],
			    stub_rate[i][4],
			    stub_rate[i][5],
			    stub_rate[i][6],
			    stub_rate[i][7],
			    stub_rate[i][8]
		       );
    }
    log_printf ("tracks: %03d %03d %03d %03d %03d %03d\n",
	track_rate[0],
	track_rate[3],
	track_rate[1],
	track_rate[4],
	track_rate[2],
	track_rate[5]
	);


}

void sp12_qtw::on_daq_config_set_pb_released()
{
//    int fd = device_d;
    uint64_t value;
    uint32_t saddr;
    off_t pos;

    log_printf("setting DAQ config\n");

    // module addresses
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    uint64_t REG_BASE = 0x40ULL; // 0x60ULL  bytes


    int ch = REG_BANK_CH; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    saddr = MEM_BASE + (ch << 12) + (0x2f << 3) ;

    uint64_t bx_offset = ui->bx_offset_spin->value();
    uint64_t valor_window = ui->valor_windows_spin->value();
    uint64_t valor_delay = ui->valor_delay_spin->value();
    uint64_t l1a_window = ui->l1a_window_spin->value();
    uint64_t l1a_delay = ui->l1a_delay_spin->value();
    uint64_t stress = ui->stress_cb->isChecked() ? 1ULL : 0ULL;
    uint64_t amc13_easy_en = ui->resync_pend->isChecked() ? 1ULL : 0ULL;
    uint64_t report_wo_track = 1ULL;
    uint64_t rpc_late_by = 6ULL;


    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            uint64_t board_id = sector_lut[id] | (endcap_lut[id] << 3); // form board id from endcap and sector at this time
            value = l1a_delay;
            value |= l1a_window      << 8;
            value |= valor_delay     << (8+3);
            value |= valor_window    << (8+3+8);
            value |= bx_offset       << (8+3+8+3);
            value |= board_id        << (8+3+8+3+12);
            value |= stress          << (8+3+8+3+12+16);
            value |= amc13_easy_en   << (8+3+8+3+12+16+1);
            value |= report_wo_track << (8+3+8+3+12+16+1+1);
            value |= rpc_late_by     << (8+3+8+3+12+16+1+1+1);


            int fd = devices_d[id];
            log_printf ("device index: %d\n", id);
            log_printf ("DAQ config write: %016llx\n", value);
            mwrite(fd, &value, 8, saddr);

            uint64_t rb_value = 0;
            pos = (REG_BASE << 32) + saddr;
            mread(fd, &rb_value, 8, pos);
            log_printf ("DAQ config read : %016llx\n", rb_value);
        }
    }


}

// map of fiber enable table to fiber_enable register bits
// index in array = fiber_enable register bit number
// value in array = fiber enable table column number
int fib_en_map[68] =
{
    53, 52, 51, 50, 49, 48, 47, 46,
    44, 43, 42, 41, 40, 39, 38, 37,
    35, 34, 33, 32, 31, 30, 29, 28,
    26, 25, 24, 23, 22, 21, 20, 19,
    17, 16, 15, 14, 13, 12, 11, 10,
    9, 8, 7, 6, 5, 4, 3, 2, 1,
    61, 60, 59, 58, 57, 56, 55,
    68, 67, 66, 65, 64, 63, 62

};

void sp12_qtw::on_en_input_fibers_released()
{
    uint64_t value;
    uint32_t saddr;

    log_printf("set fiber enable bits\n");

    // module addresses
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes


    int ch = REG_BANK_CH; // config register bank

    // form start address {chamber[6], sel[2], addr[7], 3'b0}
    saddr = MEM_BASE + (ch << 12) + (0xb << 3) ;
//    value = 0xffffffffffffffffULL;
//    value = 0x2ULL; // for tests in 904

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            value = 0ULL;
            for (int i = 62; i >= 0; i--)
            {
                int fe_column = fib_en_map[i];
                bool fe_bit = ui->bc0_source_tbl->item(5, fe_column)->checkState();
                value <<= 1;
                value |= fe_bit;
            }

            int fd = devices_d[id];
            log_printf ("device: %d setting fiber_en: %016llx\n", id, value);
            mwrite(fd, &value, 8, saddr);
        }
    }

}
// actually reads fiber_enable register
void sp12_qtw::on_dis_input_fibers_released()
{
    uint64_t value;
    uint32_t saddr;

    log_printf("read fiber enable register\n");

    // module addresses
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes


    int ch = REG_BANK_CH; // config register bank

    // form start address {chamber[6], sel[2], addr[7], 3'b0}
    saddr = MEM_BASE + (ch << 12) + (0xb << 3) ;
    value = 0ULL;

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            int fd = devices_d[id];
            mread (fd, &value, 8, saddr);
            log_printf ("device: %d fiber_en: %016llx\n", id, value);
            // display in table
            for (int i = 0; i < 63; i++) // 49 CSC+7 RPC+7 GE11 = 63 links
            {
                int fe_bit = value & 1;
                value >>= 1;
                int fe_column = fib_en_map[i];
                ui->bc0_source_tbl->item(5, fe_column)->setCheckState((Qt::CheckState)(fe_bit));
//                printf ("i: %d col: %2d bit: %d\n", i, fe_column, fe_bit);
            }
        }
    }

}

void sp12_qtw::on_core_latency_test_released()
{
    bool lat_test = ui->core_latency_test->isChecked();
    int fd = device_d;
    uint64_t value;
    uint32_t saddr;
    off_t pos;


    // module addresses
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    uint64_t REG_BASE = 0x40ULL; // 0x60ULL  bytes


    int ch = REG_BANK_CH; // config register bank

    // form start address {chamber[6], sel[2], addr[7], 3'b0}
    saddr = MEM_BASE + (ch << 12) + (0 << 3) ;
    pos = (REG_BASE << 32) + saddr;
    value = 0ULL;
    mread (fd, &value, 8, pos);
    log_printf    ("Config reg readback:       %016llx\n", value);

    if (lat_test)
    {
        value |= (1ULL << 16);
        log_printf("Enable latency test mode:  %016llx\n", value);
    }
    else
    {
        value &= ~(1ULL << 16);
        log_printf("Disable latency test mode: %016llx\n", value);
    }
    mwrite(fd, &value, 8, saddr);
    value = 0ULL;
    mread (fd, &value, 8, pos);
    log_printf    ("Config reg readback:       %016llx\n", value);
}


void sp12_qtw::on_random_triggers_pb_released()
{
    // read selected rate
    int rate_code = ui->l1a_rate_list->currentRow();
    // enable/disable
    bool random_trig_en = ui->random_triggers_pb->isChecked();
    random_trigger(rate_code, random_trig_en);
}

void sp12_qtw::on_pushButton_4_released()
{
    // VME TTC configuration
    ttc_config();
}

void sp12_qtw::on_daq_status_pb_released()
{
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    uint64_t REG_BASE = 0x40ULL; // 0x60ULL  bytes
    int ch = REG_BANK_CH;
    uint32_t saddr;
    uint64_t value, pos;

    string ttsd[16] = {"---", "WOF", "OOS", "---", "BSY", "---", "---", "---", "RDY", "---", "---", "---", "ERR", "---", "---", "DIS"};

    log_printf("\n");
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            int fd = devices_d[id];
            log_printf ("device index: %02d ", id);
            saddr = MEM_BASE + (ch << 12) + (0x30 << 3) ;
            pos = (REG_BASE << 32) + saddr;
            mread(fd, &value, 8, pos);
            uint64_t almost_full_cnt;
            almost_full_cnt = (value >> 16) & 0xffffull;
            log_printf ("Almost_full: %04llx ", almost_full_cnt);

            saddr = MEM_BASE + (ch << 12) + (0x31 << 3) ;
            pos = (REG_BASE << 32) + saddr;
            mread(fd, &value, 8, pos);
            uint64_t tts_data, tts_wof_cnt, tts_bsy_cnt, tts_oos_cnt, tts_rdy_cnt, tts_ill_cnt, amc13_ready;

            amc13_ready = (value >> 59) & 1;
            tts_data    = (value >> 55) & 0xfull;
            tts_ill_cnt = (value >> 44) & 0x7ffull;
            tts_rdy_cnt = (value >> 33) & 0x7ffull;
            tts_wof_cnt = (value >> 22) & 0x7ffull;
            tts_bsy_cnt = (value >> 11) & 0x7ffull;
            tts_oos_cnt = value & 0x7ffull;

// daq_state_cnt = {amc13_go_easy, amc13_ready, tts_data, tts_ill_cnt, tts_rdy_cnt, tts_wof_cnt, tts_bsy_cnt, tts_oos_cnt};


	    saddr = MEM_BASE + (ch << 12) + (0x2f << 3) ; // daq config reg
	    uint64_t daq_cfg_rb;
            mread(fd, &daq_cfg_rb, 8, saddr);
	    uint64_t l1a_del = daq_cfg_rb & 0xff;
	    uint64_t l1a_wnd = (daq_cfg_rb >> 8) & 0x7;
	    uint64_t val_dly = (daq_cfg_rb >> 11) & 0xff;
	    uint64_t val_wnd = (daq_cfg_rb >> 19) & 0x7;
	    

            log_printf ("tts: %s wof: %03llx bsy: %03llx oos: %03llx, rdy: %03llx ill: %03llx, amc13_rdy: %x daq_cfg: %016llx L1a_del: %02lld L1a_wnd: %01lld val_del: %02lld val_wnd: %01lld\n",
                        ttsd[tts_data].c_str(), tts_wof_cnt, tts_bsy_cnt, tts_oos_cnt, tts_rdy_cnt, tts_ill_cnt, amc13_ready, daq_cfg_rb, l1a_del, l1a_wnd, val_dly, val_wnd);
        }
    }


}

void sp12_qtw::on_af_watch_pb_released()
{
  iterations = ui->iterations_spin->value();
  key = 'A';
}

void sp12_qtw::on_af_write_delays_pb_released()
{
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
	  device_d = devices_d[id];
	  log_printf ("device index: %d\n", id);
	  af_write_delays(endcap_lut[id], sector_lut[id]);
	}
    }
}

void sp12_qtw::on_af_enable_auto_cb_released()
{
  bool af_en_auto;
  if (ui->af_enable_auto_cb->isChecked()) af_en_auto = true;
  else af_en_auto = false;

    uint32_t REG_MEM_BASE = 0x80000; // bytes
    uint64_t value;

    int ch = REG_BANK_CH; // config register bank
    uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0x11 << 3); 

    if (af_en_auto) log_printf ("enabling auto AF delays\n");
    else log_printf ("applying user's AF delays\n");

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
	  device_d = devices_d[id];
	  log_printf ("device index: %d\n", id);

	  mread(device_d, &value, 8, saddr);
	  if (af_en_auto)
	    value |= (1ULL << 19);
	  else
	    value &= ~(1ULL << 19);
	  mwrite(device_d, &value, 8, saddr);
	}
    }
  
}

void sp12_qtw::on_read_delays_pb_released()
{
    uint32_t REG_MEM_BASE = 0x80000; // bytes
    uint64_t value, daq_delay, bc0_delay, gmt_delay, auto_af, gem_delay;

    int ch = REG_BANK_CH; // config register bank
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);

            uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0x11 << 3);
            mread(device_d, &value, 8, saddr);

            daq_delay = (value & 0x0ff80ULL) >> 7; // clean up delay
            bc0_delay = (value & 0x7fc00000000ULL) >> 34; // clean up bc0 delay
            gmt_delay = (value & 0x7ff80000000000ULL) >> 43; // clean up gmt delay
            auto_af = (value >> 19) & 1ULL;

            value = 0;
            uint32_t saddr_d = REG_MEM_BASE + (ch << 12) + (0x32 << 3); // core_config register
            mread(device_d, &value, 8, saddr_d);
            int single_delay = (value >> 24)&7ULL;
            int single_en = (value >> 12) & 1ULL;

            saddr = REG_MEM_BASE + (ch << 12) + (0x76 << 3); // gem_data_del register
            mread(device_d, &value, 8, saddr);
            gem_delay = value & 0x3ff; // just take one of the delays for now
            int gem_en_manual = (value >> 7) & 1;

            log_printf("reading delays: BC0: %d, DAQ: %d GMT: %d auto_af: %d single_del: %d single_en: %d GEMbc0: %d GEMman: %d\n",
                       (int)bc0_delay, (int) daq_delay, (int) gmt_delay, (int) auto_af, single_delay, single_en, (int)gem_delay, gem_en_manual);

        }
    }

}

void sp12_qtw::on_cppf_bc0_delay_set_pb_released()
{
    uint32_t REG_MEM_BASE = 0x80000; // bytes
    uint64_t value, cppf_bc0_delay, new_val;

    int ch = REG_BANK_CH; // config register bank
    uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0x11 << 3);

    new_val = ui->cppf_bc0_delay_sb->text().toInt(0, 10);

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);

            mread(device_d, &value, 8, saddr);


            cppf_bc0_delay = (value >> 55) & 0x3fULL;

            log_printf("old cppf bc0 delay: %d\n", (int)cppf_bc0_delay);

            value = value & (~(0x3fULL << 55)); // clean up
            value = value | (new_val << 55); // insert

            mwrite(device_d, &value, 8, saddr);
            log_printf("new cppf bc0 delay: %d\n", (int)new_val);


        }
    }


}

void sp12_qtw::on_bc0_source_tbl_cellClicked(int row, int column)
{
    printf ("cell clicked: %d %d\n", row, column);
/*
// unused functionality since the MPC links upgrade. Commented out
    uint64_t ch1 = 0, mispl = 0, rx_rst = 0;

    for (int i = 0; i < 54; i++)
    {
        bool ch1_bit = ui->bc0_source_tbl->item(2, i+1)->checkState();
        ch1 <<= 1;
        ch1 |= ch1_bit ? 1 : 0;

        bool mispl_bit = ui->bc0_source_tbl->item(3, i+1)->checkState();
        mispl <<= 1;
        mispl |= mispl_bit ? 1 : 0;

        if (i % 9 != 8 || i == 8) // no reset checkboxes for non-link chambers
        {
            bool rst_bit = ui->bc0_source_tbl->item(4, i+1)->checkState();
            rx_rst <<= 1;
            rx_rst |= rst_bit ? 1 : 0;
            ui->bc0_source_tbl->item(4, i+1)->setCheckState((Qt::CheckState)(false));
        }
    }

    log_printf ("ch1   : %016llx\n", ch1);
    log_printf ("mispl : %016llx\n", mispl);
    log_printf ("rx_rst: %016llx\n", rx_rst);

    uint32_t REG_MEM_BASE = 0x80000; // bytes
    uint64_t ch1_value, mispl_value;

    int ch = REG_BANK_CH; // config register bank
    uint32_t ch1_addr = REG_MEM_BASE + (ch << 12) + (0x52 << 3);
    uint32_t mispl_addr = REG_MEM_BASE + (ch << 12) + (0x53 << 3);
    uint32_t rx_rst_addr = REG_MEM_BASE + (ch << 12) + (0x54 << 3);

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);

            mread(device_d, &ch1_value, 8, ch1_addr);
            mread(device_d, &mispl_value, 8, mispl_addr);

            log_printf ("old ch1  : %016llx\n", ch1_value);
            log_printf ("old mispl: %016llx\n", mispl_value);

            mwrite(device_d, &ch1, 8, ch1_addr);
            mwrite(device_d, &mispl, 8, mispl_addr);

            mread(device_d, &ch1_value, 8, ch1_addr);
            mread(device_d, &mispl_value, 8, mispl_addr);

            log_printf ("new ch1  : %016llx\n", ch1_value);
            log_printf ("new mispl: %016llx\n", mispl_value);

            // write RX reset register
            mwrite (device_d, &rx_rst, 8, rx_rst_addr);
            rx_rst = 0; // remove reset bits
            mwrite (device_d, &rx_rst, 8, rx_rst_addr);

            break; // program only one device
        }
    }
    */
}


void read_back_ptlut_bus_delays(int fds, bool det_wr, int id)
{
    uint32_t MEM_BASE_CL = 0x80000;
    uint32_t ch = REG_BANK_CH;
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // control register has address 0
    uint64_t reg_dat_rb[6] = {0,0,0,0,0,0};

    uint32_t reg_start = det_wr ? 0x20 : 0x1a;

    char fname[100];
    sprintf (fname, "rback_%cdel%02d.txt", det_wr ? 'w':'r', id);
    FILE* out = fopen(fname, "wt");

    int nl = 0;
    // read back delays
    for (int i = 0; i < 6; i++)
    {
        uint64_t reg_addr = saddr + ((reg_start + i) << 3);
        mread(fds, &reg_dat_rb[i], 8, reg_addr);
        for (int j = 0; j < 12; j++)
        {
            uint32_t dval = ((reg_dat_rb[i] >> (j*5)) & 0x1f);
            log_printf ("%02d ", dval);
            fprintf (out, "%02d ", dval);
            nl++;
            if (nl == 18) {log_printf ("\n"); fprintf(out, "\n"); nl = 0;}
        }

    }
    fclose (out);
}

void set_ptlut_bus_delays(int fds, bool det_wr, int id)
{
    uint32_t MEM_BASE_CL = 0x80000;
    uint32_t ch = REG_BANK_CH;
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // control register has address 0
    uint64_t reg_dat[6] = {0,0,0,0,0,0};

    uint32_t reg_start = det_wr ? 0x20 : 0x1a;

    int delval;

    char fname[100];
    sprintf (fname, "%cdel%02d.txt", det_wr ? 'w':'r', id);
    FILE* out = fopen(fname, "rt");

    // set delays
    for (int i = 0; i < 6; i++)
    {
        reg_dat[i] = 0ULL;
        for (int j = 0; j < 12; j++)
        {
            fscanf(out, "%d", &delval);
            uint64_t dval = delval;
            reg_dat[i] |= ((dval & 0x1f) << (j*5));
        }
        uint64_t reg_addr = saddr + ((reg_start + i) << 3);
        mwrite(fds, &reg_dat[i], 8, reg_addr);

    }
    fclose (out);

    uint64_t reg_addr = saddr + (0x26 << 3);
    uint64_t v = ptlut_rx_clk_delay_val;
    mwrite(device_d, &v, 8, reg_addr);

    // load new delays
    uint64_t val;
    val = (1ULL << 12);
    mwrite(device_d, &val, 8, saddr);
    val = 0;
    mwrite(device_d, &val, 8, saddr);
}


void sp12_qtw::on_lptlut_read_back_delays_pb_released()
{
    log_printf ("reading ptlut bus delays\n");
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
            read_back_ptlut_bus_delays(device_d, false, id);
            log_printf("\n");
            read_back_ptlut_bus_delays(device_d, true, id);
            log_printf("\n");
        }
    }
}

void sp12_qtw::on_pushButton_5_released()
{
    log_printf ("setting ptlut bus delays from files\n");
    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
            set_ptlut_bus_delays(device_d, false, id);
            set_ptlut_bus_delays(device_d, true, id);

        }
    }

}

void sp12_qtw::on_cosmics_pb_released()
{
    key = '3';
}

void sp12_qtw::on_in_fiber_status_pb_released()
{
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    int ch = REG_BANK_CH;
    uint32_t saddr;
    uint64_t bc0pe, balig, rxdone, txdone, cplllk, gthtxdn;

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            saddr = MEM_BASE + (ch << 12) + (18 << 3) ;
            mread(device_d, &bc0pe, 8, saddr);

            saddr = MEM_BASE + (ch << 12) + (21 << 3) ;
            mread(device_d, &balig, 8, saddr);

            saddr = MEM_BASE + (ch << 12) + (0x57 << 3) ;
            mread(device_d, &rxdone, 8, saddr);

            saddr = MEM_BASE + (ch << 12) + (0x58 << 3) ;
            mread(device_d, &txdone, 8, saddr);

            saddr = MEM_BASE + (ch << 12) + (0x59 << 3) ;
            mread(device_d, &cplllk, 8, saddr);

            saddr = MEM_BASE + (ch << 12) + (0x5a << 3) ;
            mread(device_d, &gthtxdn, 8, saddr);

            log_printf ("dev: %02d bc0pe: %013llx balig: %013llx rxdone: %013llx txdone: %013llx cplllk: %013llx gthtxdn: %013llx\n",
                        id, bc0pe, balig, rxdone, txdone, cplllk, gthtxdn);
        }
    }
}

void sp12_qtw::on_rx_reset_monitor_pb_released()
{
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    int ch = REG_BANK_CH;
    uint32_t rxsaddr, txsaddr;
    uint64_t rxdone, rxdone_r;
    uint64_t txdone, txdone_r;

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
            int pid = fork();
            if (pid == 0) // child
            {
                int i;
                rxdone_r = 0ULL;
                txdone_r = 0ULL;
                rxsaddr = MEM_BASE + (ch << 12) + (0x57 << 3) ;
                txsaddr = MEM_BASE + (ch << 12) + (0x58 << 3) ;
                for (i = 0; i < 1000000; i++)
                {
                    mread(device_d, &rxdone, 8, rxsaddr);
                    mread(device_d, &txdone, 8, txsaddr);
                    if (rxdone != rxdone_r || txdone != txdone_r)
                        log_printf ("rxdone: %016llx txdone: %016llx\n", rxdone, txdone);
                    rxdone_r = rxdone;
                    txdone_r = txdone;
                    usleep(5);

                }
                log_printf ("done\n");

                _exit(EXIT_SUCCESS);
            }
        }
    }

}

void sp12_qtw::on_mpc_links_enable_hr_pb_released()
{
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    int ch = REG_BANK_CH;
    uint32_t saddr;
    uint64_t value;

    log_printf ("enable MPC links reset on HR\n");

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            device_d = devices_d[id];
            log_printf ("device index: %d\n", id);
            saddr = MEM_BASE + (ch << 12) + (0 << 3) ;
            value = 1ULL << 19;
            mwrite(device_d, &value, 8, saddr);

        }
    }

}

void sp12_qtw::on_mpc_lnk_rst_tst_pb_released()
{
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    int ch = REG_BANK_CH;
    uint32_t rxsaddr, txsaddr, rstaddr; //, gthrxrst;
    uint64_t rxdone, rstreg;
    uint64_t txdone;

    rstaddr  = MEM_BASE + (ch << 12) ;
//    gthrxrst = MEM_BASE + (ch << 12) + (0x54 << 3) ;
    rxsaddr  = MEM_BASE + (ch << 12) + (0x57 << 3) ;
    txsaddr  = MEM_BASE + (ch << 12) + (0x58 << 3) ;


    int pid = fork();
    if (pid == 0) // child
    {
        for (int i = 0; i < 100000000; i++)
        {
            for (int id = 0; id < 13; id++)
            {
                if (devices_d[id] >= 0)
                {
                    device_d = devices_d[id];

                    // reset all MPC links
                    rstreg = 1ULL;
                    mwrite (device_d, &rstreg, 8, rstaddr);
                    rstreg = 0ULL;
                    mwrite (device_d, &rstreg, 8, rstaddr);

//                    int shc = i % 40;
//                    rstreg = 1ULL << shc;
//                    mwrite (device_d, &rstreg, 8, gthrxrst);
//                    rstreg = 0ULL;
//                    mwrite (device_d, &rstreg, 8, gthrxrst);

                }
            }
            // wait
            usleep (100);

            for (int id = 0; id < 13; id++)
            {
                if (devices_d[id] >= 0)
                {
                    device_d = devices_d[id];
                    // read reset status
                    rxdone = 0ULL;
                    txdone = 0ULL;
                    mread(device_d, &rxdone, 8, rxsaddr);
                    mread(device_d, &txdone, 8, txsaddr);

                    // check if all links reset properly
                    if ((rxdone & 0xffffff7fffULL) != 0xffffff7fffULL || (txdone & 0xffffff7fffULL) != 0xffffff7fffULL)
                    {
                        // some links did not finish, give more time
                        usleep (10000);
                        {log_printf ("#"); fflush (stdout);}

                        // read again
                        rxdone = 0ULL;
                        txdone = 0ULL;
                        mread(device_d, &rxdone, 8, rxsaddr);
                        mread(device_d, &txdone, 8, txsaddr);

                        // check again
                        if ((rxdone & 0xffffff7fffULL) != 0xffffff7fffULL || (txdone & 0xffffff7fffULL) != 0xffffff7fffULL)
                        {
                            // did not finish in a long time, report
                            log_printf ("\runit: %d rxdone: %016llx txdone: %016llx\n", id, rxdone, txdone);
                        }
                    }

                }
            }

            if (i % 5000 == 0) {log_printf ("*"); fflush (stdout);}
        }
        log_printf ("done\n");

        _exit(EXIT_SUCCESS);
    }

}

void sp12_qtw::on_single_delay_sb_editingFinished()
{

}

void sp12_qtw::on_prim_ge11_lut_write_pb_released()
{
    prim_conv_lut_verify = false;
    ge11_prim = true;
    key = 'o';

}

void sp12_qtw::on_prim_ge11_lut_verify_pb_released()
{
    prim_conv_lut_verify = true;
    ge11_prim = true;
    key = 'o';

}

void sp12_qtw::on_clk40_psen_exec_released()
{
    // clk40 clock phase adjustment for MPCX link tests
    // read adjustment count. Can be negative or positive
    int psen_count = ui->psen_count_spin->value();
    int psen_count_abs = abs(psen_count);
    int psen_sign = (psen_count > 0) ? 1 : 0;

    uint32_t REG_MEM_BASE = 0x80000; // bytes
    int ch = REG_BANK_CH; // config register bank
    uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0 << 3); // control register

    uint64_t value = 0;
    mread(device_d, &value, 8, saddr);
    // clean and apply bit 9, increment direction
    value &= ~(1ULL << 9);
    value |= (psen_sign << 9);

	// clock phase calculation:
	// one psen pulse moves phase by 1/56 of the VCO period
	// VCO freq is 40M X 20 = 800 MHz, period = 1.25 ns
	// one psen pulse = 1.25 ns / 56 = ~22.32 ps
	// scanning entire 40M period = 56 x 20 = 1120 psen pulses

    for (int i = 0; i < psen_count_abs; i++)
    {
		uint64_t tpaterr = 0;
	    uint32_t tpaddr = REG_MEM_BASE + (ch << 12) + (0x62 << 3) ; // test pattern errors reg
		
		// reset error flags
		uint64_t cntrlreg;
		mread  (device_d, &cntrlreg, 8, saddr);
		cntrlreg |= (1ULL << 21);
		mwrite (device_d, &cntrlreg, 8, saddr);
		cntrlreg &= ~(1ULL << 21);
		mwrite (device_d, &cntrlreg, 8, saddr);
		
		usleep (50000); // let errors happen
		tpaterr = 0;
	    mread(device_d, &tpaterr, 8, tpaddr); // this reads actual errors
		
		tpaterr &= 0xffffffffffULL; // only analyze MPC0..4
		//tpaterr &= 0xff0000000000ULL; // only analyze Neighbor
		if (tpaterr != 0) 
		{
			log_printf ("%016llx phase: %d\n", tpaterr, i);
			
			// give it some more time 
			usleep (100000);

			// reset error flags
			uint64_t cntrlreg;
			mread  (device_d, &cntrlreg, 8, saddr);
			cntrlreg |= (1ULL << 21);
			mwrite (device_d, &cntrlreg, 8, saddr);
			cntrlreg &= ~(1ULL << 21);
			mwrite (device_d, &cntrlreg, 8, saddr);

			usleep (50000); // let errors happen
			tpaterr = 0;
			mread(device_d, &tpaterr, 8, tpaddr); // this reads actual errors

			tpaterr &= 0xffffffffffULL; // only analyze MPC0..4
			//tpaterr &= 0xff0000000000ULL; // only analyze Neighbor
			if (tpaterr != 0) 
			{
				log_printf ("\nipersistent test pattern errors: %016llx phase: %d\n", tpaterr, i);
				break;
			}
			
		}

		
		value |=  (1ULL << 8); // set bit 8, psen
        mwrite(device_d, &value, 8, saddr);

        value &= ~(1ULL << 8); // clean bit 8, psen
        mwrite(device_d, &value, 8, saddr);

		log_printf ("\r%d      ", i);
		fflush (stdout);

		usleep (10000);

    }

	log_printf ("done psen count: %d direction: %d\n", psen_count_abs, psen_sign);
}

void sp12_qtw::on_pushButton_6_released()
{
    // test with periodic MPC reset and check for errors
    // read adjustment count. Can be negative or positive
    int psen_count = ui->psen_count_spin->value();
    int psen_count_abs = abs(psen_count);
	if (psen_count == 0) psen_count_abs = 2000000000; // 0 means infinite

    uint32_t REG_MEM_BASE = 0x80000; // bytes
    int ch = REG_BANK_CH; // config register bank
    uint32_t saddr = REG_MEM_BASE + (ch << 12) + (0 << 3); // control register

    for (int i = 0; i < psen_count_abs; i++)
    {
        uint64_t tpaterr = 0;
        uint32_t tpaddr = REG_MEM_BASE + (ch << 12) + (0x62 << 3) ; // test pattern errors reg

        // reset error flags
        uint64_t cntrlreg;
        mread  (device_d, &cntrlreg, 8, saddr);
        cntrlreg |= (1ULL << 21);
        mwrite (device_d, &cntrlreg, 8, saddr);
        cntrlreg &= ~(1ULL << 21);
        mwrite (device_d, &cntrlreg, 8, saddr);

        usleep (50000); // let errors happen
        tpaterr = 0;
        mread(device_d, &tpaterr, 8, tpaddr); // this reads actual errors

        //tpaterr &= 0xffULL; // only analyze MPC0
        tpaterr &= 0xff0000000000ULL; // only analyze Neighbor
        if (tpaterr != 0)
        {
            log_printf ("%016llx phase: %d\n", tpaterr, i);

            // give it some more time
            usleep (100000);

            // reset error flags
            uint64_t cntrlreg;
            mread  (device_d, &cntrlreg, 8, saddr);
            cntrlreg |= (1ULL << 21);
            mwrite (device_d, &cntrlreg, 8, saddr);
            cntrlreg &= ~(1ULL << 21);
            mwrite (device_d, &cntrlreg, 8, saddr);

            usleep (50000); // let errors happen
            tpaterr = 0;
            mread(device_d, &tpaterr, 8, tpaddr); // this reads actual errors

            //tpaterr &= 0xffULL; // only analyze MPC0
            tpaterr &= 0xff0000000000ULL; // only analyze Neighbor
            if (tpaterr != 0)
            {
                log_printf ("\nipersistent test pattern errors: %016llx phase: %d\n", tpaterr, i);
                break;
            }

        }

        // reset MPC here
        system ("../mpc_resetter/mpc_resetter");

        log_printf ("\r%d      ", i);
        fflush (stdout);

        usleep (1000000); // let it reboot

    }

    log_printf ("done MPC reset count: %d\n", psen_count_abs);

}

void sp12_qtw::on_hmt_rates_pb_released()
{
    key = '5';
}
