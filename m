Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F18723859
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 09:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbjFFHFj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjFFHFh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 03:05:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D80EA
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686035086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVEPuiEJ6BkZV7Gbk74X/sPF2AH33d4/YTqBvQj5xLY=;
        b=FwuP6ywbN2hGfcvCQhQxfn/Nkkf8FVKGUIAFOK2kf7P0XtifFMKuuUD/on4o9WylX3p6nE
        LDCfEfvJVwwd7o53t5kxU0cBQ1P8rtNkJdwF/5GdzaMVcky2OU1La3CsHKodTuPtIMBGD6
        ki8JzSD7Rym3+RXu57hK90CdFB0oUcY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-flqfjj7tP4asK1Sk1eqsyg-1; Tue, 06 Jun 2023 03:04:45 -0400
X-MC-Unique: flqfjj7tP4asK1Sk1eqsyg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-976c92459cbso292039466b.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 00:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686035084; x=1688627084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVEPuiEJ6BkZV7Gbk74X/sPF2AH33d4/YTqBvQj5xLY=;
        b=iUIVHM+lmB/IaKLuC7C0E2dEYVNIP1g7qt8Qc/4FTyde2ZsZADTuCc+EHCkhK2bpXX
         h9mnFDWGSaJiONbIjTxu39wbkpT/msSabApijwpIRDIv/A0ewt9lJvw9K4mu+BPz20hT
         bFMmbA1FCjfFiYF1XHT2kJLY84qw/eDLpwrItkB9jjfYCqK5M1W/4Pv/zYwkn2XqQmJm
         6SwujOSO8xXXg+JDcWSZ9UiBjo/2RB5I90kOJI/dh0fiDc7Oj9azNWZvwHBewFkTP+rn
         /nes3X4ePRMaEVp+nVAAwAJkqw26LdjUtUDjsNKnOE3yTyH0P25Hj5qQEdt/mHt5KTRB
         pTNg==
X-Gm-Message-State: AC+VfDxUj8DZntZYoYjSRyDaz8xlpBohTseORI71SFX3N6+YKQMw/C5i
        fDNBMssY6UbS3oVBKe8LycGWihhBAPCnTAN/okkqB9eXOKW++oPJ0khDTj9V7L02qkrT4iCFiNX
        LsGxmL1Bt2tAkq8LnBaPqeSsWRNCAc23lQTMyaQ==
X-Received: by 2002:a17:907:7f2a:b0:974:1e0e:9bd4 with SMTP id qf42-20020a1709077f2a00b009741e0e9bd4mr1348321ejc.16.1686035084073;
        Tue, 06 Jun 2023 00:04:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ymDIXJHjhG9Elmc3TTJp/64bJ+TyOxXOhilQjQWl+PdHVgl+qUAot1MIWgrhM8/JzRtVO8gRznR3EHX9XWJQ=
X-Received: by 2002:a17:907:7f2a:b0:974:1e0e:9bd4 with SMTP id
 qf42-20020a1709077f2a00b009741e0e9bd4mr1348305ejc.16.1686035083678; Tue, 06
 Jun 2023 00:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230417032654.32352-1-xiubli@redhat.com> <20230417032654.32352-69-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-69-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 12:34:07 +0530
