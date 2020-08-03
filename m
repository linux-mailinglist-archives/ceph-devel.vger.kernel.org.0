Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962623A72B
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Aug 2020 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgHCNFJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Aug 2020 09:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgHCNFJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 09:05:09 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFFB205CB;
        Mon,  3 Aug 2020 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596459907;
        bh=uOHYcDLKCxhDk6vCFtyA0EAaAOS+9t/Ags17e/Ql130=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=x1kHl7Udy6SSV6ce7IocODmh07VvB770FIr0DGxyo0APMnMfBCyg58qDAP2mBsBfT
         76lCXqoE+W7IM0X+r8uxLv8qZjgxD+24Yset4Vi8W5Vhz6E/cTc2MdFG32U6zRrSzM
         Rv7h8EhUIpaLGqM4aZQKpw4qXvmZQ6kRJ5vx8XMo=
Message-ID: <7195759e5a85b3aa30ab2c73a0556dcbca1a1400.camel@kernel.org>
Subject: Re: [PATCH] ceph: move sb->wb_pagevec_pool to be a global mempool
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 03 Aug 2020 09:05:06 -0400
In-Reply-To: <CAOi1vP_bBzOnZKQoE-HpNfyjSq_ebdhCZjE3mGy=9sskL2aejA@mail.gmail.com>
References: <20200730154804.1048188-1-jlayton@kernel.org>
         <CAOi1vP_bBzOnZKQoE-HpNfyjSq_ebdhCZjE3mGy=9sskL2aejA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-03 at 11:27 +0200, Ilya Dryomov wrote:
