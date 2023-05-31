Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0C4717DB7
	for <lists+ceph-devel@lfdr.de>; Wed, 31 May 2023 13:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbjEaLKO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 07:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjEaLKM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 07:10:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF848E;
        Wed, 31 May 2023 04:10:11 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9707313e32eso1045061666b.2;
        Wed, 31 May 2023 04:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685531409; x=1688123409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIvNVQs4ofAz17cCAArRP+RXzewXOY2O28nwlAxGqNc=;
        b=aLo7ylkRaX4yT5BI+8yPoXCuvp9GpFaT9jlVS5PzM/NCPHYBWj+3JA6hKKqHzJKoPi
         9jD81/0lp2UQbqVGxlXX3lp4D1ykJovedeIB3LLBpWhr84hy3Vzx6h2RwLEObFGvnA65
         2Shg7J0T20txrrBfE5wF6y1QEp6/KiSsQmN+kDivEeX+01+XA32SdizB88AkMP3fqUTO
         oeS7ajn5bKA2xbQDN7fNNUop+R1WgomxxVuzMb3bJlFNLKicl3xx+OFryVuifA0ufQAk
         ZI2Owpsj/loN2z6gzO+gJzCV60p4K/T44iopC/2FAEAhblMdY2Es/ihhpWKtlEh2+eHS
         LdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685531409; x=1688123409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sIvNVQs4ofAz17cCAArRP+RXzewXOY2O28nwlAxGqNc=;
        b=WN6eDtjLVOEAlbBXErYN6kLAORWBZFnBffIlxl8LQPtHAjXnTEQ752Hf1mIxuIua6J
         Bih7veZJ6jQ3kVegBgijpl+aqwgpTzQsXm9A223ABFmLneIWn+0kfBx3ixtAuGO5fX/n
         Vn0UbSTr7ag67v8mig1oNTkAWiOc9i/LCMgI7498o6IIUKmByAbGN9xFcJ/EQiXrduE4
         ZqKeMv7OKB9RxsJ/kNtnrnTAelYoHTHUUyg+24vqbmsk38v1GgZY8tJEizKb//T9etZj
         47k4n1yNjAWlRowhwcb2DUNSMUoLwmorMC/zUUtJdmeTGid31bjaWRlSakP6x2+Pr7kT
         NVVw==
X-Gm-Message-State: AC+VfDxyVGdhb2gN/NlQM3hsOgkGzCh4Yd/5uaiUXjBt6dtV125xY0fZ
        +a1jgRSquAl28Sx7i0x7yyIhYOogi/yLHQTmI6y0PN1wcxA=
X-Google-Smtp-Source: ACHHUZ7dzEhstXrYIOH0VyCOofnTnSScpVIBYAGgTghnmI2+SrQIILg47vf+NAAnAN7cArJZGCke6ikqnLpBdM5G5hw=
X-Received: by 2002:a17:907:7f8d:b0:96b:6fb:38d6 with SMTP id
 qk13-20020a1709077f8d00b0096b06fb38d6mr5427167ejc.65.1685531409281; Wed, 31
 May 2023 04:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230525024438.507082-1-xiubli@redhat.com>
In-Reply-To: <20230525024438.507082-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 31 May 2023 13:09:56 +0200
Message-ID: <CAOi1vP8aR=fnbUnpOSJ1yA6Je5c4tS3Ks4xMb10dymYv+y2EgQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix use-after-free bug for inodes when flushing capsnaps
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 25, 2023 at 4:45=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is racy between capsnaps flush and removing the inode from
> 'mdsc->snap_flush_list' list:
>
>    Thread A                            Thread B
> ceph_queue_cap_snap()
>  -> allocate 'capsnapA'
>  ->ihold('&ci->vfs_inode')
>  ->add 'capsnapA' to 'ci->i_cap_snaps'
>  ->add 'ci' to 'mdsc->snap_flush_list'
>     ...
> ceph_flush_snaps()
>  ->__ceph_flush_snaps()
>   ->__send_flush_snap()
>                                 handle_cap_flushsnap_ack()
>                                  ->iput('&ci->vfs_inode')
>                                    this also will release 'ci'
>                                     ...
>                                 ceph_handle_snap()
>                                  ->flush_snaps()
>                                   ->iterate 'mdsc->snap_flush_list'
>                                    ->get the stale 'ci'
>  ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>    'mdsc->snap_flush_list'           will WARNING
>
> To fix this we will remove the 'ci' from 'mdsc->snap_flush_list'
> list just before '__send_flush_snaps()' to make sure the flushsnap
> 'ack' will always after removing the 'ci' from 'snap_flush_list'.

Hi Xiubo,

I'm not sure I'm following the logic here.  If the issue is that the
inode can be released by handle_cap_flushsnap_ack(), meaning that ci is
unsafe to dereference after the ack is received, what makes e.g. the
following snippet in __ceph_flush_snaps() work:

    ret =3D __send_flush_snap(inode, session, capsnap, cap->mseq,
                            oldest_flush_tid);
    if (ret < 0) {
            pr_err("__flush_snaps: error sending cap flushsnap, "
                   "ino (%llx.%llx) tid %llu follows %llu\n",
                    ceph_vinop(inode), cf->tid, capsnap->follows);
    }

    ceph_put_cap_snap(capsnap);
    spin_lock(&ci->i_ceph_lock);

If the ack is handled after capsnap is put but before ci->i_ceph_lock
is reacquired, could use-after-free occur inside spin_lock()?

Thanks,

                Ilya

>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2209299
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index feabf4cc0c4f..a8f890b3bb9a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1595,6 +1595,11 @@ static void __ceph_flush_snaps(struct ceph_inode_i=
nfo *ci,
>
>         dout("__flush_snaps %p session %p\n", inode, session);
>
> +       /* we will flush them all; remove this inode from the queue */
> +       spin_lock(&mdsc->snap_flush_lock);
> +       list_del_init(&ci->i_snap_flush_item);
> +       spin_unlock(&mdsc->snap_flush_lock);
> +
>         list_for_each_entry(capsnap, &ci->i_cap_snaps, ci_item) {
>                 /*
>                  * we need to wait for sync writes to complete and for di=
rty
> @@ -1726,10 +1731,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>                 *psession =3D session;
>         else
>                 ceph_put_mds_session(session);
> -       /* we flushed them all; remove this inode from the queue */
> -       spin_lock(&mdsc->snap_flush_lock);
> -       list_del_init(&ci->i_snap_flush_item);
> -       spin_unlock(&mdsc->snap_flush_lock);
>  }
>
>  /*
> --
> 2.40.1
>
