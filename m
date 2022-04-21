Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8D50A093
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 15:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiDUNXB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 09:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiDUNXA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 09:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98F22B1E7
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 06:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qCTLCxWLcLBlr7eIKhMTwQ6Yxa0jc+vMZuubPQOVP7c=;
        b=dE+50B81pvEPTrWDMlYOhD7b5/5caoisCvL5INUxtlRdJYIJ9PiWu87ELRogFLcZhs/HMs
        8D5przLyDAtw7f6bgsjm3LzRQgNQdb1r24X/FXm+mh6mNMDkAp2XGKOjOqhyzjkeRI+Gon
        XWgDnAE+ura5zwl42UKdShDRlEcDCr8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-wlTjyi36PLS9bsxJqsmw0A-1; Thu, 21 Apr 2022 09:20:08 -0400
X-MC-Unique: wlTjyi36PLS9bsxJqsmw0A-1
Received: by mail-lj1-f198.google.com with SMTP id h22-20020a2e9016000000b0024dbafdc47bso1522518ljg.23
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 06:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCTLCxWLcLBlr7eIKhMTwQ6Yxa0jc+vMZuubPQOVP7c=;
        b=CuUFrZH/PNypvv+FUErKT7kpScNNXV1AlASBdxUKFHhZaQ5OY3XO4gzeyR3lMBFWY9
         FWgcFIgGhZ0Ls2djxe39Zrt0bNOj0ucVVdToiosCLH7jSeHeOEhpk0+yclIi+BedzrsL
         8gjQqPhxSTyM/FL3eq/WFxvXNnyKuWrAYZOVjTMcF/n1jYOtj/Yf0jBATbFlEIuvjmGC
         t1+QGixGUvvmrpOjLOwRvsrS5wxA0P3ZaEOTDRMRwj5kexl8PxZp1BWyEjlB2cNEFxuL
         ipJBA+LIsaqC6Lj3QZsQPfUSfdVHxwYzIoQWZ0XxcCFRctGL2966ui08SX8jKIIl+BMZ
         4qHg==
X-Gm-Message-State: AOAM532Q3JidwaTfdg7S792QdMy1xZ/5xg+7lY1F5OMKkOUMS84a6FYk
        0nGBDxeXM/jTArwT8CYzYLtSMsHMdO5Ts0eJ7RYPiFsagG68Hhs/CqXni96sSHLaWlTLQ5gt36B
        ZNrXxg3RVqZVQ9wYZGYwZS1Q3POX1ovRAMh+1xQ==
X-Received: by 2002:a19:ac42:0:b0:448:1f15:4b18 with SMTP id r2-20020a19ac42000000b004481f154b18mr18150291lfc.32.1650547206341;
        Thu, 21 Apr 2022 06:20:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzX0Lq+Q6K9amv63gKJv5g74nL7ePb94x65jdgtHqoFDnc4oXXTNUQXyv0+OYLXdg/lnqg/jaTjx/D8EvufccM=
X-Received: by 2002:a19:ac42:0:b0:448:1f15:4b18 with SMTP id
 r2-20020a19ac42000000b004481f154b18mr18150262lfc.32.1650547205795; Thu, 21
 Apr 2022 06:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220421083619.161391-1-xiubli@redhat.com>
In-Reply-To: <20220421083619.161391-1-xiubli@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 21 Apr 2022 06:19:53 -0700
Message-ID: <CAJ4mKGZzaEB0Sf5kWtJekx0iD1+BZurS-P3caRr06HciLLvfUA@mail.gmail.com>
Subject: Re: [PATCH] ceph: skip reading from Rados if pos exceeds i_size
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 21, 2022 at 1:37 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> Since we have held the Fr capibility it's safe to skip reading from
> Rados if the ki_pos is larger than or euqals to the file size.

I'm not sure this is correct, based on the patch description. If
you're in a mixed mode where there are writers and readers, they can
all have Frw and extend the file size by issuing rados writes up to
the max_size without updating each other. The client needs to have Fs
before it can rely on knowing the file size, so we should check that
before skipping a read, right?
-Greg

>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..330e42b3afec 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1614,7 +1614,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>                 return ret;
>         }
>
> -       if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
> +       if (unlikely(iocb->ki_pos >= i_size_read(inode))) {
> +               ret = 0;
> +       } else if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>             (iocb->ki_flags & IOCB_DIRECT) ||
>             (fi->flags & CEPH_F_SYNC)) {
>
> --
> 2.36.0.rc1
>