Message-ID: <CAED=hWCO3f5L-7VkJL+=baWcDwZ79prm6v7DmxcGVNTND587Zw@mail.gmail.com>
Subject: Re: [PATCH v19 68/70] ceph: fix updating the i_truncate_pagecache_size
 for fscrypt
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Mon, Apr 17, 2023 at 9:03=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When fscrypt is enabled we will align the truncate size up to the
> CEPH_FSCRYPT_BLOCK_SIZE always, so if we truncate the size in the
> same block more than once, the latter ones will be skipped being
> invalidated from the page caches.
>
> This will force invalidating the page caches by using the smaller
> size than the real file size.
>
> At the same time add more debug log and fix the debug log for
> truncate code.
>
> URL: https://tracker.ceph.com/issues/58834
> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Tested-by: Venky Shankar <vshankar@redhat.com>
> Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c  |  4 ++--
>  fs/ceph/inode.c | 35 ++++++++++++++++++++++++-----------
>  2 files changed, 26 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index e1bb6d9c16f8..3c5450f9d825 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3929,8 +3929,8 @@ static bool handle_cap_trunc(struct inode *inode,
>         if (IS_ENCRYPTED(inode) && size)
>                 size =3D extra_info->fscrypt_file_size;
>
> -       dout("handle_cap_trunc inode %p mds%d seq %d to %lld seq %d\n",
> -            inode, mds, seq, truncate_size, truncate_seq);
> +       dout("%s inode %p mds%d seq %d to %lld truncate seq %d\n",
> +            __func__, inode, mds, seq, truncate_size, truncate_seq);
>         queue_trunc =3D ceph_fill_file_size(inode, issued,
>                                           truncate_seq, truncate_size, si=
ze);
>         return queue_trunc;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 1cfcbc39f7c6..059ebe42367c 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -763,7 +763,7 @@ int ceph_fill_file_size(struct inode *inode, int issu=
ed,
>                         ceph_fscache_update(inode);
>                 ci->i_reported_size =3D size;
>                 if (truncate_seq !=3D ci->i_truncate_seq) {
> -                       dout("truncate_seq %u -> %u\n",
> +                       dout("%s truncate_seq %u -> %u\n", __func__,
>                              ci->i_truncate_seq, truncate_seq);
>                         ci->i_truncate_seq =3D truncate_seq;
>
> @@ -787,15 +787,26 @@ int ceph_fill_file_size(struct inode *inode, int is=
sued,
>                         }
>                 }
>         }
> -       if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >=3D 0 &&
> -           ci->i_truncate_size !=3D truncate_size) {
> -               dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
> -                    truncate_size);
> +
> +       /*
> +        * It's possible that the new sizes of the two consecutive
> +        * size truncations will be in the same fscrypt last block,
> +        * and we need to truncate the corresponding page caches
> +        * anyway.
> +        */
> +       if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >=3D 0) {
> +               dout("%s truncate_size %lld -> %llu, encrypted %d\n", __f=
unc__,
> +                    ci->i_truncate_size, truncate_size, !!IS_ENCRYPTED(i=
node));
> +
>                 ci->i_truncate_size =3D truncate_size;
> -               if (IS_ENCRYPTED(inode))
> +
> +               if (IS_ENCRYPTED(inode)) {
> +                       dout("%s truncate_pagecache_size %lld -> %llu\n",
> +                            __func__, ci->i_truncate_pagecache_size, siz=
e);
>                         ci->i_truncate_pagecache_size =3D size;
> -               else
> +               } else {
>                         ci->i_truncate_pagecache_size =3D truncate_size;
> +               }
>         }
>         return queue_trunc;
>  }
> @@ -2150,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
de)
>  retry:
>         spin_lock(&ci->i_ceph_lock);
>         if (ci->i_truncate_pending =3D=3D 0) {
> -               dout("__do_pending_vmtruncate %p none pending\n", inode);
> +               dout("%s %p none pending\n", __func__, inode);
>                 spin_unlock(&ci->i_ceph_lock);
>                 mutex_unlock(&ci->i_truncate_mutex);
>                 return;
> @@ -2162,8 +2173,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
de)
>          */
>         if (ci->i_wrbuffer_ref_head < ci->i_wrbuffer_ref) {
>                 spin_unlock(&ci->i_ceph_lock);
> -               dout("__do_pending_vmtruncate %p flushing snaps first\n",
> -                    inode);
> +               dout("%s %p flushing snaps first\n", __func__, inode);
>                 filemap_write_and_wait_range(&inode->i_data, 0,
>                                              inode->i_sb->s_maxbytes);
>                 goto retry;
> @@ -2174,7 +2184,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
de)
>
>         to =3D ci->i_truncate_pagecache_size;
>         wrbuffer_refs =3D ci->i_wrbuffer_ref;
> -       dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
> +       dout("%s %p (%d) to %lld\n", __func__, inode,
>              ci->i_truncate_pending, to);
>         spin_unlock(&ci->i_ceph_lock);
>
> @@ -2361,6 +2371,9 @@ static int fill_fscrypt_truncate(struct inode *inod=
e,
>                 header.data_len =3D cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_=
BLOCK_SIZE);
>                 header.file_offset =3D cpu_to_le64(orig_pos);
>
> +               dout("%s encrypt block boff/bsize %d/%lu\n", __func__,
> +                    boff, CEPH_FSCRYPT_BLOCK_SIZE);
> +
>                 /* truncate and zero out the extra contents for the last =
block */
>                 memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
>
> --
> 2.39.1
>


--=20
Milind

