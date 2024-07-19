#ifndef SP12_QTW_H
#define SP12_QTW_H

#include <QDialog>
#include <QtGui/QtGui>

namespace Ui {
class sp12_qtw;
}

class sp12_qtw : public QDialog
{
    Q_OBJECT
    
public:
    explicit sp12_qtw(QWidget *parent = 0);
    ~sp12_qtw();

    bool event( QEvent *e );

private slots:
    void on_configure_button_released();

    void on_erase_button_released();

    void on_write_button_released();

    void on_verify_button_released();

    void on_loopback_button_released();

    void on_send_reset_button_released();

    void on_configure_reset_released();

    void on_configure_status_released();

    void on_write_rldram_button_released();

    void on_terminate_button_released();

    void on_read_rldram_button_released();

    void on_test_rldram_button_released();

    void on_reset_rldram_button_released();

    void on_mcp_format_button_released();

    void on_mpc_status_button_released();

    void on_send_idle_button_released();

    void on_prep_mpc_button_released();

    void on_write_cl_b_released();

    void on_core_link_loopback_pb_released();

    void on_core_phase_inc_pb_released();

    void on_control_phase_inc_pb_released();

    void on_core_link_loopback_32_pb_released();

    void on_prim_conv_lut_write_pb_released();

    void on_core_logic_test_pb_released();

    void on_pushButton_released();

    void on_pushButton_2_released();

    void on_bc0_button_released();

    void on_l1reset_button_released();

    void on_read_link_ids_button_released();

    void on_mpc_data_to_file_pb_released();

    void on_set_delays_pb_released();

    void on_reset_rldram_button_clicked();

    void on_read_rldram_button_clicked();

    void on_lb_pt_button_released();

    void on_iddr_phase_button_released();

    void on_detect_delays_button_released();

    void on_detect_write_delays_pb_released();

    void on_pushButton_3_released();

    void on_random_addr_test_pb_released();

    void on_device_list_clicked(const QModelIndex &index);

    void on_prim_conv_lut_verify_pb_released();

    void on_occup_counters_read_pb_released();

    void on_daq_config_set_pb_released();

    void on_en_input_fibers_released();

    void on_dis_input_fibers_released();

    void on_core_latency_test_released();

    void on_resync_pb_released();

    void on_random_triggers_pb_released();

    void on_pushButton_4_released();

    void on_daq_status_pb_released();

    void on_af_watch_pb_released();

    void on_af_write_delays_pb_released();

    void on_af_enable_auto_cb_released();

    void on_read_delays_pb_released();

    void on_cppf_bc0_delay_set_pb_released();

    void on_bc0_source_tbl_cellClicked(int row, int column);

    void on_lptlut_read_back_delays_pb_released();

    void on_pushButton_5_released();

    void on_cosmics_pb_released();

    void on_in_fiber_status_pb_released();

    void on_rx_reset_monitor_pb_released();

    void on_mpc_links_enable_hr_pb_released();

    void on_mpc_lnk_rst_tst_pb_released();

    void on_single_delay_sb_editingFinished();

    void on_prim_ge11_lut_write_pb_released();

    void on_prim_ge11_lut_verify_pb_released();

    void on_clk40_psen_exec_released();

    void on_pushButton_6_released();

    void on_hmt_rates_pb_released();

private:
    Ui::sp12_qtw *ui;
};

#endif // SP12_QTW_H
