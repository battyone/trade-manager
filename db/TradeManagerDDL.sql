SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


DROP SCHEMA IF EXISTS ${sql.database};
CREATE SCHEMA IF NOT EXISTS ${sql.database};
SHOW WARNINGS;
USE ${sql.database};

-- -----------------------------------------------------
-- Table EntryLimits
-- -----------------------------------------------------
DROP TABLE IF EXISTS entrylimit ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS entrylimit (
  idEntryLimit INT NOT NULL AUTO_INCREMENT ,
  startPrice DECIMAL(10,2) NOT NULL ,
  endPrice DECIMAL(10,2) NOT NULL ,
  limitAmount DECIMAL(10,2) NULL ,
  percent DECIMAL(10,6) NULL ,
  pivotRange DECIMAL(5,2) NULL ,
  priceRound DECIMAL(10,2) NULL ,
  shareRound INT NULL ,
  version INT NULL,
  PRIMARY KEY (idEntryLimit) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table Contract
-- -----------------------------------------------------
DROP TABLE IF EXISTS contract ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS contract (
  idContract INT NOT NULL AUTO_INCREMENT ,
  category VARCHAR(80) NULL ,
  currency VARCHAR(3) NOT NULL ,
  description VARCHAR(80) NULL ,
  exchange VARCHAR(30) NOT NULL ,
  expiry DATETIME NULL ,
  idContractIB INT NULL ,
  industry VARCHAR(80) NULL ,
  localSymbol VARCHAR(6) NULL ,
  minTick DECIMAL(10,2) NULL ,
  priceMagnifier DECIMAL(10,2) NULL ,
  primaryExchange VARCHAR(10) NULL ,
  symbol VARCHAR(10) NOT NULL ,
  secType VARCHAR(4) NOT NULL ,
  secTypeId VARCHAR(5) NULL ,
  subCategory VARCHAR(80) NULL ,
  tradingClass VARCHAR(80) NULL ,
  version INT NULL,
  PRIMARY KEY (idContract) ,
  UNIQUE INDEX contract_UNIQUE (secType ASC, symbol ASC,exchange ASC,currency ASC) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table TradeAccount
-- -----------------------------------------------------
DROP TABLE IF EXISTS tradeaccount ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS tradeaccount (
  idTradeAccount INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(45) NOT NULL ,
  isDefault TINYINT(1)  NOT NULL ,
  accountNumber VARCHAR(20) NOT NULL ,
  availableFunds DECIMAL(10,2) NULL ,
  buyingPower DECIMAL(10,2) NULL ,
  cashBalance DECIMAL(10,2) NULL ,
  currency VARCHAR(3) NOT NULL ,
  grossPositionValue DECIMAL(10,2) NULL ,
  realizedPnL DECIMAL(10,2) NULL ,
  unrealizedPnL DECIMAL(10,2) NULL ,
  updateDate DATETIME NULL ,
  version INT NULL,
  PRIMARY KEY (idTradeAccount) ,
  UNIQUE INDEX name_UNIQUE (name ASC),
  UNIQUE INDEX accountNumber_UNIQUE (accountNumber ASC) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table TradingDay
-- -----------------------------------------------------
DROP TABLE IF EXISTS tradingday ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS tradingday (
  idTradingDay INT NOT NULL AUTO_INCREMENT ,
  open DATETIME NOT NULL ,
  close DATETIME NOT NULL ,
  marketBias VARCHAR(10) NULL ,
  marketGap VARCHAR(10) NULL ,
  marketBar VARCHAR(10) NULL ,
  version INT NULL,
  PRIMARY KEY (idTradingDay) ,
  UNIQUE INDEX open_UNIQUE (open ASC, close ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table Strategy
-- -----------------------------------------------------
DROP TABLE IF EXISTS strategy ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS strategy (
  idStrategy INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(45) NOT NULL ,
  description VARCHAR(240) NULL ,
  marketData TINYINT(1)  NULL ,
  className VARCHAR(100) NULL ,
  idStrategyManager INT NULL ,
  version INT NULL,
  PRIMARY KEY (idStrategy) ,
  UNIQUE INDEX name_UNIQUE (name ASC) ,
  INDEX fk_Strategy_Strategy1 (idStrategyManager ASC) ,
  CONSTRAINT fk_Strategy_Strategy1
    FOREIGN KEY (idStrategyManager )
    REFERENCES strategy (idStrategy )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION) ENGINE = InnoDB;

SHOW WARNINGS;




-- -----------------------------------------------------
-- Table TradeStrategy
-- -----------------------------------------------------
DROP TABLE IF EXISTS tradestrategy ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS tradestrategy (
  idTradeStrategy INT NOT NULL AUTO_INCREMENT ,
  barSize  INT NULL ,
  chartDays INT NULL ,
  status VARCHAR(20) NULL ,
  riskAmount DECIMAL(10,2) NULL ,
  side VARCHAR(3) NULL ,
  tier VARCHAR(1) NULL ,
  trade TINYINT(1)  NULL ,
  version INT NULL,
  idTradingDay INT NOT NULL ,
  idContract INT NOT NULL ,
  idStrategy INT NOT NULL ,
  idTradeAccount INT NOT NULL ,
  PRIMARY KEY (idTradeStrategy) ,
  INDEX fk_TradeStrategy_TradingDay1 (idTradingDay ASC) ,
  INDEX fk_TradeStrategy_Contract1 (idContract ASC) ,
  INDEX fk_TradeStrategy_Stategy1 (idStrategy ASC) ,
  INDEX fk_Trade_TradeAccount1 (idTradeAccount ASC) ,
  UNIQUE INDEX unique_tradeStrategy (idTradingDay ASC, idContract ASC, idStrategy ASC, idTradeAccount ASC) ,
  CONSTRAINT fk_TradeStrategy_TradingDay1
    FOREIGN KEY (idTradingDay )
    REFERENCES tradingday (idTradingDay )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_TradeStrategy_Contract1
    FOREIGN KEY (idContract )
    REFERENCES contract (idContract )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_TradeStrategy_Stategy1
    FOREIGN KEY (idStrategy )
    REFERENCES strategy (idStrategy )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Trade_TradeAccount1
    FOREIGN KEY (idTradeAccount)
    REFERENCES tradeaccount (idTradeAccount)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  INDEX fk_Trade_TradeStrategy1 (idTradeStrategy ASC)
)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table Trade
-- -----------------------------------------------------
DROP TABLE IF EXISTS trade ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS trade (
  idTrade INT NOT NULL AUTO_INCREMENT ,
  averagePrice DECIMAL(10,2) NULL ,
  isOpen TINYINT(1)  NOT NULL ,
  openQuantity INT NULL ,
  profitLoss DECIMAL(10,2) NULL ,
  side VARCHAR(3) NOT NULL ,
  totalCommission DECIMAL(10,2) NULL ,
  totalQuantity INT NULL ,
  totalValue DECIMAL(10,2) NULL ,
  version INT NULL,
  idTradeStrategy INT NOT NULL ,
  PRIMARY KEY (idTrade) ,
  CONSTRAINT fk_Trade_TradeStrategy1
    FOREIGN KEY (idTradeStrategy )
    REFERENCES tradestrategy (idTradeStrategy )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table TradeOrder
-- -----------------------------------------------------
DROP TABLE IF EXISTS tradeorder ; 

SHOW WARNINGS; 

CREATE  TABLE IF NOT EXISTS tradeorder (
  idTradeOrder INT NOT NULL AUTO_INCREMENT ,
  action VARCHAR(6) NOT NULL ,
  allOrNothing TINYINT(1)  NULL ,
  auxPrice DECIMAL(10,2) NULL ,
  averageFilledPrice DECIMAL(10,2) NULL ,
  clientId INT NULL ,
  commission DECIMAL(10,2) NULL ,
  createDate DATETIME NOT NULL ,
  displayQuantity INT NULL ,
  filledDate DATETIME NULL ,
  filledQuantity INT NULL ,
  goodAfterTime DATETIME NULL ,
  goodTillTime DATETIME NULL ,
  hidden TINYINT(1)  NULL ,
  isFilled TINYINT(1)  NULL ,
  isOpenPosition TINYINT(1)  NULL ,
  limitPrice DECIMAL(10,2) NULL ,
  ocaGroupName VARCHAR(45) NULL ,
  ocaType INT NULL ,
  orderKey INT NOT NULL ,
  orderReference VARCHAR(45) NULL ,
  orderType VARCHAR(10) NOT NULL ,
  overrideConstraints INT NOT NULL ,
  permId INT NULL ,
  parentId INT NULL ,
  quantity INT NOT NULL ,
  timeInForce VARCHAR(3) NOT NULL ,
  status VARCHAR(45) NULL ,
  stopPrice DECIMAL(10,2) NULL ,
  transmit TINYINT(1)  NULL ,
  triggerMethod INT NOT NULL ,
  updateDate DATETIME NOT NULL ,
  warningMessage VARCHAR(200) NULL ,
  whyHeld VARCHAR(45) NULL ,
  version INT NULL,
  idTrade INT NOT NULL ,
  PRIMARY KEY (idTradeOrder) ,
  INDEX fk_TradeOrder_Trade1 (idTrade ASC) ,
  UNIQUE INDEX tradeorderKey_UNIQUE (orderKey ASC) ,
  CONSTRAINT fk_TradeOrder_Trade1
    FOREIGN KEY (idTrade )
    REFERENCES trade (idTrade )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS; 

-- -----------------------------------------------------
-- Table TradeOrderFill
-- -----------------------------------------------------
DROP TABLE IF EXISTS tradeorderfill ;

SHOW WARNINGS; 

CREATE  TABLE IF NOT EXISTS tradeorderfill (
  idTradeOrderFill INT NOT NULL AUTO_INCREMENT ,
  averagePrice DECIMAL(10,2) NULL ,
  cumulativeQuantity INT NULL ,
  exchange VARCHAR(10) NULL ,
  execId VARCHAR(45) NULL ,
  price DECIMAL(10,2) NOT NULL ,
  quantity INT NOT NULL ,
  side VARCHAR(3) NOT NULL ,
  time DATETIME NOT NULL ,
  version INT NULL,
  idTradeOrder INT NOT NULL ,
  PRIMARY KEY (idTradeOrderFill) ,
  INDEX fk_TradeOrderFill_Order1 (idTradeOrder ASC) ,
  UNIQUE INDEX execId_UNIQUE (execId ASC, idTradeOrder ASC) ,
  CONSTRAINT fk_TradeOrderFill_Order1
    FOREIGN KEY (idTradeOrder )
    REFERENCES tradeorder (idTradeOrder )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
SHOW WARNINGS;

-- -----------------------------------------------------
-- Table Candle
-- -----------------------------------------------------
DROP TABLE IF EXISTS candle ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS candle (
  idCandle INT NOT NULL AUTO_INCREMENT ,
  close DECIMAL(10,2) NULL ,
  high DECIMAL(10,2) NULL ,
  low DECIMAL(10,2) NULL ,
  open DECIMAL(10,2) NULL ,
  period VARCHAR(45) NULL ,
  endPeriod DATETIME NULL ,
  startPeriod DATETIME NULL ,
  tradeCount INT NULL ,
  volume INT NULL ,
  vwap DECIMAL(10,2) NULL ,
  barSize INT  NULL ,
  lastUpdateDate DATETIME NULL ,
  version INT NULL,
  idContract INT NOT NULL ,
  idTradingDay INT NOT NULL ,
  PRIMARY KEY (idCandle) ,
  INDEX fk_Candle_Contract1 (idContract ASC) ,
  INDEX fk_Candle_TradingDay1 (idTradingDay ASC) ,
  UNIQUE INDEX uq_Candle (idTradingDay ASC, idContract ASC, startPeriod ASC, endPeriod ASC) ,
  CONSTRAINT fk_Candle_Contract1
    FOREIGN KEY (idContract )
    REFERENCES contract (idContract )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Candle_TradingDay1
    FOREIGN KEY (idTradingDay )
    REFERENCES tradingday (idTradingDay )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table Rule
-- -----------------------------------------------------
DROP TABLE IF EXISTS rule ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS rule (
  idRule INT NOT NULL AUTO_INCREMENT,
  comment VARCHAR(200)  NULL,
  createDate DATETIME NOT NULL,
  rule BLOB NULL,
  version INT NOT NULL,
  updateDate DATETIME NOT NULL,
  idStrategy INT NOT NULL,
  PRIMARY KEY (idRule),
  INDEX fk_Rule_Stategy1 (idStrategy ASC),
  UNIQUE INDEX idStrategy_version_UNIQUE (idStrategy ASC, version ASC),
  CONSTRAINT fk_Rule_Stategy1
    FOREIGN KEY (idStrategy )
    REFERENCES strategy (idStrategy )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table IndicatorSeries
-- -----------------------------------------------------
DROP TABLE IF EXISTS indicatorseries ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS indicatorseries (
  idIndicatorSeries INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL ,
  description VARCHAR(100) NULL ,
  type VARCHAR(51) NOT NULL ,
  displaySeries TINYINT(1) NULL ,
  seriesRGBColor INT NULL ,
  subChart TINYINT(1) NULL ,
  version INT NULL,
  idStrategy INT NULL ,
  PRIMARY KEY (idIndicatorSeries) ,
  INDEX fk_Indicator_Strategy1 (idStrategy ASC) ,
  UNIQUE INDEX indicatorSeries_UNIQUE (idStrategy ASC, type ASC, name ASC),
  CONSTRAINT fk_Indicator_Strategy1
    FOREIGN KEY (idStrategy )
    REFERENCES strategy (idStrategy )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table CodeType
-- -----------------------------------------------------
DROP TABLE IF EXISTS codetype ;

SHOW WARNINGS;

CREATE  TABLE IF NOT EXISTS codetype (
  idCodeType INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(45) NOT NULL ,
  description VARCHAR(100) NULL ,
  version INT NULL,
  PRIMARY KEY (idCodeType) ,
  UNIQUE INDEX name_UNIQUE (name ASC) )
ENGINE = InnoDB;

SHOW WARNINGS;
-- -----------------------------------------------------
-- Table CodeAttribute
-- -----------------------------------------------------
DROP TABLE IF EXISTS codeattribute ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS codeattribute (
  idCodeAttribute INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(45) NOT NULL ,
  description VARCHAR(100) NULL ,
  defaultValue VARCHAR(45) NULL ,
  className VARCHAR(100) NOT NULL ,
  classEditorName VARCHAR(100) NULL ,
  version INT NULL,
  idCodeType INT NOT NULL ,
  PRIMARY KEY (idCodeAttribute) ,
  INDEX fk_CodeAttribute_CodeType1 (idCodeType ASC) ,
  CONSTRAINT fk_CodeAttribute_CodeType1
    FOREIGN KEY (idCodeType )
    REFERENCES codetype (idCodeType )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table CodeValue
-- -----------------------------------------------------
DROP TABLE IF EXISTS codevalue ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS codevalue (
  idCodeValue INT NOT NULL AUTO_INCREMENT ,
  codeValue VARCHAR(45) NOT NULL ,
  version INT NULL,
  idCodeAttribute INT NOT NULL ,
  idIndicatorSeries INT NULL ,
  PRIMARY KEY (idCodeValue) ,
  INDEX fk_CodeValue_CodeAttribute1 (idCodeAttribute ASC) ,
  INDEX fk_CodeValue_IndicatorSeries1 (idIndicatorSeries ASC) ,
  CONSTRAINT fk_CodeValue_CodeAttribute1
    FOREIGN KEY (idCodeAttribute )
    REFERENCES codeattribute (idCodeAttribute )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_CodeValue_IndicatorSeries1
    FOREIGN KEY (idIndicatorSeries )
    REFERENCES indicatorseries (idIndicatorSeries )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
