package com.my;

import lombok.Data;
import lombok.experimental.Accessors;
import org.hyperledger.fabric.contract.annotation.DataType;
import org.hyperledger.fabric.contract.annotation.Property;

import java.util.List;

@DataType
@Data
@Accessors(chain = true)
public class CardQueryPageResult {

    @Property
    String bookmark;

    @Property
    List<CardQueryResult> cats;
}
