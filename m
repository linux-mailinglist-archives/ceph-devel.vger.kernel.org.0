Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A514D239
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 17:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTPdu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 11:33:50 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40919 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfFTPdu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 11:33:50 -0400
Received: by mail-yw1-f66.google.com with SMTP id b143so1345369ywb.7
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 08:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8KjnCJ00r7mw3I4xnRxwG0QVLTaXAeM3mei+yTK/Ckg=;
        b=ICrN2uzZu4fmWDKDMbNZjtcKNDF2sDDcgBPDPQqb9NvJp0BJsm89ysndqB7J41Ccuh
         Iy4Ry9TPwQkE/+oy+9M8YzoQu5LVLMdZYxnMKcgAKfkfg6/bpdBlMkbrpV3CBfE9hVzk
         K+ZsbLATKpCPNVAy8kqLHQCSHPiUH/UuWZIfMGvv8XVNavmbTnIPg8I8ZZV+/bWFn41G
         9aIPrsm6tpbpG0V+SMnVlGSZgawIpoWhXpZsZF+IcPQ4/hkXXFBkXvupF1AYJSzaRckx
         YGRoqlwUWWQJvWP5JGjllaUCr5/GtEfxS09eZWvNgIVXvIDo/GDfUuCwPtSfBtCf6Y/f
         AceA==
X-Gm-Message-State: APjAAAVaEDdWv2k4U79idYwliy3j6ArTy/NYNt2SxDBGlI9qHzhDnltN
        QCVgnkRtCSBYhHtPmTDtSGD5Fg==
X-Google-Smtp-Source: APXvYqzwmdwEwrSdHvRjVawcb8NMeTryNY/BAhxpVcr96f07+p700w3vFdGvEWQGtWWhu4MEKl0i7g==
X-Received: by 2002:a81:678a:: with SMTP id b132mr45325829ywc.96.1561044829373;
        Thu, 20 Jun 2019 08:33:49 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-5C3.dyn6.twc.com. [2606:a000:1100:37d::5c3])
        by smtp.gmail.com with ESMTPSA id f64sm5448513ywe.73.2019.06.20.08.33.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:33:48 -0700 (PDT)
Message-ID: <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Thu, 20 Jun 2019 11:33:47 -0400
In-Reply-To: <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-5-zyan@redhat.com>
         <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
         <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com>
         <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
         <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > > When remounting aborted mount, also reset client's entity addr.
> > > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > > from blacklist.
> > > > > 
> > > > 
> > > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > > I try to remount an unmounted filesystem:
> > > > 
> > > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > > > 
> > > > My client isn't blacklisted above, so I guess you're counting on the
> > > > umount returning without having actually unmounted the filesystem?
> > > > 
> > > > I think this ought to not need a umount first. From a UI standpoint,
> > > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > > > 
> > > This series is mainly for the case that mount point is not umountable.
> > > If mount point is umountable, user should use 'umount -f /ceph; mount
> > > /ceph'. This avoids all trouble of error handling.
> > > 
> > 
> > ...
> > 
> > > If just doing "mount -o remount", user will expect there is no
> > > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > > operation may lose data/metadata.
> > > 
> > > 
> > 
> > I don't think they'd expect that and even if they did, that's why we'd
> > return errors on certain operations until they are cleared. But, I think
> > all of this points out the main issue I have with this patchset, which
> > is that it's not clear what problem this is solving.
> > 
> > So: client gets blacklisted and we want to allow it to come back in some
> > fashion. Do we expect applications that happened to be accessing that
> > mount to be able to continue running, or will they need to be restarted?
> > If they need to be restarted why not just expect the admin to kill them
> > all off, unmount and remount and then start them back up again?
> > 
> 
> The point is let users decide what to do. Some user values
> availability over consistency. It's inconvenient to kill all
> applications that use the mount, then do umount.
> 
> 

I think I have a couple of issues with this patchset. Maybe you can
convince me though:

1) The interface is really weird.

You suggested that we needed to do:

    # umount -f /mnt/foo ; mount -o remount /mnt/foo

...but what if I'm not really blacklisted? Didn't I just kill off all
the calls in-flight with the umount -f? What if that umount actually
succeeds? Then the subsequent remount call will fail.

ISTM, that this interface (should we choose to accept it) should just
be:

    # mount -o remount /mnt/foo

