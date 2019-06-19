Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80A4AF03
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2019 02:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFSAZD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Jun 2019 20:25:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40596 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFSAZA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Jun 2019 20:25:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so17805265qtn.7
        for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2019 17:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45/PwD8WztaHTfeEnuJhkClqEyg3dSNkxnGnK1SAcjE=;
        b=EqxPliyDow30v2PTbnpn5jh40xRcgkBC9zwykkQCaoohy4p0ayq2CRRcCxHlRCkuzj
         QcLq6tW5MdOmDgav9fGhMGco1g2qgXel4esM2Hyw32sqT8d6x5mItqzZ5hbKZfWDSyCn
         RdtUCne9PldnhFygvSsqnqFhPA5kO5PaCK0Iu54kry/WTwSXVk2P2UMOyWfLapnBUUIq
         XQt6+0edeO5K8vAtfzD1ZBDVdFVmGPRQ5ThA2h6AKWnaH+9vuDwx/+1B2whpV4cocyDN
         2wZvroWTusxzebMB2HB+NsmbkyJpTBlrYOSDayX0ImUo/PTr3uXjP4nPAg6yrkWqzLfa
         KdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45/PwD8WztaHTfeEnuJhkClqEyg3dSNkxnGnK1SAcjE=;
        b=QthFvxBnULfPkPo9e8cLJJuoPs7dxPan1si/Fg1U8leyFuBgtsH02OTMp8qbHZoRI1
         fIvd/d/Ejvwjy/3gElFtmR6soCEBIWkc1ApQsecdtI0FARhki0hUMXbh/gC1vqdFjnca
         cHOEVSAthDvSxeDnU0rJ5e/k2u2NTIIlhlxQymH8WpBX30/qmny16V+4ChS57/0/0y5S
         /g4Ip9+S6QDoa51qaW/icMa1WAv+SjXwVxis3aZiDYJjJZVdmSgfH/SB3AvKOFd+ztFh
         lYC/1vnuhTN27mu60JfuzF++Xj+rlpf5MhcvWXpyo2PPg1uuraiO0tPHKI4d3uqEd+dy
         otyA==
X-Gm-Message-State: APjAAAU3zpqnpMZEXwtRN65ct1Y/VdBDhT+Q8BkOLVrCuVZaUoyKRSrf
        fHLauWVnPNng2+Caig9l98t91aoEyGW5iNSFGMzAb6ub6MsuAQ==
X-Google-Smtp-Source: APXvYqyh+hi4IEpDAqgHPAJLzIohZtd0D1xF7G5bRSt6pQKJJUE1TsbbIeMcVf8Pjm1/1dhB77taTC68Ct5WyS2reBE=
X-Received: by 2002:a0c:8b6f:: with SMTP id d47mr29446375qvc.32.1560903898928;
 Tue, 18 Jun 2019 17:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
In-Reply-To: <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 19 Jun 2019 08:24:47 +0800
Message-ID: <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > When remounting aborted mount, also reset client's entity addr.
> > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > from blacklist.
> > > >
> > >
> > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > I try to remount an unmounted filesystem:
> > >
> > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > >
> > > My client isn't blacklisted above, so I guess you're counting on the
> > > umount returning without having actually unmounted the filesystem?
> > >
> > > I think this ought to not need a umount first. From a UI standpoint,
> > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > >
>
> > This series is mainly for the case that mount point is not umountable.
> > If mount point is umountable, user should use 'umount -f /ceph; mount
> > /ceph'. This avoids all trouble of error handling.
> >
>
> ...
>
> >
> > If just doing "mount -o remount", user will expect there is no
> > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > operation may lose data/metadata.
> >
> >
>
> I don't think they'd expect that and even if they did, that's why we'd
> return errors on certain operations until they are cleared. But, I think
> all of this points out the main issue I have with this patchset, which
> is that it's not clear what problem this is solving.
>
> So: client gets blacklisted and we want to allow it to come back in some
> fashion. Do we expect applications that happened to be accessing that
> mount to be able to continue running, or will they need to be restarted?
> If they need to be restarted why not just expect the admin to kill them
> all off, unmount and remount and then start them back up again?
>

