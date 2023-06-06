Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0229723897
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 09:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbjFFHOQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 03:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbjFFHNx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 03:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB89F109
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686035580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMjFM3XnxRPUqgI7qpKI0FERYtyrMR51s21M9DVc/t8=;
        b=dsjiCkA4d1BvKd7VORfINsl7ZGOxbO4KRTivr5eUr6n9+jqS5ClX53Eo119FaEZa2lhfrp
        dT2eAY4ONlH/2u90SJTpdWeSE3yl5cu3aSzPg6dbr/2zInd581aSbMc5/0XGuBaZ6Pn2KT
        BjT5ll1wIjzvXaLlVz8G5hwzjxW7dHU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-etYujqqPNhGKiTARFD8f3A-1; Tue, 06 Jun 2023 03:12:59 -0400
X-MC-Unique: etYujqqPNhGKiTARFD8f3A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a34a0b75eso397753666b.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 00:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686035577; x=1688627577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMjFM3XnxRPUqgI7qpKI0FERYtyrMR51s21M9DVc/t8=;
        b=jq7nylmDwXART068RGi0IQhI2DRAfNinMVsIxgZFl+WTBiZeNxariNd73ARy+lqBmr
         RiNEosUKiTiB+RrZXKUdREXSl1TTIzXZzS+K3Q/Xf8g9EUS6atFDCD3mwq3JvmPOKRku
         EemPwuW219zwCdoLHiNtoeIP8YHx7jiUcIglu4xjFuFUUSKknWEk6p7Vnz8h5DJW4Ybj
         VI1XeVl46GXhKRTcqT/rk2KgNWH9EL4LB8SYr6fR7nQwZwODzI5p1POq0D2CnnOjj0Hw
         lGN9RbUaCOnZZ0OtYx+YjbnCSgSTDTXkQBT8yIVu5qDV7r7fcche3b4vDoHMXY/sGqfd
         V/UA==
X-Gm-Message-State: AC+VfDyHptn1ZDjR2iaEACC02+o0TWQkxuvLeK02rBzS7N416E5g7txI
        DLnHWUhjS6ol2tvxeHkXQSCvE+yutQ2NXn8cIvvRNdHzOiVpZblUIxIhtoOK4+tiYXVZcKCFEKn
        S2jjUreQHjSStNPefndn9Mv3Kr4HkRifgdh8V+4JRtM5Pbw==
X-Received: by 2002:a17:907:7d87:b0:969:7739:2eb7 with SMTP id oz7-20020a1709077d8700b0096977392eb7mr1471384ejc.4.1686035577612;
        Tue, 06 Jun 2023 00:12:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ67P9WRilwouseKrueA/pKk7bEKyMS++4ONEui75/gQjwU6Oad87YUcsubdavLSd3sg+RGbv7Yo+26KvMkhBfo=
X-Received: by 2002:a17:907:7d87:b0:969:7739:2eb7 with SMTP id
 oz7-20020a1709077d8700b0096977392eb7mr1471364ejc.4.1686035577350; Tue, 06 Jun
 2023 00:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230606033212.1068823-1-xiubli@redhat.com> <20230606033212.1068823-3-xiubli@redhat.com>
In-Reply-To: <20230606033212.1068823-3-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 12:42:21 +0530
Message-ID: <CAED=hWAJuga_SYKLHokHm8o8HjEZJ=SDbJ1EvAgG14BLAuFHNw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: just wait the osd requests' callbacks to
 finish when unmounting
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

On Tue, Jun 6, 2023 at 9:04=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The sync_filesystem() will flush all the dirty buffer and submit the
> osd reqs to the osdc and then is blocked to wait for all the reqs to
> finish. But the when the reqs' replies come, the reqs will be removed
> from osdc just before the req->r_callback()s are called. Which means
> the sync_filesystem() will be woke up by leaving the req->r_callback()s
> are still running.
>
> This will be buggy when the waiter require the req->r_callback()s to
> release some resources before continuing. So we need to make sure the
> req->r_callback()s are called before removing the reqs from the osdc.
>
> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_ke=
yring+0x7e/0xd0
> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864=
c #1
> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> generic_shutdown_super+0x47/0x120
> kill_anon_super+0x14/0x30
> ceph_kill_sb+0x36/0x90 [ceph]
> deactivate_locked_super+0x29/0x60
> cleanup_mnt+0xb8/0x140
> task_work_run+0x67/0xb0
> exit_to_user_mode_prepare+0x23d/0x240
> syscall_exit_to_user_mode+0x25/0x60
> do_syscall_64+0x40/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd83dc39e9b
>
> We need to increase the blocker counter to make sure all the osd
> requests' callbacks have been finished just before calling the
> kill_anon_super() when unmounting.
>
> URL: https://tracker.ceph.com/issues/58126
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c  | 10 ++++++++++
>  fs/ceph/super.c | 11 +++++++++++
>  fs/ceph/super.h |  2 ++
>  3 files changed, 23 insertions(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 78ad45567dbb..de9b82905f18 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -284,6 +284,7 @@ static void finish_netfs_read(struct ceph_osd_request=
 *req)
>         }
>         netfs_subreq_terminated(subreq, err, false);
>         iput(req->r_inode);
> +       ceph_dec_osd_stopping_blocker(fsc->mdsc);
>  }
>
>  static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subre=
q)
> @@ -411,6 +412,10 @@ static void ceph_netfs_issue_read(struct netfs_io_su=
brequest *subreq)
>         } else {
>                 osd_req_op_extent_osd_iter(req, 0, &iter);
>         }
> +       if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
> +               err =3D -EIO;
> +               goto out;
> +       }
>         req->r_callback =3D finish_netfs_read;
>         req->r_priv =3D subreq;
>         req->r_inode =3D inode;
> @@ -906,6 +911,7 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
>         else
>                 kfree(osd_data->pages);
>         ceph_osdc_put_request(req);
> +       ceph_dec_osd_stopping_blocker(fsc->mdsc);
>  }
>
>  /*
> @@ -1214,6 +1220,10 @@ static int ceph_writepages_start(struct address_sp=
ace *mapping,
>                 BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages =
- 1]) +
>                              thp_size(pages[locked_pages - 1]) - offset);
>
> +               if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
> +                       rc =3D -EIO;
> +                       goto release_folios;
> +               }
>                 req->r_callback =3D writepages_finish;
>                 req->r_inode =3D inode;
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d3f54f3d7b17..401fe61ea53a 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1524,6 +1524,17 @@ void ceph_dec_mds_stopping_blocker(struct ceph_mds=
_client *mdsc)
>         __dec_stopping_blocker(mdsc);
>  }
>
> +/* For data IO requests */
> +bool ceph_inc_osd_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +       return __inc_stopping_blocker(mdsc);
> +}
> +
> +void ceph_dec_osd_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +       __dec_stopping_blocker(mdsc);
> +}
> +
>  static void ceph_kill_sb(struct super_block *s)
>  {
>         struct ceph_fs_client *fsc =3D ceph_sb_to_client(s);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index cd5b88d819ca..2f9b6fc667b8 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1418,4 +1418,6 @@ extern void ceph_cleanup_quotarealms_inodes(struct =
ceph_mds_client *mdsc);
>  bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
>                                struct ceph_mds_session *session);
>  void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc);
> +bool ceph_inc_osd_stopping_blocker(struct ceph_mds_client *mdsc);
> +void ceph_dec_osd_stopping_blocker(struct ceph_mds_client *mdsc);
>  #endif /* _FS_CEPH_SUPER_H */
> --
> 2.40.1
>


--=20
Milind

