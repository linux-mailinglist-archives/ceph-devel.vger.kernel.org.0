Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD05412C0
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 21:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356482AbiFGTyM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 15:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358627AbiFGTwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 15:52:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB4A033A1E
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 11:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654626096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lLecFFHXRpdB7uUyPccCZkVXjsYC2e07njf3e6qCZ4w=;
        b=RpvkE87XmM4TslqeRYMeuCkFfKBxCTPL85+XA388UgoEWVigIJHgYkJNfBtF6avOyxnwF/
        AbJa55b3h3pBDAfghwS46JC/Ehle6/LlQYqtPv0YAIKsAXbhs2eT/IAIQM9ZjRx5/x+kJZ
        y86U2Gs70mY6LDKRvAQhanObJXqrb7M=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-SVyRqpV6ODK7WwXN-stl-Q-1; Tue, 07 Jun 2022 14:21:34 -0400
X-MC-Unique: SVyRqpV6ODK7WwXN-stl-Q-1
Received: by mail-qt1-f199.google.com with SMTP id s7-20020ac85cc7000000b00304e11cb41fso9605431qta.4
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 11:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=lLecFFHXRpdB7uUyPccCZkVXjsYC2e07njf3e6qCZ4w=;
        b=NS/qagKpkCVTvlLIZRW6WAzxImVi9M7YgMwLBhspTMKxeJp5QPx8UsmV95aSWIBmiy
         V+imPv5OrcTUrQW9bvak8x7CLUc8mg3sIVY5Z9CipBuvsVgz9fANkJW9KcSljb76Q7g1
         KYcJKNYd0DNO/VgARw24yVihx6RSgkt81xpwBYhEfvgfcL5mLYwCdP7XEhG8yuc01Xnc
         uT++W65fX9MAYuJ5kpy34VfBa88C+hn4JuBf6N0MY0/0oHJdCTh6LCvQbbB9ANpeZi9K
         DWiSRr+NmcoA8I+5ezTJ0UJ7AgNiUQ4tiFOUGUYTLq8kKhZ8BKQtcKvDpHXU8iDfIJTF
         qJ9g==
X-Gm-Message-State: AOAM533e2Gn81ftH5fn0U2bCcST4KxLD+kaxGrYU987lE/N9F2KYd54M
        ryWPgHi5v7jW4724aEs3wP1TH8NEshHoiJwzmzvzlkis6vxFGa2hCskLX5XE5kZOslqRTRp9moX
        HAAL7BPN+d4Z8RRBURdKes5X132/OYFAeX8rmZbZ5gikuhyV7ogom8wCberqd+DY4YwGcdGNv
X-Received: by 2002:a05:620a:d4c:b0:6a6:2df0:4d97 with SMTP id o12-20020a05620a0d4c00b006a62df04d97mr20116744qkl.478.1654626094118;
        Tue, 07 Jun 2022 11:21:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzj7QoWPhTLJpflY+/I6kF4Wy2Uj83OoP90uT9RDuTMOQJvdqevOPTFPBvxtTULjbQ+mriwsA==
X-Received: by 2002:a05:620a:d4c:b0:6a6:2df0:4d97 with SMTP id o12-20020a05620a0d4c00b006a62df04d97mr20116712qkl.478.1654626093696;
        Tue, 07 Jun 2022 11:21:33 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g11-20020a05620a40cb00b006a69f6793c5sm10626516qko.14.2022.06.07.11.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:21:33 -0700 (PDT)
Message-ID: <8ea706f2b7eec229c645e5c122689f5acc087671.camel@redhat.com>
Subject: cephfs snapc writeback order
From:   Jeff Layton <jlayton@redhat.com>
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>
Cc:     Xiubo Li <xiubli@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 07 Jun 2022 14:21:32 -0400
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I'm taking a stab at converting ceph to use the netfs write helpers. One
thing I'm seeing though is that the kclient takes great care to write
back data to the OSDs in order of snap context age, such that an older
snapc will get written back before a newer one. With the netfs helpers,
that may not happen quite as naturally. We may end up with it trying to
flush data for a newer snapc ahead of the older one.

My question is: is that necessarily a problem? We'd be sending along the
correct info from the capsnap for each snapc, which seems like it should
be sufficient to ensure that the writes get applied correctly. If we
were to send these out of order, what would break and how?
--=20
Jeff Layton <jlayton@redhat.com>

