package HolaPerroApp;

import java.util.logging.Logger;

import ufro.Animales.IHolaPerroOperations;
import ufro.Animales.IHolaPerroPOATie;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ComponentHelper;


public class helperPerro extends ComponentHelper
{

        public helperPerro(Logger containerLogger)
        {
                super(containerLogger);
        }


        protected ComponentLifecycle _createComponentImpl()
        {
                return new Perro();
        }


        protected Class _getPOATieClass()
        {
                return IHolaPerroPOATie.class;
        }


        protected Class _getOperationsInterface()
        {
                return IHolaPerroOperations.class;
        }

}
