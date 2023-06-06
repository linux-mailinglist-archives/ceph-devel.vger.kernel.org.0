Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE15A723F43
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 12:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjFFKVt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 06:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbjFFKVq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 06:21:46 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC9910C0;
        Tue,  6 Jun 2023 03:21:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51491b87565so8961692a12.1;
        Tue, 06 Jun 2023 03:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686046902; x=1688638902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7UEfI/Erv3W3ZEVRFTc3W31/8PLdp7v7zZBSbWxNB8=;
        b=Nv9VzI6O7823qTU4xRZwhzgpyo40+TBRlMebFRz1nEh15ZMtDYmxOfhYDO/+Vl9PbG
         WzuSH16ADLBSSeve0QvFmNSPlZbRfUtT/CHzI9E/2XC3R8WsZT1Qqis/sLyeu7ttfZ+n
         bkWSUs7a6C0eeZ6Liq+aC4frWfkYqJqhkEXAxIy7bWPXMXdb4qCsLJiS8sZTV85FVWdR
         OO8hcCy+o7bppfMxjM1x02c7bSutEdwfJd4nXcvoywF5Vzc9WX3VbqstTfCMr2S7ZptO
         nh8oHPeDjDkMBVRMIbpjIp6AxS/r+AQXttb3k8eVmkUOhR8Y0pp1tUEEC0HgoFmSIKTd
         q0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686046902; x=1688638902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7UEfI/Erv3W3ZEVRFTc3W31/8PLdp7v7zZBSbWxNB8=;
        b=aO7UV+xdoLTeB0/5ry5GBWMgprsE7uZvchFRJqK2Dy8sOriyWpwDqqtRoj8AZB7lcs
         870HCaHAd9FKDvOmkgTQNy+89rVVg06j+fLN2kzTFncv32F+WXohEXnrybN3y+RM1yd0
         9/XOpqm/PsN12vyf0GHzdhjLUQtaomBlnnUXn1iUdGCDZdp7QobncaH33J4b9Vu0I3gk
         fxlZaXvFTvHCamEftk6ErB87ugQOICb+wTGyUf1VgK68G0+M9V0II3GDkQoy/PBnK38F
         3rxk+JNUuIBJw4cLLQAOM3UTccTe2obe8uJfH+Nr2O4gb9ZH3ECUBZmk6IyvI7fLoydP
         xFgg==
X-Gm-Message-State: AC+VfDzQoSxyv8ut2MmKyKkM9p3e8WpfOCiXZl4aW0+97SyA6nl1EZAU
        ubhnv7fLs1V8yIaQGwYnAlJGqicppfVYN2+UnchzNpj5NxY=
X-Google-Smtp-Source: ACHHUZ64XbyFj2SSOfcdcCGfXUCrX1bGSSOiWao9j94cuOutA01pXHNl5cGbPvsqcLhfVWWPCJlSm3PBcv/YcwNDpIg=
X-Received: by 2002:a17:907:6d1d:b0:94b:4a4:2836 with SMTP id
 sa29-20020a1709076d1d00b0094b04a42836mr1737959ejc.69.1686046901878; Tue, 06
 Jun 2023 03:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230606005253.1055933-1-xiubli@redhat.com>
In-Reply-To: <20230606005253.1055933-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 6 Jun 2023 12:21:29 +0200
Message-ID: <CAOi1vP_Xr6iMgjo7RKtc4-oZdF_FX7_U3Wx4Y=REdpa4Gj7Oig@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix use-after-free bug for inodes when flushing capsnaps
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
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

On Tue, Jun 6, 2023 at 2:55=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is a race between capsnaps flush and removing the inode from
> 'mdsc->snap_flush_list' list:
>
>    =3D=3D Thread A =3D=3D                     =3D=3D Thread B =3D=3D
> ceph_queue_cap_snap()
>  -> allocate 'capsnapA'
>  ->ihold('&ci->vfs_inode')
>  ->add 'capsnapA' to 'ci->i_cap_snaps'
>  ->add 'ci' to 'mdsc->snap_flush_list'
>     ...
>    =3D=3D Thread C =3D=3D
> ceph_flush_snaps()
>  ->__ceph_flush_snaps()
>   ->__send_flush_snap()
>                                 handle_cap_flushsnap_ack()
>                                  ->iput('&ci->vfs_inode')
>                                    this also will release 'ci'
>                                     ...
>                                       =3D=3D Thread D =3D=3D
>                                 ceph_handle_snap()
>                                  ->flush_snaps()
>                                   ->iterate 'mdsc->snap_flush_list'
>                                    ->get the stale 'ci'
>  ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>    'mdsc->snap_flush_list'           will WARNING
>
> To fix this we will increase the inode's i_count ref when adding 'ci'
> to the 'mdsc->snap_flush_list' list.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2209299
> Reviewed-by: Milind Changire <mchangir@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - Fix two minor typo in commit comments.
>
>
>
>  fs/ceph/caps.c | 6 ++++++
>  fs/ceph/snap.c | 4 +++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index feabf4cc0c4f..7c2cb813aba4 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1684,6 +1684,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>         struct inode *inode =3D &ci->netfs.inode;
>         struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
>         struct ceph_mds_session *session =3D NULL;
> +       int put =3D 0;

Hi Xiubo,

Nit: renaming this variable to need_put and making it a bool would
communicate the intent better.

>         int mds;
>
>         dout("ceph_flush_snaps %p\n", inode);
> @@ -1728,8 +1729,13 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>                 ceph_put_mds_session(session);
>         /* we flushed them all; remove this inode from the queue */
>         spin_lock(&mdsc->snap_flush_lock);
> +       if (!list_empty(&ci->i_snap_flush_item))
> +               put++;

What are the cases when ci is expected to not be on snap_flush_list
list (and therefore there is no corresponding reference to put)?

The reason I'm asking is that ceph_flush_snaps() is called from two
other places directly (i.e. without iterating snap_flush_list list) and
then __ceph_flush_snaps() is called from two yet other places.  The
problem that we are presented with here is that __ceph_flush_snaps()
effectively consumes a reference on ci.  Is ci protected from being
freed by handle_cap_flushsnap_ack() very soon after __send_flush_snap()
returns in all these other places?

Thanks,

                Ilya
