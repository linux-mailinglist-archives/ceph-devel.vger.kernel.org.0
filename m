Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895474B964D
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 04:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiBQDEN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 22:04:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiBQDEM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 22:04:12 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E2F23BF38
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 19:03:58 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id w4so4752689vsq.1
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 19:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrdvGKbptPcrdymwpDHTV5m3GS8h1iRQwhNOti4Sz98=;
        b=G/T2KuegvyUPPS8EUMKGVyM8ib/sA2D2CPVN2kffcJ2Lbo8/xQlWmFv5r3TXdkhWT/
         Y9+x/wDMxHIbXFhzqCmRgEROfl1HOHcbnrBF0uXfyHyJl5gtF5HNtbtYQSoR3SpiKhk9
         XzZdWd5A9slGaQBQ/eaSE2v0anPVOfbRCyk6f5t+YnBx5eEC3XbmhKdlas/AytXwcsj9
         0cT+FisyxDReKqcOuYeYkvR6zPn+lXPcfg7hwT7AETdSB7eOGud+v8zGiqi8U3YmmKep
         rBN9IsvHEgdpxNoZ7pT6HMA1la/Fp6Df8USqWSAkdWEqIl1CBbiA1QYsGwqqazJlZMxQ
         0X1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrdvGKbptPcrdymwpDHTV5m3GS8h1iRQwhNOti4Sz98=;
        b=QJ/LdZa7IzhXXsQkWHHEqvzQYc7inJfOtvACxMkUAZrBwvn2bGCN6mJ+x5+AqA2lIm
         KeLP1hesDytBZpxlrvZ0FA8Wy8g9K0K0vZXc9UMwQio6P0gkKvJG3FA3sXtmYj5ncwzn
         z/Jz085ToTLPOfPeYL2v/e9o9ndREsvaq5hl9kNSv2xaKpV409hFCLZYCspsQr+6i+Zk
         6NO60BnyMzuTQeWsh2GhrPGbCIX+DT26rnrtIq0Lgax/K0H08qZkBPvgR1Bgz+RdHDHF
         TZdXVVewDS7nu3WVXZYiTYdzjA1H7eT21lEYfatcaLXXznnGjTAgn15hKFrX29NLWXqV
         ma8Q==
X-Gm-Message-State: AOAM533lXniWfFyIGChmHgketGumruE/gVGP2yVg9aMVCMUkgOS7vVSL
        2TIzx4a5P7Q/0AFnQDkzg6dHwkPKyMo+vIeX8j8=
X-Google-Smtp-Source: ABdhPJw58/pWDBKTyFOS9zvrRepwTh+ha7JSSbzrdcZIHpJfdfSe5q8JQlPaOkEZWX2ae5mq7J5Z4gkgivAyMdTg0oc=
X-Received: by 2002:a67:e005:0:b0:31b:74eb:1005 with SMTP id
 c5-20020a67e005000000b0031b74eb1005mr381853vsl.50.1645067037864; Wed, 16 Feb
 2022 19:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20220215122316.7625-1-xiubli@redhat.com> <20220215122316.7625-4-xiubli@redhat.com>
In-Reply-To: <20220215122316.7625-4-xiubli@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 17 Feb 2022 11:03:46 +0800
Message-ID: <CAAM7YAn8QtZZORXbczE4cLdvGrrEW=AeaAM22f9EK4YNopo+qg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is no
 new snapshot
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 15, 2022 at 11:04 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> No need to update snapshot context when any of the following two
> cases happens:
> 1: if my context seq matches realm's seq and realm has no parent.
> 2: if my context seq equals or is larger than my parent's, this
>    works because we rebuild_snap_realms() works _downward_ in
>    hierarchy after each update.
>
> This fix will avoid those inodes which accidently calling
> ceph_queue_cap_snap() and make no sense, for exmaple:
>
> There have 6 directories like:
>
> /dir_X1/dir_X2/dir_X3/
> /dir_Y1/dir_Y2/dir_Y3/
>
> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
> make a root snapshot under /.snap/root_snap. And every time when
> we make snapshots under /dir_Y1/..., the kclient will always try
> to rebuild the snap context for snap_X2 realm and finally will
> always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
> no sense.
>
> That's because the snap_X2's seq is 2 and root_snap's seq is 3.
> So when creating a new snapshot under /dir_Y1/... the new seq
> will be 4, and then the mds will send kclient a snapshot backtrace
> in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
> it will always rebuild the from the last realm, that's the root_snap.
> So later when rebuilding the snap context it will always rebuild
> the snap_X2 realm and then try to queue cap snaps for all the inodes
> related in snap_X2 realm, and we are seeing the logs like:
>
> "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index d075d3ce5f6d..1f24a5de81e7 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>                 num += parent->cached_context->num_snaps;
>         }
>
> -       /* do i actually need to update?  not if my context seq
> -          matches realm seq, and my parents' does to.  (this works
> -          because we rebuild_snap_realms() works _downward_ in
> -          hierarchy after each update.) */
> +       /* do i actually need to update? No need when any of the following
> +        * two cases:
> +        * #1: if my context seq matches realm's seq and realm has no parent.
> +        * #2: if my context seq equals or is larger than my parent's, this
> +        *     works because we rebuild_snap_realms() works _downward_ in
> +        *     hierarchy after each update.
> +        */
>         if (realm->cached_context &&
> -           realm->cached_context->seq == realm->seq &&
> -           (!parent ||
> -            realm->cached_context->seq >= parent->cached_context->seq)) {
> +           ((realm->cached_context->seq == realm->seq && !parent) ||
> +            (parent && realm->cached_context->seq >= parent->cached_context->seq))) {

With this change. When you mksnap on  /dir_Y1/, its snap context keeps
unchanged. In ceph_update_snap_trace, reset the 'invalidate' variable
for each realm should fix this issue.

>                 dout("build_snap_context %llx %p: %p seq %lld (%u snaps),
>                      " (unchanged)\n",
>                      realm->ino, realm, realm->cached_context,
> --
> 2.27.0
>
