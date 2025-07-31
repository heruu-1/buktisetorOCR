from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class BuktiSetor(db.Model):
    __tablename__ = 'bukti_setor'
    
    id = db.Column(db.Integer, primary_key=True)
    
    # File information
    filename = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.String(500), nullable=False)
    file_size = db.Column(db.Integer)
    mime_type = db.Column(db.String(100))
    
    # OCR extracted data
    kode_setor = db.Column(db.String(50))
    tanggal_setor = db.Column(db.Date)
    jumlah_setor = db.Column(db.Numeric(15, 2))
    nama_wajib_pajak = db.Column(db.String(255))
    npwp = db.Column(db.String(20))
    
    # OCR processing metadata
    ocr_confidence = db.Column(db.Float)
    ocr_text_full = db.Column(db.Text)
    processing_time = db.Column(db.Float)  # in seconds
    
    # Status and validation
    status = db.Column(db.String(20), default='pending')  # pending, processed, verified, error
    validation_errors = db.Column(db.Text)
    is_validated = db.Column(db.Boolean, default=False)
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    processed_at = db.Column(db.DateTime)
    
    # Additional metadata
    bank_name = db.Column(db.String(100))
    nomor_rekening = db.Column(db.String(50))
    catatan = db.Column(db.Text)
    
    def __repr__(self):
        return f'<BuktiSetor {self.id}: {self.filename}>'
    
    def to_dict(self):
        return {
            'id': self.id,
            'filename': self.filename,
            'file_path': self.file_path,
            'file_size': self.file_size,
            'mime_type': self.mime_type,
            'kode_setor': self.kode_setor,
            'tanggal_setor': self.tanggal_setor.isoformat() if self.tanggal_setor else None,
            'jumlah_setor': float(self.jumlah_setor) if self.jumlah_setor else None,
            'nama_wajib_pajak': self.nama_wajib_pajak,
            'npwp': self.npwp,
            'ocr_confidence': self.ocr_confidence,
            'processing_time': self.processing_time,
            'status': self.status,
            'validation_errors': self.validation_errors,
            'is_validated': self.is_validated,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'processed_at': self.processed_at.isoformat() if self.processed_at else None,
            'bank_name': self.bank_name,
            'nomor_rekening': self.nomor_rekening,
            'catatan': self.catatan
        }
    
    @classmethod
    def create_from_ocr_data(cls, file_info, ocr_data, processing_time):
        """Create new BuktiSetor instance from OCR processing results"""
        bukti = cls(
            filename=file_info.get('filename'),
            file_path=file_info.get('file_path'),
            file_size=file_info.get('file_size'),
            mime_type=file_info.get('mime_type'),
            
            kode_setor=ocr_data.get('kode_setor'),
            tanggal_setor=ocr_data.get('tanggal_setor'),
            jumlah_setor=ocr_data.get('jumlah_setor'),
            nama_wajib_pajak=ocr_data.get('nama_wajib_pajak'),
            npwp=ocr_data.get('npwp'),
            
            ocr_confidence=ocr_data.get('confidence', 0.0),
            ocr_text_full=ocr_data.get('full_text', ''),
            processing_time=processing_time,
            
            status='processed',
            processed_at=datetime.utcnow(),
            
            bank_name=ocr_data.get('bank_name'),
            nomor_rekening=ocr_data.get('nomor_rekening'),
            catatan=ocr_data.get('catatan')
        )
        
        return bukti
