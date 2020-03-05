Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A119C17A698
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCENoN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 08:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCENoM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 08:44:12 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F23208C3;
        Thu,  5 Mar 2020 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583415851;
        bh=qUOkRit6ly7yAoMgdmaSmcpMGqTvtcm7fNx9SKzW0NE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jCCvhXOMcwjenLdRRdCHwZCQYga0wY5OkmWKjpU6KSx8BbN69eLFnfG25cRRD31Dg
         BjbElDUNI1x5EE9QI5xH1VwKa7dU6EiyeFARI6qW+0QXgJsFWr9dY3ySgVc+b+BVjF
         wxcTgqI5NOiYp1qQYUt0PDgvXEvsKRq1ec2Y/sJU=
Message-ID: <b149738e94cb1998d4e69ed0a4588cdccc1948ec.camel@kernel.org>
Subject: Re: [PATCH v6 10/13] ceph: decode interval_sets for delegated inos
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 05 Mar 2020 08:44:10 -0500
In-Reply-To: <CAOi1vP-0Q-prNFBLrtVC9G1KNwxT9VBPyJOJV5JQ+ae7Y5OTiA@mail.gmail.com>
References: <20200302141434.59825-1-jlayton@kernel.org>
         <20200302141434.59825-11-jlayton@kernel.org>
         <20200305114523.GA70970@suse.com>
         <457281f5f81f3895408ac16f08abbe17429190db.camel@kernel.org>
         <CAOi1vP-0Q-prNFBLrtVC9G1KNwxT9VBPyJOJV5JQ+ae7Y5OTiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-03-05 at 14:36 +0100, Ilya Dryomov wrote:
