package alma.acs.tmcdb;
// Generated Dec 3, 2018 9:54:59 PM by Hibernate Tools 4.3.1.Final


import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * BL_FocusModelCoeffId generated by hbm2java
 */
@SuppressWarnings("serial")
@Embeddable
public class BL_FocusModelCoeffId  implements java.io.Serializable {


     private Integer version;
     private Long modTime;
     private BL_FocusModelCoeffOp operation;
     private Integer focusModelId;
     private String coeffName;

    public BL_FocusModelCoeffId() {
    }
   


    @Column(name="`VERSION`", nullable=false)
    public Integer getVersion() {
        return this.version;
    }
    
    public void setVersion(Integer version) {    
    	this.version = version;
    }



    @Column(name="`MODTIME`", nullable=false)
    public Long getModTime() {
        return this.modTime;
    }
    
    public void setModTime(Long modTime) {    
    	this.modTime = modTime;
    }



    @Column(name="`OPERATION`", nullable=false, length=1)
    public BL_FocusModelCoeffOp getOperation() {
        return this.operation;
    }
    
    public void setOperation(BL_FocusModelCoeffOp operation) {    
    	this.operation = operation;
    }



    @Column(name="`FOCUSMODELID`", nullable=false)
    public Integer getFocusModelId() {
        return this.focusModelId;
    }
    
    public void setFocusModelId(Integer focusModelId) {    
    	this.focusModelId = focusModelId;
    }



    @Column(name="`COEFFNAME`", nullable=false, length=128)
    public String getCoeffName() {
        return this.coeffName;
    }
    
    public void setCoeffName(String coeffName) {    
    	this.coeffName = coeffName;
    }



   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof BL_FocusModelCoeffId) ) return false;
		 BL_FocusModelCoeffId castOther = ( BL_FocusModelCoeffId ) other;

		 return ( (this.getVersion()==castOther.getVersion()) || ( this.getVersion()!=null && castOther.getVersion()!=null && this.getVersion().equals(castOther.getVersion()) ) )
 && ( (this.getModTime()==castOther.getModTime()) || ( this.getModTime()!=null && castOther.getModTime()!=null && this.getModTime().equals(castOther.getModTime()) ) )
 && ( (this.getOperation()==castOther.getOperation()) || ( this.getOperation()!=null && castOther.getOperation()!=null && this.getOperation().equals(castOther.getOperation()) ) )
 && ( (this.getFocusModelId()==castOther.getFocusModelId()) || ( this.getFocusModelId()!=null && castOther.getFocusModelId()!=null && this.getFocusModelId().equals(castOther.getFocusModelId()) ) )
 && ( (this.getCoeffName()==castOther.getCoeffName()) || ( this.getCoeffName()!=null && castOther.getCoeffName()!=null && this.getCoeffName().equals(castOther.getCoeffName()) ) );
   }

   public int hashCode() {
         int result = 17;

         result = 37 * result + ( getVersion() == null ? 0 : this.getVersion().hashCode() );
         result = 37 * result + ( getModTime() == null ? 0 : this.getModTime().hashCode() );
         result = 37 * result + ( getOperation() == null ? 0 : this.getOperation().hashCode() );
         result = 37 * result + ( getFocusModelId() == null ? 0 : this.getFocusModelId().hashCode() );
         result = 37 * result + ( getCoeffName() == null ? 0 : this.getCoeffName().hashCode() );
         return result;
   }


}


