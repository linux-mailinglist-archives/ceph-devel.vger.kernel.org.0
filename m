Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38E67236EA
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 07:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjFFFlH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 01:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjFFFlF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 01:41:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625A1B1
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 22:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686030019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNj96iRj+D3NjufM5OmyICxiReZ516AMETfb6BF/YTc=;
        b=Hwh+B5z43EHrND2SO/E/nptxRws3vU1Z6pJqug9sgVX9AZxwZaX/yhM10XqHjVLmdn6j4n
        /C0FIbxMtCjTU8E8NG061O4iNjbaqW8a+CnylArKBN0STCvrPRFVdomRVQoSg/6tQyXxbR
        3nixSMa8rStOkjc/MTJe8tkT4dKImnM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-kJM9lS-AOpahvtx6KoXPUA-1; Tue, 06 Jun 2023 01:40:18 -0400
X-MC-Unique: kJM9lS-AOpahvtx6KoXPUA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso388138266b.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 22:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686030017; x=1688622017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNj96iRj+D3NjufM5OmyICxiReZ516AMETfb6BF/YTc=;
        b=hLpP3TfMkVnnUEvDJIqwJ4WhjMfPtGYQOaVl8jFO5u9qr2NYTw5QwhAri8X/Uf2ljm
         5eq5Kw+6mO5M6tjdNwk9EjJ6CiXfzV+wZobC2/TV6TCfpcCIq28CrtML/a7L45ASQUpZ
         raIsBKTIZeGssydTXpT4Eo/QMbaJSUrKCrABJyofRIU7R5F7n8MLTQ9tE+Q6iRcFvSQA
         WhfPZr7BvImEWg/CRfVHkGr55+ZUuKPFokDH8sfy/ClSp6U3pPe7JMnsakiVEWjUmUdf
         Vhgf1CKVoR/PB83r/Y1WYXI1c+IwestoqIZTzaPPppgInHdiMeyncf+TS3dDOhyufrf7
         xISw==
X-Gm-Message-State: AC+VfDzstSCC7Kit7Zaqq2DUqrf5/3Pf48MbWoC6tpO2G3uu+fMJEAoh
        AcG8rEjKRGjnYMNPn+msO2YAuYVzkqQ1j2WOsmK412HkEXFJCjS+VMkTYRcBc4Ojelj0ePBUOJw
        oXCgzatDy9Zy89+qBy+zsvQibSvN2DNiw0s/8ag==
X-Received: by 2002:a17:907:360a:b0:978:6fbf:869c with SMTP id bk10-20020a170907360a00b009786fbf869cmr670563ejc.16.1686030017023;
        Mon, 05 Jun 2023 22:40:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6I6EHzAJ1B/aG3+5h1HB5uadcn6as7vz8FTZZa9bgQxdkqYUncjwHHXdN12ztbVxyG+WzfuOfV1ch4AyinZCA=
X-Received: by 2002:a17:907:360a:b0:978:6fbf:869c with SMTP id
 bk10-20020a170907360a00b009786fbf869cmr670556ejc.16.1686030016780; Mon, 05
 Jun 2023 22:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230511100911.361132-1-xiubli@redhat.com>
In-Reply-To: <20230511100911.361132-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 11:09:40 +0530
Message-ID: <CAED=hWDrOOgaXsJNjmoVm2zE=NfMySo_=mbZdsRnC=gEqdGywg@mail.gmail.com>
Subject: Re: [PATCH] ceph: trigger to flush the buffer when making snapshot
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
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

On Thu, May 11, 2023 at 3:43=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The 'i_wr_ref' is used to track the 'Fb' caps, while whenever the 'Fb'
> caps is took the kclient will always take the 'Fw' caps at the same
> time. That means it will always be a false check in __ceph_finish_cap_sna=
p().
>
> When writing to buffer the kclient will take both 'Fb|Fw' caps and then
> write the contents to the buffer pages by increasing the 'i_wrbuffer_ref'
> and then just release both 'Fb|Fw'. This is different with the user
> space libcephfs, which will keep the 'Fb' being took and use 'i_wr_ref'
> instead of 'i_wrbuffer_ref' to track this until the buffer is flushed
> to Rados.
>
> We need to defer flushing the capsnap until the corresponding buffer
> pages are all flushed to Rados, and at the same time just trigger to
> flush the buffer pages immediately.
>
> URL: https://tracker.ceph.com/issues/59343
> URL: https://tracker.ceph.com/issues/48640
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 6 ++++++
>  fs/ceph/snap.c | 9 ++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 2732f46532ec..feabf4cc0c4f 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3168,6 +3168,12 @@ static void __ceph_put_cap_refs(struct ceph_inode_=
info *ci, int had,
>         }
>         if (had & CEPH_CAP_FILE_WR) {
>                 if (--ci->i_wr_ref =3D=3D 0) {
> +                       /*
> +                        * The Fb caps will always be took and released
> +                        * together with the Fw caps.
> +                        */
> +                       WARN_ON_ONCE(ci->i_wb_ref);
> +
>                         last++;
>                         check_flushsnaps =3D true;
>                         if (ci->i_wrbuffer_ref_head =3D=3D 0 &&
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 23b31600ee3c..0e59e95a96d9 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -676,14 +676,17 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *=
ci,
>                 return 0;
>         }
>
> -       /* Fb cap still in use, delay it */
> -       if (ci->i_wb_ref) {
> +       /*
> +        * Defer flushing the capsnap if the dirty buffer not flushed yet=
.
> +        * And trigger to flush the buffer immediately.
> +        */
> +       if (ci->i_wrbuffer_ref) {
>                 dout("%s %p %llx.%llx cap_snap %p snapc %p %llu %s s=3D%l=
lu "
>                      "used WRBUFFER, delaying\n", __func__, inode,
>                      ceph_vinop(inode), capsnap, capsnap->context,
>                      capsnap->context->seq, ceph_cap_string(capsnap->dirt=
y),
>                      capsnap->size);
> -               capsnap->writing =3D 1;
> +               ceph_queue_writeback(inode);
>                 return 0;
>         }
>
> --
> 2.40.0
>


--=20
Milind