> On Thu, Mar 5, 2020 at 1:03 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2020-03-05 at 11:45 +0000, Luis Henriques wrote:
> > > On Mon, Mar 02, 2020 at 09:14:31AM -0500, Jeff Layton wrote:
> > > > Starting in Octopus, the MDS will hand out caps that allow the client
> > > > to do asynchronous file creates under certain conditions. As part of
> > > > that, the MDS will delegate ranges of inode numbers to the client.
> > > > 
> > > > Add the infrastructure to decode these ranges, and stuff them into an
> > > > xarray for later consumption by the async creation code.
> > > > 
> > > > Because the xarray code currently only handles unsigned long indexes,
> > > > and those are 32-bits on 32-bit arches, we only enable the decoding when
> > > > running on a 64-bit arch.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/mds_client.c | 122 +++++++++++++++++++++++++++++++++++++++----
> > > >  fs/ceph/mds_client.h |   9 +++-
> > > >  2 files changed, 121 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index db8304447f35..87f75d05b004 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -415,21 +415,121 @@ static int parse_reply_info_filelock(void **p, void *end,
> > > >     return -EIO;
> > > >  }
> > > > 
> > > > +
> > > > +#if BITS_PER_LONG == 64
> > > > +
> > > > +#define DELEGATED_INO_AVAILABLE            xa_mk_value(1)
> > > > +
> > > > +static int ceph_parse_deleg_inos(void **p, void *end,
> > > > +                            struct ceph_mds_session *s)
> > > > +{
> > > > +   u32 sets;
> > > > +
> > > > +   ceph_decode_32_safe(p, end, sets, bad);
> > > > +   dout("got %u sets of delegated inodes\n", sets);
> > > > +   while (sets--) {
> > > > +           u64 start, len, ino;
> > > > +
> > > > +           ceph_decode_64_safe(p, end, start, bad);
> > > > +           ceph_decode_64_safe(p, end, len, bad);
> > > > +           while (len--) {
> > > > +                   int err = xa_insert(&s->s_delegated_inos, ino = start++,
> > > > +                                       DELEGATED_INO_AVAILABLE,
> > > > +                                       GFP_KERNEL);
> > > > +                   if (!err) {
> > > > +                           dout("added delegated inode 0x%llx\n",
> > > > +                                start - 1);
> > > > +                   } else if (err == -EBUSY) {
> > > > +                           pr_warn("ceph: MDS delegated inode 0x%llx more than once.\n",
> > > > +                                   start - 1);
> > > > +                   } else {
> > > > +                           return err;
> > > > +                   }
> > > > +           }
> > > > +   }
> > > > +   return 0;
> > > > +bad:
> > > > +   return -EIO;
> > > > +}
> > > > +
> > > > +u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
> > > > +{
> > > > +   unsigned long ino;
> > > > +   void *val;
> > > > +
> > > > +   xa_for_each(&s->s_delegated_inos, ino, val) {
> > > > +           val = xa_erase(&s->s_delegated_inos, ino);
> > > > +           if (val == DELEGATED_INO_AVAILABLE)
> > > > +                   return ino;
> > > > +   }
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
> > > > +{
> > > > +   return xa_insert(&s->s_delegated_inos, ino, DELEGATED_INO_AVAILABLE,
> > > > +                    GFP_KERNEL);
> > > > +}
> > > > +#else /* BITS_PER_LONG == 64 */
> > > > +/*
> > > > + * FIXME: xarrays can't handle 64-bit indexes on a 32-bit arch. For now, just
> > > > + * ignore delegated_inos on 32 bit arch. Maybe eventually add xarrays for top
> > > > + * and bottom words?
> > > > + */
> > > > +static int ceph_parse_deleg_inos(void **p, void *end,
> > > > +                            struct ceph_mds_session *s)
> > > > +{
> > > > +   u32 sets;
> > > > +
> > > > +   ceph_decode_32_safe(p, end, sets, bad);
> > > > +   if (sets)
> > > > +           ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
> > > > +   return 0;
> > > > +bad:
> > > > +   return -EIO;
> > > > +}
> > > > +
> > > > +u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
> > > > +{
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
> > > > +{
> > > > +   return 0;
> > > > +}
> > > > +#endif /* BITS_PER_LONG == 64 */
> > > > +
> > > >  /*
> > > >   * parse create results
> > > >   */
> > > >  static int parse_reply_info_create(void **p, void *end,
> > > >                               struct ceph_mds_reply_info_parsed *info,
> > > > -                             u64 features)
> > > > +                             u64 features, struct ceph_mds_session *s)
> > > >  {
> > > > +   int ret;
> > > > +
> > > >     if (features == (u64)-1 ||
> > > >         (features & CEPH_FEATURE_REPLY_CREATE_INODE)) {
> > > > -           /* Malformed reply? */
> > > >             if (*p == end) {
> > > > +                   /* Malformed reply? */
> > > >                     info->has_create_ino = false;
> > > > -           } else {
> > > > +           } else if (test_bit(CEPHFS_FEATURE_DELEG_INO, &s->s_features)) {
> > > > +                   u8 struct_v, struct_compat;
> > > > +                   u32 len;
> > > > +
> > > >                     info->has_create_ino = true;
> > > > +                   ceph_decode_8_safe(p, end, struct_v, bad);
> > > > +                   ceph_decode_8_safe(p, end, struct_compat, bad);
> > > > +                   ceph_decode_32_safe(p, end, len, bad);
> > > > +                   ceph_decode_64_safe(p, end, info->ino, bad);
> > > 
> > > I've done a quick test in current 'testing' branch and it seems that it's
> > > currently broken.  A bisect identified this commit as 'bad' and it's
> > > failing at this point.
> > > 
> > > I'm running an old (a few weeks) 'master' vstart cluster, so I don't have
> > > the needed bits for using this DELEG_INO feature.  Running xfstest
> > > generic/001 results in:
> > > 
> > >    ceph: mds parse_reply err -5
> > >    ceph: mdsc_handle_reply got corrupt reply mds0(tid:9)
> > >    ...
> > > 
> > > s->s_features does include the CEPHFS_FEATURE_DELEG_INO bit set;
> > > 'features' is -1 (0xffffffffffffffff) and s->s_features is 0x3fff.  Maybe
> > > the issue is actually somewhere else (the cephfs feature handling code),
> > > but I'm still looking.
> > > 
> > 
> > From the patch that added this feature in userland ceph code (commit
> > 2bcf4b62643b5):
> > 
> > --- a/src/mds/cephfs_features.h
> > +++ b/src/mds/cephfs_features.h
> > @@ -32,6 +32,7 @@
> >  #define CEPHFS_FEATURE_LAZY_CAP_WANTED  11
> >  #define CEPHFS_FEATURE_MULTI_RECONNECT  12
> >  #define CEPHFS_FEATURE_NAUTILUS         12
> > +#define CEPHFS_FEATURE_DELEG_INO        13
> >  #define CEPHFS_FEATURE_OCTOPUS          13
> > 
> >  #define CEPHFS_FEATURES_ALL {          \
> > @@ -45,6 +46,7 @@
> >    CEPHFS_FEATURE_LAZY_CAP_WANTED,      \
> >    CEPHFS_FEATURE_MULTI_RECONNECT,      \
> >    CEPHFS_FEATURE_NAUTILUS,              \
> > +  CEPHFS_FEATURE_DELEG_INO,             \
> >    CEPHFS_FEATURE_OCTOPUS,               \
> >  }
> > 
> > ...this feature was added under the aegis of the
> > CEPHFS_FEATURE_DELEG_INO flag, but that bit is shared with
> > CEPHFS_FEATURE_OCTOPUS, which was already enabled in octopus before we
> > ever added it (back on April 1st 2019).
> > 
> > Any version of the MDS that has commit 49930ad8a3402 but does not have
> > 2bcf4b62643b5 will not work properly with newer kernels. Personally, I
> > don't see that as a problem per-se, as that should only be the case with
> > bleeding-edge MDS builds. Official releases should never see this issue.
> > 
> > Going forward, I think commit 49930ad8a3402 was probably a bad idea. We
> > really should not add "release" cephfs feature bits to the mask until
> > just before an official release, and should just make it alias the last
> > "real" feature bit. That should help ensure that we don't hit this
> > problem in the future.
> 
> We should avoid "release" feature bits altogether, as discussed in
> the last CDM.  They appeared because we were running out of free bits
> for RADOS features (a 64-bit field).  CephFS features are encoded in
> a bit vector that can grow as needed.
> 
> Feature masks for groups of related feature bits make sense, but they
> should be handled at a higher level.  E.g. a set of feature bits that
> a client should support in order for inline data to work properly that
> we flip to required if the user runs "ceph fs set <fsname> inline_data
> true".  The actual feature bits in the bit vector should all be
> distinct -- no overlaps.
> 

Yes, sorry, that was what we discussed, and that sounds fine to me.

The only reason those tags exist at all is that userland ceph has a
"min_compat_client" setting that disallows clients that don't support
release "X" from mounting.

I don't recall whether we had a plan to remove that setting from the
userland ceph code. Did we? It seems like if we're moving away from
declaring a particular release feature bit, then we should deprecate
min_compat_client.

-- 
Jeff Layton <jlayton@kernel.org>

