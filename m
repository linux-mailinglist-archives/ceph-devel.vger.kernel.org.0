Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA38508E0
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 12:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfFXK0T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 06:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbfFXK0T (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 06:26:19 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A8520674;
        Mon, 24 Jun 2019 10:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371978;
        bh=Bgo45ELP4Ju/A9tiOcqJ7Wqth8iVHeFxBk8b7zPOmG0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BoPczUMSQU8hXcLsNPsDd7HLM/6jufV+Ib8cx+qi8V4Ew98p17kUXF+v3h/HVMbkj
         hyN328T+HXJvrHLbs0rR5qYXT6UIdt/6VBMZ2OwIOjDbusoB9mcfHyQ0ec/rUzoQXj
         OgONKy3kAHjMpTQhH7O/yBN4wczvj9aoWYElOq10=
Message-ID: <f120875a67c1421dd7cebbb796b2c68ddf4babf6.camel@kernel.org>
Subject: Re: [PATCH v3 1/2] ceph: fix buffer length handling in virtual
 xattrs
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        agruenba@redhat.com, Joe Perches <joe@perches.com>,
        geert+renesas@glider.be, andriy.shevchenko@linux.intel.com
Date:   Mon, 24 Jun 2019 06:26:15 -0400
In-Reply-To: <CAOi1vP8bJcW8ViXhfuoCUqntqLj0bC56dc-9+MGwZvR9yHRFLA@mail.gmail.com>
References: <20190621141833.17551-1-jlayton@kernel.org>
         <20190621141833.17551-2-jlayton@kernel.org>
         <CAOi1vP8bJcW8ViXhfuoCUqntqLj0bC56dc-9+MGwZvR9yHRFLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-24 at 12:00 +0200, Ilya Dryomov wrote:
> On Fri, Jun 21, 2019 at 4:18 PM Jeff Layton <jlayton@kernel.org> wrote:
> > The convention with xattrs is to not store the termination with string
> > data, given that it returns the length. This is how setfattr/getfattr
> > operate.
> > 
> > Most of ceph's virtual xattr routines use snprintf to plop the string
> > directly into the destination buffer, but snprintf always NULL
> > terminates the string. This means that if we send the kernel a buffer
> > that is the exact length needed to hold the string, it'll end up
> > truncated.
> > 
> > Add new routines to format the string into an on-stack buffer that is
> > always large enough to hold the whole thing and then memcpy the result
> > into the destination buffer. Then, change over the virtual xattr
> > routines to use the new helper functions as appropriate.
> > 
> > Finally, make the code return ERANGE if the destination buffer size was
> > too small to hold the returned value.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/xattr.c | 103 ++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 78 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index 6621d27e64f5..359d3cbbb37b 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -112,22 +112,47 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
> >         return ret;
> >  }
> > 
> > +/* Enough to hold any possible expression of integer TYPE in base 10 */
> > +#define INT_STR_SIZE(_type)    3*sizeof(_type)+2
> > +
> > +/*
> > + * snprintf always NULL terminates, but we need for xattrs to not be. For
> > + * the integer vxattrs, just create an on-stack buffer for snprintf's
> > + * destination, and just don't copy the termination to the actual buffer.
> > + */
> > +#define GENERATE_XATTR_INT_FORMATTER(_lbl, _format, _type)                  \
> > +static size_t format_ ## _lbl ## _xattr(char *val, size_t size, _type src)   \
> > +{                                                                           \
> > +       size_t ret;                                                          \
> > +       char buf[INT_STR_SIZE(_type)];                                       \
> > +                                                                            \
> > +       ret = snprintf(buf, size ? sizeof(buf) : 0, _format, src);           \
> > +       if (ret <= size)                                                     \
> > +               memcpy(val, buf, ret);                                       \
> > +       return ret;                                                          \
> > +}
> > +
> > +GENERATE_XATTR_INT_FORMATTER(u, "%u", unsigned int)
> > +GENERATE_XATTR_INT_FORMATTER(d, "%d", int)
> > +GENERATE_XATTR_INT_FORMATTER(lld, "%lld", long long)
> > +GENERATE_XATTR_INT_FORMATTER(llu, "%llu", unsigned long long)
> > +
> >  static size_t ceph_vxattrcb_layout_stripe_unit(struct ceph_inode_info *ci,
> >                                                char *val, size_t size)
> >  {
> > -       return snprintf(val, size, "%u", ci->i_layout.stripe_unit);
> > +       return format_u_xattr(val, size, ci->i_layout.stripe_unit);
> >  }
> > 
> >  static size_t ceph_vxattrcb_layout_stripe_count(struct ceph_inode_info *ci,
> >                                                 char *val, size_t size)
> >  {
> > -       return snprintf(val, size, "%u", ci->i_layout.stripe_count);
> > +       return format_u_xattr(val, size, ci->i_layout.stripe_count);
> >  }
> > 
> >  static size_t ceph_vxattrcb_layout_object_size(struct ceph_inode_info *ci,
> >                                                char *val, size_t size)
> >  {
> > -       return snprintf(val, size, "%u", ci->i_layout.object_size);
> > +       return format_u_xattr(val, size, ci->i_layout.object_size);
> >  }
> > 
> >  static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
> > @@ -141,10 +166,14 @@ static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
> > 
> >         down_read(&osdc->lock);
> >         pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
> > -       if (pool_name)
> > -               ret = snprintf(val, size, "%s", pool_name);
> > -       else
> > -               ret = snprintf(val, size, "%lld", (unsigned long long)pool);
> > +       if (pool_name) {
> > +               ret = strlen(pool_name);
> > +
> > +               if (ret <= size)
> > +                       memcpy(val, pool_name, ret);
> > +       } else {
> > +               ret = format_lld_xattr(val, size, pool);
> > +       }
> >         up_read(&osdc->lock);
> >         return ret;
> >  }
> > @@ -155,7 +184,11 @@ static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
> >         int ret = 0;
> >         struct ceph_string *ns = ceph_try_get_string(ci->i_layout.pool_ns);
> >         if (ns) {
> > -               ret = snprintf(val, size, "%.*s", (int)ns->len, ns->str);
> > +               ret = ns->len;
> > +
> > +               if (ret <= size)
> > +                       memcpy(val, ns->str, ns->len);
> > +
> >                 ceph_put_string(ns);
> >         }
> >         return ret;
> > @@ -166,50 +199,61 @@ static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
> >  static size_t ceph_vxattrcb_dir_entries(struct ceph_inode_info *ci, char *val,
> >                                         size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_files + ci->i_subdirs);
> > +       return format_lld_xattr(val, size, ci->i_files + ci->i_subdirs);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_files(struct ceph_inode_info *ci, char *val,
> >                                       size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_files);
> > +       return format_lld_xattr(val, size, ci->i_files);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_subdirs(struct ceph_inode_info *ci, char *val,
> >                                         size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_subdirs);
> > +       return format_lld_xattr(val, size, ci->i_subdirs);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_rentries(struct ceph_inode_info *ci, char *val,
> >                                          size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_rfiles + ci->i_rsubdirs);
> > +       return format_lld_xattr(val, size, ci->i_rfiles + ci->i_rsubdirs);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_rfiles(struct ceph_inode_info *ci, char *val,
> >                                        size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_rfiles);
> > +       return format_lld_xattr(val, size, ci->i_rfiles);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
> >                                          size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_rsubdirs);
> > +       return format_lld_xattr(val, size, ci->i_rsubdirs);
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
> >                                        size_t size)
> >  {
> > -       return snprintf(val, size, "%lld", ci->i_rbytes);
> > +       return format_lld_xattr(val, size, ci->i_rbytes);
> > +}
> > +
> > +static size_t format_ts64_xattr(char *val, size_t size, struct timespec64 *src)
> > +{
> > +       size_t ret;
> > +       char buf[INT_STR_SIZE(long long) + 1 + 9];
> > +
> > +       ret = snprintf(buf, size ? sizeof(buf) : 0, "%lld.%09ld", src->tv_sec,
> > +                      src->tv_nsec);
> > +       if (ret <= size)
> > +               memcpy(val, buf, ret);
> > +       return ret;
> >  }
> > 
> >  static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
> >                                        size_t size)
> >  {
> > -       return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
> > -                       ci->i_rctime.tv_nsec);
> > +       return format_ts64_xattr(val, size, &ci->i_rctime);
> >  }
> > 
> >  /* dir pin */
> > @@ -221,7 +265,7 @@ static bool ceph_vxattrcb_dir_pin_exists(struct ceph_inode_info *ci)
> >  static size_t ceph_vxattrcb_dir_pin(struct ceph_inode_info *ci, char *val,
> >                                      size_t size)
> >  {
> > -       return snprintf(val, size, "%d", (int)ci->i_dir_pin);
> > +       return format_d_xattr(val, size, ci->i_dir_pin);
> >  }
> > 
> >  /* quotas */
> > @@ -241,20 +285,27 @@ static bool ceph_vxattrcb_quota_exists(struct ceph_inode_info *ci)
> >  static size_t ceph_vxattrcb_quota(struct ceph_inode_info *ci, char *val,
> >                                   size_t size)
> >  {
> > -       return snprintf(val, size, "max_bytes=%llu max_files=%llu",
> > -                       ci->i_max_bytes, ci->i_max_files);
> > +       size_t ret;
> > +       char buf[(2*INT_STR_SIZE(unsigned long long)) + 10 + 11];
> > +
> > +       ret = snprintf(buf, size ? sizeof(buf) : 0,
> > +                      "max_bytes=%llu max_files=%llu",
> > +                      ci->i_max_bytes, ci->i_max_files);
> > +       if (ret <= size)
> > +               memcpy(val, buf, ret);
> > +       return ret;
> >  }
> > 
> >  static size_t ceph_vxattrcb_quota_max_bytes(struct ceph_inode_info *ci,
> >                                             char *val, size_t size)
> >  {
> > -       return snprintf(val, size, "%llu", ci->i_max_bytes);
> > +       return format_llu_xattr(val, size, ci->i_max_bytes);
> >  }
> > 
> >  static size_t ceph_vxattrcb_quota_max_files(struct ceph_inode_info *ci,
> >                                             char *val, size_t size)
> >  {
> > -       return snprintf(val, size, "%llu", ci->i_max_files);
> > +       return format_llu_xattr(val, size, ci->i_max_files);
> >  }
> > 
> >  /* snapshots */
> > @@ -266,8 +317,7 @@ static bool ceph_vxattrcb_snap_btime_exists(struct ceph_inode_info *ci)
> >  static size_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
> >                                        size_t size)
> >  {
> > -       return snprintf(val, size, "%lld.%09ld", ci->i_snap_btime.tv_sec,
> > -                       ci->i_snap_btime.tv_nsec);
> > +       return format_ts64_xattr(val, size, &ci->i_snap_btime);
> >  }
> > 
> >  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
> 
> Hi Jeff,
> 
> This seems over-engineered to me.  You have four functions just for
> ints, two more for ts64 and quota and several ad-hoc %s memcpys.  Why
> not define a single function with a generously-sized buffer, BUG in
> case it's too small and take a format string?

Having to declare a 64 byte (or 128 byte or whatever) buffer on the
stack for an int seemed a bit wasteful, but ok. We can certainly do it
that way instead.

> Regardless, I would much prefer
> 
>   char buf[64];
> 
> over
> 
>   #define INT_STR_SIZE(_type)    3*sizeof(_type)+2
>   char buf[(2*INT_STR_SIZE(unsigned long long)) + 10 + 11];
> 

We'll have to agree to disagree here. I rather like seeing the math for
the buffer length calculations expanded out, particularly in the event
that they need to be changed in the future.
-- 
Jeff Layton <jlayton@kernel.org>

