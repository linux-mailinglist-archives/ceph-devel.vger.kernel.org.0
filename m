Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBC6E3BB3
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Apr 2023 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDPTt2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 15:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDPTt1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 15:49:27 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869C510F1
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 12:49:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id vc20so3971737ejc.10
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 12:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681674563; x=1684266563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMoof6hLl9fQAvUBM3Pz6SB0XfGA0bNURNO+NO7ypLA=;
        b=dbbmYFEmAUrfYWah5HBCvdASP1caY43aQE6YTzKYT1VheW2GqjV0mId8M8K5Zu+QWH
         yLFa/8DQq6/37DyGlAmq6xn5jNwvxMzL10bqWRt0NsOuibTcadYbZq8Zo6Cg7CNvpIJ9
         mgD1SHicDKLzpGEn+C9wBYlkY6YMopTXNAbdvmeXecIS25xHwySAGrhVpcOpIKndxdru
         OGhxXeK5clS+SVBZ7Hh3KskG6cX/K1Y44/NtKLiKMe8sNlA6rf+4NJGu+KLCO+z1y0MD
         zJ03cbU5/B352kJ8XjvO9MUDx9XaqAhF46YXInjT1YEHoLASzddHE+Y+UeRR+1mziaBn
         jnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681674563; x=1684266563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMoof6hLl9fQAvUBM3Pz6SB0XfGA0bNURNO+NO7ypLA=;
        b=HFwg1sfj4ifTyO9LuOe1ux45radBSz2UKjma5NaWGW95AmTsj8TzExSkqzlBEF/sO/
         dURoQVRqDipEP6SygAZ9DlRbkzimi5ulx8d/RdFsF46f7VYywA8nH0yFoWPq9XEgQxB2
         TYL/xQHkqQUih16irAfdHc8n9PyLoMrRwmDTLaQrp2Uvz4d/a9e0ffYIB/zNuPgol/hn
         B5zogF9tuuNZZ0retG2i1PGaZ/vxpePZfC06ix4YbQpYGuDR/LXz/tl/84ueSSvdq6bw
         4qdgX9Omdgq4zSxyzpCH6taD29WAwiBdnh3Y/LQyeaCpql9V+68hdcku9J0GGI+VuyA1
         hA9A==
X-Gm-Message-State: AAQBX9dBWlfOp4M4z6sw7tPRndEhC/rgeNQch/XBy5s1rdRsQtx3b2tg
        /8jQnxmWBs9UNher7ycXxRmopEGACKG43+vudkY=
X-Google-Smtp-Source: AKy350a1oBadphDYcPj4SS9Ct3eYq/+VAxgqKzE7r0x9ygOp9VrPH1eAKn4RU0bZRx1VEul0UcuZW7eNc12VPmt/azc=
X-Received: by 2002:a17:906:c355:b0:94f:b5c:a254 with SMTP id
 ci21-20020a170906c35500b0094f0b5ca254mr5009609ejb.49.1681674562728; Sun, 16
 Apr 2023 12:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230412110930.176835-1-xiubli@redhat.com> <20230412110930.176835-68-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-68-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 16 Apr 2023 21:49:10 +0200
Message-ID: <CAOi1vP_AY=R4w9BZbEXAZwr2MUNjJJXyWzji0EPSgbhL25ip=w@mail.gmail.com>
Subject: Re: [PATCH v18 67/71] libceph: defer removing the req from osdc just
 after req->r_callback
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 12, 2023 at 1:15=E2=80=AFPM <xiubli@redhat.com> wrote:
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
> URL: https://tracker.ceph.com/issues/58126
> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Tested-by: Venky Shankar <vshankar@redhat.com>
> Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 78b622178a3d..db3d93d3e692 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -2507,7 +2507,7 @@ static void submit_request(struct ceph_osd_request =
*req, bool wrlocked)
>         __submit_request(req, wrlocked);
>  }
>
> -static void finish_request(struct ceph_osd_request *req)
> +static void __finish_request(struct ceph_osd_request *req)
>  {
>         struct ceph_osd_client *osdc =3D req->r_osdc;
>
> @@ -2516,12 +2516,6 @@ static void finish_request(struct ceph_osd_request=
 *req)
>
>         req->r_end_latency =3D ktime_get();
>
> -       if (req->r_osd) {
> -               ceph_init_sparse_read(&req->r_osd->o_sparse_read);
> -               unlink_request(req->r_osd, req);
> -       }
> -       atomic_dec(&osdc->num_requests);
> -
>         /*
>          * If an OSD has failed or returned and a request has been sent
>          * twice, it's possible to get a reply and end up here while the
> @@ -2532,13 +2526,46 @@ static void finish_request(struct ceph_osd_reques=
t *req)
>         ceph_msg_revoke_incoming(req->r_reply);
>  }
>
> +static void __remove_request(struct ceph_osd_request *req)
> +{
> +       struct ceph_osd_client *osdc =3D req->r_osdc;
> +
> +       dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
> +
> +       if (req->r_osd) {
> +               ceph_init_sparse_read(&req->r_osd->o_sparse_read);
> +               unlink_request(req->r_osd, req);
> +       }
> +       atomic_dec(&osdc->num_requests);
> +}
> +
> +static void finish_request(struct ceph_osd_request *req)
> +{
> +       __finish_request(req);
> +       __remove_request(req);
> +}
> +
>  static void __complete_request(struct ceph_osd_request *req)
>  {
> +       struct ceph_osd_client *osdc =3D req->r_osdc;
> +       struct ceph_osd *osd =3D req->r_osd;
> +
>         dout("%s req %p tid %llu cb %ps result %d\n", __func__, req,
>              req->r_tid, req->r_callback, req->r_result);
>
>         if (req->r_callback)
>                 req->r_callback(req);
> +
> +       down_read(&osdc->lock);
> +       if (osd) {
> +               mutex_lock(&osd->lock);
> +               __remove_request(req);
> +               mutex_unlock(&osd->lock);
> +       } else {
> +               atomic_dec(&osdc->num_requests);
> +       }
> +       up_read(&osdc->lock);

Hi Xiubo,

I think it was highlighted before that this patch is wrong so I'm
surprised to see it in this series, broken out and with a different
subject.

On top of changing long-standing behavior which is purposefully
consistent with Objecter behavior in userspace, it also seems to
introduce a race condition with ceph_osdc_cancel_request() which can
lead, among other things, to a use-after-free on req.  Consider what
would happen if the request is cancelled while the callback is running:
since it would still be linked at that point, cancel_request() would be
allowed to go through and eventually put the messenger's reference.

Thanks,

                Ilya
