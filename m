Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9934123A1B9
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Aug 2020 11:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHCJ1u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Aug 2020 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCJ1t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Aug 2020 05:27:49 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9EFC06174A
        for <ceph-devel@vger.kernel.org>; Mon,  3 Aug 2020 02:27:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id t15so28904207iob.3
        for <ceph-devel@vger.kernel.org>; Mon, 03 Aug 2020 02:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awnOvS0NkfwEAP/VkpTvXonImABSWuvQk1W6DfI7l0c=;
        b=G/YFUmAKNjxpS4lHYHh98LKyycqrexyLtSnRS+yMRTbAPDk7lJf/oPbyx7N1dfP4FN
         XPD0kVwoDP8QS6CB1qcC+FHgsK7ZDbB2VTb3B8XR/3Nvjz5OPCRSaRwvOatDxbQV/gdx
         d6yFwIcqIsRJ1xJKNoLYYIYMKwZKIl7oSwZgqMNo6Sr87fxNNBdOobjS0wdT5wDAT/N+
         qFuC+kUE7NA2XIn3FgQs5uxSN7KzD+y4Livkj3b9SZFRYL2OQgQQul1RT9CLffxUj3Ht
         BUlTZAKBOEZmuE3stN4EGtGkTcqwvPhRwzX0qk09hoUviCHNwgPSA9ilGBTRY/TWcnby
         gJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awnOvS0NkfwEAP/VkpTvXonImABSWuvQk1W6DfI7l0c=;
        b=bgS+zABqF4aWyolgJpYLqOqEqn1zQTE5zXUVDQpaT3g1CBjLALCoEHtHIBzaXw8kuo
         ktHMK26zmrdZTOq6Ampi4O+edlft2/po/F5Q6daesYz7p0Q4wGY4D42Y8riW4KagkKT0
         dJzEXjRXhKz4cOVbEyR0qcUpYSD3GDdXNkp+EjodrtoOfjAfCJaa7Kt2LCo9JkCb8rbi
         YA8CMg+xd4AanBllnOZLQ1v154xkmE1EzESMyun1E19pU6ZVrvBYMsWdJ1/F6F/q/qie
         yfb4KvqlrBQRTTWt6BDo6mVzposnSmzZX8ueIvSzWvMwPwFd8LH+4MmX5bZ0AeJ1CtSE
         HsGA==
X-Gm-Message-State: AOAM5327MTRBVBG1QlNOdsfTfn+W3RXHssUsb7QT8WaECrAp1wxQuuT5
        05vSzOakRbmNoaOh9YJFfYVFWw2e6B4euRF//t4=
X-Google-Smtp-Source: ABdhPJzl8+p4VSCHM2M63uzLxceX3h+wvmuZnbtg1DQ4Cur1aTc93/wNHzI8F0VFnhvFtjcncChbvQq4SCgH79FCZnM=
X-Received: by 2002:a5e:991a:: with SMTP id t26mr15588965ioj.7.1596446868806;
 Mon, 03 Aug 2020 02:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200730154804.1048188-1-jlayton@kernel.org>
