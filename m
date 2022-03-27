Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4454E8871
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Mar 2022 17:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiC0P3E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 27 Mar 2022 11:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiC0P3D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 27 Mar 2022 11:29:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459A813FB0
        for <ceph-devel@vger.kernel.org>; Sun, 27 Mar 2022 08:27:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id u16so16964805wru.4
        for <ceph-devel@vger.kernel.org>; Sun, 27 Mar 2022 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=aCO23HKSt4P6Qx5ktvRU5/PddHSIjWschsN7cgdoQwg=;
        b=XgII2EuLnnVHzU2zvHbpbrDmkSwxAPD5xJxlgRMlZg7juwh4psPu6j88ky3harSHZz
         IucDmYLDcXoXj3PzBIBqTgWQ0y9uTx2UAgBQrsNkWqWUQDmaGJkuecM/BpfiTuZYhF0e
         4O4Efo/ThlSOwPJ/oJSgOPqA18WCWfsADXDj3J9QsVaggsAlYlp8KizQDTqUgDGFUKsn
         oImkfFpTT5unrAle/RqXQyXT3Hjp97h0haPOtCSiGpSjs3BTiFAMwvynyg60y2h8ixOK
         F/sr0iYiMkxeXdOUlhXYDYKZ7VqVYqN2FGeaYUKJX9qzMPVxq8vxZx8t4Yyo91gND97Q
         VhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=aCO23HKSt4P6Qx5ktvRU5/PddHSIjWschsN7cgdoQwg=;
        b=jcSuc4nLsV/1bFhluTgnIT91dHBokOAJo2fxpeo/64L2uoG5LmMCLFBpOgaSp/4Nbz
         Tp69KZoO2xTk69cTxkDtQqMMkbvuTkvAn+2GtkCeqp6jpzeuL+N64YYMaYjWOnlqnmTe
         MxLjc3oG3bx/7KXPKbYSA2oQhMJozYDS5Au8CkhZGKOmSdnMzYbWmKSxARyIRFIrC5Z4
         OyeTUycWk3tqHANw5PLGiwMyGq+UtPOAvQfALG0FSa5EF1iD05yQvY55+ohhvc3PK8lE
         7l9p7N4Ro+/cQnCC+/ivnUjpxbB4Nq1f60LjusUFDCl8OC+EWzAhyzmMRRkOCJyi3mK7
         n9gw==
X-Gm-Message-State: AOAM531Fn+88+YdyypRtFb2YgUGM62H+xI5DheTPQB8HmFOUpO7aqr13
        7hdQmmkjTul5VtXo2vBmEo8=
X-Google-Smtp-Source: ABdhPJxWKsUMkJ1kdUogrVYqPST3oOVJhrHXva4lsNhiHQsvzUDBJKSrp9XN0qOK2VRizdw58LIGtQ==
X-Received: by 2002:adf:8bdd:0:b0:205:b18d:366d with SMTP id w29-20020adf8bdd000000b00205b18d366dmr7287376wra.622.1648394843739;
        Sun, 27 Mar 2022 08:27:23 -0700 (PDT)
Received: from [192.168.0.102] ([105.112.32.237])
        by smtp.gmail.com with ESMTPSA id u11-20020a5d6acb000000b002058148822bsm14160610wrw.63.2022.03.27.08.27.18
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 27 Mar 2022 08:27:23 -0700 (PDT)
Message-ID: <6240825b.1c69fb81.71602.51fd@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Ein_finanzieller_Beitrag_von_915=2E000=2C00_=E2=82=AC=2E?=
To:     ekeleu712@gmail.com
From:   ekeleu712@gmail.com
Date:   Sun, 27 Mar 2022 08:27:11 -0700
Reply-To: samathahoopes734@gmail.com
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hallo,

  Die Li Ka Shing Foundation w=C3=BCnscht Ihnen alles Gute, Ihnen wurde ein=
e finanzielle Spende in H=C3=B6he von 915.000,00 =E2=82=AC zugesprochen. Ko=
ntaktieren Sie mich f=C3=BCr weitere Informationen
