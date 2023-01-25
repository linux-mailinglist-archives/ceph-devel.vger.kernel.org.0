Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DE167B7A3
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jan 2023 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbjAYQ6q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Jan 2023 11:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbjAYQ62 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Jan 2023 11:58:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3001F2F7BE
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jan 2023 08:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674665860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cAEaw8HiPlM7EY8wn5KFaKp72RNaFDqGJwJhY8IK2Ik=;
        b=T4kDeZTLRtdGnN9SrOd9mTVDBpLU0TrCDDQXm4OoAQ/IH/g1+Caud0tkY9nxdjJJzZ8iOL
        aEQqXTC8ogMGydOTnTGhEu4B57n/hE1if4yMr9qqZ/AYjarzmigT9kfJaEUqxGukgw+Lx/
        uSb+zCSNhbxBl5tAQb1Rs5m5VMQVtcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-S4SmSNPiMvaURlgX8hsKmw-1; Wed, 25 Jan 2023 11:57:35 -0500
X-MC-Unique: S4SmSNPiMvaURlgX8hsKmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C79B87B2A6;
        Wed, 25 Jan 2023 16:57:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 715AF40444C3;
        Wed, 25 Jan 2023 16:57:34 +0000 (UTC)
Date:   Wed, 25 Jan 2023 11:57:32 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     ceph-devel@vger.kernel.org, vromanso@redhat.com, kwolf@redhat.com,
        mimehta@redhat.com, acardace@redhat.com
Subject: rbd kernel block driver memory usage
Message-ID: <Y9FffDxl2sa9762M@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ya7Pq02Fh2YWndUg"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--Ya7Pq02Fh2YWndUg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
What sort of memory usage is expected under heavy I/O to an rbd block
device with O_DIRECT?

For example:
- Page cache: none (O_DIRECT)
- Socket snd/rcv buffers: yes
- Internal rbd buffers?

I am trying to understand how similar Linux rbd block devices behave
compared to local block device memory consumption (like NVMe PCI).

Thanks,
Stefan

--Ya7Pq02Fh2YWndUg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPRX3wACgkQnKSrs4Gr
c8j4yAgApVfE9BoYgudAOjNQT0B3PtJG8dOakuO1vbdD02aNAuApbF3a6yITxqfL
03JUbqEJClVMjM3hU3KAgILJ2m9OhDwf7Tj/2L0wlUdsyGKWs4vDwKW1YIau8sBW
QM8LzNm4NWIl5xll/kCIDFSRMBqxAfTeoP5XaB5QrihcQjtd6XkDqyfArAW+4pN8
UHe8aI+DvYSrXQvGbBh5CCs3YfaSgoY4ep+55pda31Ar+CgU2Oyrm3wScGgSfcTM
Rl7q/845yDpnwivEDEPDTjayBouQ9cSjOHwz2a2OlMumB7jgXXUKj8HaZ7TPSNen
HZ04O93AYWHXtCuWjlc8qdku14BOAQ==
=quGu
-----END PGP SIGNATURE-----

--Ya7Pq02Fh2YWndUg--