The point is let users decide what to do. Some user values
availability over consistency. It's inconvenient to kill all
applications that use the mount, then do umount.

Regards
Yan, Zheng



> > > Also, how would an admin know that this is something they ought to try?
> > > Is there a way for them to know that their client has been blacklisted?
> > >
> > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > ---
> > > >   fs/ceph/mds_client.c | 16 +++++++++++++---
> > > >   fs/ceph/super.c      | 23 +++++++++++++++++++++--
> > > >   2 files changed, 34 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index 19c62cf7d5b8..188c33709d9a 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > >                   struct ceph_cap_flush *cf;
> > > >                   struct ceph_mds_client *mdsc = fsc->mdsc;
> > > >
> > > > -         if (ci->i_wrbuffer_ref > 0 &&
> > > > -             READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
> > > > -                 invalidate = true;
> > > > +         if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> > > > +                 if (inode->i_data.nrpages > 0)
> > > > +                         invalidate = true;
> > > > +                 if (ci->i_wrbuffer_ref > 0)
> > > > +                         mapping_set_error(&inode->i_data, -EIO);
> > > > +         }
> > > >
> > > >                   while (!list_empty(&ci->i_cap_flush_list)) {
> > > >                           cf = list_first_entry(&ci->i_cap_flush_list,
> > > > @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> > > >                   session = __ceph_lookup_mds_session(mdsc, mds);
> > > >                   if (!session)
> > > >                           continue;
> > > > +
> > > > +         if (session->s_state == CEPH_MDS_SESSION_REJECTED)
> > > > +                 __unregister_session(mdsc, session);
> > > > +         __wake_requests(mdsc, &session->s_waiting);
> > > >                   mutex_unlock(&mdsc->mutex);
> > > > +
> > > >                   mutex_lock(&session->s_mutex);
> > > >                   __close_session(mdsc, session);
> > > >                   if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
> > > > @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> > > >                   }
> > > >                   mutex_unlock(&session->s_mutex);
> > > >                   ceph_put_mds_session(session);
> > > > +
> > > >                   mutex_lock(&mdsc->mutex);
> > > >                   kick_requests(mdsc, mds);
> > > >           }
> > > > +
> > > >           __wake_requests(mdsc, &mdsc->waiting_for_map);
> > > >           mutex_unlock(&mdsc->mutex);
> > > >   }
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index 67eb9d592ab7..a6a3c065f697 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
> > > >
> > > >   static int ceph_remount(struct super_block *sb, int *flags, char *data)
> > > >   {
> > > > - sync_filesystem(sb);
> > > > - return 0;
> > > > + struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > > > +
> > > > + if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
> > > > +         sync_filesystem(sb);
> > > > +         return 0;
> > > > + }
> > > > +
> > > > + /* Make sure all page caches get invalidated.
> > > > +  * see remove_session_caps_cb() */
> > > > + flush_workqueue(fsc->inode_wq);
> > > > + /* In case that we were blacklisted. This also reset
> > > > +  * all mon/osd connections */
> > > > + ceph_reset_client_addr(fsc->client);
> > > > +
> > > > + ceph_osdc_clear_abort_err(&fsc->client->osdc);
> > > > + fsc->mount_state = 0;
> > > > +
> > > > + if (!sb->s_root)
> > > > +         return 0;
> > > > + return __ceph_do_getattr(d_inode(sb->s_root), NULL,
> > > > +                          CEPH_STAT_CAP_INODE, true);
> > > >   }
> > > >
> > > >   static const struct super_operations ceph_super_ops = {
>
> --
> Jeff Layton <jlayton@redhat.com>
>