> On Thu, Jul 30, 2020 at 5:48 PM Jeff Layton <jlayton@kernel.org> wrote:
> > When doing some testing recently, I hit some page allocation failures
> > on mount, when creating the wb_pagevec_pool for the mount. That
> > requires 128k (32 contiguous pages), and after thrashing the memory
> > during an xfstests run, sometimes that would fail.
> > 
> > 128k for each mount seems like a lot to hold in reserve for a rainy
> > day, so let's change this to a global mempool that gets allocated
> > when the module is plugged in.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/addr.c               | 23 +++++++++++------------
> >  fs/ceph/super.c              | 22 ++++++++--------------
> >  fs/ceph/super.h              |  2 --
> >  include/linux/ceph/libceph.h |  1 +
> >  4 files changed, 20 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 01ad09733ac7..6ea761c84494 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -862,8 +862,7 @@ static void writepages_finish(struct ceph_osd_request *req)
> > 
> >         osd_data = osd_req_op_extent_osd_data(req, 0);
> >         if (osd_data->pages_from_pool)
> > -               mempool_free(osd_data->pages,
> > -                            ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
> > +               mempool_free(osd_data->pages, ceph_wb_pagevec_pool);
> >         else
> >                 kfree(osd_data->pages);
> >         ceph_osdc_put_request(req);
> > @@ -955,10 +954,10 @@ static int ceph_writepages_start(struct address_space *mapping,
> >                 int num_ops = 0, op_idx;
> >                 unsigned i, pvec_pages, max_pages, locked_pages = 0;
> >                 struct page **pages = NULL, **data_pages;
> > -               mempool_t *pool = NULL; /* Becomes non-null if mempool used */
> >                 struct page *page;
> >                 pgoff_t strip_unit_end = 0;
> >                 u64 offset = 0, len = 0;
> > +               bool from_pool = false;
> > 
> >                 max_pages = wsize >> PAGE_SHIFT;
> > 
> > @@ -1057,16 +1056,16 @@ static int ceph_writepages_start(struct address_space *mapping,
> >                                                       sizeof(*pages),
> >                                                       GFP_NOFS);
> >                                 if (!pages) {
> > -                                       pool = fsc->wb_pagevec_pool;
> > -                                       pages = mempool_alloc(pool, GFP_NOFS);
> > +                                       from_pool = true;
> > +                                       pages = mempool_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
> >                                         BUG_ON(!pages);
> >                                 }
> > 
> >                                 len = 0;
> >                         } else if (page->index !=
> >                                    (offset + len) >> PAGE_SHIFT) {
> > -                               if (num_ops >= (pool ?  CEPH_OSD_SLAB_OPS :
> > -                                                       CEPH_OSD_MAX_OPS)) {
> > +                               if (num_ops >= (from_pool ?  CEPH_OSD_SLAB_OPS :
> > +                                                            CEPH_OSD_MAX_OPS)) {
> >                                         redirty_page_for_writepage(wbc, page);
> >                                         unlock_page(page);
> >                                         break;
> > @@ -1161,7 +1160,7 @@ static int ceph_writepages_start(struct address_space *mapping,
> >                                      offset, len);
> >                                 osd_req_op_extent_osd_data_pages(req, op_idx,
> >                                                         data_pages, len, 0,
> > -                                                       !!pool, false);
> > +                                                       from_pool, false);
> >                                 osd_req_op_extent_update(req, op_idx, len);
> > 
> >                                 len = 0;
> > @@ -1188,12 +1187,12 @@ static int ceph_writepages_start(struct address_space *mapping,
> >                 dout("writepages got pages at %llu~%llu\n", offset, len);
> > 
> >                 osd_req_op_extent_osd_data_pages(req, op_idx, data_pages, len,
> > -                                                0, !!pool, false);
> > +                                                0, from_pool, false);
> >                 osd_req_op_extent_update(req, op_idx, len);
> > 
> >                 BUG_ON(op_idx + 1 != req->r_num_ops);
> > 
> > -               pool = NULL;
> > +               from_pool = false;
> >                 if (i < locked_pages) {
> >                         BUG_ON(num_ops <= req->r_num_ops);
> >                         num_ops -= req->r_num_ops;
> > @@ -1204,8 +1203,8 @@ static int ceph_writepages_start(struct address_space *mapping,
> >                         pages = kmalloc_array(locked_pages, sizeof(*pages),
> >                                               GFP_NOFS);
> >                         if (!pages) {
> > -                               pool = fsc->wb_pagevec_pool;
> > -                               pages = mempool_alloc(pool, GFP_NOFS);
> > +                               from_pool = true;
> > +                               pages = mempool_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
> >                                 BUG_ON(!pages);
> >                         }
> >                         memcpy(pages, data_pages + i,
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 585aecea5cad..7ec0e6d03d10 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -637,8 +637,6 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >                                         struct ceph_options *opt)
> >  {
> >         struct ceph_fs_client *fsc;
> > -       int page_count;
> > -       size_t size;
> >         int err;
> > 
> >         fsc = kzalloc(sizeof(*fsc), GFP_KERNEL);
> > @@ -686,22 +684,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >         if (!fsc->cap_wq)
> >                 goto fail_inode_wq;
> > 
> > -       /* set up mempools */
> > -       err = -ENOMEM;
> > -       page_count = fsc->mount_options->wsize >> PAGE_SHIFT;
> > -       size = sizeof (struct page *) * (page_count ? page_count : 1);
> > -       fsc->wb_pagevec_pool = mempool_create_kmalloc_pool(10, size);
> > -       if (!fsc->wb_pagevec_pool)
> > -               goto fail_cap_wq;
> > -
> >         spin_lock(&ceph_fsc_lock);
> >         list_add_tail(&fsc->metric_wakeup, &ceph_fsc_list);
> >         spin_unlock(&ceph_fsc_lock);
> > 
> >         return fsc;
> > 
> > -fail_cap_wq:
> > -       destroy_workqueue(fsc->cap_wq);
> >  fail_inode_wq:
> >         destroy_workqueue(fsc->inode_wq);
> >  fail_client:
> > @@ -732,8 +720,6 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
> >         destroy_workqueue(fsc->inode_wq);
> >         destroy_workqueue(fsc->cap_wq);
> > 
> > -       mempool_destroy(fsc->wb_pagevec_pool);
> > -
> >         destroy_mount_options(fsc->mount_options);
> > 
> >         ceph_destroy_client(fsc->client);
> > @@ -752,6 +738,7 @@ struct kmem_cache *ceph_dentry_cachep;
> >  struct kmem_cache *ceph_file_cachep;
> >  struct kmem_cache *ceph_dir_file_cachep;
> >  struct kmem_cache *ceph_mds_request_cachep;
> > +mempool_t *ceph_wb_pagevec_pool;
> > 
> >  static void ceph_inode_init_once(void *foo)
> >  {
> > @@ -796,6 +783,10 @@ static int __init init_caches(void)
> >         if (!ceph_mds_request_cachep)
> >                 goto bad_mds_req;
> > 
> > +       ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
> > +       if (!ceph_wb_pagevec_pool)
> > +               goto bad_pagevec_pool;
> > +
> >         error = ceph_fscache_register();
> >         if (error)
> >                 goto bad_fscache;
> > @@ -804,6 +795,8 @@ static int __init init_caches(void)
> > 
> >  bad_fscache:
> >         kmem_cache_destroy(ceph_mds_request_cachep);
> > +bad_pagevec_pool:
> > +       mempool_destroy(ceph_wb_pagevec_pool);
> >  bad_mds_req:
> >         kmem_cache_destroy(ceph_dir_file_cachep);
> >  bad_dir_file:
> > @@ -834,6 +827,7 @@ static void destroy_caches(void)
> >         kmem_cache_destroy(ceph_file_cachep);
> >         kmem_cache_destroy(ceph_dir_file_cachep);
> >         kmem_cache_destroy(ceph_mds_request_cachep);
> > +       mempool_destroy(ceph_wb_pagevec_pool);
> > 
> >         ceph_fscache_unregister();
> >  }
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 9001a896ae8c..4c3c964b1c54 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -118,8 +118,6 @@ struct ceph_fs_client {
> > 
> >         struct ceph_mds_client *mdsc;
> > 
> > -       /* writeback */
> > -       mempool_t *wb_pagevec_pool;
> >         atomic_long_t writeback_count;
> > 
> >         struct workqueue_struct *inode_wq;
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index e5ed1c541e7f..c8645f0b797d 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -282,6 +282,7 @@ extern struct kmem_cache *ceph_dentry_cachep;
> >  extern struct kmem_cache *ceph_file_cachep;
> >  extern struct kmem_cache *ceph_dir_file_cachep;
> >  extern struct kmem_cache *ceph_mds_request_cachep;
> > +extern mempool_t *ceph_wb_pagevec_pool;
> > 
> >  /* ceph_common.c */
> >  extern bool libceph_compatible(void *data);
> 
> Looks fine to me.
> 
> I think it used to be just a single page per mount before
> 95cca2b44e54 ("ceph: limit osd write size") because fsopt->wsize
> defaulted to 0 which meant "no limit".  And CEPH_MSG_MAX_DATA_LEN
> got increased from 16M to 64M as well...
> 
> Thanks,
> 
>                 Ilya

Yeah, I think this is something that has changed over time. Regardless
though, keeping a per-sb mempool is rather weird. Most filesystems make
do with global ones.

As a side note, it should be done in a separate patch, but I think we
can also fix some of the places that have "try kmalloc and fall back to
mempool if that fails" patterns.

mempools already operate like that -- they only fall back to allocating
from the reserved pool when allocations fail, so doing it manually is
redundant.
-- 
Jeff Layton <jlayton@kernel.org>

