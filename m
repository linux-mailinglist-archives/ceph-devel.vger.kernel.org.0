Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7C714A9FB
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jan 2020 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgA0Som (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jan 2020 13:44:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:53926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0Som (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 13:44:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9D599AD81;
        Mon, 27 Jan 2020 18:44:39 +0000 (UTC)
Date:   Mon, 27 Jan 2020 18:44:43 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] ceph: parallelize all copy-from requests in
 copy_file_range
Message-ID: <20200127184443.GB22545@suse.com>
References: <20200127164321.17468-1-lhenriques@suse.com>
 <20200127164321.17468-3-lhenriques@suse.com>
 <CAOi1vP9HB4dPTHrgn2bTZ3nM2HSpLkwRvjZ8za0KE4NNnHmmtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9HB4dPTHrgn2bTZ3nM2HSpLkwRvjZ8za0KE4NNnHmmtw@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 06:58:46PM +0100, Ilya Dryomov wrote:
> On Mon, Jan 27, 2020 at 5:43 PM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > Right now the copy_file_range syscall serializes all the OSDs 'copy-from'
> > operations, waiting for each request to complete before sending the next
> > one.  This patch modifies copy_file_range so that all the 'copy-from'
> > operations are sent in bulk and waits for its completion at the end.  This
> > will allow significant speed-ups, specially when sending requests for
> > different target OSDs.
> >
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/file.c                  | 38 +++++++++++++++++++++++++++++++--
> >  include/linux/ceph/osd_client.h |  2 ++
> >  net/ceph/osd_client.c           |  1 +
> >  3 files changed, 39 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 1e6cdf2dfe90..5d8f0ba11719 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1931,6 +1931,28 @@ static int is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
> >         return 0;
> >  }
> >
> > +static int wait_copy_from_reqs(struct list_head *osd_reqs)
> > +{
> > +       struct ceph_osd_request *req;
> > +       int ret = 0, err;
> > +
> > +       while (!list_empty(osd_reqs)) {
> > +               req = list_first_entry(osd_reqs,
> > +                                      struct ceph_osd_request,
> > +                                      r_copy_item);
> > +               list_del_init(&req->r_copy_item);
> > +               err = ceph_osdc_wait_request(req->r_osdc, req);
> > +               if (err) {
> > +                       if (!ret)
> > +                               ret = err;
> > +                       dout("copy request failed (err=%d)\n", err);
> > +               }
> > +               ceph_osdc_put_request(req);
> > +       }
> > +
> > +       return ret;
> > +}
> 
> This should probably go into libceph, as ceph_osdc_wait_requests().

Sure, that makes sense.

> > +
> >  static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                                       struct file *dst_file, loff_t dst_off,
> >                                       size_t len, unsigned int flags)
> > @@ -1943,12 +1965,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >         struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> >         struct ceph_object_locator src_oloc, dst_oloc;
> >         struct ceph_object_id src_oid, dst_oid;
> > +       struct ceph_osd_request *req;
> >         loff_t endoff = 0, size;
> >         ssize_t ret = -EIO;
> >         u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
> >         u32 src_objlen, dst_objlen, object_size;
> >         int src_got = 0, dst_got = 0, err, dirty;
> >         bool do_final_copy = false;
> > +       LIST_HEAD(osd_reqs);
> >
> >         if (src_inode->i_sb != dst_inode->i_sb) {
> >                 struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> > @@ -2097,7 +2121,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                 ceph_oid_printf(&dst_oid, "%llx.%08llx",
> >                                 dst_ci->i_vino.ino, dst_objnum);
> >                 /* Do an object remote copy */
> > -               err = ceph_osdc_copy_from(
> > +               req = ceph_osdc_copy_from_nowait(
> >                         &src_fsc->client->osdc,
> >                         src_ci->i_vino.snap, 0,
> >                         &src_oid, &src_oloc,
> > @@ -2108,7 +2132,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > -               if (err) {
> > +               if (IS_ERR(req)) {
> > +                       err = PTR_ERR(req);
> >                         if (err == -EOPNOTSUPP) {
> >                                 src_fsc->have_copy_from2 = false;
> >                                 pr_notice("OSDs don't support 'copy-from2'; "
> > @@ -2117,14 +2142,23 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                         dout("ceph_osdc_copy_from returned %d\n", err);
> >                         if (!ret)
> >                                 ret = err;
> > +                       /* wait for all queued requests */
> > +                       wait_copy_from_reqs(&osd_reqs);
> >                         goto out_caps;
> >                 }
> > +               list_add(&req->r_copy_item, &osd_reqs);
> >                 len -= object_size;
> >                 src_off += object_size;
> >                 dst_off += object_size;
> >                 ret += object_size;
> >         }
> >
> > +       err = wait_copy_from_reqs(&osd_reqs);
> > +       if (err) {
> > +               if (!ret)
> > +                       ret = err;
> > +               goto out_caps;
> > +       }
> >         if (len)
> >                 /* We still need one final local copy */
> >                 do_final_copy = true;
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 7916a178d137..2b4a14bc6154 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -210,6 +210,8 @@ struct ceph_osd_request {
> >         u64 r_data_offset;                    /* ditto */
> >         bool r_linger;                        /* don't resend on failure */
> >
> > +       struct list_head r_copy_item;         /* used for copy-from operations */
> > +
> 
> We have r_private_item for exactly this kind of ad-hoc lists, already
> used in rbd and ceph_direct_read_write().

Ah!  I've actually considered using it, but thought that using the same
field for different purposes may be a source of confusion and bugs in the
future.  But sure, it can be used.  I'll add a comment in the struct
definition regarding this ad-hoc usage.

Cheers,
--
Luís
