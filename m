Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7635C29626
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 12:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390749AbfEXKnB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 06:43:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37443 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390739AbfEXKm7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 06:42:59 -0400
Received: by mail-io1-f68.google.com with SMTP id u2so7398607ioc.4
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 03:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lmr98IZUw+i+lmIfwf6Wvj6wU7FuPFI2LjIopaw52D4=;
        b=eLsLVGlouk0GRTjD9c4/MIazBCYcvlEvYSuUQZNToU9OA1+APK9xNWsHvXpWUr3qP0
         9IZB8UlyznOoUizDH3ZvNDCOWnrebswky7TjnqkXbQ2Bf3F61XDBmSQVuDzzV056Xycb
         6EYr5grtvTEG8ItfMybcKfQJNyypqrexyPCPQLUjBs7uMTVTBXyMC+Ox53mo74IbcqkB
         TwMPvM28PxSyZ8cma3H85bncf5pdIAg5DINqGFpPSkDMBCjQD6H2OdIDtPkl01MidFHL
         zjPTzk15FbUmXntNBnZ0GuuHm7vqQubNcdQX4adzSEShLEYeJOIARQ0EoxZw11PpyuJX
         xaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lmr98IZUw+i+lmIfwf6Wvj6wU7FuPFI2LjIopaw52D4=;
        b=kyLfa3b45/+9570M9Aglaf708NlA+k/1rfK/c6sWzSctKY2W45w8bPefPs1AnpzQcg
         oD4KmpP1eJ1vL4576ZMt/HD0WjJh0phnCRHMX/4jCge1zJMlRumDGPJovE7JKA4RE94g
         63wmQ43yowOEsGm2BKOLcXKLcN0DpyHTIWPAwpJVrZDHPRTGMBbdxKNG42miXoJkrKWj
         5C6NrB2MdFKHLx86fHSTDUPE869Wg+rHjZNBT2aaiRP/kn7u7aBZvoy4RXjpb5htFBVJ
         jPUzlLO24+lfkjWedACxYt9M4MFMGd4HpqY2oAexVb++cwENcupPjGgW3N2Kr6i8Algg
         mWqw==
X-Gm-Message-State: APjAAAXfbKryi4jllFQM5gA2sOHg8Y8XgRmn2mbcSPTl9hjaAg/ObrW9
        r+3hFVBzUr+a/WaLK61ucfua4RzDDl7HJIFIzXZ06Api
X-Google-Smtp-Source: APXvYqziH1ULe9xTp7eNiYB2YlIRHAxa7hPTagUpRWZFc663mN7syuFYTHZBabnU/3QS5j6teuJt/XS/5umzvvHXA5A=
X-Received: by 2002:a5d:991a:: with SMTP id x26mr9725882iol.112.1558694578857;
 Fri, 24 May 2019 03:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190430120534.5231-1-xxhdx1985126@gmail.com> <20190430120534.5231-2-xxhdx1985126@gmail.com>