...and if the client figures out that it has been blacklisted, then it
does the right thing during the remount (whatever that right thing is).

2) It's not clear to me who we expect to use this.

Are you targeting applications that do not use file locking? Any that do
use file locking will probably need some special handling, but those
that don't might be able to get by unscathed as long as they can deal
with -EIO on fsync by replaying writes since the last fsync.

The catch here is that not many applications do that. Most just fall
over once fsync hits an error. That is a bit of a chicken and egg
problem though, so that's not necessarily an argument against doing
this.

> 
> > > > Also, how would an admin know that this is something they ought to try?
> > > > Is there a way for them to know that their client has been blacklisted?
> > > > 
> > > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > > ---
> > > > >   fs/ceph/mds_client.c | 16 +++++++++++++---
> > > > >   fs/ceph/super.c      | 23 +++++++++++++++++++++--
> > > > >   2 files changed, 34 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index 19c62cf7d5b8..188c33709d9a 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >                   struct ceph_cap_flush *cf;
> > > > >                   struct ceph_mds_client *mdsc = fsc->mdsc;
> > > > > 
> > > > > -         if (ci->i_wrbuffer_ref > 0 &&
> > > > > -             READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
> > > > > -                 invalidate = true;
> > > > > +         if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> > > > > +                 if (inode->i_data.nrpages > 0)
> > > > > +                         invalidate = true;
> > > > > +                 if (ci->i_wrbuffer_ref > 0)
> > > > > +                         mapping_set_error(&inode->i_data, -EIO);
> > > > > +         }
> > > > > 
> > > > >                   while (!list_empty(&ci->i_cap_flush_list)) {
> > > > >                           cf = list_first_entry(&ci->i_cap_flush_list,
> > > > > @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> > > > >                   session = __ceph_lookup_mds_session(mdsc, mds);
> > > > >                   if (!session)
> > > > >                           continue;
> > > > > +
> > > > > +         if (session->s_state == CEPH_MDS_SESSION_REJECTED)
> > > > > +                 __unregister_session(mdsc, session);
> > > > > +         __wake_requests(mdsc, &session->s_waiting);
> > > > >                   mutex_unlock(&mdsc->mutex);
> > > > > +
> > > > >                   mutex_lock(&session->s_mutex);
> > > > >                   __close_session(mdsc, session);
> > > > >                   if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
> > > > > @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> > > > >                   }
> > > > >                   mutex_unlock(&session->s_mutex);
> > > > >                   ceph_put_mds_session(session);
> > > > > +
> > > > >                   mutex_lock(&mdsc->mutex);
> > > > >                   kick_requests(mdsc, mds);
> > > > >           }
> > > > > +
> > > > >           __wake_requests(mdsc, &mdsc->waiting_for_map);
> > > > >           mutex_unlock(&mdsc->mutex);
> > > > >   }
> > > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > > index 67eb9d592ab7..a6a3c065f697 100644
> > > > > --- a/fs/ceph/super.c
> > > > > +++ b/fs/ceph/super.c
> > > > > @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
> > > > > 
> > > > >   static int ceph_remount(struct super_block *sb, int *flags, char *data)
> > > > >   {
> > > > > - sync_filesystem(sb);
> > > > > - return 0;
> > > > > + struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > > > > +
> > > > > + if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
> > > > > +         sync_filesystem(sb);
> > > > > +         return 0;
> > > > > + }
> > > > > +
> > > > > + /* Make sure all page caches get invalidated.
> > > > > +  * see remove_session_caps_cb() */
> > > > > + flush_workqueue(fsc->inode_wq);
> > > > > + /* In case that we were blacklisted. This also reset
> > > > > +  * all mon/osd connections */
> > > > > + ceph_reset_client_addr(fsc->client);
> > > > > +
> > > > > + ceph_osdc_clear_abort_err(&fsc->client->osdc);
> > > > > + fsc->mount_state = 0;
> > > > > +
> > > > > + if (!sb->s_root)
> > > > > +         return 0;
> > > > > + return __ceph_do_getattr(d_inode(sb->s_root), NULL,
> > > > > +                          CEPH_STAT_CAP_INODE, true);
> > > > >   }
> > > > > 
> > > > >   static const struct super_operations ceph_super_ops = {
> > 
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 

-- 
Jeff Layton <jlayton@redhat.com>

