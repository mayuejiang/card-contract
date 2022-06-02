package com.my;

import com.alibaba.fastjson.JSON;
import com.google.common.collect.Lists;
import lombok.extern.java.Log;
import org.apache.commons.collections4.IterableUtils;
import org.apache.commons.lang3.StringUtils;
import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.*;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ledger.KeyValue;
import org.hyperledger.fabric.shim.ledger.QueryResultsIterator;
import org.hyperledger.fabric.shim.ledger.QueryResultsIteratorWithMetadata;

import java.util.List;
import java.util.logging.Level;

@Contract(
        name = "CardContract",
        transactionSerializer = "com.my.ValidationJSONTransactionSerializer",
        info = @Info(
                title = "Card contract",
                description = "card contract",
                version = "0.0.1-SNAPSHOT",
                license = @License(
                        name = "Apache 2.0 License",
                        url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
                contact = @Contact(
                        email = "card@example.com",
                        name = "Card contract",
                        url = "https://hyperledger.example.com")))
@Default
@Log
public class CardContract implements ContractInterface {

    @Transaction
    public Card createCard2(Context ctx, Card card) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(card.getKey());

        if (StringUtils.isNotBlank(cardState)) {
            String errorMessage = String.format("User %s already exists", card.getKey());
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }

        stub.putStringState(card.getKey(), JSON.toJSONString(card));

        return card;
    }

    @Transaction
    public Card createCard(final Context ctx, final String key, String name, String imageUrl, String privateKey, String owner) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(key);

        if (StringUtils.isNotBlank(cardState)) {
            String errorMessage = String.format("Card %s already exists", key);
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }

        Card card = new Card().setKey(key)
                .setName(name)
                .setImageUrl(imageUrl)
                .setPrivateKey(privateKey)
                .setOwner(owner);

        String json = JSON.toJSONString(card);
        stub.putStringState(key, json);

        stub.setEvent("createCardEvent", org.apache.commons.codec.binary.StringUtils.getBytesUtf8(json));
        return card;
    }

    @Transaction
    public Card updateCard(final Context ctx, final String key, String name, String imageUrl, String privateKey, String owner) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(key);

        if (StringUtils.isBlank(cardState)) {
            String errorMessage = String.format("Card %s does not exist", key);
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }

        Card card = new Card().setKey(key)
                .setName(name)
                .setImageUrl(imageUrl)
                .setPrivateKey(privateKey)
                .setOwner(owner);

        String json = JSON.toJSONString(card);
        stub.putStringState(key, JSON.toJSONString(card));

        stub.setEvent("updateCardEvent", org.apache.commons.codec.binary.StringUtils.getBytesUtf8(json));
        return card;
    }

    @Transaction
    public Card changeCardOwner(final Context ctx, final String key, String newOwner) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(key);

        if (StringUtils.isBlank(cardState)) {
            String errorMessage = String.format("Card %s does not exist", key);
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }
        Card card = JSON.parseObject(cardState , Card.class);
        card.setOwner(newOwner);

        String json = JSON.toJSONString(card);
        stub.putStringState(key, JSON.toJSONString(card));

        stub.setEvent("changeCardOwner", org.apache.commons.codec.binary.StringUtils.getBytesUtf8(json));
        return card;
    }
    @Transaction
    public Card deleteCard(final Context ctx, final String key) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(key);

        if (StringUtils.isBlank(cardState)) {
            String errorMessage = String.format("Card %s does not exist", key);
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }

        stub.delState(key);

        stub.setEvent("deleteCardEvent", org.apache.commons.codec.binary.StringUtils.getBytesUtf8(cardState));
        return JSON.parseObject(cardState, Card.class);
    }

    @Transaction
    public Card getCard(final Context ctx, final String key) {
        ChaincodeStub stub = ctx.getStub();
        String cardState = stub.getStringState(key);

        if (StringUtils.isBlank(cardState)) {
            String errorMessage = String.format("Card %s does not exist", key);
            log.log(Level.ALL, errorMessage);
            throw new ChaincodeException(errorMessage);
        }

        return JSON.parseObject(cardState , Card.class);
    }

    @Transaction
    public CardQueryResultList queryCardByName(final Context ctx, String name) {

        log.info(String.format("使用 name 查询 card , name = %s", name));

        String query = String.format("{\"selector\":{\"name\":\"%s\"} , \"use_index\":[\"_design/indexCardDoc\", \"indexCard\"]}", name);

        log.info(String.format("query string = %s", query));
        return queryCard(ctx.getStub(), query);
    }

    @Transaction
    public CardQueryResultList queryCardByImageUrl(final Context ctx, String imageUrl) {
        log.info(String.format("使用 imageUrl 查询 card , imageUrl = %s", imageUrl));

        String query = String.format("{\"selector\":{\"imageUrl\":\"%s\"} , \"use_index\":[\"_design/indexCardDoc\", \"indexCard\"]}", imageUrl);

        log.info(String.format("query string = %s", query));
        return queryCard(ctx.getStub(), query);
    }

    @Transaction
    public CardQueryResultList queryCardByOwner(final Context ctx, String owner) {
        log.info(String.format("使用 owner 查询 card , owner = %s", owner));

        String query = String.format("{\"selector\":{\"owner\":\"%s\"} , \"use_index\":[\"_design/indexCardDoc\", \"indexCard\"]}", owner);

        log.info(String.format("query string = %s", query));
        return queryCard(ctx.getStub(), query);
    }

    @Transaction
    public CardQueryResultList queryCardByPrivateKey(final Context ctx, String privateKey) {
        log.info(String.format("使用 privateKey 查询 card , privateKey = %s", privateKey));

        String query = String.format("{\"selector\":{\"privateKey\":\"%s\"} , \"use_index\":[\"_design/indexCardDoc\", \"indexCard\"]}", privateKey);

        log.info(String.format("query string = %s", query));
        return queryCard(ctx.getStub(), query);
    }

    private CardQueryResultList queryCard(ChaincodeStub stub, String query) {
        CardQueryResultList resultList = new CardQueryResultList();
        QueryResultsIterator<KeyValue> queryResult = stub.getQueryResult(query);
        List<CardQueryResult> results = Lists.newArrayList();

        if (!IterableUtils.isEmpty(queryResult)) {
            for (KeyValue kv : queryResult) {
                results.add(new CardQueryResult().setKey(kv.getKey()).setCard(JSON.parseObject(kv.getStringValue(), Card.class)));
            }
            resultList.setCards(results);
        }

        return resultList;
    }

    @Transaction
    public CardQueryPageResult queryCardPageByOwner(final Context ctx, String owner , Integer pageSize , String bookmark) {
        log.info(String.format("使用 name 分页查询 card , owner = %s" , owner));

        String query = String.format("{\"selector\":{\"owner\":\"%s\"} , \"use_index\":[\"_design/indexCardDoc\", \"indexCard\"]}", owner);

        log.info(String.format("query string = %s" , query));

        ChaincodeStub stub = ctx.getStub();
        QueryResultsIteratorWithMetadata<KeyValue> queryResult = stub.getQueryResultWithPagination(query, pageSize, bookmark);

        List<CardQueryResult> cards = Lists.newArrayList();

        if (! IterableUtils.isEmpty(queryResult)) {
            for (KeyValue kv : queryResult) {
                cards.add(new CardQueryResult().setKey(kv.getKey()).setCard(JSON.parseObject(kv.getStringValue() , Card.class)));
            }
        }

        return new CardQueryPageResult()
                .setCats(cards)
                .setBookmark(queryResult.getMetadata().getBookmark());
    }

    @Override
    public void beforeTransaction(Context ctx) {
        log.info("*************************************** beforeTransaction ***************************************");
    }

    @Override
    public void afterTransaction(Context ctx, Object result) {
        log.info("*************************************** afterTransaction ***************************************");
        System.out.println("result --------> " + result);
    }
}
