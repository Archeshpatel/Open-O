package oscar.billing.dao;

import oscar.billing.model.Appointment;
import oscar.billing.model.Diagnostico;
import oscar.billing.model.ProcedimentoRealizado;
import oscar.billing.model.Provider;

import oscar.oscarDB.DBHandler;
import oscar.oscarDB.DBPreparedHandlerAdvanced;

import oscar.util.DAO;
import oscar.util.DateUtils;
import oscar.util.FieldTypes;
import oscar.util.SqlUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Properties;


public class AppointmentDAO extends DAO {
    public AppointmentDAO(Properties pvar) throws SQLException {
        super(pvar);
    }

    public void billing(Appointment app) throws SQLException {
        String sqlProc;
        String sqlDiag;
		String sqlApp;

        sqlProc = "insert into cad_procedimento_realizado (appointment_no, co_procedimento, dt_realizacao) values (?, ?, ?)";
        sqlDiag = "insert into cad_diagnostico (appointment_no, co_cid) values (?, ?)";
        sqlApp = "update appointment set billing = 'P' where appointment_no = ?";

        DBPreparedHandlerAdvanced db = getDBPreparedHandlerAdvanced();
        PreparedStatement pstmProc = db.getPrepareStatement(sqlProc);
        PreparedStatement pstmDiag = db.getPrepareStatement(sqlDiag);
		PreparedStatement pstmApp = db.getPrepareStatement(sqlApp);

        db.setAutoCommit(false);

        try {
            unBilling(app, db);

            for (int i = 0; i < app.getProcedimentoRealizado().size(); i++) {
                ProcedimentoRealizado pr = (ProcedimentoRealizado) app.getProcedimentoRealizado()
                                                                      .get(i);

                //appoitment_no
                SqlUtils.fillPreparedStatement(pstmProc, 1,
                    new Long(pr.getAppointment().getAppointmentNo()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmProc, 2,
                    new Long(pr.getCadProcedimentos().getCoProcedimento()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmProc, 3,
                    DateUtils.formatDate(DateUtils.getDate(pr.getDtRealizacao()),
                        "dd/MM/yyyy"), FieldTypes.DATE);
                db.execute(pstmProc);
            }

            for (int i = 0; i < app.getDiagnostico().size(); i++) {
                Diagnostico diag = (Diagnostico) app.getDiagnostico().get(i);

                //appoitment_no
                SqlUtils.fillPreparedStatement(pstmDiag, 1,
                    new Long(diag.getAppointment().getAppointmentNo()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmDiag, 2,
                    diag.getCadCid().getCoCid(), FieldTypes.CHAR);
                db.execute(pstmDiag);
            }
            
			SqlUtils.fillPreparedStatement(pstmApp, 1,
				String.valueOf(app.getAppointmentNo()), FieldTypes.LONG);
			db.execute(pstmApp);

            db.commit();
        } catch (Exception e) {
            db.rollback();
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            pstmDiag.close();
            pstmProc.close();
            db.closeConn();
        }
    }

    public void unBilling(Appointment app) throws SQLException {
        String sqlProc;
        String sqlDiag;

        sqlProc = "delete from cad_procedimento_realizado where appointment_no = ?";
        sqlDiag = "delete from cad_diagnostico where appointment_no = ?";

        DBPreparedHandlerAdvanced db = getDBPreparedHandlerAdvanced();
        PreparedStatement pstmProc = db.getPrepareStatement(sqlProc);
        PreparedStatement pstmDiag = db.getPrepareStatement(sqlDiag);

        db.setAutoCommit(false);

        try {
            SqlUtils.fillPreparedStatement(pstmProc, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            db.execute(pstmProc);

            SqlUtils.fillPreparedStatement(pstmDiag, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            db.execute(pstmDiag);

            db.commit();
        } catch (Exception e) {
            db.rollback();
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            pstmDiag.close();
            pstmProc.close();
            db.closeConn();
        }
    }

    public void unBilling(Appointment app, DBPreparedHandlerAdvanced db)
        throws SQLException {
        String sqlProc;
        String sqlDiag;

        sqlProc = "delete from cad_procedimento_realizado where appointment_no = ?";
        sqlDiag = "delete from cad_diagnostico where appointment_no = ?";

        PreparedStatement pstmProc = db.getPrepareStatement(sqlProc);
        PreparedStatement pstmDiag = db.getPrepareStatement(sqlDiag);

        try {
            SqlUtils.fillPreparedStatement(pstmProc, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            db.execute(pstmProc);

            SqlUtils.fillPreparedStatement(pstmDiag, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            db.execute(pstmDiag);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            pstmDiag.close();
            pstmProc.close();
        }
    }

    public Appointment retrieve(String id) throws SQLException {
        Appointment appointment = new Appointment();
        String sql =
            "select app.appointment_no, app.provider_no, prov.first_name, prov.last_name, app.demographic_no, dem.first_name, dem.last_name, app.name, app.reason, app.appointment_date " +
            "from appointment app, provider prov, demographic dem " +
            "where app.provider_no = prov.provider_no and " +
            "app.demographic_no = dem.demographic_no and " +
            "app.appointment_no = " + id;

        DBHandler db = getDb();

        try {
            ResultSet rs = db.GetSQL(sql);

            if (rs.next()) {
                appointment.setAppointmentNo(rs.getLong(1));
                appointment.getProvider().setProviderNo(rs.getString(2));
                appointment.getProvider().setFirstName(rs.getString(3));
                appointment.getProvider().setLastName(rs.getString(4));
                appointment.getDemographic().setDemographicNo(rs.getLong(5));
                appointment.getDemographic().setFirstName(rs.getString(6));
                appointment.getDemographic().setLastName(rs.getString(7));
                appointment.setName(rs.getString(8));
                appointment.setReason(rs.getString(9));
				appointment.setAppointmentDate(rs.getDate(10));
            }
        } finally {
            db.CloseConn();
        }

        return appointment;
    }

    public ArrayList listFatDoctor(String type, Provider provider)
        throws SQLException {
        ArrayList list = new ArrayList();
        String sql =
            "select a.appointment_no, a.appointment_date, a.provider_no, b.last_name, " +
            "b.first_name, a.demographic_no, c.last_name, c.first_name " +
            "from appointment a, provider b, demographic c " +
            "where a.provider_no = b.provider_no and " +
            "a.demographic_no = c.demographic_no ";

        if (type.equals(Appointment.AGENDADO)) {
            sql = sql + " and a.billing = '" + Appointment.AGENDADO + "'";
        } else if (type.equals(Appointment.FATURADO)) {
			sql = sql + " and a.billing = '" + Appointment.FATURADO + "'";
        } else if (type.equals(Appointment.PENDENTE)) {
            sql = sql + " and a.billing is null";
        }
        
        if (provider != null && !provider.getProviderNo().trim().equals("0")) {
			sql = sql + " and a.provider_no = " +  provider.getProviderNo().trim();
        }

        sql = sql + " order by a.appointment_date";

        DBHandler db = getDb();

        try {
            ResultSet rs = db.GetSQL(sql);

            while (rs.next()) {
            	Appointment app = new Appointment();
            	app.setAppointmentNo(rs.getLong(1));
            	app.setAppointmentDate(rs.getDate(2));
            	app.getProvider().setProviderNo(rs.getString(3));
            	app.getProvider().setLastName(rs.getString(4));
            	app.getProvider().setFirstName(rs.getString(5));
				app.getDemographic().setDemographicNo(rs.getLong(6));
				app.getDemographic().setLastName(rs.getString(7));
				app.getDemographic().setFirstName(rs.getString(8));
				
				list.add(app);            	
            }
        } finally {
            db.CloseConn();
        }

        return list;
    }
}