In-Reply-To: <20190430120534.5231-2-xxhdx1985126@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 24 May 2019 12:41:24 +0200
Message-ID: <CAOi1vP8aBw8-GO1Y8J4CNLZtZkxTrvg4JCGL1Qg8Gn_phQtSsw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: use cephfs cgroup contoller to limit client ops
To:     xxhdx1985126@gmail.com
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 2:07 PM <xxhdx1985126@gmail.com> wrote:
>
> From: Xuehan Xu <xuxuehan@360.cn>
>
> Signed-off-by: Xuehan Xu <xuxuehan@360.cn>
> ---
>  fs/ceph/mds_client.c            | 34 +++++++++++++++++++++++++-
>  fs/ceph/mds_client.h            |  9 +++++++
>  fs/ceph/super.c                 |  5 +++-
>  include/linux/ceph/osd_client.h | 11 ++++++++-
>  include/linux/ceph/types.h      |  1 -
>  net/ceph/ceph_common.c          |  2 +-
>  net/ceph/ceph_fs.c              |  1 -
>  net/ceph/osd_client.c           | 42 +++++++++++++++++++++++++++++++++
>  8 files changed, 99 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9049c2a3e972..4ba6b4de0f64 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -20,6 +20,10 @@
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/debugfs.h>
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +#include <linux/cgroup_cephfs.h>
> +#endif
> +
>  #define RECONNECT_MAX_SIZE (INT_MAX - PAGE_SIZE)
>
>  /*
> @@ -689,6 +693,9 @@ void ceph_mdsc_release_request(struct kref *kref)
>         struct ceph_mds_request *req = container_of(kref,
>                                                     struct ceph_mds_request,
>                                                     r_kref);
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    kfree(req->qitem.tokens_requested);
> +#endif
>         destroy_reply_info(&req->r_reply_info);
>         if (req->r_request)
>                 ceph_msg_put(req->r_request);
> @@ -2035,6 +2042,12 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>  {
>         struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
>         struct timespec64 ts;
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    struct task_struct* tsk = current;
> +    struct cgroup_subsys_state* css = tsk->cgroups->subsys[cephfs_cgrp_subsys.id];
> +    struct cephfscg* cephfscg_p =
> +        container_of(css, struct cephfscg, css);
> +#endif
>
>         if (!req)
>                 return ERR_PTR(-ENOMEM);
> @@ -2058,6 +2071,10 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>
>         req->r_op = op;
>         req->r_direct_mode = mode;
> +
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    queue_item_init(&req->qitem, &cephfscg_p->meta_ops_throttle, META_OPS_TB_NUM);
> +#endif
>         return req;
>  }
>
> @@ -2689,9 +2706,22 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
>                          struct ceph_mds_request *req)
>  {
>         int err;
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    struct task_struct* ts = current;
> +    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
> +    struct cephfscg* cephfscg_p =
> +        container_of(css, struct cephfscg, css);
> +#endif
>
>         dout("do_request on %p\n", req);
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    req->qitem.tokens_requested[META_OPS_IOPS_IDX] = 1;
> +    err = get_token_bucket_throttle(&cephfscg_p->meta_ops_throttle, &req->qitem);
> +    if (err)
> +        goto nolock_err;
> +#endif
> +
>         /* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
>         if (req->r_inode)
>                 ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
> @@ -2755,6 +2785,7 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
>
>  out:
>         mutex_unlock(&mdsc->mutex);
> +nolock_err:
>         dout("do_request %p done, result %d\n", req, err);
>         return err;
>  }
> @@ -4166,7 +4197,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>
>         strscpy(mdsc->nodename, utsname()->nodename,
>                 sizeof(mdsc->nodename));
> -       return 0;
> +
> +    return 0;
>  }
>
>  /*
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 50385a481fdb..814f0ecca523 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -16,6 +16,10 @@
>  #include <linux/ceph/mdsmap.h>
>  #include <linux/ceph/auth.h>
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +#include <linux/cgroup_cephfs.h>
> +#endif
> +
>  /* The first 8 bits are reserved for old ceph releases */
>  #define CEPHFS_FEATURE_MIMIC           8
>  #define CEPHFS_FEATURE_REPLY_ENCODING  9
> @@ -284,6 +288,11 @@ struct ceph_mds_request {
>         /* unsafe requests that modify the target inode */
>         struct list_head r_unsafe_target_item;
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    /* requests that blocked by the token bucket throttle*/
> +    struct queue_item qitem;
> +#endif
> +
>         struct ceph_mds_session *r_session;
>
>         int               r_attempts;   /* resend attempts */
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 6d5bb2f74612..19d035dfe414 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1161,7 +1161,10 @@ MODULE_ALIAS_FS("ceph");
>
>  static int __init init_ceph(void)
>  {
> -       int ret = init_caches();
> +       int ret = 0;
> +    pr_info("init_ceph\n");
> +
> +    ret = init_caches();
>         if (ret)
>                 goto out;
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 2294f963dab7..31011a1e9573 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -16,6 +16,10 @@
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/pagelist.h>
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +#include <linux/cgroup_cephfs.h>
> +#endif
> +
>  struct ceph_msg;
>  struct ceph_snap_context;
>  struct ceph_osd_request;
> @@ -193,7 +197,12 @@ struct ceph_osd_request {
>
>         int               r_result;
>
> -       struct ceph_osd_client *r_osdc;
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    /* token bucket throttle item*/
> +    struct queue_item qitem;
> +#endif
> +
> +    struct ceph_osd_client *r_osdc;
>         struct kref       r_kref;
>         bool              r_mempool;
>         struct completion r_completion;       /* private to osd_client.c */
> diff --git a/include/linux/ceph/types.h b/include/linux/ceph/types.h
> index bd3d532902d7..3b404bdbb28f 100644
> --- a/include/linux/ceph/types.h
> +++ b/include/linux/ceph/types.h
> @@ -27,5 +27,4 @@ struct ceph_cap_reservation {
>         int used;
>  };
>
> -
>  #endif
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 79eac465ec65..a0087532516b 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -503,7 +503,7 @@ ceph_parse_options(char *options, const char *dev_name,
>                         opt->osd_request_timeout = msecs_to_jiffies(intval * 1000);
>                         break;
>
> -               case Opt_share:
> +        case Opt_share:
>                         opt->flags &= ~CEPH_OPT_NOSHARE;
>                         break;
>                 case Opt_noshare:
> diff --git a/net/ceph/ceph_fs.c b/net/ceph/ceph_fs.c
> index 756a2dc10d27..744a6e5c0cba 100644
> --- a/net/ceph/ceph_fs.c
> +++ b/net/ceph/ceph_fs.c
> @@ -4,7 +4,6 @@
>   */
>  #include <linux/module.h>
>  #include <linux/ceph/types.h>
> -
>  /*
>   * return true if @layout appears to be valid
>   */
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index fa9530dd876e..27d9fdf88af6 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -22,6 +22,10 @@
>  #include <linux/ceph/pagelist.h>
>  #include <linux/ceph/striper.h>
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +#include <linux/cgroup_cephfs.h>
> +#endif
> +
>  #define OSD_OPREPLY_FRONT_LEN  512
>
>  static struct kmem_cache       *ceph_osd_request_cache;
> @@ -492,6 +496,10 @@ static void ceph_osdc_release_request(struct kref *kref)
>              req->r_request, req->r_reply);
>         request_release_checks(req);
>
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    kfree(req->qitem.tokens_requested);
> +#endif
> +
>         if (req->r_request)
>                 ceph_msg_put(req->r_request);
>         if (req->r_reply)
> @@ -587,6 +595,13 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
>                                                gfp_t gfp_flags)
>  {
>         struct ceph_osd_request *req;
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    struct task_struct* ts = current;
> +    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
> +    struct cephfscg* cephfscg_p =
> +        container_of(css, struct cephfscg, css);
> +    int r = 0;
> +#endif
>
>         if (use_mempool) {
>                 BUG_ON(num_ops > CEPH_OSD_SLAB_OPS);
> @@ -606,6 +621,11 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
>         req->r_num_ops = num_ops;
>         req->r_snapid = CEPH_NOSNAP;
>         req->r_snapc = ceph_get_snap_context(snapc);
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    r = queue_item_init(&req->qitem, &cephfscg_p->data_ops_throttle, DATA_OPS_TB_NUM);
> +    if (unlikely(r))
> +        return NULL;
> +#endif
>
>         dout("%s req %p\n", __func__, req);
>         return req;
> @@ -4463,6 +4483,28 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
>                             struct ceph_osd_request *req,
>                             bool nofail)
>  {
> +#ifdef CONFIG_CGROUP_CEPH_FS
> +    struct task_struct* ts = current;
> +    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
> +    struct cephfscg* cephfscg_p =
> +        container_of(css, struct cephfscg, css);
> +    int err = 0;
> +    int i = 0;
> +    u64 len = 0;
> +
> +    dout("%s: req: %p, tid: %llu, tokens_requested: %p, tb_item_num: %d\n", __func__, req, req->r_tid, req->qitem.tokens_requested, req->qitem.tb_item_num);
> +    req->qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
> +    for (i = 0; i < req->r_num_ops; i++) {
> +        if (req->r_ops[i].op == CEPH_OSD_OP_READ
> +                || req->r_ops[i].op == CEPH_OSD_OP_WRITE)
> +            len += req->r_ops[i].extent.length;
> +    }
> +    dout("%s: req: %llu, ops: %d, len: %llu\n", __func__, req->r_tid, req->r_num_ops, len);
> +    req->qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
> +    err = get_token_bucket_throttle(&cephfscg_p->data_ops_throttle, &req->qitem);
> +    if (err)
> +        return err;
> +#endif
>         down_read(&osdc->lock);
>         submit_request(req, false);
>         up_read(&osdc->lock);

Looking at the previous patch, get_token_bucket_throttle() blocks
waiting for the requested tokens to become available.  This is not
going to work because ceph_osdc_start_request() is called from all
sorts of places, including the messenger worker threads.

ceph_osdc_start_request() should never fail.  Treat it as a void
function -- the return value is ignored in new code and the signature
will eventually be updated to *req -> void.

Thanks,

                Ilya
