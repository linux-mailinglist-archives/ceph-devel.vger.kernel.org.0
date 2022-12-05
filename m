Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3B642CAD
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Dec 2022 17:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiLEQUB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Dec 2022 11:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLEQUA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Dec 2022 11:20:00 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30031D32E
        for <ceph-devel@vger.kernel.org>; Mon,  5 Dec 2022 08:19:58 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id s187so7392627oie.10
        for <ceph-devel@vger.kernel.org>; Mon, 05 Dec 2022 08:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=MWS/JvZcJY4EX4Ib+4OihgA0OkKSjDFs6+tKdwzxspueAWB4Fn2g+xKTKxYaa7nexn
         r2F1GJzzo6LHchbmEjQvlx80FEGDEkEZKp6vf6o9B/JUvfeH+VRksZPjcnKE2j/qYbjy
         U4ka9KuEn4J4mAgAPf8PKGI8I1hLPYWVWcQeyD2fVi3HIcvq+HtXVP1x2DKeR2fp9w7X
         al77m9cj5dzVMv4gADpiNdwiJHpCNA0wdInBKyPIfKxis6h1ByVTeYQvjssoOHngimO/
         NralOY8A7K5rlhI7MEWYPkFues8oa1G/Vjvi1VUn5snwpYglbh0edUzjgRwpukgbPAmo
         E+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=bit5XpUcUoo382jAsSL9Ff0IpiEQODxBugn4a6h5tv9LS2mpWOPTO+XgxazvVKdq9S
         Dzhei6rKDSlKaSYie0Q9orkiyr5j++L9W+xMnWG6YTr8a/oSYwlUnal9n7HIWtlynu4t
         +ozNJlcgkc1AbuWRe2wG9VikvjwF5whxzn4I0geimzRZS+0Z+nvJZUGrC3vZr27YFI4a
         0tdgTBliMdZSGArbLrNYPsSooqYWsrfbeFUozqRc8UABuTi35yQc0O3Kv3MS4Wc5HZSh
         fTNnnMz9vUJ+mGIxlDaUyxBW3RDYkW4ARQY29icoat1LBu+FFcza9IPBI08juncxeAwZ
         b80g==
X-Gm-Message-State: ANoB5pnNVO9r1K0+wMnzFS3PGR7QNfZ28SyDIeTp6+jZ/UnaJh/gRCNm
        eTzEBEeA3Ao9J8TDSWQzruC5EnVRlHzVUUqtxi4=
X-Google-Smtp-Source: AA0mqf4uRGKJ3oooc36JNyAWEF37CrYjULOinQvEyC3sVRqncK/YSl2TY80IxChZQEj+8UWY8RTR4aQHpiPdCp9T8b0=
X-Received: by 2002:a05:6808:1905:b0:35b:e3c4:c1ab with SMTP id
 bf5-20020a056808190500b0035be3c4c1abmr9883226oib.204.1670257198329; Mon, 05
 Dec 2022 08:19:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6870:5ccc:b0:143:84e0:abae with HTTP; Mon, 5 Dec 2022
 08:19:57 -0800 (PST)
Reply-To: phmanu212@hotmail.com
From:   Philip Manul <phmanu005@gmail.com>
Date:   Mon, 5 Dec 2022 08:19:57 -0800
Message-ID: <CAFKg=da0EWkSKYRYDQ_5Oahkxs+dkp2LZf0PFquCgKUSm5Q_sQ@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.
