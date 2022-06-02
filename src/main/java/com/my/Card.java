package com.my;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.experimental.Accessors;
import org.hibernate.validator.constraints.Length;
import org.hyperledger.fabric.contract.annotation.DataType;
import org.hyperledger.fabric.contract.annotation.Property;

@DataType
@Data
@Accessors(chain = true)
public class Card {

    @NotBlank(message = "key 不能为空")
    @Property
    String key;

    @NotBlank(message = "name 不能为空")
    @Length(max = 200, message = "name 不能超过200个字符")
    @Property
    String name;

    @NotBlank(message = "imageUrl 不能为空")
    @Length(max = 200, message = "imageUrl 不能超过200个字符")
    @Property
    String imageUrl;

    @Property
    String privateKey;

    @NotBlank(message = "name 不能为空")
    @Property
    String owner;

}
