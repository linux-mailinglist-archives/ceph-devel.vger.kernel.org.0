Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EAE7B773D
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Oct 2023 06:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbjJDEsW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Oct 2023 00:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbjJDEsV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Oct 2023 00:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E98B8
        for <ceph-devel@vger.kernel.org>; Tue,  3 Oct 2023 21:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696394858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQRTY1iLvW//4egG9uk2DBU6FYFkc254H1XeMDqpBg8=;
        b=eG7vlnIPLIDL3MYaHLi2GyyPPNEg4GLkNPf0aWqA59XEdXCKTM8If1PfQW3XlI7+6VT5hz
        10RpRVVEUGCnGlEFP91WM1vq5xYxo3MoZL7dvazQKtG0TCinQ2xZ7r9d3o/5a+NF/kG7qF
        1gFaXsYcOBQ/fjg7a9RqHSETh6izWt0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-7eUzDrloPueD7ZRNek2SXQ-1; Wed, 04 Oct 2023 00:47:35 -0400
X-MC-Unique: 7eUzDrloPueD7ZRNek2SXQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a5d86705e4so151739566b.1
        for <ceph-devel@vger.kernel.org>; Tue, 03 Oct 2023 21:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696394854; x=1696999654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQRTY1iLvW//4egG9uk2DBU6FYFkc254H1XeMDqpBg8=;
        b=a+iqn/N2UQsIWg95ypefuZhY1iPl6wYJ+qSpFnSPrvM96MWTGJoJKt/JZQ/FURLozj
         Q//zd4fxUNoh6b6dvU6C+03vPNZhaev7HlRZTIUWoG3QVAFqzwhKr/WQnZyfHB43/Avo
         o6DgWJzRediZe1mF0V5QujFbYEK9JrGufg0kTcn5KAglLPCYlZC+ImzlvzV5liCi4MoI
         9ktL1fypozDUluvL5ErE744PbeYW2S8qdHgxEUC8XkAAP9evYHhPJ0MqT66whfJL7RER
         /pX/ecHoY8+va1BUNKfiuhOWHaetY1Iat0kzlPfLGYcQOSy6+9kLCfMj37OpVYbSFHIR
         FMWw==
X-Gm-Message-State: AOJu0Yy6dHKy84I0dPtOrl3RSWa0Y6syURSDLLCfs21gjzEISr/awz5K
        vhTPM6m/Rak5GocR9zZ1q9d0HMao2seT/FzjOkml13QSyEgY2O6LqPH5l+jXhtTYjZQ9yxgaKVx
        QnVaBRULkoGGWqLgtvLsUMbqCJzcMixl6XfOUfQ==
X-Received: by 2002:a17:906:738b:b0:9ae:3f7a:f777 with SMTP id f11-20020a170906738b00b009ae3f7af777mr1035761ejl.9.1696394854255;
        Tue, 03 Oct 2023 21:47:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6BQLnNbOIES/4eJakdOfOZDX6AgF3S299BhCHrwoIXdRE0/hgrDGne9CC/uxSOi4WKhNkgnMFcWE2HHGJmrM=
X-Received: by 2002:a17:906:738b:b0:9ae:3f7a:f777 with SMTP id
 f11-20020a170906738b00b009ae3f7af777mr1035747ejl.9.1696394853987; Tue, 03 Oct
 2023 21:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20231003110556.140317-1-vshankar@redhat.com> <CAOi1vP89eWiqUy9yZhWcSzujFre8YSnrCiNMczE_cX3QbDRsEg@mail.gmail.com>
In-Reply-To: <CAOi1vP89eWiqUy9yZhWcSzujFre8YSnrCiNMczE_cX3QbDRsEg@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 4 Oct 2023 10:16:57 +0530
Message-ID: <CACPzV1nwAubtY2dxp88_sNNNA2DU0sOtCaSJiSoKjXcD0LHJQA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ceph: enable async dirops by default"
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

On Tue, Oct 3, 2023 at 5:00=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> wr=
ote:
>
> On Tue, Oct 3, 2023 at 1:06=E2=80=AFPM Venky Shankar <vshankar@redhat.com=
> wrote:
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.
> >
> > We have identified an issue in the MDS affecting CephFS users using
> > the kernel driver. The issue was first introduced in the octopus
> > release that added support for clients to perform asynchronous
> > directory operations using the `nowsync` mount option. The issue
> > presents itself as an MDS crash resembling (any of) the following
> > crashes:
> >
> >         https://tracker.ceph.com/issues/61009
> >         https://tracker.ceph.com/issues/58489
> >
> > There is no apparent data loss or corruption, but since the underlying
> > cause is related to an (operation) ordering issue, the extent of the
> > problem could surface in other forms - most likely MDS crashes
> > involving preallocated inodes.
> >
> > The fix is being reviewed and is being worked on priority:
> >
> >         https://github.com/ceph/ceph/pull/53752
> >
> > As a workaround, we recommend (kernel) clients be remounted with the
> > `wsync` mount option which disables asynchronous directory operations
> > (depending on the kernel version being used, the default could be
> > `nowsync`).
> >
> > This change reverts the default, so, async dirops is disabled (by defau=
lt).
>
> Hi Venky,
>
> Given that the fix is now up and being reviewed on priority, does it
> still make sense to change the default?
>
> According to Xiubo, https://tracker.ceph.com/issues/58489 which morphed
> into https://tracker.ceph.com/issues/61009 isn't the only concern -- he
> also brought up https://tracker.ceph.com/issues/62810.  If the move to
> revert (change of default) is also prompted by that issue, it should be
> described in the patch.

Fair enough -- I'll push out with an updated commit message.

>
> Thanks,
>
>                 Ilya
>


--=20
Cheers,
Venky

