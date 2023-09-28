Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB47B17F6
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Sep 2023 11:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjI1J7H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Sep 2023 05:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjI1J7F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Sep 2023 05:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF8195
        for <ceph-devel@vger.kernel.org>; Thu, 28 Sep 2023 02:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695895092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3P5lzYqknlqp9XQ0Q5vHYT4lpq4MfVBbEwOgSILB4A=;
        b=MtFYY+JawleRnaYbbpImUSK4nsDz6UcaPmzomod7jP5G1ip3mOU7W5M9EdBGEVZITH7mSB
        XczUy+of5obpgVL+OQ9SSA+0xcA1+/7fPok9pESjv571I/9PLxMfuludKUlE4kXyDiaUGx
        Lp2u9Rl1eTju61MyWe6IZfHyTOgAH2E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-0-QEoLfNMzyK8wLaRKb_yA-1; Thu, 28 Sep 2023 05:58:10 -0400
X-MC-Unique: 0-QEoLfNMzyK8wLaRKb_yA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-99bebfada8cso1087056166b.1
        for <ceph-devel@vger.kernel.org>; Thu, 28 Sep 2023 02:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695895089; x=1696499889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3P5lzYqknlqp9XQ0Q5vHYT4lpq4MfVBbEwOgSILB4A=;
        b=TEFYsxqmNqEez1drgGjx1hCkl8Y0dnRm1ert4AB/mkxpJ3xxBt6lZ9RMKoyy+lJScM
         upfuY0SFKNXYqjbFujaoK75E7pMxJT6sk13NrrRmWhxmChOKzNRRjHJTyNTqOgyuxDmN
         QluCwOZK5OjP+iv2tmtwx1VPmMZ8gcYA/Ufa1boJTNqRhpXSFpwK39Rq5V2es4NIGPJq
         7fU/U9ZRT1+tlsCSY8gWKFLfNbdv0wF50ucx6ith8xevqfBXH6a7YtxVw0ivuWNyTx36
         6xUUzr1m7tAgSc9ABlna9TJ7/WHX+vCJF75fTun0FX+FfvW1P6zke8svvSYTaZaBgteo
         91NQ==
X-Gm-Message-State: AOJu0Yyr4+xVp35ANLMdSbRRKf1LrSYRIlDUpPQLJFnX/kyYEy7D2BP1
        Nkoc2lwkHnJ/SyjQbC1SEmpVY1WFAmMHcI7wrQ9ZLxR7MYIDtazhyrT5kfKJKbN0ictguL65Jdp
        ACBehCJPgheFRc4jYOL4qWHasm3UC9kMjnMMngw==
X-Received: by 2002:a17:907:c205:b0:9ad:7d5c:52f5 with SMTP id ti5-20020a170907c20500b009ad7d5c52f5mr812088ejc.75.1695895089215;
        Thu, 28 Sep 2023 02:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrQPwphiqtHS/oYMaQXbql7FP87mgScDvlTGdQg67hH/Ker2oPKx/452KYf0B5sMuP35cIark9FBwoaBG+hCo=
X-Received: by 2002:a17:907:c205:b0:9ad:7d5c:52f5 with SMTP id
 ti5-20020a170907c20500b009ad7d5c52f5mr812076ejc.75.1695895088888; Thu, 28 Sep
 2023 02:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230927013009.151922-1-xiubli@redhat.com>
In-Reply-To: <20230927013009.151922-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 28 Sep 2023 15:27:32 +0530
Message-ID: <CACPzV1nvrxFmjEgAwtVvoPYneWjj7dksJT9wJS4GYtQ3=LCEpw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ceph: enable async dirops by default"
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
        mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 7:02=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.
>
> The async dirop is buggy and introduce several bugs in MDS side
> and not stable yet. Let's disable it for now and enable it later
> when it's ready.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 4 ++--
>  fs/ceph/super.h | 3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5ec102f6b1ac..2bf6ccc9887b 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -742,8 +742,8 @@ static int ceph_show_options(struct seq_file *m, stru=
ct dentry *root)
>         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>                 seq_show_option(m, "recover_session", "clean");
>
> -       if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> -               seq_puts(m, ",wsync");
> +       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> +               seq_puts(m, ",nowsync");
>         if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
>                 seq_puts(m, ",nopagecache");
>         if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 7f4b62182a5d..a5476892896c 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -47,8 +47,7 @@
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
>         (CEPH_MOUNT_OPT_DCACHE |                \
> -        CEPH_MOUNT_OPT_NOCOPYFROM |            \
> -        CEPH_MOUNT_OPT_ASYNC_DIROPS)
> +        CEPH_MOUNT_OPT_NOCOPYFROM)
>
>  #define ceph_set_mount_opt(fsc, opt) \
>         (fsc)->mount_options->flags |=3D CEPH_MOUNT_OPT_##opt
> --
> 2.41.0
>

LGTM.

Requires an explanation on the issue and its impact - let's add that in.

--=20
Cheers,
Venky

