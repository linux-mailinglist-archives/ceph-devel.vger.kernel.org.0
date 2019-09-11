Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76989B0492
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 21:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfIKTcM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 15:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfIKTcL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 15:32:11 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62C8206A5;
        Wed, 11 Sep 2019 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568230331;
        bh=Ao8l+W7vJkqG5WR3WLlQ0pRT+2DGRSnnwjhAHQFt42w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ttFjmhGlQdNa4dFNZ1+i5LA6Ei95aiORD+sPsOabCThKPPeb58rR2R2ZiYwmd3SQ8
         Ab17+CqieSktHvVWlU6lCbMVpflL7ZTL/17JRYg7zIUkYnlOlwEO+HRu8yGVHQmW79
         EPM9rLDKOT7MHhJNEL6bmByOz6snAkza/RBUJgC8=
Message-ID: <e9003274871de6262459fe6e57f05f9521692adf.camel@kernel.org>
Subject: Re: [PATCH] ceph: convert int fields in ceph_mount_options to
 unsigned int
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 15:32:09 -0400
In-Reply-To: <CAOi1vP-=qNbaCffVft8WDUuHvS9BccML8zvC8ZszDb=QGb6LVg@mail.gmail.com>
References: <20190911164037.23495-1-jlayton@kernel.org>
         <CAOi1vP-=qNbaCffVft8WDUuHvS9BccML8zvC8ZszDb=QGb6LVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-09-11 at 20:32 +0200, Ilya Dryomov wrote:
> On Wed, Sep 11, 2019 at 6:42 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Most of these values should never be negative, so convert them to
> > unsigned values. Leave caps_max alone however, as it will be compared
> > with a counter that we want to leave signed.
> > 
> > Add some sanity checking to the parsed values, and clean up some
> > unneeded casts.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/mds_client.c |  5 +++--
> >  fs/ceph/super.c      | 34 ++++++++++++++++++----------------
> >  fs/ceph/super.h      | 16 ++++++++--------
> >  3 files changed, 29 insertions(+), 26 deletions(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 0d7afabb1f49..da882217d04d 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2031,12 +2031,13 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
> >         struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
> >         struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
> >         size_t size = sizeof(struct ceph_mds_reply_dir_entry);
> > -       int order, num_entries;
> > +       unsigned int num_entries;
> > +       int order;
> > 
> >         spin_lock(&ci->i_ceph_lock);
> >         num_entries = ci->i_files + ci->i_subdirs;
> >         spin_unlock(&ci->i_ceph_lock);
> > -       num_entries = max(num_entries, 1);
> > +       num_entries = max(num_entries, 1U);
> >         num_entries = min(num_entries, opt->max_readdir);
> > 
> >         order = get_order(size * num_entries);
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 2710f9a4a372..fa95c2faf167 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -170,10 +170,10 @@ static const struct fs_parameter_enum ceph_param_enums[] = {
> >  static const struct fs_parameter_spec ceph_param_specs[] = {
> >         fsparam_flag_no ("acl",                         Opt_acl),
> >         fsparam_flag_no ("asyncreaddir",                Opt_asyncreaddir),
> > -       fsparam_u32     ("caps_max",                    Opt_caps_max),
> > +       fsparam_s32     ("caps_max",                    Opt_caps_max),
> >         fsparam_u32     ("caps_wanted_delay_max",       Opt_caps_wanted_delay_max),
> >         fsparam_u32     ("caps_wanted_delay_min",       Opt_caps_wanted_delay_min),
> > -       fsparam_s32     ("write_congestion_kb",         Opt_congestion_kb),
> > +       fsparam_u32     ("write_congestion_kb",         Opt_congestion_kb),
> >         fsparam_flag_no ("copyfrom",                    Opt_copyfrom),
> >         fsparam_flag_no ("dcache",                      Opt_dcache),
> >         fsparam_flag_no ("dirstat",                     Opt_dirstat),
> > @@ -185,8 +185,8 @@ static const struct fs_parameter_spec ceph_param_specs[] = {
> >         fsparam_flag_no ("quotadf",                     Opt_quotadf),
> >         fsparam_u32     ("rasize",                      Opt_rasize),
> >         fsparam_flag_no ("rbytes",                      Opt_rbytes),
> > -       fsparam_s32     ("readdir_max_bytes",           Opt_readdir_max_bytes),
> > -       fsparam_s32     ("readdir_max_entries",         Opt_readdir_max_entries),
> > +       fsparam_u32     ("readdir_max_bytes",           Opt_readdir_max_bytes),
> > +       fsparam_u32     ("readdir_max_entries",         Opt_readdir_max_entries),
> > 
> > [...]
> > 
> >         case Opt_caps_max:
> > -               fsopt->caps_max = result.uint_32;
> > +               if (result.int_32 < 0)
> > +                       goto invalid_value;
> > +               fsopt->caps_max = result.int_32;
> 
> I picked on David's patch because it converted everything to unsigned,
> but left write_congestion_kb, readdir_max_bytes and readdir_max_entries
> signed.  None of them can be negative, so it didn't make sense to me.
> 
> This patch fixes that, but leaves caps_max signed.  caps_max can't be
> negative, so again it doesn't make sense to me.  If we are going to
> tweak the option table as part of this conversion, I think it needs to
> be consistent: either signed with a check or unsigned without a check
> for all options that can't be negative.

It should never be set to a negative value, but caps_max gets propagated
to mdsc->caps_use_max, and that value is eventually compared to
mdsc->caps_use_count (see ceph_trim_dentries). caps_use_max is a simple
counter that is incremented or decremented when we add or remove caps.

My experience with these sorts of counters is that it's best to leave
them signed, as they can underflow in the face of bugs. When that
happens it's better that the resulting value end up looking to be less
than zero than really large.

Could we make caps_max be unsigned and leave everything else signed?
Sure, but I don't see any benefit to doing that.
-- 
Jeff Layton <jlayton@kernel.org>