In-Reply-To: <20200730154804.1048188-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Aug 2020 11:27:49 +0200
Message-ID: <CAOi1vP_bBzOnZKQoE-HpNfyjSq_ebdhCZjE3mGy=9sskL2aejA@mail.gmail.com>
Subject: Re: [PATCH] ceph: move sb->wb_pagevec_pool to be a global mempool
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 30, 2020 at 5:48 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> When doing some testing recently, I hit some page allocation failures
> on mount, when creating the wb_pagevec_pool for the mount. That
> requires 128k (32 contiguous pages), and after thrashing the memory
> during an xfstests run, sometimes that would fail.
>
> 128k for each mount seems like a lot to hold in reserve for a rainy
> day, so let's change this to a global mempool that gets allocated
> when the module is plugged in.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c               | 23 +++++++++++------------
>  fs/ceph/super.c              | 22 ++++++++--------------
>  fs/ceph/super.h              |  2 --
>  include/linux/ceph/libceph.h |  1 +
>  4 files changed, 20 insertions(+), 28 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 01ad09733ac7..6ea761c84494 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -862,8 +862,7 @@ static void writepages_finish(struct ceph_osd_request *req)
>
>         osd_data = osd_req_op_extent_osd_data(req, 0);
>         if (osd_data->pages_from_pool)
> -               mempool_free(osd_data->pages,
> -                            ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
> +               mempool_free(osd_data->pages, ceph_wb_pagevec_pool);
>         else
>                 kfree(osd_data->pages);
>         ceph_osdc_put_request(req);
> @@ -955,10 +954,10 @@ static int ceph_writepages_start(struct address_space *mapping,
>                 int num_ops = 0, op_idx;
>                 unsigned i, pvec_pages, max_pages, locked_pages = 0;
>                 struct page **pages = NULL, **data_pages;
> -               mempool_t *pool = NULL; /* Becomes non-null if mempool used */
>                 struct page *page;
>                 pgoff_t strip_unit_end = 0;
>                 u64 offset = 0, len = 0;
> +               bool from_pool = false;
>
>                 max_pages = wsize >> PAGE_SHIFT;
>
> @@ -1057,16 +1056,16 @@ static int ceph_writepages_start(struct address_space *mapping,
>                                                       sizeof(*pages),
>                                                       GFP_NOFS);
>                                 if (!pages) {
> -                                       pool = fsc->wb_pagevec_pool;
> -                                       pages = mempool_alloc(pool, GFP_NOFS);
> +                                       from_pool = true;
> +                                       pages = mempool_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
>                                         BUG_ON(!pages);
>                                 }
>
>                                 len = 0;
>                         } else if (page->index !=
>                                    (offset + len) >> PAGE_SHIFT) {
> -                               if (num_ops >= (pool ?  CEPH_OSD_SLAB_OPS :
> -                                                       CEPH_OSD_MAX_OPS)) {
> +                               if (num_ops >= (from_pool ?  CEPH_OSD_SLAB_OPS :
> +                                                            CEPH_OSD_MAX_OPS)) {
>                                         redirty_page_for_writepage(wbc, page);
>                                         unlock_page(page);
>                                         break;
> @@ -1161,7 +1160,7 @@ static int ceph_writepages_start(struct address_space *mapping,
>                                      offset, len);
>                                 osd_req_op_extent_osd_data_pages(req, op_idx,
>                                                         data_pages, len, 0,
> -                                                       !!pool, false);
> +                                                       from_pool, false);
>                                 osd_req_op_extent_update(req, op_idx, len);
>
>                                 len = 0;
> @@ -1188,12 +1187,12 @@ static int ceph_writepages_start(struct address_space *mapping,
>                 dout("writepages got pages at %llu~%llu\n", offset, len);
>
>                 osd_req_op_extent_osd_data_pages(req, op_idx, data_pages, len,
> -                                                0, !!pool, false);
> +                                                0, from_pool, false);
>                 osd_req_op_extent_update(req, op_idx, len);
>
>                 BUG_ON(op_idx + 1 != req->r_num_ops);
>
> -               pool = NULL;
> +               from_pool = false;
>                 if (i < locked_pages) {
>                         BUG_ON(num_ops <= req->r_num_ops);
>                         num_ops -= req->r_num_ops;
> @@ -1204,8 +1203,8 @@ static int ceph_writepages_start(struct address_space *mapping,
>                         pages = kmalloc_array(locked_pages, sizeof(*pages),
>                                               GFP_NOFS);
>                         if (!pages) {
> -                               pool = fsc->wb_pagevec_pool;
> -                               pages = mempool_alloc(pool, GFP_NOFS);
> +                               from_pool = true;
> +                               pages = mempool_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
>                                 BUG_ON(!pages);
>                         }
>                         memcpy(pages, data_pages + i,
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 585aecea5cad..7ec0e6d03d10 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -637,8 +637,6 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>                                         struct ceph_options *opt)
>  {
>         struct ceph_fs_client *fsc;
> -       int page_count;
> -       size_t size;
>         int err;
>
>         fsc = kzalloc(sizeof(*fsc), GFP_KERNEL);
> @@ -686,22 +684,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>         if (!fsc->cap_wq)
>                 goto fail_inode_wq;
>
> -       /* set up mempools */
> -       err = -ENOMEM;
> -       page_count = fsc->mount_options->wsize >> PAGE_SHIFT;
> -       size = sizeof (struct page *) * (page_count ? page_count : 1);
> -       fsc->wb_pagevec_pool = mempool_create_kmalloc_pool(10, size);
> -       if (!fsc->wb_pagevec_pool)
> -               goto fail_cap_wq;
> -
>         spin_lock(&ceph_fsc_lock);
>         list_add_tail(&fsc->metric_wakeup, &ceph_fsc_list);
>         spin_unlock(&ceph_fsc_lock);
>
>         return fsc;
>
> -fail_cap_wq:
> -       destroy_workqueue(fsc->cap_wq);
>  fail_inode_wq:
>         destroy_workqueue(fsc->inode_wq);
>  fail_client:
> @@ -732,8 +720,6 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>         destroy_workqueue(fsc->inode_wq);
>         destroy_workqueue(fsc->cap_wq);
>
> -       mempool_destroy(fsc->wb_pagevec_pool);
> -
>         destroy_mount_options(fsc->mount_options);
>
>         ceph_destroy_client(fsc->client);
> @@ -752,6 +738,7 @@ struct kmem_cache *ceph_dentry_cachep;
>  struct kmem_cache *ceph_file_cachep;
>  struct kmem_cache *ceph_dir_file_cachep;
>  struct kmem_cache *ceph_mds_request_cachep;
> +mempool_t *ceph_wb_pagevec_pool;
>
>  static void ceph_inode_init_once(void *foo)
>  {
> @@ -796,6 +783,10 @@ static int __init init_caches(void)
>         if (!ceph_mds_request_cachep)
>                 goto bad_mds_req;
>
> +       ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
> +       if (!ceph_wb_pagevec_pool)
> +               goto bad_pagevec_pool;
> +
>         error = ceph_fscache_register();
>         if (error)
>                 goto bad_fscache;
> @@ -804,6 +795,8 @@ static int __init init_caches(void)
>
>  bad_fscache:
>         kmem_cache_destroy(ceph_mds_request_cachep);
> +bad_pagevec_pool:
> +       mempool_destroy(ceph_wb_pagevec_pool);
>  bad_mds_req:
>         kmem_cache_destroy(ceph_dir_file_cachep);
>  bad_dir_file:
> @@ -834,6 +827,7 @@ static void destroy_caches(void)
>         kmem_cache_destroy(ceph_file_cachep);
>         kmem_cache_destroy(ceph_dir_file_cachep);
>         kmem_cache_destroy(ceph_mds_request_cachep);
> +       mempool_destroy(ceph_wb_pagevec_pool);
>
>         ceph_fscache_unregister();
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 9001a896ae8c..4c3c964b1c54 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -118,8 +118,6 @@ struct ceph_fs_client {
>
>         struct ceph_mds_client *mdsc;
>
> -       /* writeback */
> -       mempool_t *wb_pagevec_pool;
>         atomic_long_t writeback_count;
>
>         struct workqueue_struct *inode_wq;
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index e5ed1c541e7f..c8645f0b797d 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -282,6 +282,7 @@ extern struct kmem_cache *ceph_dentry_cachep;
>  extern struct kmem_cache *ceph_file_cachep;
>  extern struct kmem_cache *ceph_dir_file_cachep;
>  extern struct kmem_cache *ceph_mds_request_cachep;
> +extern mempool_t *ceph_wb_pagevec_pool;
>
>  /* ceph_common.c */
>  extern bool libceph_compatible(void *data);

Looks fine to me.

I think it used to be just a single page per mount before
95cca2b44e54 ("ceph: limit osd write size") because fsopt->wsize
defaulted to 0 which meant "no limit".  And CEPH_MSG_MAX_DATA_LEN
got increased from 16M to 64M as well...

Thanks,

                Ilya
